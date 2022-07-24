$pluginRepositoryPath = "c:\l4d2-serverbuilder\repository"

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

function Start-copyPlugins {
	param (
		[Parameter(Mandatory)]
		[string[]]$selectedPlugins,
		[Parameter(Mandatory)]
		[string[]]$globalPlugins
	)

	write-host "Here are the selected" + $selectedPlugins
	write-host "Here are the available" + $globalPlugins
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
Start-copyPlugins $selectedPlugins.label $availablePlugins
