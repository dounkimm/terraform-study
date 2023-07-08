# 테라폼 스터디 1주차

## 1. IaC와 테라폼

####  1. IaC
  - IaC : 코드형 인프라(Infrastructure as Code)로 코드로서의 인프라
  - 코드로 인프라를 관리한다는 것은 '자유롭게 변경'하고, '환경을 이해'하고, '반복적으로 동일한 상태를 만들수 있다'

#### 2. 테라폼
  - 테라폼은 하시코프(Hashicorp)에서 공개한 IaC 도구
  - 제공 유형 : On-Premise(Terraform opensource), Hosted SaaS(Terraform Cloud), Private Install(Terraform Enterprise) 형태로 제공
  - 테라폼과 다른 도구의 비교  
    | |Terraform|Ansible|CloudFormation|ARM Template|
    |------|---|---|---|---|
    |유형|프로비저닝|구성관리|프로비저닝|프로비저닝|  
    |오픈소스 여부|공개|공개|비공개|비공개|  
    |적용 대상 클라우드|멀티|멀티|AWS 전용|Azure전용|  
    |구성 방식|이뮤터블|뮤터블|이뮤터블|이뮤터블|  

<br/>
<br/>

## 2. 실행 환경 구성

####  1. 테라폼 설치
  - 설치 url : https://developer.hashicorp.com/terraform/downloads?product_intent=terraform
  - OS : Linux
    <pre>
      <code>
        # wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
        # echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
        # sudo apt update && sudo apt install terraform
      </code>
    </pre>
  - 설치 후 버전 확인        
    ![image](https://github.com/dounkimm/tstudy/assets/98010656/26082ebb-627b-49ad-a8be-c2690092fd91)

####  2. IDE 구성
  - IDE는 Visual Studio Code(VS Code) 사용
  - VS Code Extensions(확장) 설치  
      - HashiCorp HCL  
        ![image](https://github.com/dounkimm/tstudy/assets/98010656/d83ed24d-dbc8-4924-adbf-191a791367a0)
      - HashiCorp Terraform  
        ![image](https://github.com/dounkimm/tstudy/assets/98010656/4c992540-02f6-4e45-a1a1-761adc66d3f2)

<br/>
<br/>

## 3. 기본 사용법(1)

####  1. 주요 커맨드
  - terraform init : 테라폼 구성 파일이 있는 작업 디렉터리를 초기화 하는데 사용
  - terraform plan : 테라폼 적용할 변경사항에 관한 실행 계획을 생성하는 동작. **출력 결과를 통해 변경이 적용될 내용 검토 가능**
  - terraform apply : plan에서 작성된 내용을 토대로 작업 실행. **동작에 대한 승할 것을 묻는 메세지 출력**
  - terraform destroy : 테라폼 구성에서 관리하는 모든 개체를 제거
  - terraform fmt

####  2. HCL
  - HCL(HashiCorp configuration language)은 하시코프에서 IaC와 구성 정보를 명시하기 위해 개발된 오픈 소스 도구
  - JSON과 YAML방식의 기계 친화적인 언어로도 사용이 가능하지만 HCL을 사용하면 더 간결하고 읽기 쉬움
  - 테라폼으로 인프라를 구성하기 위한 선언 블록
    > terraform 블록  
    > resource 블록  
    > data 블록  
    > variable 블록  
    > local 블록  
    > output 블록  

####  3. 테라폼 블록 & 백엔드 블록
  - 테라폼 블록 : 테라폼의 구성을 명시하는데 사용  
    → 버전 관리 방식 # version = Major.Minor.Patch  
    → 협업을 위한 관점으로 확장 할 경우를 위해 **버전 명시 필요**  
  - 백엔드 블록 : 테라폼 실행 시 저장되는 State의 저장 위치를 선언  
    → **하나의 백엔드만 허용**  
    → 테라폼은 State의 데이터를 사용해 코드로 관리된 리소스를 탐색하고 추적  

#### 4. 리소스
  - 리소스 블록 : resource로 시작하며, 리소스 블록이 생성할 리소스 유형을 정의
    <pre>
      <code>
        resource "<리소스 유형>" "<이름>"{
          <인수> = <값>
        }
            
        resource "local_file" "abc"{
          content = "123!"
          filename = "${path.module}/abc.txt"
        }
      </code>
    </pre>
  - 종속성 : resource, module 선언으로 프로비저닝되는 각 요소의 생성 순서를 구분
    → 강제로 리소스 간 명시적 종속성을 부여할 경우에는 메타인수인 **depends_on**을 활용
    <pre>
      <code>
        resource "local_file" "abc"{
          content = "123!"
          filename = "${path.module}/abc.txt"
        }
        
        resource "local_file" "def"{
          content = local_file.abc.content    //local_file.abc의 속성 값을 넣기 위해서는 local_file.abc 리소스가 생성 된 후 local_file.def 생성되어야 함
          filename = "${path.module}/def.txt"
        
          depends_on = [local_file.abc]      //local_file.abc에 대한 종속성 명시
        }
      </code>
    </pre>
  - 수명주기
    > create_before_destroy(bool) : 리소스 수정 시 신규 리소스를 우선 생성하고 기존 리소스를 삭제
    > prevent_destroy(bool) : 해당 리소스를 삭제 하려 할 때 명시적으로 거부
    > ignore_changes(list) : 리소스 요소에 선언된 인수의 변경 사항을 테라폼 실행 시 무시
    > precondition : 리소스 요소에 선언된 인수의 조건을 검증
    > postcondition : plan 과 apply 이후 결과를 속성 값으로 검증
    

#### 5. 데이터 소스 & 입력 변수(Variable)
  - 데이터 소스 : 테라폼으로 정의되지 않은 외부 리소스 또는 저장된 정보를 **테라폼 내에서 참조 할 때 사용**
    <pre>
      <code>
        data "<리소스 유형>" "<이름>"{
          <인수> = <값>
        }

        # 데이터 소스 참조
        data.<리소스 유형>.<이름>.<속성>
      </code>
    </pre>
  - 입력 변수(Variable) : 변수 선언 시 사용되는 블록
    <pre>
      <code>
        variable "<이름>"{
          <인수> = <값>
        }
      </code>
    </pre>
    → 테라폼 코드 구성에 예약되어 있어 사용 불가능한 이름 : *source, version, providers, count, for_each, lifecycle, depends_on, locals*  
    → 변수 유형
      - 기본유형
        >string  
        >number  
        >bool  
        >any  
      - 집합 유형
        >list(<유형>)  
        >map(<유형>)  
        >set(<유형>)  
        >object({<인수 이름>=<유형>, ...})  
        >tuple([<유형>, ...]))  


#### 6. local(지역 값)
  - 코드 내에서 사용자가 지정한 값 또는 속성 값을 가공해 참조 가능
  - **local은 외부에서 입력되지 않고, 코드 내에서만 가공되어 동작하는 값을 선언**
  - 로컬이 선언되는 블록은 **locals**로 시작하며 참조 시에는 **local.<이름>**으로 참조
