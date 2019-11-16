#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.618.0'}

#revoke an ip and change to curentip for port

#$portToCheck = "22"





$portToCheck = $LambdaInput.portToCheck
$currentIp = $LambdaInput.currentIp
$dryRun = $LambdaInput.dryRun




$secGroup = Get-EC2SecurityGroup
$secGroupList = $secGroup | Where-Object {$_.IpPermissions.ToPort -eq $portToCheck}
$resultSetCount = $secGroupList.Count
Write-Host "Found" $resultSetCount "groups with ports" $portToCheck "open"

foreach ($secGroup in $secGroupList){

	$PortPermissionList = $secGroup.IpPermissions | Where ToPort -in $portToCheck

	
	foreach ($ipPermisson in $PortPermissionList){
    
		Write-Host "-----------------------------------"
		Write-Host "Name :" $secGroup.GroupName
		Write-Host "Id:" $secGroup.GroupId
		

		$ipInSecurityGroup = $ipPermisson.Ipv4Ranges.CidrIp.Split("/")[0]
		
		Write-Host "IP address in security group:" $ipInSecurityGroup "for port:" $ipPermisson.FromPort
		
		If ($currentIp -ne $ipInSecurityGroup){
        
			Write-Host "Revoking permission for IP" $ipPermisson.Iprange "for port: " $ipPermisson.FromPort 
			if (!$dryRun){
				Revoke-EC2SecurityGroupIngress -GroupId $secGroup.GroupId -IpPermissions $ipPermisson 	
			}

			$cidrBlocks = New-Object 'collections.generic.list[string]'
			$cidrBlocks.add($currentIp + "/32")
			$newIpPermissions = New-Object Amazon.EC2.Model.IpPermission 
			$newIpPermissions.IpProtocol = $ipPermisson.IpProtocol
			$newIpPermissions.FromPort = $ipPermisson.FromPort 
			$newIpPermissions.ToPort = $ipPermisson.ToPort 
			$newIpPermissions.IpRanges = $cidrBlocks
			
			Write-Host "Granting permission for IP" $newIpPermissions.Iprange "for port" $newIpPermissions.FromPort 
			
			if (!$dryRun){
            
				Grant-EC2SecurityGroupIngress -GroupId $secGroup.GroupId -IpPermissions $newIpPermissions 
											  
			}
		}
		else
		{
			Write-Host "Security group is up-to-date"
		}
		Write-Host "-----------------------------------"
	}

}    
