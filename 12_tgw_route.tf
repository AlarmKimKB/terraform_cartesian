data "aws_ec2_transit_gateway" "tgw" {
  id = var.tgw_id
}

data "aws_ec2_transit_gateway_attachment" "tgw_attachment" {
  filter {
    name   = "transit-gateway-id"
    values = [data.aws_ec2_transit_gateway.tgw.id]
  }
}


// !! 아래 코드는 원하는 값이 나오지 않는다 !!
# resource "aws_route" "add_route" {
#   depends_on = [data.aws_ec2_transit_gateway.tgw]
#   count                  = length(var.add_route)

#   route_table_id         = aws_route_table.private_routing_tables[count.index].id
#   destination_cidr_block = var.add_route[count.index]
#   transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
# }


// Cartesian Product 리소스 반복문
resource "aws_route" "add_route" {
  for_each = {
    for pair in local.add_route :
    "${pair.route_table_name}:${pair.destination_cidr_block}" => pair
    if pair.create_route == true
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr_block
  transit_gateway_id     = data.aws_ec2_transit_gateway.tgw.id
  depends_on             = [data.aws_ec2_transit_gateway.tgw]
}
