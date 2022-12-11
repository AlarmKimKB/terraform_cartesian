output "vpc_id" {
  value = aws_vpc.example.id
}

output "pub_sub_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "pri_sub_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "pub_rtb_id" {
  value = aws_route_table.public_routing_tables[*].id
}

output "pri_rtb_id" {
  value = aws_route_table.private_routing_tables[*].id
}

# output "tgw_id" {
#   value = data.aws_ec2_transit_gateway.tgw.id
# }

# output "tgw_attachment_id" {
#   value = data.aws_ec2_transit_gateway_attachment.tgw_attachment.id
# }

# output "local_add_route_value" {
#   value = local.add_route
# }

# output "final_add_route_value" {
#   value = aws_route.add_route
# }

# output "prior_for_each" {
#   value = local.check_value
# }