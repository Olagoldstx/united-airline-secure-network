
data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals { type = "Service", identifiers = ["ec2.amazonaws.com"] }
  }
}
resource "aws_iam_role" "ec2_role" {
  name               = "stc-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
}
resource "aws_iam_role_policy" "minimal_ssm" {
  name = "stc-ec2-role-ssm-min"
  role = aws_iam_role.ec2_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": ["ssm:DescribeInstanceInformation"],
      "Resource": "*"
    }]
  })
}
output "role_name" { value = aws_iam_role.ec2_role.name }
