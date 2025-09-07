variable "queue_name" {
  type    = string
  default = "eda-bedrock-queue"
}

variable "lambda_name" {
  type    = string
  default = "eda-bedrock-consumer-v2"
}

variable "lambda_timeout" {
  type    = number
  default = 30
}

variable "model_id" {
  type    = string
  default = "amazon.titan-text-lite-v1"
}
