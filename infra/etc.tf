data "local_file" "bar" {
    filename = "./hello.txt"
}

output value {
    value = data.local_file.bar
}