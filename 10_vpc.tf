resource "aws_vpc" "example" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = {
    Name = format("vpc-%s",
           var.env)
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags   = {
    Name = format("igw-%s",
           var.env)
  }
}

resource "aws_eip" "example_eip" {
  depends_on     = [aws_internet_gateway.example]
  count          = length(var.public_subnets)
  vpc            = true

  tags   = {
    Name = format("eip-%s-%s",
           var.env,
           substr(split("-", var.public_subnets[count.index].az)[2], 1, 1))
  }
}

resource "aws_nat_gateway" "example_nat" {
  depends_on    = [aws_eip.example_eip]
  count         = length(var.public_subnets)

  allocation_id = aws_eip.example_eip[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index].id

  tags   = {
    Name = format("nat-%s-%s",
           var.env,
           substr(split("-", var.public_subnets[count.index].az)[2], 1, 1))
  }
}


resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.example.id
  availability_zone       = var.public_subnets[count.index].az
  cidr_block              = var.public_subnets[count.index].cidr
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.example]

  tags = {
  // sub-stg-pub-a
  Name = format("sub-%s-pub-%s",
         var.env,
         substr(split("-", var.public_subnets[count.index].az)[2], 1, 1)
         )}
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.example.id
  availability_zone       = var.private_subnets[count.index].az
  cidr_block              = var.private_subnets[count.index].cidr
  map_public_ip_on_launch = true
  depends_on              = [aws_internet_gateway.example]

  tags = {
  // sub-stg-pub-a
  Name = format("sub-%s-pri-%s",
         var.env,
         substr(split("-", var.private_subnets[count.index].az)[2], 1, 1)
         )}
}
