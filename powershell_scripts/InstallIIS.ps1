Configuration InstallIIS {
  # Import the module that contains the resources we're using.
  Import-DscResource -ModuleName PsDesiredStateConfiguration

  # The Node statement specifies which targets this configuration will be applied to.
  Node 'localhost' {

    # Install IIS
    WindowsFeature InstallWebServer { 
      Ensure = "Present"
      Name = "Web-Server" 
    }
  }
}

InstallIIS