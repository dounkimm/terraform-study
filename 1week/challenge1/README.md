
### 리소스 생성 그래프 확인

```
# terraform graph
digraph {
        compound = "true"
        newrank = "true"
        subgraph "root" {
                "[root] aws_instance.example (expand)" [label = "aws_instance.example", shape = "box"]
                "[root] aws_security_group.instance (expand)" [label = "aws_security_group.instance", shape = "box"]
                "[root] provider[\"registry.terraform.io/hashicorp/aws\"]" [label = "provider[\"registry.terraform.io/hashicorp/aws\"]", shape = "diamond"]
                "[root] var.security_group_name" [label = "var.security_group_name", shape = "note"]
                "[root] aws_instance.example (expand)" -> "[root] aws_security_group.instance (expand)"
                "[root] aws_security_group.instance (expand)" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"]"
                "[root] aws_security_group.instance (expand)" -> "[root] var.security_group_name"
                "[root] output.public_ip (expand)" -> "[root] aws_instance.example (expand)"
                "[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)" -> "[root] aws_instance.example (expand)"
                "[root] root" -> "[root] output.public_ip (expand)"
                "[root] root" -> "[root] provider[\"registry.terraform.io/hashicorp/aws\"] (close)"
        }
}
```

![image](https://github.com/dounkimm/tstudy/assets/98010656/68945cba-044c-4bda-81a8-2f775a69dd84)

