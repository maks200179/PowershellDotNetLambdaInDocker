#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.618.0'}

#revoke an ip and change to curentip for port

function Get-AWSEC2Details 
{
    [CmdletBinding()]
    Param 
    (
        [parameter(Mandatory=$true)]   
        [string] $PortToCheck
        ,
        [parameter(Mandatory=$true)]   
        [string] $CurrentIp
        ,
        [parameter(Mandatory=$true)]   
        [bool] $DryRun
    )
    
    try 
    {
        $secGroupList = Get-EC2SecurityGroup | Select -Property  IpPermissions,GroupId,GroupName |   Where-Object {$_.IpPermissions.ToPort -eq $portToCheck} -ErrorAction stop
    }
    catch 
    {
        $ErrorMessage = $_.Exception.Message
        Write-Error "Get-AWSEC2Details - Error: $ErrorMessage"
    }
    
    
        foreach ($secGroup in $secGroupList)
        {
            $PortPermissionList = $secGroup.IpPermissions | Where ToPort -in $portToCheck
        
            foreach ($ipPermisson in $PortPermissionList)
            {
                $ipInSecurityGroup = $ipPermisson.Ipv4Ranges.CidrIp.Split("/")[0]
                
                Write-Host "IP address in security group:" $ipInSecurityGroup "for port:" $ipPermisson.FromPort
                
                If ($currentIp -ne $ipInSecurityGroup)
                {
                    Write-Host "Revoking permission for IP" $ipPermisson.Ipv4Ranges.CidrIp.Split("/")[0] "for port: " $ipPermisson.FromPort 
                    if (!$DryRun)
                    {
                        
                        try 
                        {
                            Revoke-EC2SecurityGroupIngress -GroupId $secGroup.GroupId -IpPermissions $ipPermisson   
                        } 
                        catch 
                        {
                            $ErrorMessage = $_.Exception.Message
                            Write-Error "Revoke-EC2SecurityGroupIngress - Error: $ErrorMessage"
                            Continue
                        }
                      
                        
                    }
                        
                            $cidrBlocks = New-Object 'collections.generic.list[string]'
                            $cidrBlocks.add($currentIp + "/32")
                            $newIpPermissions = New-Object Amazon.EC2.Model.IpPermission 
                            $newIpPermissions.IpProtocol = $ipPermisson.IpProtocol
                            $newIpPermissions.FromPort = $ipPermisson.FromPort 
                            $newIpPermissions.ToPort = $ipPermisson.ToPort 
                            $newIpPermissions.IpRanges = $cidrBlocks
                            
                            Write-Host "Granting permission for IP" $newIpPermissions.IpRanges.Split("/")[0] "for port" $newIpPermissions.FromPort 
                        
                    if (!$DryRun)
                    {
                            
                        try 
                        {
                            Grant-EC2SecurityGroupIngress -GroupId $secGroup.GroupId -IpPermissions $newIpPermissions 
                        } 
                        catch 
                        {
                            $ErrorMessage = $_.Exception.Message
                            Write-Error "Grant-EC2SecurityGroupIngress - Error: $ErrorMessage"
                            Continue
                        }
                                                          
                    }
                }
                
                else
                    
                {
                    Write-Host "Security group is up-to-date"
                }
                    
                Write-Host "-----------------------------------"
            }

        }   
}      

#Get-AWSEC2Details  "22"   "192.168.1.1"  $False
Get-AWSEC2Details $LambdaInput.portToCheck $LambdaInput.currentIp $LambdaInput.dryRun
