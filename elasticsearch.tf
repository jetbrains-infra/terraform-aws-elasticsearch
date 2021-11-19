resource "aws_elasticsearch_domain" "default" {
  domain_name           = local.domain_name
  elasticsearch_version = local.version
  access_policies       = data.aws_iam_policy_document.anonymous_access.json

  ebs_options {
    ebs_enabled = true
    volume_size = local.node_disk_size
    volume_type = "gp2"
  }

  cluster_config {
    instance_count           = local.node_amount
    instance_type            = local.node_instance_type
    dedicated_master_count   = local.dedicated_master_count
    dedicated_master_type    = local.dedicated_master_type
    dedicated_master_enabled = local.dedicated_master_count == 0 ? false : true
    zone_awareness_enabled   = local.multi_az
  }

  vpc_options {
    security_group_ids = [aws_security_group.elasticsearch.id]
    subnet_ids         = local.subnets
  }

  log_publishing_options {
    cloudwatch_log_group_arn = local.index_slow_log_group_arn
    enabled                  = local.index_slow_log_group_arn == "" ? false : true
    log_type                 = "INDEX_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = local.search_slow_log_group_arn
    enabled                  = local.search_slow_log_group_arn == "" ? false : true
    log_type                 = "SEARCH_SLOW_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = local.es_application_log_group_arn
    enabled                  = local.es_application_log_group_arn == "" ? false : true
    log_type                 = "ES_APPLICATION_LOGS"
  }

  log_publishing_options {
    cloudwatch_log_group_arn = local.audit_log_group_arn
    enabled                  = local.audit_log_group_arn == "" ? false : true
    log_type                 = "AUDIT_LOGS"
  }
}
