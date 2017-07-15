Build Utilities for Squirrel 
============================

A package that integrates creation of [Squirrel](https://github.com/Squirrel/Squirrel.Windows) installers
into the build process of C#-Projects.
Building setup packages should work for both "classic" csprojs as well as new "SDK-based" csprojs targeting full framework.

Usage
------

*The following guide assumes you know how to package an application using Squirrel. Please refer to the [Squirrel documentation](https://github.com/Squirrel/Squirrel.Windows/blob/master/docs/getting-started/0-overview.md) for details.*

### Installing Packages
- Include package in your project-file
    ```
    Install-Package Grynwald.Utilities.Squirrel.Build
    ```
In order to create an installer, the Squirrel and Nuget executables are required. Both of them
are distributed as NuGet packages (`Squirrel.Windows` and `NuGet.CommandLine`)

- For Visual Studio 2017/MSBuild 15, including the required packages as package reference is sufficient
    ```xml
    <PackageReference Include="Squirrel.Windows" Version="1.7.7" />
    <PackageReference Include="NuGet.CommandLine" Version="4.1.0" />
    ```
- When using packages.config or project.json, you'll need to set the MSBuild variables
  `SetupSquirrelVersion` and `SetupNugetVersion` to the version of the package you're using
  so the build targets can determine the path to nuget.exe and squirrel.exe
    ```xml
    <PropertyGroup>
        <SetupSquirrelVersion>1.7.7</SetupSquirrelVersion>
        <SetupNugetVersion>4.1.0</SetupNugetVersion>
    </PropertyGroup>
    ```
*Note: The setup target is currently not tied to a specific version of NuGet and/or Squirrel, so you should be able to update these packages as you see fit*

### Configure setup
You'll need to add some settings to your csproj to successfully build a setup
- PackageVersion: The version of your application. 
- Authors: You name. This will show up as publisher in the Control Panel's installed application list
- Example
    ```xml
    <PropertyGroup>
        <PackageVersion>1.2.3</PackageVersion>
        <Authors>Author name</Authors>
    </PropertyGroup>
    ```
- See also [NuGet Package Metadata](https://github.com/Squirrel/Squirrel.Windows/blob/master/docs/using/nuget-package-metadata.md)

- Define a MSBuild target called `DetermineSetupInputFiles`. This target will be called by the `BuildSetup` target and is responsible
  for determining the files that will be part of your application package.
  Example:

    ```xml
    <Target Name="DetermineSetupInputFiles">
        <ItemGroup>
            <SetupInputFiles Include="$(OutputPath)**\*.dll" />    
            <SetupInputFiles Include="$(OutputPath)**\*.exe" />
        </ItemGroup>
    </Target>
    ```

Optionally you can specify some additional settings to customize the build process
- `SetupOutputPath`: The final output path of the installer and your application package.
  Default value: `$(OutputPath)\Setup`
- `SetupTmpPath`: The path where temporary data is stored. 
  Default value: `$(BaseIntermediateOutputPath)$(Configuration)\Setup`
- `PackageId`: The name of your application package. This is the name Squirrel will use to determine 
  the installation location. 
  Default value: `$(MSBuildProjectName)`
- `Description`: A description of your application. 
  Default Value: `$(MSBuildProjectName)`

### Build Squirrel installer
To create a installer from a project, you can call the `BuildSetup` target

    msbuild MyProject.csproj /t:BuildSetup

Alternatively, you can set the MSBuild variable `BuildSetupOnBuild` to true on either the commandline or 
in your project file. This will run the `BuildSetup` every time the project is built.
