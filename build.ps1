$buildDirectory = Join-Path $PSScriptRoot "build"
$srcDirectory = Join-Path $PSScriptRoot "src"
$nugetPath = Join-Path $buildDirectory "nuget.exe"

if((Test-Path $buildDirectory) -eq $false)
{
    New-Item -ItemType Directory $buildDirectory > $null
}

if((Test-Path $nugetPath) -eq $false)
{
    Invoke-WebRequest "https://dist.nuget.org/win-x86-commandline/latest/nuget.exe" -OutFile $nugetPath
}

$nuspecFiles = Get-ChildItem -Path $srcDirectory -Filter "*.nuspec"

foreach($spec in $nuspecFiles)
{   
    $expr =  "$($nugetPath) pack `"$($spec.FullName)`" -OutputDirectory `"$($buildDirectory)`" -BasePath `"$($srcDirectory)`""
    Invoke-Expression $expr
}
