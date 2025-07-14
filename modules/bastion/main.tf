resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  associate_public_ip_address = true
  key_name                    = var.key_name
  private_ip                  = var.private_ip
  iam_instance_profile        = aws_iam_instance_profile.bastion.name  

  user_data = templatefile("${path.module}/user-data.sh.tpl", {
  rds_host      = var.rds_host
  rds_user      = var.rds_user
  rds_password  = var.rds_password
})

  tags = {
    Name = "${var.cluster_name}-bastion"
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = 30
  }
}

resource "aws_iam_instance_profile" "bastion" {
  name = "bastion-instance-profile"
  role = var.bastion_iam_role_name
}