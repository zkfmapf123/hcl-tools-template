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
    cd infra/packer-templates/openvpn && packer init . && packer build .
    cd infra/packer-templates/grafana && packer init . && packer build .
    or
    cd infra/pakcer-templates && make build

    // terraform 구성
    cd infra && terraform init && terraform apply
```

## 참고

- cloud-init status --wait

  ```
      해당 명령어는 user_data 실행 후 provisoning 되도록 하는 명령어
  ```

- --restart unless-stopped

  ```
  // 해당 명령어를 사용하여 ami가 실행되면 바로 구동이 될수 있도록 함.
  docker run \
  -d \
  -p 3000:3000 \
  --restart unless-stopped \
  --name=grafana \
  grafana/grafana:$GRAFANA_VERSION

  ```

- set -euf -o pipefail

  ```
      shell 파일 맨처음 위치한 명령어로써,
      해당 shell파일이 실패했을 경우 바로 종료한다 라는 의미...
  ```
