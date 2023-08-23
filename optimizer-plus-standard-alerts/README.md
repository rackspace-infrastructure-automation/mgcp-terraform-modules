# mod-ops-standard-alerts

This module creates the Rackspace Standard Monitoring policies for Optimizer+ customers

## Prerequisites
1. python 3.5 or higher
1. gcloud installed and configured with your janus account
1. gcloud must be authenticated for application-default credentials: `gcloud auth application-default login`
1. terraform 1.5.3 or above
1. tfenv
1. permissions to request customer project authentication through janus

## Usage example

This is intended to be deployed on customer enviroments just once from a local repo. There will be no code repository on the customer side for these alerts.
Any future change needs to be done in console directly.

Once all the requirements are met, to deploy these alert just run:

`gsutil cp gs://mgcp-build-optimizer-plus-alerts/deploy_o+_alerts.py . ; python3 deploy_o+_alerts.py`

and follow on-screen instructions

## Workaround process

1. Download the repo locally
`git clone https://github.com/rackspace-infrastructure-automation/mgcp-terraform-modules.git`
1. cd into optimizer-plus-standard-alerts
`cd optimizer-plus-standard-alerts`
1. Deploy with terraform
`terraform apply -var project_id=PROJECT_ID -var url_listl='["URL1", "URL2", "URL3"]' -var watchman_token="WATCHMAN_TOKEN_SECRET"  -auto-approve`

## Providers
| Name | Version |
|------|---------|
| google | 4.73.0 |
| google-beta | 4.73.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| project\_id | n/a | `string` | n/a | yes |
| url_list | List of URLs to be monitored |  `list(string)` | n/a | yes |
| watchman_token | Watchman token secret, this can be retrived following this guide: https://one.rackspace.com/display/manpubcld/GCP+-+Creating+Watchman+Notification+channels | `string` | n/a | yes |

## Outputs

No output.
