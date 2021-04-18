
## Connect to vCenter and Load all vm names to variable $VirtualMachines
cls
$vCenter = Read-Host -Prompt "Please type the vCenter IP or FQDN "
Connect-VIServer -Server $vCenter
$vmList = get-vm | select -ExpandProperty name


 

##  Main menu  ######
function mainmenu{
menu 
$Choice = Read-Host -Prompt "Choice" 
  If ($Choice -eq "1") {
       vm_tools_info
       menu
 } ElseIf ($Choice -eq "2") {
       check_snap
       menu
 } ElseIf ($Choice -eq "3"){
      vm_tools_del
 }ElseIf ($Choice -eq "4"){
      clear
      Write-Host "Existing script."
      Disconnect-VIServer -Server * -Force -Confirm:$false 
 }
 Else {
    error
 }
}




##  Create menu  ######
function menu {
 cls
   Write-Host "================================================" 
   Write-Host "  Welcome to vCenter multiChoice menu."
   Write-Host "================================================
    Please provide number for required action 
   -------------------------------------------
     1. VM Tools
     2. Check for snapshots
     3. Multi selection snaps to remove
     4.Exit 
   ------------"
 }



##  VM Tools Info Menu "1"  ######
function vm_tools_info {
   $vmTools = get-vm | select -ExpandProperty name
   get-vm $vmTools | %{get-view $_.id} | Format-Table -AutoSize Name,@{N="Tools version";E={if($_.Guest.ToolsVersion -ne ""){$_.Guest.ToolsVersion}}},@{Name="ToolsStatus";Expression={$_.Guest.ToolsStatus}}| out-file vmtools_info.txt
   Write-Host "VMTools file is stored in vmtools_info.txt"
   Start-Sleep -s 3
   Invoke-Item vmtools_info.txt
   
## Go back to main menu
 back_menu 
 }



##  Check for snapshots Menu "2"  ######
function check_snap {
   Get-VM | Sort Name | Get-Snapshot | Where { $_.Name.Length -gt 0 } | Select VM,Name,Created,Description,@{N="SizeGB";E={[math]::Round(($_.SizeMB/1024),2)}}| Format-List | out-file snaps_file.txt
   Write-Host "Snapshot file is stored in snaps_file.txt"
   Start-Sleep -s 3
   Invoke-Item snaps_file.txt

## Go back to main menu
 back_menu 
 }

####################################################################


##  Check for snapshots Menu "3"  ######
function vm_tools_del {
  $snaps = Get-VM | Sort Name | Get-Snapshot | Where { $_.Name.Length -gt 0 } | Select VM,Name,Created,Description,@{N="SizeGB";E={[math]::Round(($_.SizeMB/1024),2)}}| Out-GridView -Title "Select Multiple Snaps to be Removed" -OutputMode Multiple
  $totaltasks = 5

  foreach($snap in $snaps){
      $removal = Get-VM -Name $snap.VM | Get-Snapshot -Name $snap.Name | Remove-Snapshot -Confirm:$false
      $current = Get-Task | where {$_.Name -eq 'RemoveSnapshot_Task' -and 'Running','Queued' -contains $_.State
     }

     while ($current.count -gt $totaltasks) {
      sleep 5
      $current = Get-Task | where {$_.Name -eq 'RemoveSnapshot_Task' -and 'Running','Queued' -contains $_.State}
     }
   
}

## Go back to main menu
 back_menu 
 }



##  Back to main menu  ######

function back_menu {
  cls
  Start-Sleep -s 3
  mainmenu
}



##  Invalid menu option  ######

function error {
  Write-Host " Invalid menu option. Please try again"
  Start-Sleep -s 2
  mainmenu
}


#####Start of Script ############
mainmenu
