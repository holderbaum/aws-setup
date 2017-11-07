# AWS Multi Account Setup

This will set up two accounts:

## Governance Account

Contains just users, no other resources. Logging in to this account is basically useless, since there are no policies.

## Resource Account

Contains all resources and an AdminRole that can be assumed by Governance users.

## How to run

Run `terraform init` to create a working directory.

Create a file `terraform.tfvars` in this directory:

```terraform
res_account_id = "..."
res_access_key = "..."
res_secret_key = "..."
res_alias = "unique alias of the res account" # e.g. mystartup-res

gov_account_id = "..."
gov_access_key = "..."
gov_secret_key = "..."
gov_alias = "unique alias of the res account" # e.g. mystartup-gov
```

Run `terraform plan`.
If everything is as expected, run `terraform apply` to execute the planned steps.

## TODO

* Enforce Multi Factor
* Create Admin Group for managing users
* Enforce short user token TTL
