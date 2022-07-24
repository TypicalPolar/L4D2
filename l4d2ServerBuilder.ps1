$pluginRepositoryPath = "c:\l4d2-serverbuilder\repository"
$exportPath = "c:\l4d2-serverbuilder\exports\"



function Check-PluginFolder {
	param (
		[Parameter(Mandatory)]
		[string]$RepositoryPath
	)

	# write-host "Checking for Builder Information"

	$pluginFolderList = Get-ChildItem -Path $RepositoryPath

	# $buildinfoSuccess = $null
	# $buildinfoSuccess = @{}
	#
	# foreach ($pluginFolder in $PluginFolderList) {
	# 	$builderFolderLocation = $pluginFolder.FullName + "\builderinfo.csv"
	# 	if(Test-Path $builderFolderLocation -PathType Leaf){
	# 		write-host "- Found Builder Information File in" $pluginFolder.Name -ForegroundColor DarkGreen
	# 		$buildinfoSuccess.add($pluginFolder.FullName,$builderFolderLocation)
	# 	}
	# 	else
	# 	{
	# 		write-host "- Builder Information File Missing in" $pluginFolder.Name -ForegroundColor Red
	# 	}
	# }
	#
	# return $buildinfoSuccess

	return $pluginFolderList
}

function Select-Plugins {
	param (
		[Parameter(Mandatory)]
		[string[]]$PluginList
	)

	$title = "Available L4D2 Plugins"
	$message = "Select from the following plugins to be installed."

	$menuOptions = [System.Management.Automation.Host.ChoiceDescription[]]$PluginList
	$result = $host.ui.PromptForChoice($title, $message, $menuOptions, $IgnoreChoice)
	return $menuOptions[$result]
}

function Create-OutputFolder {
	$sessionExportFolder = $exportPath + (Get-Date).toString("yyyy_MM_dd_HH_mm_ss")
	try{
		New-Item -ItemType "directory" -Path $sessionExportFolder -ea stop
	}
	catch{
		write-host "[WARN] Failed to Create Output Folder" -ForegroundColor red
	}
}

function Start-copyPlugins {
	param (
		[Parameter(Mandatory)]
		[string[]]$selectedPlugins,
		[Parameter(Mandatory)]
		[object[]]$globalPlugins,
		[Parameter(Mandatory)]
		[string]$destination
	)

	foreach ($plugin in $selectedPlugins){
		$currentPlugin = $globalPlugins | where-object -Property Name -like $plugin
		write-host "Added Plugin:" $currentPlugin.Name
		$pluginContent = $currentPlugin.FullName + "\*"
		Copy-item -Force -Recurse $pluginContent -Destination $destination
	}
}

# function Read-BuilderInformation {
# 	param (
# 		[Parameter(Mandatory)]
# 		[string[]]$requiringReading
# 	)
	# $pluginOptions = @()
	#
	# foreach ($plugin in $readPlugins) {
	# 	$pluginOption = New-Object System.Management.Automation.Host.ChoiceDescription $plugin.name, $plugin.description
	# 	New-Variable -Name "$($plugin_Option)_option" -Value $pluginOption
	# 	$selectedArray += Get-Variable -Name "$($plugin_Option)_option"
	# }
# }

$availablePlugins = Check-PluginFolder $pluginRepositoryPath

$selectedPlugins = Select-Plugins $availablePlugins

$outputfolder = Create-OutputFolder

Start-copyPlugins $selectedPlugins.label $availablePlugins $outputfolder
