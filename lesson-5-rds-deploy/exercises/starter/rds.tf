module "project_rds_p" {
  source = "./modules/rds-p"
  private_subnet_ids = module.vpc.private_subnet_ids
  vpc_id = module.vpc.vpc_id
  availability_zones = ["us-east-2a","us-east-2b","us-east-2c"]
}

module "project_rds_s" {
  source                  = "./modules/rds-s"
  rds_primary_source_identifier  = module.project_rds_p.db_cluster_arn  
  rds_primary_source_region      = "us-east-2"  
  availability_zones = ["us-west-1a","us-west-1c"]

  private_subnet_ids = module.vpc_west.private_subnet_ids
  vpc_id = module.vpc_west.vpc_id

  providers = {
    aws = aws.usw1
   }
}