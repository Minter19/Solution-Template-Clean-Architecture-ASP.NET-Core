param (
    [string]$SolutionName = "Mprx.CleanArchitectureTemplate"
)

$root = Join-Path -Path $PSScriptRoot -ChildPath $SolutionName
$srcPath = "$root\src"
$testsPath = "$root\tests"

$folders = @(
    # _01.Core
    "$srcPath\_01.Core\_01.Entities",
    "$srcPath\_01.Core\_02.UseCases",
    "$srcPath\_01.Core\_03.Enums",
    "$srcPath\_01.Core\_04.Interfaces",
    "$srcPath\_01.Core\_05.Specifications",

    # _02.InterfaceAdapters
    "$srcPath\_02.InterfaceAdapters\_01.Controllers",
    "$srcPath\_02.InterfaceAdapters\_02.DTOs",
    "$srcPath\_02.InterfaceAdapters\_03.Mappers",
    "$srcPath\_02.InterfaceAdapters\_04.Presenters",
    "$srcPath\_02.InterfaceAdapters\_05.Services",

    # _03.Infrastructure
    "$srcPath\_03.Infrastructure\_01.FrameworksAndDrivers",
    "$srcPath\_03.Infrastructure\_02.Persistence",
    "$srcPath\_03.Infrastructure\_03.Repositories",
    "$srcPath\_03.Infrastructure\_04.Configurations",
    "$srcPath\_03.Infrastructure\_05.Client",
    
    # _04.WebAPI
    "$srcPath\_04.WebAPI",
    
    # _05.WebUI
    "$srcPath\_05.WebUI",
    
    # _06.Tests.Unit
    "$testsPath\_06.Tests.Unit\_01.Core",
    "$testsPath\_06.Tests.Unit\_02.InterfaceAdapters",

    # _07.Tests.Integration
    "$testsPath\_07.Tests.Integration\_01.Infrastructure",
    "$testsPath\_07.Tests.Integration\_02.WebAPI"
)

# Buat folder
$folders | ForEach-Object { New-Item -ItemType Directory -Path $_ -Force }

# Buat solusi
Write-Host "Creating solution $SolutionName.sln"
dotnet new sln -n $SolutionName -o $root

# Buat proyek
dotnet new classlib -n "_01.Core" -o "$srcPath\_01.Core"
dotnet new classlib -n "_02.InterfaceAdapters" -o "$srcPath\_02.InterfaceAdapters"
dotnet new classlib -n "_03.Infrastructure" -o "$srcPath\_03.Infrastructure"
dotnet new webapi -n "_04.WebAPI" -o "$srcPath\_04.WebAPI"
dotnet new mudblazor --interactivity Server --name "_05.WebUI" --output "$srcPath\_05.WebUI" --all-interactive

dotnet new xunit -n "_06.Tests.Unit" -o "$testsPath\_06.Tests.Unit"
dotnet new xunit -n "_07.Tests.Integration" -o "$testsPath\_07.Tests.Integration"

# Tambah package ke Infrastructure
dotnet add "$srcPath\_03.Infrastructure\_03.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.SqlServer
dotnet add "$srcPath\_03.Infrastructure\_03.Infrastructure.csproj" package Microsoft.EntityFrameworkCore.Design
dotnet add "$srcPath\_04.WebAPI\_04.WebAPI.csproj" package OpenTelemetry.Extensions.Hosting
dotnet add "$srcPath\_04.WebAPI\_04.WebAPI.csproj" package OpenTelemetry.Instrumentation.AspNetCore
dotnet add "$srcPath\_04.WebAPI\_04.WebAPI.csproj" package OpenTelemetry.Instrumentation.Http
dotnet add "$srcPath\_04.WebAPI\_04.WebAPI.csproj" package OpenTelemetry.Exporter.Console
dotnet add "$srcPath\_04.WebAPI\_04.WebAPI.csproj" package OpenTelemetry.Exporter.Otlp

# Tambah reference antar proyek
dotnet add "$srcPath\_02.InterfaceAdapters\_02.InterfaceAdapters.csproj" reference "$srcPath\_01.Core\_01.Core.csproj"
dotnet add "$srcPath\_03.Infrastructure\_03.Infrastructure.csproj" reference "$srcPath\_01.Core\_01.Core.csproj"
dotnet add "$srcPath\_04.WebAPI\_04.WebAPI.csproj" reference "$srcPath\_01.Core\_01.Core.csproj"
dotnet add "$srcPath\_04.WebAPI\_04.WebAPI.csproj" reference "$srcPath\_02.InterfaceAdapters\_02.InterfaceAdapters.csproj"
dotnet add "$srcPath\_04.WebAPI\_04.WebAPI.csproj" reference "$srcPath\_03.Infrastructure\_03.Infrastructure.csproj"
dotnet add "$srcPath\_05.WebUI\_05.WebUI.csproj" reference "$srcPath\_01.Core\_01.Core.csproj"

# Tambahkan proyek ke solution
Get-ChildItem -Path "$root\src" -Recurse -Filter *.csproj | ForEach-Object {
    dotnet sln "$root\$SolutionName.sln" add $_.FullName
}
Get-ChildItem -Path "$root\tests" -Recurse -Filter *.csproj | ForEach-Object {
    dotnet sln "$root\$SolutionName.sln" add $_.FullName
}

Write-Host "✅ Done creating Clean Architecture solution: $SolutionName"
