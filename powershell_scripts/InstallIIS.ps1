Configuration InstallIIS 
{
  Import-DscResource -ModuleName PsDesiredStateConfiguration

  Node 'localhost' 
  {
    WindowsFeature InstallWebServer 
    { 
      Ensure = "Present"
      Name = "Web-Server" 
    }
  }
}

InstallIIS