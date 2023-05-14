
resource "aws_ecr_repository" "ECR" {
  name   = "flask_app"
}

resource "aws_ecr_repository" "ECR2" {
  name   = "mysql"
}
