variable "bcg_org_name" {
  type        = string
  description = "BCG organization that is installing One-click in GCP (e.g. GP, GPDev)"
  default     = "gp"
}

variable "billing_account" {
  type        = string
  description = "GCP billing account to associate the project with"
  default     = "01DE6F-C4F422-6D00A9"
}

variable "env" {
  type        = string
  description = "Product environment which is typically \"sandbox\",\"preprod\", or \"prod\""
}

variable "folder_id" {
  type        = string
  description = "GCP folder ID where the project will be hosted (this can also be the top-level org ID)"
}

variable "org_id" {
  type        = number
  description = "GCP organization ID"
}

variable "product_name" {
  type        = string
  description = "BCG product or client name"
}

variable "region" {
  type        = string
  description = "GCP region such as \"us-central1\", \"us-east4\", \"europe-west3\""
  default     = "us-central1"
}

variable "required_labels" {
  type        = map(any)
  description = "GCP labels associated with all resource that support labels. The following are required: costcenter, environment, owner, technicalowner"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "sb_name" {
  type        = string
  description = "Storage Bucket name"
}

variable "vm_name" {
  type        = string
  description = "Virtual Machine name"
}

/*
 * IAM Roles
 */
variable "owners" {
  type        = list(string)
  description = "Users who will have \"roles/owner\" privileges"
  default     = []
}

variable "viewers" {
  type        = list(string)
  description = "Users who will have \"roles/viewer\" privileges"
  default     = []
}