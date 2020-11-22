output "queue_name" {
  value       = module.payment_status_webhook.queue_name
  description = "The name of the queue"
}

output "api_gateway_url" {
  value       = module.payment_status_webhook.api_gateway_url
  description = "The url of the api gateway"
}
