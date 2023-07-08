
### 리소스 생성 그래프 확인

```
digraph {
        compound = "true"
        newrank = "true"
        subgraph "root" {
                "[root] aws_instance.test (expand)" [label = "aws_instance.test", shape = "box"]
                "[root] aws_security_group.test_sg (expand)" [label = "aws_security_group.test_sg", shape = "box"]
                "[root] aws_subnet.test_subnet (expand)" [label = "aws_subnet.test_subnet", shape = "box"]
                "[root] data.aws_vpc.selected (expand)" [label = "data.aws_vpc.selected", shape = "box"]
                "[root] provider[\"registry.terraform.io/hashicorp/aws\"]" [label = "provider[\"registry.terraform.io/hashicorp/aws\"]", shape = "diamond"]
                "[root] var.key_name" [label = "var.key_name", shape = "note"]
                "[root] var.name" [label = "var.name", shape = "note"]
                "[root] var.vpc_id" [label = "var.vpc_id", shape = "note"]
                "[root] aws_instance.test (expand)" -> "[root] aws_security_group.test_sg (expand)"
                "[root] aws_instance.test (expand)" -> "[root] aws_subnet.test_subnet (expand)"
                "[root] aws_instance.test (expand)" -> "[root] var.key_name"
                "[root] aws_security_group.test_sg (expand)" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"]"
                "[root] aws_security_group.test_sg (expand)" -> "[root] var.name"
                "[root] aws_subnet.test_subnet (expand)" -> "[root] data.aws_vpc.selected (expand)"
                "[root] aws_subnet.test_subnet (expand)" -> "[root] var.name"
                "[root] data.aws_vpc.selected (expand)" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"]"
                "[root] data.aws_vpc.selected (expand)" -> "[root] var.vpc_id"
                "[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)" -> "[root] aws_instance.test (expand)"
                "[root] root" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)"
        }
}
```
![image](https://github.com/dounkimm/tstudy/assets/98010656/4bbb2a72-0674-4d65-a443-8aaf6d2a5ad9)
