resource "null_resource" "postdirtalert_build" {
    triggers = {
        source_code = local.source_chksum
    }
    provisioner "local-exec" {
      command = "GOOS=linux GOARCH=amd64 CGO_ENABLED=0 GOFLAGS=-trimpath go build -mod=readonly -ldflags='-s -w' -o ${local.postdirtalert_build_path} ${local.postdirtalert_src_path}"
    }
}

data "archive_file" "postdirtalert_archive" {
    depends_on = [ null_resource.postdirtalert_build ]
    type = "zip"
    source_file = local.postdirtalert_build_path
    output_path = local.postdirtalert_zip_path
}

resource "aws_lambda_function" "postdirtalert_function" {
    function_name = "postdirtalert"
    description = "Post updates to soil moisture levels"
    role = aws_iam_role.lambda_exec_role.arn
    handler = "postdirtalert"
    memory_size = 128
    filename = local.postdirtalert_zip_path
    source_code_hash = data.archive_file.postdirtalert_archive.output_base64sha256

    runtime = "go1.x"
}
