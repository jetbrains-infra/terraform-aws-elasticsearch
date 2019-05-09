resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "default" {
  domain_name           = "${local.domain_name}"
  elasticsearch_version = "${local.version}"
  access_policies       = "${data.aws_iam_policy_document.anonymous_access.json}"

  ebs_options {
    ebs_enabled = true
    volume_size = "${local.node_disk_size}"
    volume_type = "gp2"
  }

  cluster_config {
    instance_count           = "${local.node_amount}"
    instance_type            = "${local.node_instance_type}"
    dedicated_master_enabled = false
    zone_awareness_enabled   = "${local.multi_az}"
  }

  vpc_options {
    security_group_ids = ["${aws_security_group.elasticsearch.id}"]
    subnet_ids         = ["${local.subnets}"]
  }
}