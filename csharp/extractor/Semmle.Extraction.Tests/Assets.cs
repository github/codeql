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
            var assets = new Assets(new ProgressMonitor(new LoggerStub()));
            var json = assetsJson1;
            var dependencies = new DependencyContainer();

            // Execute
            var success = assets.TryParse(json, dependencies);

            // Verify
            Assert.True(success);
            Assert.Equal(7, dependencies.Paths.Count());
            Assert.Equal(6, dependencies.Packages.Count());

            var normalizedPaths = dependencies.Paths.Select(FixExpectedPathOnWindows);
            // Used references
            Assert.Contains("castle.core/4.4.1/lib/netstandard1.5/Castle.Core.dll", normalizedPaths);
            Assert.Contains("castle.core/4.4.1/lib/netstandard1.5/Castle.Core2.dll", normalizedPaths);
            Assert.Contains("json.net/1.0.33/lib/netstandard2.0/Json.Net.dll", normalizedPaths);
            Assert.Contains("microsoft.aspnetcore.cryptography.internal/6.0.8/lib/net6.0/Microsoft.AspNetCore.Cryptography.Internal.dll", normalizedPaths);
            Assert.Contains("humanizer.core/2.8.26/lib/netstandard2.0", normalizedPaths);
            // Used packages
            Assert.Contains("castle.core", dependencies.Packages);
            Assert.Contains("json.net", dependencies.Packages);
            Assert.Contains("microsoft.aspnetcore.cryptography.internal", dependencies.Packages);
            Assert.Contains("humanizer.core", dependencies.Packages);
            // Used frameworks
            Assert.Contains("microsoft.netcore.app.ref", dependencies.Packages);
            Assert.Contains("microsoft.aspnetcore.app.ref", dependencies.Packages);
        }

        [Fact]
        public void TestAssetsFailure()
        {
            // Setup
            var assets = new Assets(new ProgressMonitor(new LoggerStub()));
            var json = "garbage data";
            var dependencies = new DependencyContainer();

            // Execute
            var success = assets.TryParse(json, dependencies);

            // Verify
            Assert.False(success);
            Assert.Empty(dependencies.Paths);
        }

        [Fact]
        public void TestAssetsNet70()
        {
            // Setup
            var assets = new Assets(new ProgressMonitor(new LoggerStub()));
            var json = assetsNet70;
            var dependencies = new DependencyContainer();

            // Execute
            var success = assets.TryParse(json, dependencies);

            // Verify
            Assert.True(success);
            Assert.Equal(4, dependencies.Paths.Count);
            Assert.Equal(4, dependencies.Packages.Count);


            var normalizedPaths = dependencies.Paths.Select(FixExpectedPathOnWindows);
            // Used paths
            Assert.Contains("microsoft.netcore.app.ref", dependencies.Packages);
            Assert.Contains("microsoft.aspnetcore.app.ref", dependencies.Packages);
            Assert.Contains("newtonsoft.json/12.0.1/lib/netstandard2.0/Newtonsoft.Json.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json.bson/1.0.2/lib/netstandard2.0/Newtonsoft.Json.Bson.dll", normalizedPaths);
            // Used packages
            Assert.Contains("microsoft.netcore.app.ref", dependencies.Packages);
            Assert.Contains("microsoft.aspnetcore.app.ref", dependencies.Packages);
            Assert.Contains("newtonsoft.json", dependencies.Packages);
            Assert.Contains("newtonsoft.json.bson", dependencies.Packages);

        }

        [Fact]
        public void TestAssetsNet48()
        {
            // Setup
            var assets = new Assets(new ProgressMonitor(new LoggerStub()));
            var json = assetsNet48;
            var dependencies = new DependencyContainer();

            // Execute
            var success = assets.TryParse(json, dependencies);

            // Verify
            Assert.True(success);
            Assert.Equal(3, dependencies.Paths.Count);
            Assert.Equal(3, dependencies.Packages.Count);

            var normalizedPaths = dependencies.Paths.Select(FixExpectedPathOnWindows);
            // Used references
            Assert.Contains("microsoft.netframework.referenceassemblies.net48/1.0.2", normalizedPaths);
            Assert.Contains("newtonsoft.json/12.0.1/lib/net45/Newtonsoft.Json.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json.bson/1.0.2/lib/net45/Newtonsoft.Json.Bson.dll", normalizedPaths);
            // Used packages
            Assert.Contains("microsoft.netframework.referenceassemblies.net48", dependencies.Packages);
            Assert.Contains("newtonsoft.json", dependencies.Packages);
            Assert.Contains("newtonsoft.json.bson", dependencies.Packages);
        }

        [Fact]
        public void TestAssetsNetstandard21()
        {
            // Setup
            var assets = new Assets(new ProgressMonitor(new LoggerStub()));
            var json = assetsNetstandard21;
            var dependencies = new DependencyContainer();

            // Execute
            var success = assets.TryParse(json, dependencies);

            // Verify
            Assert.True(success);
            Assert.Equal(3, dependencies.Paths.Count);
            Assert.Equal(3, dependencies.Packages.Count);

            var normalizedPaths = dependencies.Paths.Select(FixExpectedPathOnWindows);

            // Used references
            Assert.Contains("netstandard.library.ref", normalizedPaths);
            Assert.Contains("newtonsoft.json/12.0.1/lib/netstandard2.0/Newtonsoft.Json.dll", normalizedPaths);
            Assert.Contains("newtonsoft.json.bson/1.0.2/lib/netstandard2.0/Newtonsoft.Json.Bson.dll", normalizedPaths);
            // Used packages
            Assert.Contains("netstandard.library.ref", dependencies.Packages);
            Assert.Contains("newtonsoft.json", dependencies.Packages);
            Assert.Contains("newtonsoft.json.bson", dependencies.Packages);
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
    }
}
