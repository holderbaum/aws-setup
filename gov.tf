provider "aws" {
    alias = "gov"
    region = "${var.aws_region}"
    access_key = "${var.gov_access_key}"
    secret_key = "${var.gov_secret_key}"
}

# create a group, which will be able to assume "ExternalAdminRole" from res account
resource "aws_iam_group" "res_admins" {
    provider = "aws.gov"
    name = "ResAdminsGroup"
}

# create a group policy, which allows to assume "ExternalAdminRole"
resource "aws_iam_group_policy" "res_admins_policy" {
    provider = "aws.gov"
    name = "ResAdminsPolicy"
    group = "${aws_iam_group.res_admins.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Resource": "${aws_iam_role.external_admin_role.arn}"
    }
}
EOF
}

# create a user "bob"
resource "aws_iam_user" "bob" {
    provider = "aws.gov"
    name = "bob"
}

# add "bob" to res_admins group
resource "aws_iam_group_membership" "res_admins" {
    provider = "aws.gov"
    name = "res_admins_group_membership"
    users = [
        "${aws_iam_user.bob.name}"
    ]
    group = "${aws_iam_group.res_admins.name}"
}
