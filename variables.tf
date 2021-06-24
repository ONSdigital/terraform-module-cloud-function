variable "name" {
  type        = string
  description = "Required: Common name for resources including the resulting cloud function"
}

variable "region" {
  type        = string
  default     = "europe-west2"
  description = "Optional: The region where resources will be deployed"
}

variable "runtime" {
  type        = string
  default     = "python38"
  description = "Optional: The cloud function runtime. See: https://cloud.google.com/functions/docs/concepts/exec#runtimes"
}


variable "project" {
  type        = string
  default     = ""
  description = "Optional: The name of the project to deploy the cloud function to"
}

variable "entry_point" {
  type        = string
  default     = "main"
  description = "Optional: The name of the function to call when the cloud function is invoked"
}

variable "timeout" {
  type        = number
  default     = 30
  description = "Optional: The time in seconds that should elapse before considering the function timed out"
}

variable "available_memory" {
  type        = number
  default     = 128
  description = "Optional: The amount memory to assign to the function"
}

variable "service_account_email" {
  type        = string
  default     = ""
  description = "Optional: The email of the service account to run the cloud function as"
}

variable "environment_variables" {
  type        = map(string)
  default     = {}
  description = "Optional: Additional environment variables to add to the cloud function"
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Optional: Additional labels to add to the cloud function"
}

variable "trigger_event_type" {
  type        = string
  default     = ""
  description = "Optional: The topic or bucket resource to trigger the cloud function. See: https://cloud.google.com/functions/docs/calling/"
}

variable "trigger_event_resource" {
  type        = string
  default     = ""
  description = "Optional: The Id of the topic or bucket resource that will trigger the cloud function"
}

variable "retry_on_failure" {
  type        = bool
  default     = false
  description = "Optional: Whether to re run the cloud function after it has failed"
}

variable "source_directory" {
  type        = string
  description = "Required: The path of the directory that contains your source code"
}

variable "slack_token" {
  default     = ""
  description = "Optional: Slack token for authenticating with Slack for alerting"
}

variable "slack_channel" {
  default     = ""
  description = "Optional: The Slack channel to send alerts to."
}

variable "trigger_http" {
  default = false
  description = "Any HTTP request (of a supported type) to the endpoint will trigger function execution."
}
