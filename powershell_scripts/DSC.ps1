Configuration DSC 
{  
  Import-DSCResource -ModuleName xStorage
  Import-DscResource -ModuleName PsDesiredStateConfiguration
  # Import-DscResource -ModuleName cChoco

  Node 'localhost' 
  {
    #Data dics
    xWaitforDisk Disk2 
    {
      DiskId = 2
      RetryIntervalSec = 60
      RetryCount = 10
    }
    xDisk FVolume 
    {
      DiskId = 2
      DriveLetter = 'F'
      FSLabel = 'Data'
    }
    
    #IIS
    WindowsFeature InstallWebServer 
    { 
      Ensure = "Present"
      Name = "Web-Server" 
    }

    #Choco + .NET Core
    cChocoInstaller installChoco
    {
      InstallDir = 'C:\choco'
    }
    cChocoPackageInstaller NetCore_sdk
    {
        Name      = 'dotnetcore-sdk'
        DependsOn = '[cChocoInstaller]installChoco'
    }
    cChocoPackageInstaller NetCore_modules
    {
        Name      = 'dotnetcore-windowshosting'
        DependsOn = '[cChocoInstaller]installChoco'
    }
  }
}

DSC