variable "vpc_cidr_base" {
  default = "10.0"
}

variable "az_count" {
  default = "3"
}

variable "key_pair_name" {
  default = "main-key"
}

variable "key_pair_pub" {
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDK4jbUxkawdKoU0ewhL8RihzvssqKCFnOrd81qTcS+4gbxsnPENTsdyS8lEqoBfZqkMTv0oMCCxHntSMPi+7m6hIKAhWzXi/xHUOlUn/KQ/UlpFKzGHjK7h/pqZdkjliHI3TXtIV3PptqtYo+cc9CRUF2kY3WnikkCOLpkQGtyUtq7e4jHCufT5VWe+FoVYco/dxbXDeNvJ1FPr6F2bKL5XEqdQ/ZFut+j6WFF8UWm/s7xin9hmmtYIvWgOLe1iUyo9adnkaJYwY+VoAXKEuWJKUqdKYM9fMAMf+PGYMlnoel67KDj1qLz7Rww+KKKMTBTIlHzZLhUQz+0khRCsKyGDiR6BFMbjuT8X7MIPVatTy8zchVvKH0HicJ94j1MFpo1KowXBJ3aqCJV0qCBM3IUKlkzpQAGMoNaIZ9atXBhi8e/Z+XezSu3zH+QojLv0uZavbDuhD4p9fsaGvcEG0LQ0ES2nTs1hHd71chXoq6eaY+8QsoacsLIuspn8fwiqws="
}

variable "web_instance" {
  default = "t3a.small"
}

variable "db_username" {
  default = "username"
}

variable "db_password" {
  default = "password"
}

variable "db_instance" {
  default = "db.r4.large"
}

variable "wp_password" {
  default = "wp_password"
}


###

data "aws_availability_zones" "az_avail" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

###

resource "aws_vpc" "main" {
  cidr_block = "${var.vpc_cidr_base}.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "pub_sub" {
  count             = var.az_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.vpc_cidr_base}.${count.index}.0/24"
  availability_zone = data.aws_availability_zones.az_avail.names["${count.index}"]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "priv_sub" {
  count             = var.az_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.vpc_cidr_base}.1${count.index}.0/24"
  availability_zone = data.aws_availability_zones.az_avail.names["${count.index}"]
}

resource "aws_subnet" "db_sub" {
  count             = var.az_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = "${var.vpc_cidr_base}.2${count.index}.0/24"
  availability_zone = data.aws_availability_zones.az_avail.names["${count.index}"]
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_eip" "nat_eip" {
  count = var.az_count
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  count         = var.az_count
  subnet_id     = element(aws_subnet.pub_sub.*.id, count.index)
  allocation_id = element(aws_eip.nat_eip.*.id, count.index)
  depends_on = [
    aws_eip.nat_eip,
    aws_subnet.pub_sub
  ]
}

resource "aws_route_table" "pub" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "pub_int_gw" {
  route_table_id         = aws_route_table.pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "priv" {
  count  = var.az_count
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_nat_gw" {
  count                  = var.az_count
  route_table_id         = element(aws_route_table.priv.*.id, count.index)
  nat_gateway_id         = element(aws_nat_gateway.nat_gw.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  depends_on = [
    aws_route_table.priv,
    aws_nat_gateway.nat_gw
  ]
}

resource "aws_route_table_association" "pub_sub" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.pub_sub.*.id, count.index)
  route_table_id = aws_route_table.pub.id
}

resource "aws_route_table_association" "priv_sub" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.priv_sub.*.id, count.index)
  route_table_id = element(aws_route_table.priv.*.id, count.index)
}

resource "aws_route_table_association" "db_sub" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.db_sub.*.id, count.index)
  route_table_id = element(aws_route_table.priv.*.id, count.index)
}

resource "aws_key_pair" "main" {
  key_name   = var.key_pair_name
  public_key = var.key_pair_pub
}

resource "aws_security_group" "main_ec2" {
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.main_elb.id]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.main_elb.id]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "main" {
  count           = 1
  ami             = data.aws_ami.ubuntu.id
  instance_type   = var.web_instance
  key_name        = aws_key_pair.main.id
  subnet_id       = element(aws_subnet.priv_sub.*.id, count.index)
  security_groups = [aws_security_group.main_ec2.id]
}

resource "aws_security_group" "main_elb" {
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 2222
    to_port     = 2222
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "main" {
  listener {
    instance_port     = 22
    instance_protocol = "tcp"
    lb_port           = 2222
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:22"
    interval            = 5
  }

  instances                   = aws_instance.main.*.id
  security_groups             = [aws_security_group.main_elb.id]
  subnets                     = aws_subnet.pub_sub.*.id
  cross_zone_load_balancing   = true

  depends_on = [
    aws_instance.main
  ]
}

resource "aws_db_subnet_group" "main" {
  name       = "main"
  subnet_ids = aws_subnet.db_sub.*.id
}

resource "aws_security_group" "main_db" {
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.main_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_rds_cluster_instance" "main_db_instance" {
  count                = 1
  identifier           = "main-db-aurora-cluster-${count.index}"
  cluster_identifier   = aws_rds_cluster.main.id
  instance_class       = var.db_instance
  db_subnet_group_name = aws_db_subnet_group.main.id
  engine               = aws_rds_cluster.main.engine
  engine_version       = aws_rds_cluster.main.engine_version
  apply_immediately    = true
}
resource "aws_rds_cluster" "main" {
  cluster_identifier     = "main-db-aurora-cluster"
  db_subnet_group_name   = aws_db_subnet_group.main.id
  database_name          = "maindb"
  master_username        = var.db_username
  master_password        = var.db_password
  vpc_security_group_ids = [aws_security_group.main_db.id]
  skip_final_snapshot    = true
}

resource "null_resource" "bootstrap" {
  depends_on = [
    aws_elb.main,
    aws_instance.main,
    aws_rds_cluster_instance.main_db_instance
  ]

  triggers = {
    always_run = "${join(" ", aws_instance.main.*.id)}"
  }

  provisioner "file" {
    source      = "ansible"
    destination = "/tmp/ansible"

    connection {
      host        = aws_elb.main.dns_name
      port        = 2222
      user        = "ubuntu"
      private_key = file("./private.key")
    }
  }

  provisioner "remote-exec" {
    connection {
      host        = aws_elb.main.dns_name
      port        = 2222
      user        = "ubuntu"
      private_key = file("./private.key")
    }

    inline = [
      "sudo apt update -y",
      "sudo apt install software-properties-common -y",
      "sudo apt-add-repository --yes --update ppa:ansible/ansible",
      "sudo apt install ansible python3-pip -y",
      "ansible-galaxy collection install community.mysql",
      "cd /tmp/ansible",
      "ansible-playbook playbook.yml -e root_username=${var.db_username} -e root_password=${var.db_password} -e rds_dns=${aws_rds_cluster.main.endpoint} -e wp_password=${var.wp_password}"
    ]
  }
}

###

output "aws_vpc_id" {
  value = aws_vpc.main.id
}

output "elb_dns" {
  value = aws_elb.main.dns_name
}

output "wordpress_url" {
  value = "http://${aws_elb.main.dns_name}/blog"
}
