#Requires -Modules @{ModuleName='AWSPowerShell.NetCore';ModuleVersion='3.3.618.0'}
function Get-AWSRDSDetails 
{
    [CmdletBinding()]
    Param 
    (
            [parameter(Mandatory=$true)]   
            [string] $VpcSecurityGroupIDToRemove
    )
    
    $rulesRemoved = 0
    $rulesFinded  = 0

    try {
        $RDSInstances = Get-RDSDBInstance | Select -Property  VpcSecurityGroups,DBInstanceArn,DBInstanceIdentifier -ErrorAction stop
    } catch {
        $ErrorMessage = $_.Exception.Message
        Write-Error "Get-AWSRDSDetails - Error: $ErrorMessage"
        
    }
    
    foreach ($instance in $RDSInstances) 
    {
        [array]$VpcGroupID    = ($instance.VpcSecurityGroups.VpcSecurityGroupId).Trim() 
        $Environment          = Get-RDSTagForResource  $instance.DBInstanceArn | Where-Object {$_.key -eq "Phase"} | Select-Object -Expand Value
        $DBInstanceIdentifier = ($instance.DBInstanceIdentifier | ft -HideTableHeaders | Out-String).Trim()
        
        if(($VpcGroupID -Contains $VpcSecurityGroupIDToRemove) -and ($Environment -eq "Prod")) 
        {
            $rulesFinded++
            
            if($VpcGroupID.Count -gt 1) 
            
            {
                [System.Collections.ArrayList]$VpcGroupIDEdited = $VpcGroupID
                $VpcGroupIDEdited.Remove($VpcSecurityGroupIDToRemove)
            }
                
            else
            {
                Write-Host "The RDS " $DBInstanceIdentifier " has only one vpc group , cant remove" 
                Continue
            }
                
            try 
            {
                Edit-RDSDBInstance -DBInstanceIdentifier $DBInstanceIdentifier -VpcSecurityGroupId $VpcGroupIDEdited -Force 
            }   catch 
            {
                $ErrorMessage = $_.Exception.Message
                Write-Error "Edit-RDSDBInstance - Error: $ErrorMessage"
                Continue
            }    
                $rulesRemoved++
        }
        
    }
    
    Write-Host "CountRulesFinded : "  $rulesFinded
    Write-Host "CountRulesRemoved : " $rulesRemoved
    
}





Get-AWSRDSDetails  $LambdaInput.VpcSecurityGroupVar
