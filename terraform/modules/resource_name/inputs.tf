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
}

variable "os" {
  type        = string
  description = "The operating system that the server  (e.g. development, production, qa)."
  default = ""
}

variable "purpose" {
  type        = string
  description = "Identifies the purpose of the server if applicable (e.g. application, web, database)."
  default     = ""
}


variable "suffix" {
  type        = string
  description = "This is an optional suffix that will be included at the end of the server_base_name output."
  default     = ""
}

