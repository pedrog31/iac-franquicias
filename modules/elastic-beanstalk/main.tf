resource "aws_elastic_beanstalk_application" "franquicias_application" {
  name        = "backend-franquicias-${var.tags.environment}"
  description = "backend-franquicias"
}

resource "aws_launch_template" "franquicias_launch_template" {
  name_prefix   = "franquicias-launch-template"
  instance_type = "t2.micro"
}

resource "aws_s3_bucket" "franquicias_image" {
  bucket = "franquicias-image"
  tags   = var.tags
}

resource "aws_s3_object" "franquicias_image_deployment" {
  bucket = aws_s3_bucket.franquicias_image.id
  key    = "Dockerrun.aws.json"
  source = "Dockerrun.aws.json"
}

resource "aws_elastic_beanstalk_application_version" "franquicias_version" {
  name        = "franquicias-version"
  application = aws_elastic_beanstalk_application.franquicias_application.name
  description = "application version created by terraform"
  bucket      = aws_s3_bucket.franquicias_image.id
  key         = aws_s3_object.franquicias_image_deployment.id
}

resource "aws_elastic_beanstalk_configuration_template" "franquicias_template" {
  name                = "franquicias_template"
  application         = aws_elastic_beanstalk_application.franquicias_application.name
  solution_stack_name = "64bit Amazon Linux 2023 v4.3.7 running Docker"
}

resource "aws_elastic_beanstalk_environment" "franquicias_environment" {
  name          = "backend-franquicias"
  application   = aws_elastic_beanstalk_application.franquicias_application.name
  template_name = aws_elastic_beanstalk_configuration_template.franquicias_template.name
  version_label = aws_elastic_beanstalk_application_version.franquicias_version.name
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "SingleInstance"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.franquicias_beanstalk_iam_instance_profile.arn
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = "true"
  }
  setting {
    namespace = "aws:elasticbeanstalk:cloudwatch:logs"
    name      = "StreamLogs"
    value     = "True"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_URL"
    value     = "r2dbc:pool:mysql://${var.db_host}:${var.db_port}/${var.db_name}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USERNAME"
    value     = var.db_user
  }
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PASSWORD"
    value     = var.db_password
  }
  tags = var.tags
}

resource "aws_iam_role" "franquicias_role" {
  name = "franquicias-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "franquicias_beanstalk_log_attach" {
  role       = aws_iam_role.franquicias_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}

resource "aws_iam_instance_profile" "franquicias_beanstalk_iam_instance_profile" {
  name = "beanstalk_iam_instance_profile"
  role = aws_iam_role.franquicias_role.name
}
