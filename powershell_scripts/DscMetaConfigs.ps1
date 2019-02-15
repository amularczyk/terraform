# The DSC configuration that will generate metaconfigurations
[DscLocalConfigurationManager()]
Configuration DscMetaConfigs
{
	param
	(
		[Parameter(Mandatory=$True)]
		[String]$RegistrationUrl,
		[Parameter(Mandatory=$True)]
		[String]$RegistrationKey,
		[Parameter(Mandatory=$True)]
		[String[]]$ComputerName,
		[Int]$RefreshFrequencyMins = 30,
		[Int]$ConfigurationModeFrequencyMins = 15,
		[String]$ConfigurationMode = 'ApplyAndMonitor',
		[String]$NodeConfigurationName,
		[Boolean]$RebootNodeIfNeeded = $False,
		[String]$ActionAfterReboot = 'ContinueConfiguration',
		[Boolean]$AllowModuleOverwrite = $False,
		[Boolean]$ReportOnly
	)

	if(!$NodeConfigurationName -or $NodeConfigurationName -eq '')
	{
		$ConfigurationNames = $null
	}
	else
	{
		$ConfigurationNames = @($NodeConfigurationName)
	}

	if($ReportOnly)
	{
		$RefreshMode = 'PUSH'
	}
	else
	{
		$RefreshMode = 'PULL'
	}

	Node $ComputerName
	{
		Settings
		{
			RefreshFrequencyMins           = $RefreshFrequencyMins
			RefreshMode                    = $RefreshMode
			ConfigurationMode              = $ConfigurationMode
			AllowModuleOverwrite           = $AllowModuleOverwrite
			RebootNodeIfNeeded             = $RebootNodeIfNeeded
			ActionAfterReboot              = $ActionAfterReboot
			ConfigurationModeFrequencyMins = $ConfigurationModeFrequencyMins
		}

		if(!$ReportOnly)
		{
			ConfigurationRepositoryWeb AzureAutomationStateConfiguration
			{
				ServerUrl          = $RegistrationUrl
				RegistrationKey    = $RegistrationKey
				ConfigurationNames = $ConfigurationNames
			}

			ResourceRepositoryWeb AzureAutomationStateConfiguration
			{
				ServerUrl       = $RegistrationUrl
				RegistrationKey = $RegistrationKey
			}
		}

		ReportServerWeb AzureAutomationStateConfiguration
		{
			ServerUrl       = $RegistrationUrl
			RegistrationKey = $RegistrationKey
		}
	}
}

# Create the metaconfigurations
# NOTE: DSC Node Configuration names are case sensitive in the portal.
# TODO: edit the below as needed for your use case
$Params = @{
	RegistrationUrl = 'https://we-agentservice-prod-1.azure-automation.net/accounts/b675921d-17d0-4d0d-94b7-89dbb588c77a';
	RegistrationKey = '9zPvy1aia8a24z02YuSXa8jFYorkNIqZzpeBL69jqbgFlzfU4TfRiNnMSd2C0RzdibQtKCY5/8DXZ9SyC45iOA==';
	ComputerName = @('terraform');
	NodeConfigurationName = 'InstallIIS.localhost';
	RefreshFrequencyMins = 30;
	ConfigurationModeFrequencyMins = 15;
	RebootNodeIfNeeded = $False;
	AllowModuleOverwrite = $False;
	ConfigurationMode = 'ApplyAndMonitor';
	ActionAfterReboot = 'ContinueConfiguration';
	ReportOnly = $False;  # Set to $True to have machines only report to AA DSC but not pull from it
}

# Use PowerShell splatting to pass parameters to the DSC configuration being invoked
# For more info about splatting, run: Get-Help -Name about_Splatting
DscMetaConfigs @Params