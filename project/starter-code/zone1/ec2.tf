  module "project_ec2" {
   source             = "./modules/ec2"
   instance_count     = var.instance_count
   name               = local.name
   account            = data.aws_caller_identity.current.account_id
   aws_ami            = "ami-0496ed06629717eba"
   private_subnet_ids = module.vpc.private_subnet_ids
   public_subnet_ids  = module.vpc.public_subnet_ids
   vpc_id             = module.vpc.vpc_id
   project_root_directory = var.project_root_directory
   lb_security_group = module.alb.lb_security_group
   lb_target_group = module.alb.lb_target_group_arn
 }

#  resource "null_resource" "update_postman_env_file" {
#   triggers = {
#     always_run = "${timestamp()}"
#   }

#   provisioner "local-exec" {
#     working_dir = var.project_root_directory
#     command = "cat SRE-Project.postman_environment.json | jq \".values=( [ .values[] | if .key==\\\"public-ip\\\" then .value=\\\"${module.project_ec2.ec2_instance_public_ip[0]}\\\" else . end ])\" > SRE-Project.postman_environment.json"
#   }
# }