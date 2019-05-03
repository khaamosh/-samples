#Assemblies that are to be reflected for this script to work.

[System.Reflection.Assembly]::LoadWithPartialName("System")
[System.Reflection.Assembly]::LoadWithPartialName("System.Configuration")
[System.Reflection.Assembly]::LoadFrom("<The path of the StackExchange.Redis dll module>")



#Values of the Redis Cache Connection-String
$Keys = "The connection string for Azure Redis"

#The log file which needs to be configured for the operations that are written

# These are the modes for the log file
$fileMode = [System.IO.FileMode]::Open
$fileAccess = [System.IO.FileAccess]::ReadWrite
$fileShare = [System.IO.FileShare]::None

#The stream that needs to be opened and provide the address of the log file 
#Make sure that the log file is already created in the Azure Desktop.

$fileStream = New-Object -TypeName System.IO.FileStream "<address-of-the-log-file>", $fileMode, $fileAccess, $fileShare

#Reader for the connection logs which is refenced in the parameter.
$reader = New-Object -TypeName System.IO.StreamWriter -ArgumentList $fileStream


#Creating Azure Redis Cache Connection

$lazyconnection = [StackExchange.Redis.ConnectionMultiplexer]::Connect($Keys,$reader)

#Executing the commands in Azure Redis

# 1. Get the Azure Redis Database
$database = $lazyconnection.GetDatabase()

#Write in the command that needs to be executed in Redis Cache
$cmd = "FLUSHDB"

Write-Host "\nExecuting the flush command on Redis"
$test = $database.Execute($cmd.ToString())

Write-Host "\nThe response from redis is  :: $test"

#Closing the log file so that it can be used again.
$fileStream.Close()



    





