output "public_ec2_public_ip" {
    value = module.ec2_public.public_ec2_public_ip 
}
output "public_ec2_private_ip" {
    value = module.ec2_public.public_ec2_private_ip
}