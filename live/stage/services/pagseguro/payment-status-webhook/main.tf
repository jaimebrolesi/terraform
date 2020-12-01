
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# DEPLOY A WEBSERVER CLUSTER USING THE WEBSERVER-CLUSTER MODULE
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ----------------------------------------------------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# ----------------------------------------------------------------------------------------------------------------------

terraform {
  required_version = ">= 0.13.5"

  backend "s3" {
    bucket         = "terraform.smartapi"
    key            = "live/stage/services/pagseguro/payment-status-webhook/terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "terraform-smartapi-locks"
    encrypt        = true
  }
}

# ------------------------------------------------------------------------------
# CONFIGURE OUR AWS CONNECTION
# ------------------------------------------------------------------------------

provider "aws" {
  region = "sa-east-1"
}

locals {
  env = "homolog"
}

# ------------------------------------------------------------------------------
# DEPLOY THE PAGSEGURO/PAYMENT-STATUS-WEBHOOK MODULE
# ------------------------------------------------------------------------------

module "payment_status_webhook" {
  source = "git@github.com:jaimebrolesi/terraform-modules.git//services/pagseguro/payment-status-webhook?ref=v0.0.36"

  queue_name              = "${local.env}_pagseguro_payment_status_webhook"
  queue_body_class        = "br.com.brainweb.pecab2c.order.model.PaymentStatusMessage"
  iam_role_name           = title("${local.env}PagseguroPaymentStatus")
  api_gateway_name        = "${local.env}_pagseguro_webhooks"
  api_gateway_description = "Rest API to use for Pagseguro on Staging environment"
  environment             = local.env
}
