#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.618.0'}
$VpcSecurityGroupIDToRemove = $LambdaInput.VpcSecurityGroupVar

$rulesRemoved = 0

	try {
		$RDSInstances = Get-RDSDBInstance 
	} catch {
		$ErrorMessage = $_.Exception.Message
		Write-Warning "Get-AWSRDSDetails - Error: $ErrorMessage"
		return
	}
    
	foreach ($instance in $RDSInstances) {
			
            $VpcGroupID           = ($instance.VpcSecurityGroups | Select-Object -Expand VpcSecurityGroupId).Trim() 
			$ARN			      = ($instance.DBInstanceArn |ft -HideTableHeaders |	 Out-String).Trim()
			$Environment	      = Get-RDSTagForResource  $instance.DBInstanceArn | Where-Object {$_.key -eq "Phase"} | Select-Object -Expand Value
            $VpcSecurityGroupName = (Get-EC2SecurityGroup  -GroupId $VpcGroupID | Select-Object -Expand GroupName).Trim() 
             
            
            if(($VpcGroupID -Contains $VpcSecurityGroupToRemove) -and ($Environment -Contains "Prod")) {
                Write-Host "Security_Group_Id : " $VpcGroupID
                Write-Host "ARN_ID : " $ARN
                Write-Host "Vpc_Security_Group_Name : " $VpcSecurityGroupName
                try {
                    Remove-EC2SecurityGroup -GroupId $VpcGroupID -Force
                } catch {
		            $ErrorMessage = $_.Exception.Message
		            Write-Warning "Get-AWSRDSDetails - Error: $ErrorMessage"
		            return
	        }    
                $rulesRemoved++
                Write-Host "rulesRemoved : " $rulesRemoved
		}

}