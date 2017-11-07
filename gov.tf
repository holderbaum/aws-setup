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

# create a group policy, which allows to change password
resource "aws_iam_group_policy" "change_password_policy" {
    provider = "aws.gov"
    name = "ChangePasswordPolicy"
    group = "${aws_iam_group.res_admins.id}"
    policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "iam:GetAccountPasswordPolicy",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "iam:ChangePassword",
            "Resource": "arn:aws:iam::${var.gov_account_id}:user/$${aws:username}"
        }
    ]
}
EOF
}

# create a user "bob"
resource "aws_iam_user" "bob" {
    provider = "aws.gov"
    name = "bob"
}

resource "aws_iam_user_login_profile" "bob_initial_password" {
  provider = "aws.gov"
  user    = "${aws_iam_user.bob.name}"
  pgp_key = "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"
}

output "bob_password" {
  value = "${aws_iam_user_login_profile.bob_initial_password.encrypted_password}"
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
