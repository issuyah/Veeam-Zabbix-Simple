# Variables
$zabbixServer = "Server IP or FQDN"
$zabbixHost = "Host name in Zabbix"
$zabbixSenderPath = "C:\zabbix_agent2\bin\zabbix_sender.exe"

# Veeam module Import
Import-Module Veeam.Backup.PowerShell

# Connection to Veeam Server
Connect-VBRServer -Server "localhost"

# Get Veeam Jobs into a variable
$backupJobs = Get-VBRJob
$tapeJobs = Get-VBRTapeJob # Added to include Tape Jobs
$allJobs = $backupJobs + $tapeJobs # Combined Backup and Tape Jobs

# Prepare data for Zabbix Discovery
$discoveryData = @()
foreach ($job in $allJobs) {
    # Clean Zabbix Job Name
    $cleanJobName = $job.Name -replace '[^a-zA-Z0-9_]', ''
    $discoveryData += @{"{#NOM}"=$cleanJobName}
}
# Convert data into Json and replace " with ?
$discoveryJson = $discoveryData | ConvertTo-Json -Compress
$finaljson = $discoveryJson | ForEach-Object {$_ -replace '\"', '?'}
# Send data to Zabbix server
& $zabbixSenderPath -z $zabbixServer -s $zabbixHost -k job.json -o $finaljson

# Prepare job results for Zabbix
foreach ($job in $allJobs.where{$_.info.IsScheduleEnabled -eq 'True'}) {
    # Clean Zabbix Job Name
    $cleanJobName = $job.Name -replace '[^a-zA-Z0-9_]', ''
    $jobName = "job[" + $cleanJobName + "]"
    
    # Get job result for Backup Jobs or status for Tape Jobs
    if ($job.PSObject.TypeNames -contains "Veeam.Backup.Core.CJobTape") {
        $jobStatus = "Enabled" # Tape Jobs don't have "last result"
        & $zabbixSenderPath -z $zabbixServer -s $zabbixHost -k $jobName -o $jobStatus
    } else {
        $lastResult = $job.GetLastResult()
        # Send data to Zabbix server
        & $zabbixSenderPath -z $zabbixServer -s $zabbixHost -k $jobName -o $lastResult
    }
    echo $jobName
}

foreach ($job in $allJobs.where{$_.info.IsScheduleEnabled -ne 'True'}) {
    # Clean Zabbix Job Name
    $cleanJobName = $job.Name -replace '[^a-zA-Z0-9_]', ''
    $jobName = "job[" + $cleanJobName + "]"

    # Send status as "Disabled" for all types of jobs
    & $zabbixSenderPath -z $zabbixServer -s $zabbixHost -k $jobName -o "Disabled"
    echo $jobName
}

# Disconnect from Veeam Server
Disconnect-VBRServer
