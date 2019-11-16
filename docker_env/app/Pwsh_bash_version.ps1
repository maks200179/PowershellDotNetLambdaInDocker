$rulesRemoved = 0
#$VpcSecurityGroup = $LambdaInput.VpcSecurityGroupVar
$VpcSecurityGroup = "{sg-0a9cae49df2872c0d}"

#$string = (Get-RDSDBInstance | Select-Object -ExpandProperty VpcSecurityGroups |ft -HideTableHeaders|	Out-String).Trim()
$string = (Get-RDSDBInstance | select -Property	 VpcSecurityGroups,DBInstanceArn | ft -HideTableHeaders | Out-String).Trim()

ForEach ($item in $($string -split "`r`n|`r|`n"))  
 {

	$DBInstanceArn =  ($item -split " " | select -last 1)
	$VpcSecurityGroupID =  ($item -split " " | select -first 1)
	
	Write-Host "DBInstanceArn : " $DBInstanceArn
	Write-Host "VpcSecurityGroup : " $VpcSecurityGroupID
	
	$GetTagForRds = Get-RDSTagForResource -ResourceName $DBInstanceArn | Where-Object {$_.key -eq "Phase"} | Select-Object -Expand Value
	
	
	if(($VpcSecurityGroupID -Contains $VpcSecurityGroup) -and ($GetTagForRds -Contains "Prod")) {
			Write-Host "securityGroupId : " $VpcSecurityGroupID
			Write-Host "GetTagForRds : "    $GetTagForRds
			
			$rulesRemoved++
			Write-Host "rulesRemoved : " $rulesRemoved
		}
	
	
	
}  
