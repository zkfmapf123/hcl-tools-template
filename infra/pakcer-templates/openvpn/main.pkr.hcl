build {
    name = "aws"

    sources = [
        "amazon-ebs.ubuntu",
    ]

    ## 클라우드 인스턴스 초기화
    provisioner "shell" {
        inline = [
            "cloud-init status --wait"
        ]
        execute_command = "sudo -S sh -c '{{ .Vars }} {{ .Path }}'"
    }

    ## Debugging
    # provisioner "breakpoint" {
    #     disable = false
    #     note = "cloud-init debugging"
    # }

    provisioner "file" {
        source = "${path.root}/files/run-docker-openvpn.sh"
        destination = "/tmp/run-docker-openvpn.sh"
    }

    ## Debugging
    # provisioner "breakpoint" {
    #     disable = false
    #     note = "attach file debugging"
    # }

    provisioner "shell" {
        scripts = [
            "${path.root}/scripts/update-apt.sh",
            "${path.root}/scripts/install-common-tools.sh",
            "${path.root}/scripts/configure-locale.sh",
            "${path.root}/scripts/install-docker.sh",
            "${path.root}/scripts/clean-apt.sh",
        ]

        execute_command = "sudo -S sh -c '{{ .Vars}} {{ .Path}}'"
    }

    post-processor "manifest" {
        output = "${path.root}/dist/openvpn-manifest.json"
        strip_path = true
    }

}