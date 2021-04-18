# vCenter Snapshots and VMTools version.

## Scope:
 You can use the script in order check vmtools versions of the vms, check if there are snapshots present in vCenter and also select multiple snapshots to be removed. The script will generate files for VMTools and for snapshots that are present on vCenter.
 
## Requirements:
* Windows Server 2K12 and above // Windows 10
* Powershell 5.1 and above
* PowerCli either standalone or import the module in Powershell (Preferred)


## Running the script
Open Powershell or Powercli and run the script directly
```powershell
  PS> vcenter_snapshots.ps1
```
It will ask you for the vCenter name. You can either put FQDN or IP and a pop up for vCenter credentials will appear. You can use any account that has "Administrator" rights on vCenter. It is not necessary to use the administrator@vsphere.local

## Example

![Alt text](/screenshots/vcenter.jpg?raw=true "Run script")
 
As soon as the script logs to the vCenter it will give you a menu with 4 options. 

![Alt text](/screenshots/menu.jpg?raw=true "Menu")

## Option 1:
It will generate a file with vmtools version and status for all vms. From there it is easy to spot which vm needs ugrade, which needs install and which vmtools are up-to-date

![Alt text](/screenshots/vmtools.jpg?raw=true "VMTools")

## Option 2:
It will generate a file with information of snapshots like Name, Description, size and date of creation.

![Alt text](/screenshots/snapsfile.jpg?raw=true "Snapshot")

## Option 3:
It will popup a grid window with all the snapshots on vCenter. You can select multiple snapshots by holding Ctrl key. The script will remove all the selected snapshots 5 tasks at a time.

![Alt text](/screenshots/snaps.jpg?raw=true "Snapshot")

The script will check the tasks on vCenter and allow only 5 removal snapshot tasks at all time. This means that even if you select multiple snaps to be removed in vCenter only 5 tasks will be performed at any time. 
For example you select 8 snapshots to be removed. Script will perform snapshot removal for the first 5 snapshots and as soon as any of the tasks complete then the remaining snaps will take place to be removed.

![Alt text](/screenshots/vcenter_tasks.jpg?raw=true "vCenter Tasks")

## Option 4:
Quits the script.
   
## Frequetly Asked Questions:
* Will be there downtime during this activity?
   > No there is no downtime. VMTools and Snapshot report removal has no impact to running vms

* How many snapshots can I remove?
   > You can select as many snapshots from the list as you want. Script will not perform the task to all selected snapshots at once but only 5 tasks at a time
     
* Is the activity tracked on vCenter?
   > Yes. You can see the snapshots and the tasks on the vCenter task tab. You can monitor the progress from there.
  
