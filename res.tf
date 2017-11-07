provider "aws" {
  alias = "res"
  region = "${var.aws_region}"
  access_key = "${var.res_access_key}"
  secret_key = "${var.res_secret_key}"
}

# in res account create iam policy, which will grants admin rights
resource "aws_iam_policy" "external_admin_policy" {
    provider = "aws.res"
    name = "ExternalAdminPolicy"
    path = "/"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
}
EOF
}

# in res account create a role which can be assumed by gov account
resource "aws_iam_role" "external_admin_role" {
    provider = "aws.res"
    name = "ExternalAdminRole"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::${var.gov_account_id}:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

# attach policy to role
resource "aws_iam_policy_attachment" "external_admin_policy_attachment_to_external_admin_role" {
    provider = "aws.res"
    name = "external_admin_policy_attachment"
    roles = ["${aws_iam_role.external_admin_role.name}"]
    policy_arn = "${aws_iam_policy.external_admin_policy.arn}"
}
