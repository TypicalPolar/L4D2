$pluginRepositoryPath = "c:\l4d2-serverbuilder\repository"
$pluginFolderList = Get-ChildItem -Path $pluginRepositoryPath

$allAvailablePlugins = @{}

foreach ($pluginFolder in $pluginFolderList) {
	$builderFolderLocation = $pluginFolder.FullName + "\builderinfo.csv"
	if(Test-Path $builderFolderLocation -PathType Leaf){

		write-host "Found" $pluginFolder.Name "with build file." -ForegroundColor DarkGreen

		#Importing Plugin Build File CSV
		$pluginRawBuildData = import-csv -path $builderFolderLocation

		#Converting array into usable hashtable and adding into global plugins hashtable
		$BuildDataHashtable = @{}

		foreach ($RawBuildData in $pluginRawBuildData){

			$BuildDataHashtable.Add($RawBuildData.Key,$RawBuildData.Value)

		}

		#Adding hashtable into global plugins list
		$allAvailablePlugins.Add($BuildDataHashtable.name,$BuildDataHashtable)
		write-host "Added" $BuildDataHashtable.name "into plugin table."

	}
	else
	{

		write-host "[ERROR]" $pluginFolder.Name "is missing a build file" -ForegroundColor Red

	}
}
