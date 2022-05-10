variable "artifact_folder" {
  type        = string
  description = "The folder where the src or binary of your function resides for bundling."
  default     = "./.artifacts"
}

variable "description" {
  type        = string
  description = "The description of your lambda. Used for documenting purposes."
  default     = ""
}

variable "name" {
  type        = string
  description = "The name of your function. This must match the name of your binary in case of types [go]."
}

variable "prefix" {
  type        = string
  description = "Adds a prefix to the function name."
  default     = ""
}

variable "suffix" {
  type        = string
  description = "Adds a suffix to the function name."
  default     = ""
}

variable "memory" {
  type        = number
  description = "The memory you wish to assign to the lambda function."
  default     = 256
}

variable "timeout" {
  type        = number
  description = "The maximum amount of time (in seconds) your function is allowed to run."
  default     = 3
}

/*
condition = contains(["nodejs", "nodejs4.3", "nodejs4.3-edge", "nodejs6.10", "nodejs8.10", "nodejs10.x", "nodejs12.x", "nodejs14.x",
      "python2.7", "python3.6", "python3.7", "python3.8", "python3.9", "ruby2.5", "ruby2.7",
      "java8", "java8.al2", "java11", "dotnetcore1.0", "dotnetcore2.0", "dotnetcore2.1", "dotnetcore3.1", "dotnet6",
    "go1.x", "provided", "provided.al2"], var.runtime)
*/

variable "environment_vars" {
  type        = map(string)
  description = "Environment variables you want to set in the lambda environment."
  default     = {}
}

variable "managed_policies" {
  type        = set(string)
  description = "A set of managed policies, referenced by arn, which will be attached to the created role of the lambda function."
  default     = []
}

variable "inline_policies" {
  type        = list(string)
  description = "A list of policy statements, in json, which will be set on the created role of the lambda function."
  default     = []
}

variable "logs" {
  type = object({
    enabled   = bool
    retention = optional(number)
  })

  description = "Enables cloudwatch logging with the given retention in days and also adds the needed iam policies to your lambda."
  default = {
    enabled   = false
    retention = 30
  }

  validation {
    condition     = var.logs.enabled ? contains([0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653], var.logs.retention) : true
    error_message = "Only one of theese values are allowed for retention: [0, 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653]."
  }
}

variable "init_empty" {
  type        = bool
  description = "Controls wether the module should init the lambda with an empty archive file. This comes handy when you want to seperate infrastructure changes from application changes in your workflow."
  default     = false
}

variable "type" {
  type = string
  description = "The type of function you are deploying."
  default = "go"

  validation {
    condition = contains(["go", "node"], var.type)
    error_message = "Currently only go and node functions are supported."
  }
}
