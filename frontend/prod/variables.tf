variable "bucket_name" {
  default = "crc-frontend"
}

variable "web_assets_path" {
  default = "../../../frontend/src"
}

variable "env" {
  type = string
}

variable "domain_name" {
  default = "mycrc.site"
}

variable "alternate_domains" {
  type    = list(string)
  default = ["my.mycrc.site", "www.mycrc.site"]
}

variable "default_root_object" {
  default = "html/index.html"
}