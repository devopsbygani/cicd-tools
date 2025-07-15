module "jenkins" {
  source  = "terraform-aws-modules/ec2-instance/aws"  #open source module for instance creation.
  name = "jenkins"
  ami = data.aws_ami.joindevops.id
  instance_type          = "t3.small"
  vpc_security_group_ids = [var.sg_id]
  subnet_id = "subnet-04269c5138b0e91e6" #replace your Subnet
  user_data = file("jenkins.sh")
  tags = merge(var.common_tags,var.server_tags,
  {
    Name = "jenkins"
  }
  )
  # root_block_device = [
  #   {
  #   volume_size = 50       # Size of the root volume in GB
  #   volume_type = "gp3"    # General Purpose SSD (you can change it if needed)
  #   delete_on_termination = true  # Automatically delete the volume when the instance is terminated
  #   }
  # ]
  root_block_device = {
  size                  = 50
  type                  = "gp3"
  delete_on_termination = true
}
  
}

# module "jenkins_agent" {
#   source  = "terraform-aws-modules/ec2-instance/aws"  #open source module for instance creation.
#   name = "jenkins-agent"
#   ami = data.aws_ami.joindevops.id
#   instance_type          = "t3.small"
#   vpc_security_group_ids = [var.sg_id]
#   subnet_id = "subnet-04269c5138b0e91e6" #replace your default sSubnet 
#   user_data = file("jenkins_agent.sh")
#   tags = merge(var.common_tags,var.server_tags,
#   {
#     Name = "jenkins-agent"
#   }
#   )
#   # root_block_device = [
#   #   {
#   #   volume_size = 50       # Size of the root volume in GB
#   #   volume_type = "gp3"    # General Purpose SSD (you can change it if needed)
#   #   delete_on_termination = true  # Automatically delete the volume when the instance is terminated
#   #   }
#   # ]
#   root_block_device = {
#   size                  = 50
#   type                  = "gp3"
#   delete_on_termination = true
# }
# }

# module "jenkins_nodejs" {
#   source  = "terraform-aws-modules/ec2-instance/aws"  #open source module for instance creation.
#   name = "nodejseks"
#   ami = data.aws_ami.joindevops.id
#   instance_type          = "t3.small"
#   vpc_security_group_ids = [var.sg_id]
#   user_data = file("nodejs.sh")
#   tags = merge(var.common_tags,var.server_tags,
#   {
#     Name = "nodejseks"
#   }
#   )
#   root_block_device = [
#     {
#     volume_size = 50       # Size of the root volume in GB
#     volume_type = "gp3"    # General Purpose SSD (you can change it if needed)
#     delete_on_termination = true  # Automatically delete the volume when the instance is terminated
#     }
#   ]  
# }

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "~> 3.0"

  zone_name = var.zone_name

  records = [
    {
      name    = "jenkins"  # jenkins.devgani.online
      type    = "A"
      ttl     = 1
      records = [
        module.jenkins.public_ip
      ]
      allow_overwrite = true
      
    }

    # {
    #   name    = "jenkins-agent" # jenkins-agent.devgani.online
    #   type    = "A"
    #   ttl     = 1
    #   records = [
    #     module.jenkins_agent.private_ip
    #   ]
    #   allow_overwrite = true

    # }

    # {
    #   name    = "nodejseks" # nodejseks.devgani.online
    #   type    = "A"
    #   ttl     = 1
    #   records = [
    #     module.jenkins_nodejs.private_ip
    #   ]
    #   allow_overwrite = true

    # }
  ]
}



