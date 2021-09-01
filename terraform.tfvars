instance_type       = "t2.micro"
protocol            = "tcp"
region              = "us-east-1"
cidr                = ["0.0.0.0/0"]
connection_draining = true
common_tags         = "devops14-2021"
az                  = ["us-east-1a", "us-east-1b"]