# This Module contain the EC2 Creation with EIP attached With Custom EBS Size

## Variabes Used

| Variable Name | Type      | Example           |
| :-----        | :----     | :----             |
| region        | String    | "ap-southeast-1"  |
| az_code       | String    | "a"               |
| redhat        | bool      | false             |
| ubuntu        | bool      | false             |
| amzlinux      | bool      | false             |
| windows2019   | bool      | false             |
| ebs_size      | Number    | 10                |
| instance_type | String    | "t2.micro"        |
| ec2_name      | String    | "bastian-vm"      |
| ec2_key       | String    | "ec2_key_pair"    |
| project       | String    | "test-project"    |
| ec2_vpc       | String    | "vpc-59d68"       |
| ec2_subnet    | String    | "subnet-5d825"    |
| my_ip         | String    | "121.16.15.18"    |

.
.
### **Note:** Out of the four varibles __redhat__, __ubuntu__, __amzlinux__ and __windows2019__, only one can be true at a given execution.

