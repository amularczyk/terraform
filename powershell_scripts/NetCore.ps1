Configuration NetCore 
{  
  Import-DscResource -ModuleName cChoco

  Node 'localhost' {
    cChocoInstaller installChoco
    {
      InstallDir = 'C:\choco'
    }
    cChocoPackageInstaller NetCore_sdk
    {
        Name      = 'dotnetcore-sdk'
        DependsOn = '[cChocoInstaller]installChoco'
    }
    # cChocoPackageInstaller NetCore_runtime
    # {
    #     Name      = 'dotnetcore-runtime'
    #     DependsOn = '[cChocoInstaller]installChoco'
    # }
    cChocoPackageInstaller NetCore_modules
    {
        Name      = 'dotnetcore-windowshosting'
        DependsOn = '[cChocoInstaller]installChoco'
    }
  }
}

NetCore