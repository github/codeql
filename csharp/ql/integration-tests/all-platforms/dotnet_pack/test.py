import os
import dotnet

@dotnet.xdist_group_if_macos
def test(codeql, csharp):
    codeql.database.create(command="dotnet pack -o nugetpackage")
    assert os.path.isfile(
        "nugetpackage/dotnet_pack.1.0.0.nupkg"
    ), "The NuGet package was not created."
