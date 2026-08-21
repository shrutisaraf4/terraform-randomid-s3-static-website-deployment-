resource "aws_instance" "project1_server" {
  ami           = "ami-023b6eace47afd3b4"
  instance_type = "t3.nano"
  tags = { Name = "project1_server" }
}