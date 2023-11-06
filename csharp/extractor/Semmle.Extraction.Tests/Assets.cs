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
            Assert.Equal(5, dependencies.RequiredPaths.Count());
            Assert.Equal(4, dependencies.UsedPackages.Count());

            var normalizedPaths = dependencies.RequiredPaths.Select(FixExpectedPathOnWindows);
            // Required references
            Assert.Contains("castle.core/4.4.1/lib/netstandard1.5/Castle.Core.dll", normalizedPaths);
            Assert.Contains("castle.core/4.4.1/lib/netstandard1.5/Castle.Core2.dll", normalizedPaths);
            Assert.Contains("json.net/1.0.33/lib/netstandard2.0/Json.Net.dll", normalizedPaths);
            Assert.Contains("microsoft.aspnetcore.cryptography.internal/6.0.8/lib/net6.0/Microsoft.AspNetCore.Cryptography.Internal.dll", normalizedPaths);
            Assert.Contains("humanizer.core/2.8.26/lib/netstandard2.0", normalizedPaths);
            // Used packages
            Assert.Contains("castle.core", dependencies.UsedPackages);
            Assert.Contains("json.net", dependencies.UsedPackages);
            Assert.Contains("microsoft.aspnetcore.cryptography.internal", dependencies.UsedPackages);
            Assert.Contains("humanizer.core", dependencies.UsedPackages);
        }

        [Fact]
        public void TestAssets2()
        {
            // Setup
            var assets = new Assets(new ProgressMonitor(new LoggerStub()));
            var json = assetsJson2;
            var dependencies = new DependencyContainer();

            // Execute
            var success = assets.TryParse(json, dependencies);

            // Verify
            Assert.True(success);
            Assert.Equal(2, dependencies.RequiredPaths.Count());

            var normalizedPaths = dependencies.RequiredPaths.Select(FixExpectedPathOnWindows);
            // Required references
            Assert.Contains("microsoft.netframework.referenceassemblies/1.0.3", normalizedPaths);
            Assert.Contains("microsoft.netframework.referenceassemblies.net48/1.0.3", normalizedPaths);
            // Used packages
            Assert.Contains("microsoft.netframework.referenceassemblies", dependencies.UsedPackages);
            Assert.Contains("microsoft.netframework.referenceassemblies.net48", dependencies.UsedPackages);
        }

        [Fact]
        public void TestAssets3()
        {
            // Setup
            var assets = new Assets(new ProgressMonitor(new LoggerStub()));
            var json = "garbage data";
            var dependencies = new DependencyContainer();

            // Execute
            var success = assets.TryParse(json, dependencies);

            // Verify
            Assert.False(success);
            Assert.Empty(dependencies.RequiredPaths);
        }

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

        private readonly string assetsJson2 = """
{
    "version": 3,
    "targets": {
        ".NETFramework,Version=v4.8": {
            "Microsoft.NETFramework.ReferenceAssemblies/1.0.3": {
                "type": "package",
                "dependencies": {
                    "Microsoft.NETFramework.ReferenceAssemblies.net48": "1.0.3"
                }
            },
            "Microsoft.NETFramework.ReferenceAssemblies.net48/1.0.3": {
                "type": "package",
                "build": {
                    "build/Microsoft.NETFramework.ReferenceAssemblies.net48.targets": {}
                }
            }
        }
    }
}
""";
    }
}
