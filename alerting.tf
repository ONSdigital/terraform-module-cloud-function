locals {
  slack_message = <<-EOT
    :warning: Function *${var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name}* has exited with either `crash`, `timeout`, `connection error` or `error` :exclamation:
    <https://console.cloud.google.com/functions/details/${var.trigger_http ? google_cloudfunctions_function.http-function[0].region : google_cloudfunctions_function.function[0].region}/${var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name}?project=${var.project}&tab=logs| :cloud_functions: Logs>
    EOT
}

resource "google_monitoring_notification_channel" "slack" {
  count = length(var.slack_token) > 0 ? 1 : 0

  type         = "slack"
  display_name = "${var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name} Slack Notification"
  description  = "A slack notification channel for ${var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name}"
  enabled      = true

  labels = {
    "channel_name" = var.slack_channel
  }

  sensitive_labels {
    auth_token = var.slack_token
  }
}

resource "google_logging_metric" "metric" {
  count = length(var.slack_token) > 0 ? 1 : 0

  name        = "${var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name}-metric"
  description = "${var.trigger_http ? google_cloudfunctions_function.http-function[0] : google_cloudfunctions_function.function[0]} metric"

  filter = <<-EOT
    resource.type="cloud_function"
    resource.labels.function_name="${var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name}"
    severity="DEBUG"
    "finished with status: 'crash'"
    OR
    "finished with status: 'error'"
    OR
    "finished with status: 'timeout'"
    OR
    "finished with status: 'connection error'"
    EOT

  label_extractors = {
    "function_name" = "EXTRACT(resource.labels.function_name)"
  }

  metric_descriptor {
    display_name = "${var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name}-metric-descriptor"
    metric_kind  = "DELTA"
    value_type   = "INT64"

    labels {
      key        = "function_name"
      value_type = "STRING"
    }
  }
}

resource "google_monitoring_alert_policy" "alert_policy" {
  count = length(var.slack_token) > 0 ? 1 : 0

  display_name          = "${var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name}-alert-policy"
  combiner              = "OR"
  notification_channels = [google_monitoring_notification_channel.slack[0].id]

  conditions {
    display_name = "${var.trigger_http ? google_cloudfunctions_function.http-function[0].name : google_cloudfunctions_function.function[0].name} alert policy condition"

    condition_threshold {
      comparison = "COMPARISON_GT"
      duration   = "0s"
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.metric[0].id}\" resource.type=\"cloud_function\""

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_DELTA"
      }

      trigger {
        count   = 1
        percent = 0
      }
    }
  }

  documentation {
    content   = local.slack_message
    mime_type = "text/markdown"
  }
}
