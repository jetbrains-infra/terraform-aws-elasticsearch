variable "name" {
  description = "A unique name of ElasticSearch domain."
}

variable "project" {
  description = "Project tag."
}

variable "elasticsearch_version" {
  description = "ElasticSearch version."
  default     = "6.5"
}

variable "node_instance_type" {
  description = "Instance type of cluster node."
  default     = "t2.small.elasticsearch"
}

variable "dedicated_master_type" {
  description = "Instance type of dedicated master node."
  default     = "t3.small.elasticsearch"
}

variable "dedicated_master_count" {
  description = "Amount of dedicated master nodes."
  default     = "0"
}

variable "index_slow_log_group_arn" {
  description = "Index slow logs ARN"
  default     = ""
}

variable "search_slow_log_group_arn" {
  description = "Search slow logs ARN"
  default     = ""
}

variable "es_application_log_group_arn" {
  description = "Error logs ARN"
  default     = ""
}

variable "audit_log_group_arn" {
  description = "Audit logs ARN"
  default     = ""
}

variable "node_disk_size" {
  description = "Disk size of cluster node."
  default     = "10"
}

variable "node_amount" {
  description = "Amount of cluster nodes."
  default     = 2
}

variable "subnets" {
  description = "A list of VPC subnet IDs."
  type        = list(string)
}

variable "trusted_cidr_blocks" {
  description = "A list of trusted external IP. You may provide consumer subnets."
  type        = list(string)
  default     = []
}

variable "multi_az" {
  description = "Availability zones awareness"
  default     = true
}

data "aws_region" "current" {
}

data "aws_caller_identity" "current" {
}

data "aws_iam_policy_document" "anonymous_access" {
  statement {
    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions   = ["es:*"]
    resources = ["${local.domain_arn}/*"]
  }
}

data "aws_subnet" "default" {
  id = local.subnets[0]
}

locals {
  project                      = var.project
  vpc_id                       = data.aws_subnet.default.vpc_id
  region                       = data.aws_region.current.name
  account_id                   = data.aws_caller_identity.current.account_id
  domain_name                  = var.name
  domain_arn                   = "arn:aws:es:${local.region}:${local.account_id}:domain/${local.domain_name}"
  version                      = var.elasticsearch_version
  node_instance_type           = var.node_instance_type
  dedicated_master_count       = var.dedicated_master_count
  dedicated_master_type        = var.dedicated_master_type
  index_slow_log_group_arn     = var.index_slow_log_group_arn
  search_slow_log_group_arn    = var.search_slow_log_group_arn
  es_application_log_group_arn = var.es_application_log_group_arn
  audit_log_group_arn          = var.audit_log_group_arn
  node_disk_size               = var.node_disk_size
  node_amount                  = var.node_amount
  subnets                      = var.subnets
  trusted_cidr_blocks          = var.trusted_cidr_blocks
  multi_az                     = var.multi_az
}