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
		[Parameter(Mandatory=$True)]
		[String]$NodeConfigurationName,
		[Int]$RefreshFrequencyMins = 30,
		[Int]$ConfigurationModeFrequencyMins = 15,
		[String]$ConfigurationMode = 'ApplyAndMonitor',
		[Boolean]$RebootNodeIfNeeded = $False,
		[String]$ActionAfterReboot = 'ContinueConfiguration',
		[Boolean]$AllowModuleOverwrite = $False,
		[Boolean]$ReportOnly = $False
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

DscMetaConfigs