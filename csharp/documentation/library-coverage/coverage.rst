C# framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total),`CWE-079` :sub:`Cross-site scripting`
   `ServiceStack <https://servicestack.net/>`_,"``ServiceStack.*``, ``ServiceStack``",,7,194,
   System,"``System.*``, ``System``",47,12111,54,5
   Others,"``Amazon.Lambda.APIGatewayEvents``, ``Amazon.Lambda.Core``, ``Dapper``, ``ILCompiler``, ``ILLink.RoslynAnalyzer``, ``ILLink.Shared``, ``ILLink.Tasks``, ``Internal.IL``, ``Internal.Pgo``, ``Internal.TypeSystem``, ``Microsoft.ApplicationBlocks.Data``, ``Microsoft.AspNetCore.Components``, ``Microsoft.AspNetCore.Http``, ``Microsoft.AspNetCore.Mvc``, ``Microsoft.AspNetCore.WebUtilities``, ``Microsoft.CSharp``, ``Microsoft.Diagnostics.Tools.Pgo``, ``Microsoft.DotNet.Build.Tasks``, ``Microsoft.DotNet.PlatformAbstractions``, ``Microsoft.EntityFrameworkCore``, ``Microsoft.Extensions.Caching.Distributed``, ``Microsoft.Extensions.Caching.Memory``, ``Microsoft.Extensions.Configuration``, ``Microsoft.Extensions.DependencyInjection``, ``Microsoft.Extensions.DependencyModel``, ``Microsoft.Extensions.Diagnostics.Metrics``, ``Microsoft.Extensions.FileProviders``, ``Microsoft.Extensions.FileSystemGlobbing``, ``Microsoft.Extensions.Hosting``, ``Microsoft.Extensions.Http``, ``Microsoft.Extensions.Logging``, ``Microsoft.Extensions.Options``, ``Microsoft.Extensions.Primitives``, ``Microsoft.Interop``, ``Microsoft.JSInterop``, ``Microsoft.NET.Build.Tasks``, ``Microsoft.VisualBasic``, ``Microsoft.Win32``, ``Mono.Linker``, ``MySql.Data.MySqlClient``, ``Newtonsoft.Json``, ``SourceGenerators``, ``Windows.Security.Cryptography.Core``",60,2252,152,4
   Totals,,107,14370,400,9

