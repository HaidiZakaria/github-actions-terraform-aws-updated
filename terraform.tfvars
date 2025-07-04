region            = "eu-west-1"
ami_id            = "ami-0fab1b527ffa9b942" # Ubuntu 22.04 (verify in your region)
instance_type     = "t2.micro"
aws_access_key    = "" # Will be passed in GitHub Secrets
aws_secret_key    = "" # Will be passed in GitHub Secrets
public_key_path   = "id_rsa.pub"
private_key_path  = "id_rsa"
