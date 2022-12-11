resource "aws_route_table" "public_routing_tables" {
  count  = ( length(aws_subnet.public_subnets) > 1 ) ? 1 : 0
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }
  
  tags = {
    Name = format("rtb-%s-pub-%d",
           var.env,
           (count.index+1))
  }
}

resource "aws_route_table" "private_routing_tables" {
  count  = length(aws_subnet.private_subnets)
  vpc_id = aws_vpc.example.id

  dynamic "route" {
    for_each = var.private_subnets[count.index].use_nat ? [true] : []
    content {
      cidr_block      = "0.0.0.0/0"
      nat_gateway_id  = aws_nat_gateway.example_nat[count.index].id
    }
  }

  // 아래처럼 Static 하게 Route 설정을 해도 괜찮지만...
#   route {
#     cidr_block 			= "10.100.0.0/16"
#     transit_gateway_id  = "data.aws_ec2_transit_gateway_attachment.tgw_attachment.id"
#   }
#   route {
#     cidr_block 			= "192.168.10.0/24"
#     transit_gateway_id  = "data.aws_ec2_transit_gateway_attachment.tgw_attachment.id"
#   }  

  tags = {
    Name = format("rtb-%s-pri-%s",
           var.env,
           substr(split("-", var.private_subnets[count.index].az)[2], 1, 1))
  }

}

resource "aws_route_table_association" "public_subnets" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public_routing_tables[0].id
}

resource "aws_route_table_association" "private_subnets" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_routing_tables[count.index].id
}