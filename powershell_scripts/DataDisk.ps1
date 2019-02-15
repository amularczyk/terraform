Configuration DataDisk 
{
  Import-DSCResource -ModuleName xStorage

  Node 'localhost' 
  {
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
  }
}