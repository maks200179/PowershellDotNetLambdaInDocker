
```
IAM Web console  -> add programatic user 


Access key ID
xxxxxxxxxxxxxxxxxxx

Secret access key
xxxxxxxxxxxxxxxxxxxx

To install docker and docker compose use command   "./install_env.sh --docker_env" or "bash install_env.sh --docker_env"
To build docker powershell use "./build.sh" or "bash build.sh"  

docker cp /git_powershell/app/Pwsh_object_version.ps1  powershell:/LambdaFunctionRdsSgFind/

docker exec -it powershell bash

pwsh  to run powershell

Set-AWSCredential  -AccessKey xxxxxxxxxxxxxxxxxxx   -SecretKey xxxxxxxxxxxxxxxxxxxxxxx  -StoreAs MyNewProfile
Set-AWSCredentials -StoredCredentials MyNewProfile
Set-DefaultAWSRegion -Region us-east-2
Publish-AWSPowerShellLambda -ScriptPath \LambdaFunctionRdsSgFind\Pwsh_object_version.ps1.ps1 -Name  LambdaFunctionRdsSgFind -Region us-east-2

IAM create ne User and add user policy
 

Name  : Lambda: CreateAPolicyAPI


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


Create Lambda RDS policy 

Add to Lambda policy.


LambdaRds policy


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
