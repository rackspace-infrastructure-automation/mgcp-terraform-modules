variable "project_id" {
  description = "Please type the project ID where the alert policies will be deployed"
  type        = string
}

variable "watchman_token" {
  description = "Please paste here the secret for the watchman Token"
  type        = string
}

variable "url_list" {
  description = "Please type the list of URLs that you wish to monitor separated by comma. Example ['http://rackspace.com'. 'https://www.google.com']"
  type        = list(string)
}
