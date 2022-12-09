$pluginRepositoryPath = "c:\l4d2-serverbuilder\repository"
$exportPath = "c:\l4d2-serverbuilder\exports\"



function Read-PluginFolder {
	param (
		[Parameter(Mandatory)]
		[string]$RepositoryPath
	)

	# write-host "Checking for Builder Information"

	if (!(Test-Path -Path $RepositoryPath)){
		write-host "[ERROR] Repository folder is missing!" -ForegroundColor red
	}

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

	# Menu for selecting plugins. Options are populated from the Read-PluginFolder function.
	$title = "Available L4D2 Plugins"
	$message = "Select from the following plugins to be installed."

	$menuOptions = [System.Management.Automation.Host.ChoiceDescription[]]$PluginList
	$result = $host.ui.PromptForChoice($title, $message, $menuOptions, $IgnoreChoice)
	return $menuOptions[$result]
}

function New-OutputFolder {
	$sessionExportFolder = $exportPath + (Get-Date).toString("yyyy_MM_dd_HH_mm_ss")
	try{
		New-Item -ItemType "directory" -Path $sessionExportFolder -ea stop
	}
	catch{
		write-host "[ERROR] Failed to Create Output Folder" -ForegroundColor red
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

		#Filtering global plugins with selected plugins
		$currentPlugin = $globalPlugins | where-object -Property Name -like $plugin
		write-host "Adding Plugin:" $currentPlugin.Name
		$pluginContent = $currentPlugin.FullName + "\*"

		try{
			Copy-item -Force -Recurse $pluginContent -Destination $destination -ea stop
		}
		catch{
			write-host "[ERROR] Adding" $currentPlugin.Name "failed!" -ForegroundColor red
		}

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

$availablePlugins = Read-PluginFolder $pluginRepositoryPath

$selectedPlugins = Select-Plugins $availablePlugins

$outputfolder = New-OutputFolder

Start-copyPlugins $selectedPlugins.label $availablePlugins $outputfolder
