variable "application" {
  type        = string
  description = "The application that will be hosted on the server."
}

variable "cloud" {
  type        = string
  description = "The cloud where server will be deployed."
}

variable "environment" {
  type        = string
  description = "The environment that the resource will be deployed to (e.g. production)."
}

variable "location" {
  type        = string
  description = "The location where the resource will be deployed; in the case of AWS this represents the region."
  default     = ""
}
