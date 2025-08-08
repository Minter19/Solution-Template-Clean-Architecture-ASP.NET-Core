# ✨ Clean Architecture Solution Template Maker

[![.NET](https://img.shields.io/badge/.NET-8.0-blueviolet)](https://dotnet.microsoft.com/en-us/download/dotnet/8.0)

A powerful PowerShell script to scaffold a .NET solution following the principles of **Clean Architecture**. This tool automates the creation of projects, folder structures, and dependencies, letting you focus on writing code, not on setup.

The generated solution includes projects for Core logic, Interface Adapters, Infrastructure, a Web API, and a MudBlazor Web UI, along with corresponding unit and integration test projects.

---

## 📋 Prerequisites

Before you begin, ensure your development environment has the following installed:

* **.NET 8 SDK** (or the version targeted in the script)
* **MudBlazor Project Templates**: Required for the Web UI project. Install or update them with the following command:
    ```sh
    dotnet new install MudBlazor.Templates
    ```

---

## 🚀 Getting Started

Follow these simple steps to generate your new solution.

1.  **Open PowerShell as an Administrator.**

2.  **Set the Execution Policy.** This allows the script to run in the current PowerShell session.
    ```powershell
    Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
    ```

3.  **Run the Script.**
    * To create a solution with the default name (`Mprx.CleanArchitectureTemplate`):
        ```powershell
        .\SolutionTemplateMaker.ps1
        ```
    * To use a custom name:
        ```powershell
        .\SolutionTemplateMaker.ps1 -SolutionName "YourCompany.YourAppName"
        ```

The script will create a new root folder with your solution name and generate the complete project structure inside it.

---

## 🏗️ Generated Project Structure

The script will produce the following folder and project layout:

```
YourSolutionName/
├── src/
│   ├── _01.Core/
│   ├── _02.InterfaceAdapters/
│   ├── _03.Infrastructure/
│   ├── _04.WebAPI/
│   └── _05.WebUI/
│
├── tests/
│   ├── _06.Tests.Unit/
│   └── _07.Tests.Integration/
│
└── YourSolutionName.sln
```

### 🔗 Project References

The script automatically configures the following project dependencies to maintain a clean separation of concerns:

* `InterfaceAdapters` → `Core`
* `Infrastructure` → `Core`
* `WebAPI` → `Core`, `InterfaceAdapters`, `Infrastructure`
* `WebUI` → `Core`

### 📦 Included NuGet Packages

Key packages are pre-installed to get you started:

* **Infrastructure:**
    * `Microsoft.EntityFrameworkCore.SqlServer`
    * `Microsoft.EntityFrameworkCore.Design`
* **WebAPI:**
    * `OpenTelemetry.Extensions.Hosting`
    * `OpenTelemetry.Instrumentation.AspNetCore`
    * `OpenTelemetry.Instrumentation.Http`
    * `OpenTelemetry.Exporter.Console`
    * `OpenTelemetry.Exporter.Otlp`
