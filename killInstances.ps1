[string[]] $InstanceList = @()
[string []] $states = @("running","pending","shutting-down","terminated","stopping","stopped")
foreach ($Region in (Get-AWSRegion).Region) { 
	Write-Output "Processing  Region $Region "
	foreach ($s in $states) {
		$InstanceList=(Get-EC2Instance -Region $Region -filter  @{Name="instance-state-name";Value=$s}).Instances.InstanceId
		$theCount=$InstanceList.Count
		Write-Output "Region $Region has  total $theCount instances[  $InstanceList  ]  in state $s" 
		if ($s -eq "running" -or $s -eq "pending"){
			Write-Output "Attempting to kill the instances $instanceList" 
			foreach ($i in $InstanceList) { 
			Edit-EC2InstanceAttribute -Region $Region -InstanceId $i -DisableapiTermination $FALSE
			Write-Output "Removing instance $i"
			Remove-EC2Instance -Region $Region -InstanceId $i  -Force
			Write-Output "Removed instance $i"
			}
		  }
	 }	
	Write-Output "Completed  Region" $Region 
}