data "amazon-ami" "ubuntu" {
    filters = {
        virtualization-type = "hvm"
        name = "ubuntu/images/*ubuntu-focal-20.04-amd64-server-*"
        root-device-type = "ebs"
    }

    owners = ["099720109477"]
    most_recent = true
}

source "amazon-ebs" "ubuntu" {
    ami_name = var.name
    ami_description = var.description
    source_ami = data.amazon-ami.ubuntu.id

    instance_type = "t2.micro"
    region = var.region
    ssh_username = "ubuntu"

    tags = {
        Name = "${var.name}-packer"
    }
}