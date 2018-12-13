$storageAccount = "storage-account-name" 
$accesskey = "storage-key-name"

function UploadToQueue($QueueMessage,$QueueName){
    $method = "POST"
    $contenttype = "application/x-www-form-urlencoded"
    $version = "2017-04-17"
    $resource = "$QueueName/messages"
    $queue_url = "https://$storageAccount.queue.core.windows.net/$resource"
    $GMTTime = (Get-Date).ToUniversalTime().toString('R')
    $canonheaders = "x-ms-date:$GMTTime`nx-ms-version:$version`n"


    #string to sign is used to generate the hash
    $stringToSign = "$method`n`n$contenttype`n`n$canonheaders/$storageAccount/$resource"
    $hmacsha = New-Object System.Security.Cryptography.HMACSHA256

    #fetching the key
    $hmacsha.key = [Convert]::FromBase64String($accesskey)

    #Computation of the hash
    $signature = $hmacsha.ComputeHash([Text.Encoding]::UTF8.GetBytes($stringToSign))
    $signature = [Convert]::ToBase64String($signature)
    $headers = @{
        'x-ms-date' = $GMTTime
        Authorization = "SharedKeyLite " + $storageAccount + ":" + $signature
        "x-ms-version" = $version
        Accept = "text/xml"
    }
    
    $QueueMessage = [Text.Encoding]::UTF8.GetBytes($QueueMessage)

    #Message in base 64 sting
    $QueueMessage =[Convert]::ToBase64String($QueueMessage)
    $body = "<QueueMessage><MessageText>$QueueMessage</MessageText></QueueMessage>"
    $item = Invoke-RestMethod -Method $method -Uri $queue_url -Headers $headers -Body $body -ContentType $contenttype
}

UploadToQueue -QueueMessage <<message> -QueueName  <<queue name>> 

