Configuration DataDisk
{
    Import-DSCResource -ModuleName xStorage 

    Node localhost
    {
        xWaitforDisk Disk2
        {
            DiskNumber = 2
            RetryIntervalSec = 60
            Count = 60
        }
        xDisk FVolume
        {
            DiskNumber = 2
            DriveLetter = 'F'
            FSLabel = 'Data'
        }
    }
}