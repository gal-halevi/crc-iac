locals {
  file_name = basename(var.source_file_path)
  file_stem = element(split(".", local.file_name), 0)
}