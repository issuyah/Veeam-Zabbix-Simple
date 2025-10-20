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

# Prepare data for Zabbix Discovery
$discoveryData = @()
foreach ($job in $backupJobs) {
    # Clean Zabbix Job Name
    $cleanJobName = $job.Name -replace '[^a-zA-Z0-9_]', ''
    $discoveryData += @{"{#NOM}"=$cleanJobName}
}
#Convert data into Json and replace " with ?
$discoveryJson = $discoveryData | ConvertTo-Json -Compress
$finaljson = $discoveryJson | ForEach-Object {$_ -replace '\"', '?'}
#Send data to Zabbix server
& $zabbixSenderPath -z $zabbixServer -s $zabbixHost -k job.json -o $finaljson

# Prepare job results for Zabbix
foreach ($job in $backupJobs.where{$_.info.IsScheduleEnabled -eq 'True'}) {
    # Clean Zabbix Job Name
    $cleanJobName = $job.Name -replace '[^a-zA-Z0-9_]', ''
    $key = "job[" + $cleanJobName + "]"
    $lastSession = $job.FindLastSession()
    $lastResult = $lastSession.Result

    # #Send data to Zabbix server
    & $zabbixSenderPath -z $zabbixServer -s $zabbixHost -k $key -o $lastResult
}


foreach ($job in $backupJobs.where{$_.info.IsScheduleEnabled -ne 'True'}) {
# Clean Zabbix Job Name
    $cleanJobName = $job.Name -replace '[^a-zA-Z0-9_]', ''
    $key = "job[" + $cleanJobName + "]"

    #Send data to Zabbix server
    & $zabbixSenderPath -z $zabbixServer -s $zabbixHost -k $key -o "Disabled"
}

# Prepare job last run delay for Zabbix
$date = Get-Date
foreach ($job in $backupJobs.where{$_.info.IsScheduleEnabled -eq 'True'}) {
    # Clean Zabbix Job Name
    $cleanJobName = $job.Name -replace '[^a-zA-Z0-9_]', ''
    $key = "jobLR[" + $cleanJobName + "]"
    $lastSession = $job.FindLastSession()
    $lastRun = $lastSession.EndTime
    $result = [int]($date-$lastRun).TotalSeconds

    # #Send data to Zabbix server
    & $zabbixSenderPath -z $zabbixServer -s $zabbixHost -k $key -o $result
}


# Disconnect from zabbix host
Disconnect-VBRServer