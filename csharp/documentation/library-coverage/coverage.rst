C# framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total),`CWE-079` :sub:`Cross-site scripting`
   `ServiceStack <https://servicestack.net/>`_,"``ServiceStack.*``, ``ServiceStack``",,7,194,
   System,"``System.*``, ``System``",44,10614,60,9
   Others,"``Amazon.Lambda.APIGatewayEvents``, ``Amazon.Lambda.Core``, ``Dapper``, ``ILCompiler``, ``ILLink.RoslynAnalyzer``, ``ILLink.Shared``, ``ILLink.Tasks``, ``Internal.IL``, ``Internal.Pgo``, ``Internal.TypeSystem``, ``JsonToItemsTaskFactory``, ``Microsoft.Android.Build``, ``Microsoft.Apple.Build``, ``Microsoft.ApplicationBlocks.Data``, ``Microsoft.CSharp``, ``Microsoft.Diagnostics.Tools.Pgo``, ``Microsoft.DotNet.Build.Tasks``, ``Microsoft.EntityFrameworkCore``, ``Microsoft.Extensions.Caching.Distributed``, ``Microsoft.Extensions.Caching.Memory``, ``Microsoft.Extensions.Configuration``, ``Microsoft.Extensions.DependencyInjection``, ``Microsoft.Extensions.DependencyModel``, ``Microsoft.Extensions.Diagnostics.Metrics``, ``Microsoft.Extensions.FileProviders``, ``Microsoft.Extensions.FileSystemGlobbing``, ``Microsoft.Extensions.Hosting``, ``Microsoft.Extensions.Http``, ``Microsoft.Extensions.Logging``, ``Microsoft.Extensions.Options``, ``Microsoft.Extensions.Primitives``, ``Microsoft.Interop``, ``Microsoft.NET.Build.Tasks``, ``Microsoft.NET.WebAssembly.Webcil``, ``Microsoft.VisualBasic``, ``Microsoft.WebAssembly.Build.Tasks``, ``Microsoft.Win32``, ``Mono.Linker``, ``MySql.Data.MySqlClient``, ``Newtonsoft.Json``, ``SourceGenerators``, ``Windows.Security.Cryptography.Core``",54,1821,148,
   Totals,,98,12442,402,9

