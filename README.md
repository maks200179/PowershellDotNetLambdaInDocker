
# AWS: create IAM User 

IAM Web console  -> create programatic user. 

Access key ID
xxxxxxxxxxxxxxxxxxx
Secret access key
xxxxxxxxxxxxxxxxxxxx



 
# User access permission to create Lambda

PolicyName  : LambdaCreatePolicyAPI

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

# Lambda RDS policy 

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
                "rds:StopDBInstance",
                "rds:StartDBInstance",
                "rds:ListTagsForResource",
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


# Docker compose env 

To install docker and docker compose use command   "./install_env.sh --docker_env" or "bash install_env.sh --docker_env"

To build docker powershell use "./build.sh" or "bash build.sh"  


```
docker exec powershell pwsh -c "Set-AWSCredential  -AccessKey xxxxxxxxxxxxxxxxxxx   -SecretKey xxxxxxxxxxxxxxxxxxxxxxx  -StoreAs MyNewProfile"
docker exec powershell pwsh -c "Initialize-AWSDefaultConfiguration -ProfileName MyNewProfile -Region us-east-2"
docker exec -it powershell bash
pwsh -c "Publish-AWSPowerShellLambda -ScriptPath \app\Pwsh_object_version.ps1 -Name  LambdaFunctionName" 

```
