resource "docker_image" "nginx" {
  name = "nginx:${var.nginx_version}"
}

resource "docker_container" "nginx" {
  name  = var.nginx_container_name
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.nginx_container_external_port
  }
}
