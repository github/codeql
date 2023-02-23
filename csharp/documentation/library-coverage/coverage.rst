C# framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total),`CWE-079` :sub:`Cross-site scripting`
   `ServiceStack <https://servicestack.net/>`_,"``ServiceStack.*``, ``ServiceStack``",,7,194,
   System,"``System.*``, ``System``",8,12154,65,7
   Others,"``Dapper``, ``JsonToItemsTaskFactory``, ``Microsoft.ApplicationBlocks.Data``, ``Microsoft.CSharp``, ``Microsoft.EntityFrameworkCore``, ``Microsoft.Extensions.Caching.Distributed``, ``Microsoft.Extensions.Caching.Memory``, ``Microsoft.Extensions.Configuration``, ``Microsoft.Extensions.DependencyInjection``, ``Microsoft.Extensions.DependencyModel``, ``Microsoft.Extensions.FileProviders``, ``Microsoft.Extensions.FileSystemGlobbing``, ``Microsoft.Extensions.Hosting``, ``Microsoft.Extensions.Http``, ``Microsoft.Extensions.Logging``, ``Microsoft.Extensions.Options``, ``Microsoft.Extensions.Primitives``, ``Microsoft.Interop``, ``Microsoft.NET.Build.Tasks``, ``Microsoft.NETCore.Platforms.BuildTasks``, ``Microsoft.VisualBasic``, ``Microsoft.Win32``, ``MySql.Data.MySqlClient``, ``Newtonsoft.Json``, ``Windows.Security.Cryptography.Core``",,556,138,
   Totals,,8,12717,397,7

