#create VPC
resource "aws_vpc" "myvpc1" {
    tags = {
      Name="myvpc1"
    }
  cidr_block = "10.0.0.0/16"
}
#create Internet gateway and attach to vpc
resource "aws_internet_gateway" "myvpc1" {
    tags = {
        Name="myig1"
    }
  #attach Ig to vpc
  vpc_id = aws_vpc.myvpc1.id
}
# create public subnet
resource "aws_subnet" "myvpc1" {
    vpc_id = aws_vpc.myvpc1.id
    tags ={
        Name="mypubsub"
    }
    #availability_zone = "eu-west-1a"
    cidr_block = "10.0.0.0/17"  
}
# create private subnet and nat gateway
resource "aws_eip" "myelastic" {
  
}
resource "aws_nat_gateway" "myvpc1" {
  tags = {
    Name="Mynat"
  }
  subnet_id = aws_subnet.myvpc1.id
  allocation_id = aws_eip.myelastic.id
}

# create route table
resource "aws_route_table" "myvpc1" {
    tags = {
      Name="mypubrt"
    }
    vpc_id = aws_vpc.myvpc1.id
    #create edit route
    route{
        cidr_block="0.0.0.0/0"
        gateway_id = aws_internet_gateway.myvpc1.id
    }
}
#create subnet association
resource "aws_route_table_association" "myvpc1" {
#edit subnet assoccciation
route_table_id =aws_route_table.myvpc1.id
subnet_id = aws_subnet.myvpc1.id
}
#ec2 instance
resource "aws_instance" "myec2" {
    tags ={
        Name="my-jenkins1"
    }
    ami = var.ami_id
    instance_type = var.instance_type
    key_name = var.key_name
    subnet_id = aws_subnet.myvpc1.id
  
}
