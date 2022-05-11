C# framework & library support
================================

.. csv-table::
   :header-rows: 1
   :class: fullWidthTable
   :widths: auto

   Framework / library,Package,Flow sources,Taint & value steps,Sinks (total),`CWE-079` :sub:`Cross-site scripting`
   `ServiceStack <https://servicestack.net/>`_,"``ServiceStack.*``, ``ServiceStack``",,7,194,
   System,"``System.*``, ``System``",3,2336,28,5
   Others,"``Dapper``, ``Microsoft.ApplicationBlocks.Data``, ``Microsoft.Extensions.Primitives``, ``Microsoft.VisualBasic``, ``MySql.Data.MySqlClient``, ``Newtonsoft.Json``",,149,131,
   Totals,,3,2492,353,5

