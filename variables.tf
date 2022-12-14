variable "name" {
    description = "The name of the Lambda function."
    type        = string
}

variable "role_arn" {
    description = "The Amazon Resource Name (ARN) of the existing function's execution role."
    type        = string
    default     = null
}

variable "create_role" {
    description = "Flag to decide if new IAM Role is required to be provisioned."
    type        = bool
    default     = true
}

variable "policies" {
  description = "(Optional) List of Policies (to be provisioned) to be attached to IAM Role."
  default = []
}

variable "description" {
    description = "(Optional) Description of what your Lambda Function does."
    type        = string
    default     = null
}

variable "architecture" {
    description = "(Optional) Instruction set architecture for Lambda function."
    type        = string
    default     = "x86_64"

    validation {
        condition = contains(["arm64", "x86_64"], var.architecture)
        error_message = "Possible values for `architecture` are `arm64` and `x86_64`."
    }
}

variable "runtime" {
    description = "(Optional) Identifier of the function's runtime."
    type        = string
    default     = null
}

variable "package_type" {
    description = "(Optional) Lambda deployment package type."
    type        = string
    default     = "Zip"

    validation {
        condition = contains(["Zip", "Image"], var.package_type)
        error_message = "Possible values for `package_type` are `Zip` and `Image`."
    }
}

variable "file_name" {
    description = "(Optional) Path to the function's deployment package within the local filesystem."
    type        = string
    default     = null
}

variable image_uri {
    description = "(Optional) ECR image URI containing the function's deployment package."
    type        = string
    default     = null
}

variable "s3_bucket" {
    description = "(Optional) S3 bucket location containing the function's deployment package."
    type        = string
    default     = null
}

variable "s3_key" {
    description = "(Optional) S3 key of an object containing the function's deployment package."
    type        = string
    default     = null
}

variable "s3_object_version" {
    description = "(Optional) Object version containing the function's deployment package."
    type        = string
    default     = null
}

variable "handler" {
    description = "(Optional) Function entrypoint in your code."
    type        = string
    default     = null
}

variable "memory_size" {
    description = "(Optional) Amount of memory in MB your Lambda Function can use at runtime."
    type        = number
    default     = 128
}

variable "timeout" {
    description = "(Optional) Amount of time that Lambda Function has to run in seconds."
    type        = number
    default     = 3
}

variable "reserved_concurrent_executions" {
    description = "(Optional) Amount of reserved concurrent executions for this lambda function."
    type        = number
    default     = -1
}

variable "kms_key_arn" {
    description = "(Optional) Amazon Resource Name (ARN) of the AWS Key Management Service (KMS) key that is used to encrypt environment variables."
    type        = string
    default     = null
}

variable "publish" {
    description = "(Optional) Flag to decide if publish creation/change as new Lambda Function Version."
    type        = bool
    default     = false
}

variable "layers" {
    description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
    type = list(string)
    default = []

    validation {
        condition = (length(var.layers) <= 5)
        error_message = "Maximum of 5 Layers can be attached to Lambda Function."
    }
}

variable "ephemeral_storage" {
    description = "(Optional) The amount of Ephemeral storage(/tmp) to allocate for the Lambda Function in MB."
    type        = number
    default     = 512

    validation {
      condition = var.ephemeral_storage >= 512 && var.ephemeral_storage <= 10240
      error_message = "The minimum supported ephemeral_storage value (in MB) defaults to 512 and the maximum supported value is 10240."
    }
}

variable "environment_variables" {
    description = "The map of the environment variables."
    type        = map(string)
    default     = {}
}

variable "efs_arn" {
    description = "Amazon Resource Name (ARN) of the Amazon EFS Access Point that provides access to the file system."
    type = string
    default = null
}

variable "efs_mount_path" {
    description = "Path where the function can access the file system, starting with /mnt/."
    type = string
    default = null
}

variable "dead_letter_target_arn" {
    description = "The ARN of an SNS topic or SQS queue to notify when an invocation fails."
    type        = string
    default     = null
}

variable "subnet_ids" {
    description = "List of subnet IDs associated with the Lambda function."
    type        = list(string)
    default     = []
}

variable "sg_ids" {
    description = "List of security group IDs associated with the Lambda function."
    type        = list(string)
    default     = []
}

variable "tracing_mode" {
    description = "Mode to define if sampling and tracing a subset of incoming requests with AWS X-Ray."
    type        = string
    default     = null

    validation {
        condition = var.tracing_mode != null ? contains(["PassThrough", "Active"], var.tracing_mode) : true
        error_message = "Possible values for `tracing_mode` are `PassThrough` and `Active`."
    }
}

variable "aliases" {
    description = <<EOF
List of Lambda Function Alias configuration Map:

name: (Required) The name of the alias.
description: (Optional) The description of the alias.
function_version: (Optional) The Lambda function version which this alias is created for.
additional_version_weights: (Optional) A map of key/value pairs that defines the proportion of events that should be sent to different versions of a lambda function.
provisioned_concurrent_executions: (optional) Amount of capacity to allocate.
EOF
    type    = any
    default = []
}

variable "lambda_permissions" {
    description = <<EOF
The list of permissions configuration map, given to external sources to access the Lambda function.

id: (Required) The unique Name of the permission.
action: (Optional) The AWS Lambda action you want to allow in this statement.
qualifier: (Optional) Function version or alias name on which this permission will be applied.
principal: (Required) The principal who is getting this permission.
principal_org_id: (Optional) The identifier for your organization in AWS Organizations.
source_arn: (Optional) The ARN of the specific resource to grant permission to.
source_account: (Optional) The AWS account ID (without a hyphen) of the source owner, for allowing cross-account access, or for S3 and SES.
function_url_auth_type: (Optional) Lambda Function URLs authentication type.
event_source_token: (Optional) The Event Source Token to validate. Used with Alexa Skills.
EOF
    type = list(map(string))
    default = []
}

variable "lambda_function_provisioned_concurrency" {
    description = <<EOF
Provisioned Concurrency Configuration for Lambda Function versions.

qualifier: (Optional) Function version.
provisioned_concurrent_executions: (optional) Amount of capacity to allocate.
EOF
    type = list(map(string))
    default = []  
}

variable "create_lambda_function_url" {
    description = "Flag to decide if create Lambda function URL."
    type        = bool
    default     = false
}

variable "function_url_qualifier" {
    description = "The alias name or `$LATEST`."
    type        = string
    default     = null
}

variable "authorization_type" {
    description = "Type of authentication that the function URL uses."
    type        = string
    default     = "NONE"
}

variable "cors" {
    description = <<EOF
The cross-origin resource sharing (CORS) settings map for the function URL.

allow_credentials: (Optional) Flag to decide if allow cookies or other credentials in requests to the function URL.
allow_headers: (Optional) The HTTP headers that origins can include in requests to the function URL.
allow_methods: (Optional) The HTTP methods that are allowed when calling the function URL.
allow_origins: (Optional) The origins that can access the function URL.
expose_headers: (Optional) The HTTP headers in your function response that you want to expose to origins that call the function URL.
max_age: (Optional) The maximum amount of time, in seconds, that web browsers can cache results of a preflight request. 

EOF
    type        = any
    default     = {}
}

variable "tags" {
    description = "(Optional) Map of default tags to assign to Lambda."
    type        = map(string)
    default     = {}
}