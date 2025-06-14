module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"  #open source module for instance creation.
  count = 1
  name = var.servers[0]
  ami = data.aws_ami.joindevops.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [local.sg_id]
  user_data = file("jenkins.sh")
  tags = merge(var.common_tags,var.server_tags,
  {
    Name = var.servers[count.index[0]]
  }
  )
  root_block_device = [
    {
    volume_size = 50       # Size of the root volume in GB
    volume_type = "gp3"    # General Purpose SSD (you can change it if needed)
    delete_on_termination = true  # Automatically delete the volume when the instance is terminated
    }
  ]
}

module "jenkins_agent" {
  source  = "terraform-aws-modules/ec2-instance/aws"  #open source module for instance creation.
  count = 1
  name = var.servers[1]
  ami = data.aws_ami.joindevops.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [local.sg_id]
  user_data = file("jenkins_agent.sh")
  tags = merge(var.common_tags,var.server_tags,
  {
    Name = var.servers[count.index[1]]
  }
  )
  root_block_device = [
    {
    volume_size = 50       # Size of the root volume in GB
    volume_type = "gp3"    # General Purpose SSD (you can change it if needed)
    delete_on_termination = true  # Automatically delete the volume when the instance is terminated
    }
  ]  
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins"
      type    = "A"
      ttl     = 1
      records = [ module.jenkins.public_ip ]
      allow_overwrite = true
      
    },

    {
      name    = "jenkins-agent"
      type    = "A"
      ttl     = 1
      records = [ module.jenkins_agent.private_ip ]
      allow_overwrite = true

    }
  ]
}



