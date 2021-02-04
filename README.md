# Cloud Function

Provision a GCP Cloud Function

## Requirements

| Name | Version |
|------|---------|
| [Terraform](https://www.terraform.io/downloads.html) | 14 |

## Providers

| Name | Version |
|------|---------|
| archive | `2.0.0` |
| google | `3.54.0` |
| google-beta | `3.54.0` |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| available\_memory | Optional: The amount memory to assign to the function | `number` | `128` | no |
| entry\_point | Optional: The name of the function to call when the cloud function is invoked | `string` | `"main"` | no |
| environment\_variables | Optional: Additional environment variables to add to the cloud function | `map(string)` | `{}` | no |
| labels | Optional: Additional labels to add to the cloud function | `map(string)` | `{}` | no |
| name | Required: Common name for resources including the resulting cloud function | `string` | n/a | yes |
| project | Optional: The name of the project to deploy the cloud function to | `string` | `""` | no |
| region | Optional: The region where resources will be deployed | `string` | `"europe-west2"` | no |
| retry\_on\_failure | Optional: Whether to re run the cloud function after it has failed | `bool` | `false` | no |
| runtime | Optional: The cloud function runtime. See: https://cloud.google.com/functions/docs/concepts/exec#runtimes | `string` | `"python38"` | no |
| service\_account\_email | Optional: The email of the service account to run the cloud function as | `string` | `""` | no |
| slack\_channel | Optional: The Slack channel to send alerts to. | `string` | `""` | no |
| slack\_token | Optional: Slack token for authenticating with Slack for alerting | `string` | `""` | no |
| source\_directory | Required: The path of the directory that contains your source code | `string` | n/a | yes |
| timeout | Optional: The time in seconds that should elapse before considering the function timed out | `number` | `30` | no |
| trigger\_event\_resource | Optional: The Id of the topic or bucket resource that will trigger the cloud function | `string` | `""` | no |
| trigger\_event\_type | Optional: The topic or bucket resource to trigger the cloud function. See: https://cloud.google.com/functions/docs/calling/ | `string` | `""` | no |

## Outputs

| Name |
|------|
| function\_environment\_variables |
| function\_service\_account |
| source\_bucket\_url |


## Usage

__Note__:
- By default, the source bucket will trigger the function when a file is written to it.
- The simplest usage is to pass the directory containing your python code to `source_directory`


__Simple python function__

```terraform
module "function" {
  source = "terraform/cloud-function"

  name             = "file-check"
  source_directory = "./modules/cloud-function"
}
```
---------------
__Simple nodejs function__

```terraform
module "function" {
  source = "terraform/cloud-function"

  name             = "file-check"
  runtime          = "nodejs12"
  source_directory = "./modules/cloud-function"
}
```
---------------
__Golang function triggered by a pubsub topic__

```terraform
module "function" {
  source = "terraform/cloud-function"

  name                   = "file-check"
  source_directory       = "./modules/cloud-function"
  runtime                = "go113"
  retry_on_failure       = true
  service_account_email  = "data-service-account@data-project.gserviceaccount.com"
  trigger_event_type     = "google.pubsub.topic.publish"
  trigger_event_resource = google_pubsub_topic.data_topic.id
}
```
---------------

__Nodejs function with monitoring and slack notifications__

```terraform
module "function" {
  source = "../../terraform/cloud-function"

  name                   = "file-check"
  source_directory       = "./modules/cloud-function"
  runtime                = "nodejs"
  available_memory       = 256
  retry_on_failure       = true
  entry_point            = "run"
  service_account_email  = "data-service-account@data-project.gserviceaccount.com"
  trigger_event_resource = google_storage_bucket.bucket.id
  slack_token            = "N3ItiznXKZOq9ga2pF8B35270gYzspQL8u/Wt2nBrrCHyOeXnk/VyP+f44zDqneMXPMKt31aBrpWUf9yt1497w=="
  slack_channel          = "dsc-data-monitoring"

  environment_variables = {
    DATASET            = "bigquery-dataset"
    OUTPUT_DATA_BUCKET = "my-bucket-for-output-data"
  }
}
```
