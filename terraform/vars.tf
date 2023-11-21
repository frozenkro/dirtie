locals {
    source_chksum = filesha256("${path.module}/../src/funcs/postdirtalert.go")
    postdirtalert_build_path = "../bin/postdirtalert"
    postdirtalert_zip_path = "../bin/postdirtalert.zip"
    postdirtalert_src_path = "../src/funcs/postdirtalert.go"
}   

variable "AWS_CLI_PROFILE" {}

variable "MOSQUITTO_INST_KEY_NAME" {}
