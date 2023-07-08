# Terraform + Packer + Ansible

## Todo

- Terraform

  - [x] vpc
  - [x] nat gateway
  - [x] subnets

- Packer

  - [ ] make openvpn ec2 ami
  - [ ] make grafana ec2 ami

- Ansible

## Execute

```
    // ami 설치
    cd ifnra/packer-templates/openvpn && packer init . && packer build .
    cd ifnra/packer-templates/grafana && packer init . && packer build .

    // terraform 구성
    cd infra && terraform init && terraform apply
```
