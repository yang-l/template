variable "nginx_version" {
  type        = string
  description = "Nginx version pulled from the official dockerhub"
  default     = "latest"
}

variable "nginx_container_name" {
  type        = string
  description = "Name of the Nginx container"
  default     = "nginx"
}

variable "nginx_container_external_port" {
  type        = number
  description = "The Nginx container external port"
  default     = 8080
}
