# Terraform + Packer + Ansible

## Todo

- Terraform

  - [x] vpc
  - [x] nat gateway
  - [x] subnets
  - [x] ec2 from read data aws_ami

- Packer

  - [x] make openvpn ec2 ami
  - [x] make grafana ec2 ami

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

- openvpn의 run-docker-openvpn.sh은 파일 copy만 하는경우
  ```
      open-vpn의 경우 해당 인스턴스의 public_ip가 필요한데,
      pakcer의 경우 ami를 만들때의 public_ip와 실제 인스턴스가 running 되고난 후의 public_ip가 상이하기 때문에...
  ```
