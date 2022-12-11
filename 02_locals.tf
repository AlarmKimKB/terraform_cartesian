locals {
  add_route = [
    for pair in setproduct(aws_route_table.private_routing_tables, var.add_route) : {
      route_table_id         = pair[0].id
      destination_cidr_block = pair[1].dst_cidr
      create_route           = pair[1].create_route
      route_table_name       = pair[0].tags.Name
    }
  ]

  check_value = {
    for pair in local.add_route :
    "${pair.route_table_name}:${pair.destination_cidr_block}" => pair
    if pair.create_route == true
  }
}