Param([String]$version)

$buildDirectory = Join-Path $PSScriptRoot "build"
$srcDirectory = Join-Path $PSScriptRoot "src"
$nugetPath = Join-Path $buildDirectory "nuget.exe"

if([String]::IsNullOrWhiteSpace($version))
{
    $version = $env:APPVEYOR_BUILD_VERSION
}
if([String]::IsNullOrWhiteSpace($version))
{
    $version = "1.0.0"
}


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
    $expr =  "$($nugetPath) pack `"$($spec.FullName)`" -OutputDirectory `"$($buildDirectory)`" -BasePath `"$($srcDirectory)`" -Version $($version)"
    Invoke-Expression $expr
}
