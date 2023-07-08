build {
    name = "aws"

    sources = [
        "amazon-ebs.ubuntu",
    ]

    ## user_data에 기재된 명령어 진행 후 provisioning 진행...
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