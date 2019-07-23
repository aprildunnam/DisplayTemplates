$goodFiles = Read-Host -Prompt 'Input the path of the directory you want to copy from' 
$badFiles = Read-Host -Prompt 'Input the path of the directory you want to past to' 
$fileExtensionType = Read-Host -Prompt 'Input the extension type you want to replace (make sure to include .extensionname)'
Get-ChildItem $goodFiles | ForEach-Object {
    $currentFile = $_
    $currentFileName =  $_.BaseName
    Write-Host $currentFile
    $badFileLocation = Get-ChildItem -Recurse $badFiles | Where-Object { $_.BaseName -Match "$currentFileName" -and $_.extension -eq $fileExtensionType} | Select-Object -ExpandProperty DirectoryName

    if($badFileLocation) {   # if this variable is not null, we've found original file location
        Write-Host "found file [$currentFile] in location: [$badFileLocation]. overwriting the original."
        Copy-Item -Path $goodFiles\$currentFile -Destination $badFileLocation -Force
        Write-Host "Deleting [$fileExtensionType] : [$badFileLocation][$currentFileName].jse file"
        Remove-Item -Path $badFileLocation\$currentFileName.jse -Force
    }
    else {
        Write-Warning "Could not find a [$fileExtensionType] file named [$currentFileName] in location [$badFiles]."
    }

}