module "aws_elastic_beanstalk" {
  source      = "../../modules/elastic-beanstalk"
  db_host     = module.aws_rds.db_host
  db_name     = module.aws_rds.db_name
  db_port     = module.aws_rds.db_port
  db_user     = module.aws_rds.db_user
  db_password = module.aws_rds.db_password
  tags        = var.tags
}

module "aws_rds" {
  source = "../../modules/rds"
  tags   = var.tags
}
