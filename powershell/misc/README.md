
# Type model generation

Type information about .NET and PowerShell SDK methods are obtained by generating data extension files that populate the `typeModel` extensible predicate.

The type models are located here: https://github.com/microsoft/codeql/blob/main/powershell/ql/lib/semmle/code/powershell/frameworks/

## dotnet/dotnet-api-docs and MicrosoftDocs/powershell-docs-sdk-dotnet

Follow the steps below in order to generate new type models:
1. Join the `MicrosoftDocs` organisation to ensure that you can access https://github.com/MicrosoftDocs/powershell-docs-sdk-dotnet/tree/main/dotnet/xml (if you haven't already).
2.
Run the following commands

    ```
    # Clone dotnet/dotnet-api-docs
    git clone https://github.com/dotnet/dotnet-api-docs --depth 1
    # Clone MicrosoftDocs/powershell-docs-sdk-dotnet
    git clone git@github.com:MicrosoftDocs/powershell-docs-sdk-dotnet.git --depth 1
    # Generate data extensions
    python3 misc/typemodelgen.py dotnet-api-docs/xml/ powershell-docs-sdk-dotnet/dotnet/xml
    ```
This will generate 600+ folders that need to be copied into https://github.com/microsoft/codeql/blob/main/powershell/ql/lib/semmle/code/powershell/frameworks/.

## dotnet/SqlClient

The type models for this is generated via a CodeQL query. Following these steps to generate these type models

1. Download a C# DB for `dotnet/SqlClient` (for instance using VSCode's `CodeQL: Download Database from GitHub`)
2. Run the following command (note: your current working directory is assumed to be CodeQL):
```
python .\powershell\misc\typemodelgenFromDB.py . powershell/ql/lib/semmle/code/powershell/frameworks/generated/dotnet.sqlclient.typemodel.yml path/to/the/db/you/downloaded/above
```
This will generate the file `dotnet.sqlclient.typemodel.yml` inside the right folder.