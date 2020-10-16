variable "assume_role_arn" {
  description = "The role to assume to deploy resources. This determines the account being targeted."
}

variable "CI_COMMIT_SHORT_SHA" {
  type         = string
  description  = "The first eight characters of the commit revision for which project is built."
}

variable "CI_JOB_ID" {
  type        = string
  description = "The unique id of the current job that GitLab CI/CD uses internally."
}

variable "CI_PROJECT_PATH_SLUG" {
  type        = string
  description = "Identifies the Gitlab repository that this project came from."
}
