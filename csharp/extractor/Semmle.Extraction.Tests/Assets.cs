using Xunit;
using System.Linq;
using Semmle.Extraction.CSharp.DependencyFetching;

namespace Semmle.Extraction.Tests
{
    public class AssetsTests
    {
        private static string FixExpectedPathOnWindows(string path) => path.Replace('\\', '/');

        [Fact]
        public void TestAssets1()
        {
            // Setup
            var assets = new Assets(new LoggerStub());
            var json = assetsJson1;

            // Execute
            var success = assets.TryParse(json, "");

            // Verify
            Assert.True(success);
            Assert.Equal(6, assets.Dependencies.Paths.Count);
            Assert.Equal(5, assets.Dependencies.Packages.Count);

            var normalizedPaths = assets.Dependencies.Paths.Select(FixExpectedPathOnWindows);
            // Used references
            Assert.Contains("castle.core/4.4.1/lib/netstandard1.5/Castle.Core.dll", normalizedPaths);
            Assert.Contains("castle.core/4.4.1/lib/netstandard1.5/Castle.Core2.dll", normalizedPaths);
            Assert.Contains("json.net/1.0.33/lib/netstandard2.0/Json.Net.dll", normalizedPaths);
            Assert.Contains("microsoft.aspnetcore.cryptography.internal/6.0.8/lib/net6.0/Microsoft.AspNetCore.Cryptography.Internal.dll", normalizedPaths);
            // Used packages
            Assert.Contains("castle.core", assets.Dependencies.Packages);
            Assert.Contains("json.net", assets.Dependencies.Packages);
            Assert.Contains("microsoft.aspnetcore.cryptography.internal", assets.Dependencies.Packages);
            // Used frameworks
            Assert.Contains("microsoft.netcore.app.ref", assets.Dependencies.Packages);
            Assert.Contains("microsoft.aspnetcore.app.ref", assets.Dependencies.Packages);
        }

        [Fact]
        public void TestAssetsFailure()
        {
            // Setup
            var assets = new Assets(new LoggerStub());
            var json = "garbage data";

            // Execute
            var success = assets.TryParse(json, "");

            // Verify
            Assert.False(success);
            Assert.Empty(assets.Dependencies.Paths);
        }

        [Fact]
        public void TestAssetsNet70()
        {
            // Setup
            var assets = new Assets(new LoggerStub());
            var json = assetsNet70;

            // Execute
            var success = assets.TryParse(json, "");

            // Verify
            Assert.True(success);
            Assert.Equal(4, assets.Dependencies.Paths.Count);
            Assert.Equal(4, assets.Dependencies.Packages.Count);


            var normalizedPaths = assets.Dependencies.Paths.Select(FixExpectedPathOnWindows);
            // Used paths
            Assert.Contains("microsoft.netcore.app.ref", normalizedPaths);
            Assert.Contains("microsoft.aspnetcore.app.ref", normalizedPaths);
            Assert.Contains("newtonsoft.json/12.0.1/lib/netstandard2.0/Newtonsoft.Json.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json.bson/1.0.2/lib/netstandard2.0/Newtonsoft.Json.Bson.dll", normalizedPaths);
            // Used packages
            Assert.Contains("microsoft.netcore.app.ref", assets.Dependencies.Packages);
            Assert.Contains("microsoft.aspnetcore.app.ref", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json.bson", assets.Dependencies.Packages);

        }

        [Fact]
        public void TestAssetsNet48()
        {
            // Setup
            var assets = new Assets(new LoggerStub());
            var json = assetsNet48;

            // Execute
            var success = assets.TryParse(json, "");

            // Verify
            Assert.True(success);
            Assert.Equal(3, assets.Dependencies.Paths.Count);
            Assert.Equal(3, assets.Dependencies.Packages.Count);

            var normalizedPaths = assets.Dependencies.Paths.Select(FixExpectedPathOnWindows);
            // Used references
            Assert.Contains("microsoft.netframework.referenceassemblies.net48/1.0.2", normalizedPaths);
            Assert.Contains("newtonsoft.json/12.0.1/lib/net45/Newtonsoft.Json.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json.bson/1.0.2/lib/net45/Newtonsoft.Json.Bson.dll", normalizedPaths);
            // Used packages
            Assert.Contains("microsoft.netframework.referenceassemblies.net48", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json.bson", assets.Dependencies.Packages);
        }

        [Fact]
        public void TestAssetsNetstandard21()
        {
            // Setup
            var assets = new Assets(new LoggerStub());
            var json = assetsNetstandard21;

            // Execute
            var success = assets.TryParse(json, "");

            // Verify
            Assert.True(success);
            Assert.Equal(3, assets.Dependencies.Paths.Count);
            Assert.Equal(3, assets.Dependencies.Packages.Count);

            var normalizedPaths = assets.Dependencies.Paths.Select(FixExpectedPathOnWindows);

            // Used references
            Assert.Contains("netstandard.library.ref", normalizedPaths);
            Assert.Contains("newtonsoft.json/12.0.1/lib/netstandard2.0/Newtonsoft.Json.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json.bson/1.0.2/lib/netstandard2.0/Newtonsoft.Json.Bson.dll", normalizedPaths);
            // Used packages
            Assert.Contains("netstandard.library.ref", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json.bson", assets.Dependencies.Packages);
        }

        [Fact]
        public void TestAssetsNetStandard16()
        {
            // Setup
            var assets = new Assets(new LoggerStub());
            var json = assetsNetstandard16;

            // Execute
            var success = assets.TryParse(json, "");

            // Verify
            Assert.True(success);
            Assert.Equal(5, assets.Dependencies.Paths.Count);
            Assert.Equal(5, assets.Dependencies.Packages.Count);

            var normalizedPaths = assets.Dependencies.Paths.Select(FixExpectedPathOnWindows);

            // Used references
            Assert.Contains("netstandard.library/1.6.1", normalizedPaths);
            Assert.Contains("microsoft.csharp/4.3.0/ref/netstandard1.0/Microsoft.CSharp.dll", normalizedPaths);
            Assert.Contains("microsoft.win32.primitives/4.3.0/ref/netstandard1.3/Microsoft.Win32.Primitives.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json/12.0.1/lib/netstandard1.3/Newtonsoft.Json.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json.bson/1.0.2/lib/netstandard1.3/Newtonsoft.Json.Bson.dll", normalizedPaths);
            // Used packages
            Assert.Contains("netstandard.library", assets.Dependencies.Packages);
            Assert.Contains("microsoft.csharp", assets.Dependencies.Packages);
            Assert.Contains("microsoft.win32.primitives", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json.bson", assets.Dependencies.Packages);
        }

        [Fact]
        public void TestAssetsNetcoreapp20()
        {
            // Setup
            var assets = new Assets(new LoggerStub());
            var json = assetsNetcoreapp20;

            // Execute
            var success = assets.TryParse(json, "");

            // Verify
            Assert.True(success);
            Assert.Equal(144, assets.Dependencies.Paths.Count);
            Assert.Equal(3, assets.Dependencies.Packages.Count);

            var normalizedPaths = assets.Dependencies.Paths.Select(FixExpectedPathOnWindows);

            // Used references (only some of them)
            Assert.Contains("microsoft.netcore.app/2.0.0/ref/netcoreapp2.0/Microsoft.CSharp.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json/12.0.1/lib/netstandard2.0/Newtonsoft.Json.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json.bson/1.0.2/lib/netstandard2.0/Newtonsoft.Json.Bson.dll", normalizedPaths);
            // Used packages
            Assert.Contains("microsoft.netcore.app", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json.bson", assets.Dependencies.Packages);
        }

        [Fact]
        public void TestAssetsNetcoreapp31()
        {
            // Setup
            var assets = new Assets(new LoggerStub());
            var json = assetsNetcoreapp31;

            // Execute
            var success = assets.TryParse(json, "");

            // Verify
            Assert.True(success);

            var normalizedPaths = assets.Dependencies.Paths.Select(FixExpectedPathOnWindows);

            // Used paths
            Assert.Contains("microsoft.netcore.app.ref", normalizedPaths);
            Assert.Contains("microsoft.aspnetcore.app.ref", normalizedPaths);
            Assert.Contains("newtonsoft.json/12.0.1/lib/netstandard2.0/Newtonsoft.Json.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json.bson/1.0.2/lib/netstandard2.0/Newtonsoft.Json.Bson.dll", normalizedPaths);
            // Used packages
            Assert.Contains("microsoft.netcore.app.ref", assets.Dependencies.Packages);
            Assert.Contains("microsoft.aspnetcore.app.ref", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json", assets.Dependencies.Packages);
            Assert.Contains("newtonsoft.json.bson", assets.Dependencies.Packages);
        }

        /// <summary>
        /// This is manually created JSON string with the same structure as the assets file.
        /// </summary>
        private readonly string assetsJson1 = """
{
    "version": 3,
    "targets": {
        "net7.0": {
            "Castle.Core/4.4.1": {
                "type": "package",
                "dependencies": {
                    "NETStandard.Library": "1.6.1",
                    "System.Collections.Specialized": "4.3.0",
                },
                "compile": {
                    "lib/netstandard1.5/Castle.Core.dll": {
                        "related": ".xml"
                    },
                    "lib/netstandard1.5/Castle.Core2.dll": {
                        "related": ".xml"
                    }
                },
                "runtime": {
                    "lib/netstandard1.5/Castle.Core.dll": {
                        "related": ".xml"
                    }
                }
            },
            "Json.Net/1.0.33": {
                "type": "package",
                "compile": {
                     "lib/netstandard2.0/Json.Net.dll": {}
                },
                "runtime": {
                    "lib/netstandard2.0/Json.Net.dll": {}
                }
            },
            "MessagePackAnalyzer/2.1.152": {
                "type": "package"
            },
            "Microsoft.AspNetCore.Cryptography.Internal/6.0.8": {
                "type": "package",
                "compile": {
                    "lib/net6.0/Microsoft.AspNetCore.Cryptography.Internal.dll": {
                        "related": ".xml"
                    }
                },
                "runtime": {
                    "lib/net6.0/Microsoft.AspNetCore.Cryptography.Internal.dll": {
                        "related": ".xml"
                    }
                }
            },
            "Humanizer.Core/2.8.26": {
                "type": "package",
                "compile": {
                    "lib/netstandard2.0/_._": {
                        "related": ".xml"
                    }
                },
                "runtime": {
                    "lib/netstandard2.0/Humanizer.dll": {
                        "related": ".xml"
                    }
                }
            },
            "Nop.Core/4.5.0": {
                "type": "project",
                "compile": {
                    "bin/placeholder/Nop.Core.dll": {}
                },
                "runtime": {
                    "bin/placeholder/Nop.Core.dll": {}
                }
            },
        }
    },
    "project": {
        "version": "1.0.0",
        "frameworks": {
            "net7.0": {
                "targetAlias": "net7.0",
                "downloadDependencies": [
                    {
                        "name": "Microsoft.AspNetCore.App.Ref",
                        "version": "[7.0.2, 7.0.2]"
                    },
                    {
                        "name": "Microsoft.NETCore.App.Ref",
                        "version": "[7.0.2, 7.0.2]"
                    }
                ],
                "frameworkReferences": {
                    "Microsoft.AspNetCore.App": {
                        "privateAssets": "none"
                    },
                    "Microsoft.NETCore.App": {
                        "privateAssets": "all"
                    }
                }
            }
        }
    }
}
""";

        /// <summary>
        /// This is part of the content of the assets file that dotnet generates based on the
        /// following project file content.
        ///
        /// <Project Sdk="Microsoft.NET.Sdk.Web">
        ///   <PropertyGroup>
        ///     <TargetFramework>net70</TargetFramework>
        ///     <Nullable>enable</Nullable>
        ///     <ImplicitUsings>enable</ImplicitUsings>
        ///   </PropertyGroup>
        ///   <ItemGroup>
        ///     <PackageReference Include="Newtonsoft.Json.Bson" Version="1.0.2" />
        ///   </ItemGroup>
        /// </Project>
        /// </summary>
        private readonly string assetsNet70 = """
{
  "version": 3,
  "targets": {
    "net7.0": {
      "Newtonsoft.Json/12.0.1": {
        "type": "package",
        "compile": {
          "lib/netstandard2.0/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard2.0/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        }
      },
      "Newtonsoft.Json.Bson/1.0.2": {
        "type": "package",
        "dependencies": {
          "Newtonsoft.Json": "12.0.1"
        },
        "compile": {
          "lib/netstandard2.0/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard2.0/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        }
      }
    }
  },
  "project": {
    "version": "1.0.0",
    "restore": {
      "projectUniqueName": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "projectName": "csharpwebapp",
      "projectPath": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "packagesPath": "/Users/michaelnebel/Work/playground/csharpwebapp/packages",
      "outputPath": "/Users/michaelnebel/Work/playground/csharpwebapp/obj/",
      "projectStyle": "PackageReference",
      "configFilePaths": [
        "/Users/michaelnebel/.nuget/NuGet/NuGet.Config"
      ],
      "originalTargetFrameworks": [
        "net70"
      ],
      "sources": {
        "https://api.nuget.org/v3/index.json": {}
      },
      "frameworks": {
        "net7.0": {
          "targetAlias": "net70",
          "projectReferences": {}
        }
      },
      "warningProperties": {
        "warnAsError": [
          "NU1605"
        ]
      }
    },
    "frameworks": {
      "net7.0": {
        "targetAlias": "net70",
        "dependencies": {
          "Newtonsoft.Json.Bson": {
            "target": "Package",
            "version": "[1.0.2, )"
          }
        },
        "imports": [
          "net461",
          "net462",
          "net47",
          "net471",
          "net472",
          "net48",
          "net481"
        ],
        "assetTargetFallback": true,
        "warn": true,
        "downloadDependencies": [
          {
            "name": "Microsoft.AspNetCore.App.Ref",
            "version": "[7.0.2, 7.0.2]"
          },
          {
            "name": "Microsoft.NETCore.App.Host.osx-x64",
            "version": "[7.0.2, 7.0.2]"
          },
          {
            "name": "Microsoft.NETCore.App.Ref",
            "version": "[7.0.2, 7.0.2]"
          }
        ],
        "frameworkReferences": {
          "Microsoft.AspNetCore.App": {
            "privateAssets": "none"
          },
          "Microsoft.NETCore.App": {
            "privateAssets": "all"
          }
        },
        "runtimeIdentifierGraphPath": "/Users/michaelnebel/.dotnet/sdk/7.0.102/RuntimeIdentifierGraph.json"
      }
    }
  }
}
""";

        /// <summary>
        /// This is part of the content of the assets file that dotnet generates based on the
        /// following project file content.
        ///
        /// <Project Sdk="Microsoft.NET.Sdk.Web">
        ///   <PropertyGroup>
        ///     <TargetFramework>net4.8</TargetFramework>
        ///     <Nullable>enable</Nullable>
        ///     <ImplicitUsings>enable</ImplicitUsings>
        ///   </PropertyGroup>
        ///   <ItemGroup>
        ///     <PackageReference Include="Newtonsoft.Json.Bson" Version="1.0.2" />
        ///   </ItemGroup>
        /// </Project>
        /// </summary>
        private readonly string assetsNet48 = """
{
  "version": 3,
  "targets": {
    ".NETFramework,Version=v4.8": {
      "Microsoft.NETFramework.ReferenceAssemblies/1.0.2": {
        "type": "package",
        "dependencies": {
          "Microsoft.NETFramework.ReferenceAssemblies.net48": "1.0.2"
        }
      },
      "Microsoft.NETFramework.ReferenceAssemblies.net48/1.0.2": {
        "type": "package",
        "build": {
          "build/Microsoft.NETFramework.ReferenceAssemblies.net48.targets": {}
        }
      },
      "Newtonsoft.Json/12.0.1": {
        "type": "package",
        "compile": {
          "lib/net45/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/net45/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        }
      },
      "Newtonsoft.Json.Bson/1.0.2": {
        "type": "package",
        "dependencies": {
          "Newtonsoft.Json": "12.0.1"
        },
        "compile": {
          "lib/net45/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/net45/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        }
      }
    }
  },
  "projectFileDependencyGroups": {
    ".NETFramework,Version=v4.8": [
      "Microsoft.NETFramework.ReferenceAssemblies >= 1.0.2",
      "Newtonsoft.Json.Bson >= 1.0.2"
    ]
  },
  "packageFolders": {
    "/Users/michaelnebel/Work/playground/csharpwebapp/packages": {}
  },
  "project": {
    "version": "1.0.0",
    "restore": {
      "projectUniqueName": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "projectName": "csharpwebapp",
      "projectPath": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "packagesPath": "/Users/michaelnebel/Work/playground/csharpwebapp/packages",
      "outputPath": "/Users/michaelnebel/Work/playground/csharpwebapp/obj/",
      "projectStyle": "PackageReference",
      "configFilePaths": [
        "/Users/michaelnebel/.nuget/NuGet/NuGet.Config"
      ],
      "originalTargetFrameworks": [
        "net4.8"
      ],
      "sources": {
        "https://api.nuget.org/v3/index.json": {}
      },
      "frameworks": {
        "net48": {
          "targetAlias": "net4.8",
          "projectReferences": {}
        }
      },
      "warningProperties": {
        "warnAsError": [
          "NU1605"
        ]
      }
    },
    "frameworks": {
      "net48": {
        "targetAlias": "net4.8",
        "dependencies": {
          "Microsoft.NETFramework.ReferenceAssemblies": {
            "suppressParent": "All",
            "target": "Package",
            "version": "[1.0.2, )",
            "autoReferenced": true
          },
          "Newtonsoft.Json.Bson": {
            "target": "Package",
            "version": "[1.0.2, )"
          }
        },
        "runtimeIdentifierGraphPath": "/Users/michaelnebel/.dotnet/sdk/7.0.102/RuntimeIdentifierGraph.json"
      }
    }
  }
}
""";

        /// <summary>
        /// This is part of the content of the assets file that dotnet generates based on the
        /// following project file content.
        ///
        /// <Project Sdk="Microsoft.NET.Sdk.Web">
        ///   <PropertyGroup>
        ///     <TargetFramework>netstandard2.1</TargetFramework>
        ///     <Nullable>enable</Nullable>
        ///     <ImplicitUsings>enable</ImplicitUsings>
        ///   </PropertyGroup>
        ///   <ItemGroup>
        ///     <PackageReference Include="Newtonsoft.Json.Bson" Version="1.0.2" />
        ///   </ItemGroup>
        /// </Project>
        /// </summary>
        private readonly string assetsNetstandard21 = """
{
  "version": 3,
  "targets": {
    ".NETStandard,Version=v2.1": {
      "Newtonsoft.Json/12.0.1": {
        "type": "package",
        "compile": {
          "lib/netstandard2.0/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard2.0/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        }
      },
      "Newtonsoft.Json.Bson/1.0.2": {
        "type": "package",
        "dependencies": {
          "Newtonsoft.Json": "12.0.1"
        },
        "compile": {
          "lib/netstandard2.0/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard2.0/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        }
      }
    }
  },
  "projectFileDependencyGroups": {
    ".NETStandard,Version=v2.1": [
      "Newtonsoft.Json.Bson >= 1.0.2"
    ]
  },
  "packageFolders": {
    "/Users/michaelnebel/Work/playground/csharpwebapp/packages": {}
  },
  "project": {
    "version": "1.0.0",
    "restore": {
      "projectUniqueName": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "projectName": "csharpwebapp",
      "projectPath": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "packagesPath": "/Users/michaelnebel/Work/playground/csharpwebapp/packages",
      "outputPath": "/Users/michaelnebel/Work/playground/csharpwebapp/obj/",
      "projectStyle": "PackageReference",
      "configFilePaths": [
        "/Users/michaelnebel/.nuget/NuGet/NuGet.Config"
      ],
      "originalTargetFrameworks": [
        "netstandard2.1"
      ],
      "sources": {
        "https://api.nuget.org/v3/index.json": {}
      },
      "frameworks": {
        "netstandard2.1": {
          "targetAlias": "netstandard2.1",
          "projectReferences": {}
        }
      },
      "warningProperties": {
        "warnAsError": [
          "NU1605"
        ]
      }
    },
    "frameworks": {
      "netstandard2.1": {
        "targetAlias": "netstandard2.1",
        "dependencies": {
          "Newtonsoft.Json.Bson": {
            "target": "Package",
            "version": "[1.0.2, )"
          }
        },
        "imports": [
          "net461",
          "net462",
          "net47",
          "net471",
          "net472",
          "net48",
          "net481"
        ],
        "assetTargetFallback": true,
        "warn": true,
        "downloadDependencies": [
          {
            "name": "NETStandard.Library.Ref",
            "version": "[2.1.0, 2.1.0]"
          }
        ],
        "frameworkReferences": {
          "NETStandard.Library": {
            "privateAssets": "all"
          }
        },
        "runtimeIdentifierGraphPath": "/Users/michaelnebel/.dotnet/sdk/7.0.102/RuntimeIdentifierGraph.json"
      }
    }
  }
}
""";
        /// <summary>
        /// This is part of the content of the assets file that dotnet generates based on the
        /// following project file content.
        ///
        /// <Project Sdk="Microsoft.NET.Sdk.Web">
        ///   <PropertyGroup>
        ///     <TargetFramework>netstandard1.6</TargetFramework>
        ///     <Nullable>enable</Nullable>
        ///     <ImplicitUsings>enable</ImplicitUsings>
        ///   </PropertyGroup>
        ///   <ItemGroup>
        ///     <PackageReference Include="Newtonsoft.Json.Bson" Version="1.0.2" />
        ///   </ItemGroup>
        /// </Project>
        /// </summary>
        private readonly string assetsNetstandard16 = """
{
  "version": 3,
  "targets": {
    ".NETStandard,Version=v1.6": {
      "Microsoft.CSharp/4.3.0": {
        "type": "package",
        "dependencies": {
          "System.Collections": "4.3.0",
          "System.Diagnostics.Debug": "4.3.0",
          "System.Dynamic.Runtime": "4.3.0",
          "System.Globalization": "4.3.0",
          "System.Linq": "4.3.0",
          "System.Linq.Expressions": "4.3.0",
          "System.ObjectModel": "4.3.0",
          "System.Reflection": "4.3.0",
          "System.Reflection.Extensions": "4.3.0",
          "System.Reflection.Primitives": "4.3.0",
          "System.Reflection.TypeExtensions": "4.3.0",
          "System.Resources.ResourceManager": "4.3.0",
          "System.Runtime": "4.3.0",
          "System.Runtime.Extensions": "4.3.0",
          "System.Runtime.InteropServices": "4.3.0",
          "System.Threading": "4.3.0"
        },
        "compile": {
          "ref/netstandard1.0/Microsoft.CSharp.dll": {
            "related": ".xml"
          }
        },
        "runtime": {
          "lib/netstandard1.3/Microsoft.CSharp.dll": {}
        }
      },
      "Microsoft.NETCore.Platforms/1.1.0": {
        "type": "package",
        "compile": {
          "lib/netstandard1.0/_._": {}
        },
        "runtime": {
          "lib/netstandard1.0/_._": {}
        }
      },
      "Microsoft.NETCore.Targets/1.1.0": {
        "type": "package",
        "compile": {
          "lib/netstandard1.0/_._": {}
        },
        "runtime": {
          "lib/netstandard1.0/_._": {}
        }
      },
      "Microsoft.Win32.Primitives/4.3.0": {
        "type": "package",
        "dependencies": {
          "Microsoft.NETCore.Platforms": "1.1.0",
          "Microsoft.NETCore.Targets": "1.1.0",
          "System.Runtime": "4.3.0"
        },
        "compile": {
          "ref/netstandard1.3/Microsoft.Win32.Primitives.dll": {
            "related": ".xml"
          }
        }
      },
      "NETStandard.Library/1.6.1": {
        "type": "package",
        "dependencies": {
          "Microsoft.NETCore.Platforms": "1.1.0",
          "Microsoft.Win32.Primitives": "4.3.0",
          "System.AppContext": "4.3.0",
          "System.Collections": "4.3.0",
          "System.Collections.Concurrent": "4.3.0",
          "System.Console": "4.3.0",
          "System.Diagnostics.Debug": "4.3.0",
          "System.Diagnostics.Tools": "4.3.0",
          "System.Diagnostics.Tracing": "4.3.0",
          "System.Globalization": "4.3.0",
          "System.Globalization.Calendars": "4.3.0",
          "System.IO": "4.3.0",
          "System.IO.Compression": "4.3.0",
          "System.IO.Compression.ZipFile": "4.3.0",
          "System.IO.FileSystem": "4.3.0",
          "System.IO.FileSystem.Primitives": "4.3.0",
          "System.Linq": "4.3.0",
          "System.Linq.Expressions": "4.3.0",
          "System.Net.Http": "4.3.0",
          "System.Net.Primitives": "4.3.0",
          "System.Net.Sockets": "4.3.0",
          "System.ObjectModel": "4.3.0",
          "System.Reflection": "4.3.0",
          "System.Reflection.Extensions": "4.3.0",
          "System.Reflection.Primitives": "4.3.0",
          "System.Resources.ResourceManager": "4.3.0",
          "System.Runtime": "4.3.0",
          "System.Runtime.Extensions": "4.3.0",
          "System.Runtime.Handles": "4.3.0",
          "System.Runtime.InteropServices": "4.3.0",
          "System.Runtime.InteropServices.RuntimeInformation": "4.3.0",
          "System.Runtime.Numerics": "4.3.0",
          "System.Security.Cryptography.Algorithms": "4.3.0",
          "System.Security.Cryptography.Encoding": "4.3.0",
          "System.Security.Cryptography.Primitives": "4.3.0",
          "System.Security.Cryptography.X509Certificates": "4.3.0",
          "System.Text.Encoding": "4.3.0",
          "System.Text.Encoding.Extensions": "4.3.0",
          "System.Text.RegularExpressions": "4.3.0",
          "System.Threading": "4.3.0",
          "System.Threading.Tasks": "4.3.0",
          "System.Threading.Timer": "4.3.0",
          "System.Xml.ReaderWriter": "4.3.0",
          "System.Xml.XDocument": "4.3.0"
        }
      },
      "Newtonsoft.Json/12.0.1": {
        "type": "package",
        "dependencies": {
          "Microsoft.CSharp": "4.3.0",
          "NETStandard.Library": "1.6.1",
          "System.ComponentModel.TypeConverter": "4.3.0",
          "System.Runtime.Serialization.Formatters": "4.3.0",
          "System.Runtime.Serialization.Primitives": "4.3.0",
          "System.Xml.XmlDocument": "4.3.0"
        },
        "compile": {
          "lib/netstandard1.3/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard1.3/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        }
      },
      "Newtonsoft.Json.Bson/1.0.2": {
        "type": "package",
        "dependencies": {
          "NETStandard.Library": "1.6.1",
          "Newtonsoft.Json": "12.0.1"
        },
        "compile": {
          "lib/netstandard1.3/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard1.3/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        }
      }
    }
  },
    "projectFileDependencyGroups": {
    ".NETStandard,Version=v1.6": [
      "NETStandard.Library >= 1.6.1",
      "Newtonsoft.Json.Bson >= 1.0.2"
    ]
  },
  "packageFolders": {
    "/Users/michaelnebel/Work/playground/csharpwebapp/packages": {}
  },
  "project": {
    "version": "1.0.0",
    "restore": {
      "projectUniqueName": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "projectName": "csharpwebapp",
      "projectPath": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "packagesPath": "/Users/michaelnebel/Work/playground/csharpwebapp/packages",
      "outputPath": "/Users/michaelnebel/Work/playground/csharpwebapp/obj/",
      "projectStyle": "PackageReference",
      "configFilePaths": [
        "/Users/michaelnebel/.nuget/NuGet/NuGet.Config"
      ],
      "originalTargetFrameworks": [
        "netstandard1.6"
      ],
      "sources": {
        "https://api.nuget.org/v3/index.json": {}
      },
      "frameworks": {
        "netstandard1.6": {
          "targetAlias": "netstandard1.6",
          "projectReferences": {}
        }
      },
      "warningProperties": {
        "warnAsError": [
          "NU1605"
        ]
      }
    },
    "frameworks": {
      "netstandard1.6": {
        "targetAlias": "netstandard1.6",
        "dependencies": {
          "NETStandard.Library": {
            "target": "Package",
            "version": "[1.6.1, )",
            "autoReferenced": true
          },
          "Newtonsoft.Json.Bson": {
            "target": "Package",
            "version": "[1.0.2, )"
          }
        },
        "runtimeIdentifierGraphPath": "/Users/michaelnebel/.dotnet/sdk/7.0.102/RuntimeIdentifierGraph.json"
      }
    }
  }
}
""";

        /// <summary>
        /// This is part of the content of the assets file that dotnet generates based on the
        /// following project file content.
        ///
        /// <Project Sdk="Microsoft.NET.Sdk.Web">
        ///   <PropertyGroup>
        ///     <TargetFramework>netcoreapp2.0</TargetFramework>
        ///     <Nullable>enable</Nullable>
        ///     <ImplicitUsings>enable</ImplicitUsings>
        ///   </PropertyGroup>
        ///   <ItemGroup>
        ///     <PackageReference Include="Newtonsoft.Json.Bson" Version="1.0.2" />
        ///   </ItemGroup>
        /// </Project>
        /// </summary>
        private readonly string assetsNetcoreapp20 = """
{
  "version": 3,
  "targets": {
    ".NETCoreApp,Version=v2.0": {
      "Microsoft.NETCore.App/2.0.0": {
        "type": "package",
        "dependencies": {
          "Microsoft.NETCore.DotNetHostPolicy": "2.0.0",
          "Microsoft.NETCore.Platforms": "2.0.0",
          "NETStandard.Library": "2.0.0"
        },
        "compile": {
          "ref/netcoreapp2.0/Microsoft.CSharp.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/Microsoft.VisualBasic.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/Microsoft.Win32.Primitives.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.AppContext.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Buffers.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Collections.Concurrent.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Collections.Immutable.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Collections.NonGeneric.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Collections.Specialized.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Collections.dll": {
            "related": ".Concurrent.xml;.Immutable.xml;.NonGeneric.xml;.Specialized.xml;.xml"
          },
          "ref/netcoreapp2.0/System.ComponentModel.Annotations.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.ComponentModel.Composition.dll": {},
          "ref/netcoreapp2.0/System.ComponentModel.DataAnnotations.dll": {},
          "ref/netcoreapp2.0/System.ComponentModel.EventBasedAsync.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.ComponentModel.Primitives.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.ComponentModel.TypeConverter.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.ComponentModel.dll": {
            "related": ".Annotations.xml;.EventBasedAsync.xml;.Primitives.xml;.TypeConverter.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Configuration.dll": {},
          "ref/netcoreapp2.0/System.Console.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Core.dll": {},
          "ref/netcoreapp2.0/System.Data.Common.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Data.dll": {
            "related": ".Common.xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.Contracts.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.Debug.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.DiagnosticSource.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.FileVersionInfo.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.Process.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.StackTrace.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.TextWriterTraceListener.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.Tools.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.TraceSource.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Diagnostics.Tracing.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Drawing.Primitives.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Drawing.dll": {
            "related": ".Primitives.xml"
          },
          "ref/netcoreapp2.0/System.Dynamic.Runtime.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Globalization.Calendars.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Globalization.Extensions.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Globalization.dll": {
            "related": ".Calendars.xml;.Extensions.xml;.xml"
          },
          "ref/netcoreapp2.0/System.IO.Compression.FileSystem.dll": {},
          "ref/netcoreapp2.0/System.IO.Compression.ZipFile.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.IO.Compression.dll": {
            "related": ".xml;.ZipFile.xml"
          },
          "ref/netcoreapp2.0/System.IO.FileSystem.DriveInfo.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.IO.FileSystem.Primitives.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.IO.FileSystem.Watcher.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.IO.FileSystem.dll": {
            "related": ".DriveInfo.xml;.Primitives.xml;.Watcher.xml;.xml"
          },
          "ref/netcoreapp2.0/System.IO.IsolatedStorage.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.IO.MemoryMappedFiles.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.IO.Pipes.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.IO.UnmanagedMemoryStream.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.IO.dll": {
            "related": ".Compression.xml;.Compression.ZipFile.xml;.FileSystem.DriveInfo.xml;.FileSystem.Primitives.xml;.FileSystem.Watcher.xml;.FileSystem.xml;.IsolatedStorage.xml;.MemoryMappedFiles.xml;.Pipes.xml;.UnmanagedMemoryStream.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Linq.Expressions.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Linq.Parallel.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Linq.Queryable.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Linq.dll": {
            "related": ".Expressions.xml;.Parallel.xml;.Queryable.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Net.Http.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.HttpListener.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.Mail.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.NameResolution.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.NetworkInformation.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.Ping.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.Primitives.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.Requests.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.Security.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.ServicePoint.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.Sockets.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.WebClient.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.WebHeaderCollection.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.WebProxy.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.WebSockets.Client.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Net.WebSockets.dll": {
            "related": ".Client.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Net.dll": {
            "related": ".Http.xml;.HttpListener.xml;.Mail.xml;.NameResolution.xml;.NetworkInformation.xml;.Ping.xml;.Primitives.xml;.Requests.xml;.Security.xml;.ServicePoint.xml;.Sockets.xml;.WebClient.xml;.WebHeaderCollection.xml;.WebProxy.xml;.WebSockets.Client.xml;.WebSockets.xml"
          },
          "ref/netcoreapp2.0/System.Numerics.Vectors.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Numerics.dll": {
            "related": ".Vectors.xml"
          },
          "ref/netcoreapp2.0/System.ObjectModel.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Reflection.DispatchProxy.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Reflection.Emit.ILGeneration.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Reflection.Emit.Lightweight.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Reflection.Emit.dll": {
            "related": ".ILGeneration.xml;.Lightweight.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Reflection.Extensions.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Reflection.Metadata.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Reflection.Primitives.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Reflection.TypeExtensions.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Reflection.dll": {
            "related": ".DispatchProxy.xml;.Emit.ILGeneration.xml;.Emit.Lightweight.xml;.Emit.xml;.Extensions.xml;.Metadata.xml;.Primitives.xml;.TypeExtensions.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Resources.Reader.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Resources.ResourceManager.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Resources.Writer.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.CompilerServices.VisualC.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.Extensions.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.Handles.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.InteropServices.RuntimeInformation.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.InteropServices.WindowsRuntime.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.InteropServices.dll": {
            "related": ".RuntimeInformation.xml;.WindowsRuntime.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Runtime.Loader.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.Numerics.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.Serialization.Formatters.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.Serialization.Json.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.Serialization.Primitives.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.Serialization.Xml.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Runtime.Serialization.dll": {
            "related": ".Formatters.xml;.Json.xml;.Primitives.xml;.Xml.xml"
          },
          "ref/netcoreapp2.0/System.Runtime.dll": {
            "related": ".CompilerServices.VisualC.xml;.Extensions.xml;.Handles.xml;.InteropServices.RuntimeInformation.xml;.InteropServices.WindowsRuntime.xml;.InteropServices.xml;.Loader.xml;.Numerics.xml;.Serialization.Formatters.xml;.Serialization.Json.xml;.Serialization.Primitives.xml;.Serialization.Xml.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Security.Claims.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Security.Cryptography.Algorithms.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Security.Cryptography.Csp.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Security.Cryptography.Encoding.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Security.Cryptography.Primitives.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Security.Cryptography.X509Certificates.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Security.Principal.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Security.SecureString.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Security.dll": {
            "related": ".Claims.xml;.Cryptography.Algorithms.xml;.Cryptography.Csp.xml;.Cryptography.Encoding.xml;.Cryptography.Primitives.xml;.Cryptography.X509Certificates.xml;.Principal.xml;.SecureString.xml"
          },
          "ref/netcoreapp2.0/System.ServiceModel.Web.dll": {},
          "ref/netcoreapp2.0/System.ServiceProcess.dll": {},
          "ref/netcoreapp2.0/System.Text.Encoding.Extensions.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Text.Encoding.dll": {
            "related": ".Extensions.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Text.RegularExpressions.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Threading.Overlapped.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Threading.Tasks.Dataflow.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Threading.Tasks.Extensions.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Threading.Tasks.Parallel.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Threading.Tasks.dll": {
            "related": ".Dataflow.xml;.Extensions.xml;.Parallel.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Threading.Thread.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Threading.ThreadPool.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Threading.Timer.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Threading.dll": {
            "related": ".Overlapped.xml;.Tasks.Dataflow.xml;.Tasks.Extensions.xml;.Tasks.Parallel.xml;.Tasks.xml;.Thread.xml;.ThreadPool.xml;.Timer.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Transactions.Local.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Transactions.dll": {
            "related": ".Local.xml"
          },
          "ref/netcoreapp2.0/System.ValueTuple.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Web.HttpUtility.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Web.dll": {
            "related": ".HttpUtility.xml"
          },
          "ref/netcoreapp2.0/System.Windows.dll": {},
          "ref/netcoreapp2.0/System.Xml.Linq.dll": {},
          "ref/netcoreapp2.0/System.Xml.ReaderWriter.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Xml.Serialization.dll": {},
          "ref/netcoreapp2.0/System.Xml.XDocument.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Xml.XPath.XDocument.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Xml.XPath.dll": {
            "related": ".XDocument.xml;.xml"
          },
          "ref/netcoreapp2.0/System.Xml.XmlDocument.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Xml.XmlSerializer.dll": {
            "related": ".xml"
          },
          "ref/netcoreapp2.0/System.Xml.dll": {
            "related": ".ReaderWriter.xml;.XDocument.xml;.XmlDocument.xml;.XmlSerializer.xml;.XPath.XDocument.xml;.XPath.xml"
          },
          "ref/netcoreapp2.0/System.dll": {
            "related": ".AppContext.xml;.Buffers.xml;.Collections.Concurrent.xml;.Collections.Immutable.xml;.Collections.NonGeneric.xml;.Collections.Specialized.xml;.Collections.xml;.ComponentModel.Annotations.xml;.ComponentModel.EventBasedAsync.xml;.ComponentModel.Primitives.xml;.ComponentModel.TypeConverter.xml;.ComponentModel.xml;.Console.xml;.Data.Common.xml;.Diagnostics.Contracts.xml;.Diagnostics.Debug.xml;.Diagnostics.DiagnosticSource.xml;.Diagnostics.FileVersionInfo.xml;.Diagnostics.Process.xml;.Diagnostics.StackTrace.xml;.Diagnostics.TextWriterTraceListener.xml;.Diagnostics.Tools.xml;.Diagnostics.TraceSource.xml;.Diagnostics.Tracing.xml;.Drawing.Primitives.xml;.Dynamic.Runtime.xml;.Globalization.Calendars.xml;.Globalization.Extensions.xml;.Globalization.xml;.IO.Compression.xml;.IO.Compression.ZipFile.xml;.IO.FileSystem.DriveInfo.xml;.IO.FileSystem.Primitives.xml;.IO.FileSystem.Watcher.xml;.IO.FileSystem.xml;.IO.IsolatedStorage.xml;.IO.MemoryMappedFiles.xml;.IO.Pipes.xml;.IO.UnmanagedMemoryStream.xml;.IO.xml;.Linq.Expressions.xml;.Linq.Parallel.xml;.Linq.Queryable.xml;.Linq.xml;.Net.Http.xml;.Net.HttpListener.xml;.Net.Mail.xml;.Net.NameResolution.xml;.Net.NetworkInformation.xml;.Net.Ping.xml;.Net.Primitives.xml;.Net.Requests.xml;.Net.Security.xml;.Net.ServicePoint.xml;.Net.Sockets.xml;.Net.WebClient.xml;.Net.WebHeaderCollection.xml;.Net.WebProxy.xml;.Net.WebSockets.Client.xml;.Net.WebSockets.xml;.Numerics.Vectors.xml;.ObjectModel.xml;.Reflection.DispatchProxy.xml;.Reflection.Emit.ILGeneration.xml;.Reflection.Emit.Lightweight.xml;.Reflection.Emit.xml;.Reflection.Extensions.xml;.Reflection.Metadata.xml;.Reflection.Primitives.xml;.Reflection.TypeExtensions.xml;.Reflection.xml;.Resources.Reader.xml;.Resources.ResourceManager.xml;.Resources.Writer.xml;.Runtime.CompilerServices.VisualC.xml;.Runtime.Extensions.xml;.Runtime.Handles.xml;.Runtime.InteropServices.RuntimeInformation.xml;.Runtime.InteropServices.WindowsRuntime.xml;.Runtime.InteropServices.xml;.Runtime.Loader.xml;.Runtime.Numerics.xml;.Runtime.Serialization.Formatters.xml;.Runtime.Serialization.Json.xml;.Runtime.Serialization.Primitives.xml;.Runtime.Serialization.Xml.xml;.Runtime.xml;.Security.Claims.xml;.Security.Cryptography.Algorithms.xml;.Security.Cryptography.Csp.xml;.Security.Cryptography.Encoding.xml;.Security.Cryptography.Primitives.xml;.Security.Cryptography.X509Certificates.xml;.Security.Principal.xml;.Security.SecureString.xml;.Text.Encoding.Extensions.xml;.Text.Encoding.xml;.Text.RegularExpressions.xml;.Threading.Overlapped.xml;.Threading.Tasks.Dataflow.xml;.Threading.Tasks.Extensions.xml;.Threading.Tasks.Parallel.xml;.Threading.Tasks.xml;.Threading.Thread.xml;.Threading.ThreadPool.xml;.Threading.Timer.xml;.Threading.xml;.Transactions.Local.xml;.ValueTuple.xml;.Web.HttpUtility.xml;.Xml.ReaderWriter.xml;.Xml.XDocument.xml;.Xml.XmlDocument.xml;.Xml.XmlSerializer.xml;.Xml.XPath.XDocument.xml;.Xml.XPath.xml"
          },
          "ref/netcoreapp2.0/WindowsBase.dll": {},
          "ref/netcoreapp2.0/mscorlib.dll": {},
          "ref/netcoreapp2.0/netstandard.dll": {}
        },
        "build": {
          "build/netcoreapp2.0/Microsoft.NETCore.App.props": {},
          "build/netcoreapp2.0/Microsoft.NETCore.App.targets": {}
        }
      },
      "Microsoft.NETCore.DotNetAppHost/2.0.0": {
        "type": "package"
      },
      "Microsoft.NETCore.DotNetHostPolicy/2.0.0": {
        "type": "package",
        "dependencies": {
          "Microsoft.NETCore.DotNetHostResolver": "2.0.0"
        }
      },
      "Microsoft.NETCore.DotNetHostResolver/2.0.0": {
        "type": "package",
        "dependencies": {
          "Microsoft.NETCore.DotNetAppHost": "2.0.0"
        }
      },
      "Microsoft.NETCore.Platforms/2.0.0": {
        "type": "package",
        "compile": {
          "lib/netstandard1.0/_._": {}
        },
        "runtime": {
          "lib/netstandard1.0/_._": {}
        }
      },
      "NETStandard.Library/2.0.0": {
        "type": "package",
        "dependencies": {
          "Microsoft.NETCore.Platforms": "1.1.0"
        },
        "compile": {
          "lib/netstandard1.0/_._": {}
        },
        "runtime": {
          "lib/netstandard1.0/_._": {}
        },
        "build": {
          "build/netstandard2.0/NETStandard.Library.targets": {}
        }
      },
      "Newtonsoft.Json/12.0.1": {
        "type": "package",
        "compile": {
          "lib/netstandard2.0/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard2.0/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        }
      },
      "Newtonsoft.Json.Bson/1.0.2": {
        "type": "package",
        "dependencies": {
          "Newtonsoft.Json": "12.0.1"
        },
        "compile": {
          "lib/netstandard2.0/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard2.0/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        }
      }
    }
  },
  "projectFileDependencyGroups": {
    ".NETCoreApp,Version=v2.0": [
      "Microsoft.NETCore.App >= 2.0.0",
      "Newtonsoft.Json.Bson >= 1.0.2"
    ]
  },
  "packageFolders": {
    "/Users/michaelnebel/Work/playground/csharpwebapp/packages": {}
  },
  "project": {
    "version": "1.0.0",
    "restore": {
      "projectUniqueName": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "projectName": "csharpwebapp",
      "projectPath": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "packagesPath": "/Users/michaelnebel/Work/playground/csharpwebapp/packages",
      "outputPath": "/Users/michaelnebel/Work/playground/csharpwebapp/obj/",
      "projectStyle": "PackageReference",
      "configFilePaths": [
        "/Users/michaelnebel/.nuget/NuGet/NuGet.Config"
      ],
      "originalTargetFrameworks": [
        "netcoreapp2.0"
      ],
      "sources": {
        "https://api.nuget.org/v3/index.json": {}
      },
      "frameworks": {
        "netcoreapp2.0": {
          "targetAlias": "netcoreapp2.0",
          "projectReferences": {}
        }
      },
      "warningProperties": {
        "warnAsError": [
          "NU1605"
        ]
      }
    },
    "frameworks": {
      "netcoreapp2.0": {
        "targetAlias": "netcoreapp2.0",
        "dependencies": {
          "Microsoft.NETCore.App": {
            "suppressParent": "All",
            "target": "Package",
            "version": "[2.0.0, )",
            "autoReferenced": true
          },
          "Newtonsoft.Json.Bson": {
            "target": "Package",
            "version": "[1.0.2, )"
          }
        },
        "imports": [
          "net461",
          "net462",
          "net47",
          "net471",
          "net472",
          "net48",
          "net481"
        ],
        "assetTargetFallback": true,
        "warn": true,
        "runtimeIdentifierGraphPath": "/Users/michaelnebel/.dotnet/sdk/7.0.102/RuntimeIdentifierGraph.json"
      }
    }
  }
}
""";

        /// <summary>
        /// This is part of the content of the assets file that dotnet generates based on the
        /// following project file content.
        ///
        /// <Project Sdk="Microsoft.NET.Sdk.Web">
        ///   <PropertyGroup>
        ///     <TargetFramework>netcoreapp3.1</TargetFramework>
        ///     <Nullable>enable</Nullable>
        ///     <ImplicitUsings>enable</ImplicitUsings>
        ///   </PropertyGroup>
        ///   <ItemGroup>
        ///     <PackageReference Include="Newtonsoft.Json.Bson" Version="1.0.2" />
        ///   </ItemGroup>
        /// </Project>
        /// </summary>
        private readonly string assetsNetcoreapp31 = """
{
  "version": 3,
  "targets": {
    ".NETCoreApp,Version=v3.1": {
      "Newtonsoft.Json/12.0.1": {
        "type": "package",
        "compile": {
          "lib/netstandard2.0/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard2.0/Newtonsoft.Json.dll": {
            "related": ".pdb;.xml"
          }
        }
      },
      "Newtonsoft.Json.Bson/1.0.2": {
        "type": "package",
        "dependencies": {
          "Newtonsoft.Json": "12.0.1"
        },
        "compile": {
          "lib/netstandard2.0/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        },
        "runtime": {
          "lib/netstandard2.0/Newtonsoft.Json.Bson.dll": {
            "related": ".pdb;.xml"
          }
        }
      }
    }
  },
  "projectFileDependencyGroups": {
    ".NETCoreApp,Version=v3.1": [
      "Newtonsoft.Json.Bson >= 1.0.2"
    ]
  },
  "packageFolders": {
    "/Users/michaelnebel/Work/playground/csharpwebapp/packages": {}
  },
  "project": {
    "version": "1.0.0",
    "restore": {
      "projectUniqueName": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "projectName": "csharpwebapp",
      "projectPath": "/Users/michaelnebel/Work/playground/csharpwebapp/csharpwebapp.csproj",
      "packagesPath": "/Users/michaelnebel/Work/playground/csharpwebapp/packages",
      "outputPath": "/Users/michaelnebel/Work/playground/csharpwebapp/obj/",
      "projectStyle": "PackageReference",
      "configFilePaths": [
        "/Users/michaelnebel/.nuget/NuGet/NuGet.Config"
      ],
      "originalTargetFrameworks": [
        "netcoreapp3.1"
      ],
      "sources": {
        "https://api.nuget.org/v3/index.json": {}
      },
      "frameworks": {
        "netcoreapp3.1": {
          "targetAlias": "netcoreapp3.1",
          "projectReferences": {}
        }
      },
      "warningProperties": {
        "warnAsError": [
          "NU1605"
        ]
      }
    },
    "frameworks": {
      "netcoreapp3.1": {
        "targetAlias": "netcoreapp3.1",
        "dependencies": {
          "Newtonsoft.Json.Bson": {
            "target": "Package",
            "version": "[1.0.2, )"
          }
        },
        "imports": [
          "net461",
          "net462",
          "net47",
          "net471",
          "net472",
          "net48",
          "net481"
        ],
        "assetTargetFallback": true,
        "warn": true,
        "downloadDependencies": [
          {
            "name": "Microsoft.AspNetCore.App.Ref",
            "version": "[3.1.10, 3.1.10]"
          },
          {
            "name": "Microsoft.NETCore.App.Host.osx-x64",
            "version": "[3.1.32, 3.1.32]"
          },
          {
            "name": "Microsoft.NETCore.App.Ref",
            "version": "[3.1.0, 3.1.0]"
          }
        ],
        "frameworkReferences": {
          "Microsoft.AspNetCore.App": {
            "privateAssets": "none"
          },
          "Microsoft.NETCore.App": {
            "privateAssets": "all"
          }
        },
        "runtimeIdentifierGraphPath": "/Users/michaelnebel/.dotnet/sdk/7.0.102/RuntimeIdentifierGraph.json"
      }
    }
  }
}
""";
    }
}
