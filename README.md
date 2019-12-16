## PowerShell core 6 and .Net core 3 in Docker on Centos7  


#### AWS: Create an IAM User 

IAM Web console  -> create programatic user. 

Access key ID
xxxxxxxxxxxxxxxxxxx
Secret access key
xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

#### Restrict user permission by source Ip for all AWS resourses 

Create IAM new policy and attach to new user 

```
{
    "Version": "2012-10-17",
    "Statement": {
        "Effect": "Deny",
        "Action": "*",
        "Resource": "*",
        "Condition": {
            "NotIpAddress": {
                "aws:SourceIp": [
                    "The_ip_you_want_to_allow/32",
                    "The_ip_you_want_to_allow/32"
                ]
            }
        }
    }
}

```
#### Lambda and IAM policy
 
User access permission to create Lambda

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "lambda:CreateFunction",
                "lambda:UpdateFunctionConfiguration",
                "lambda:UpdateFunctionCode",
                "lambda:GetFunctionConfiguration",
                "lambda:ListFunctions",
                "iam:CreateRole",
                "iam:attachRolePolicy",
                "iam:createPolicy",
                "iam:ListRoles",
                "iam:ListPolicies",
                "iam:GetRole",
                "iam:PassRole",
                "iam:ListRolePolicies",
                "iam:ListAttachedRolePolicies"
            ],
            "Resource": "*"
        }
    ]
}

```

#### Lambda RDS policy 

Should Add to Lambda policy.


LambdaRds policy json

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "rds:DescribeDBInstances",
                "rds:ListTagsForResource",
                "rds:ModifyDBInstance"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
```

#### To use EC2 the policy below required

For script Pwsh_revoke_ip_adress_for_port.ps1

The test event json.
```
{
  "portToCheck": "22",
  "currentIp": "the_ip_you_want_to_allow_connect_to_port_22",
  "dryRun": $false
}
```
#### EC2 policy 
```

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DescribeSecurityGroups",
                "ec2:RevokeSecurityGroupIngress"
            ],
            "Resource": "*"
        }
    ]
}


```


#### Docker compose env 

To install docker and docker compose use command   "./install_env.sh --docker_env" or "bash install_env.sh --docker_env"

To build docker powershell use "./build.sh" or "bash build.sh"  


```
docker exec powershell pwsh -c "Set-AWSCredential  -AccessKey xxxxxxxxxxxxxxxxxxx   -SecretKey xxxxxxxxxxxxxxxxxxxxxxx  -StoreAs MyNewProfile"
docker exec powershell pwsh -c "Initialize-AWSDefaultConfiguration -ProfileName MyNewProfile -Region us-east-2"
docker exec -it powershell bash
pwsh -c "Publish-AWSPowerShellLambda -ScriptPath \app\Pwsh_find_a_group_rds_object_version.ps1 -Name  LambdaFunctionName" 

```
