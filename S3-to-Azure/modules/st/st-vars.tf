variable "env" {
    description = "Environment, used for tagging. EG: dev, prod, test, stage"
    type = string
    default = "dev" 
}

variable "azure_region" {
    description = "Region resources are deployed to"
    type = string
}