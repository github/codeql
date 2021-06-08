/**
 * @name Defining a class that inherits or has a property derived from the obsolete DataSet or DataTable types
 * @description Defining a class that inherits or has a property derived from the obsolete DataSet or DataTable types may lead to the usage of dangerous functionality. Please visit https://go.microsoft.com/fwlink/?linkid=2132227 for details.
 * @kind problem
 * @problem.severity warning
 * @id cs/dataset-serialization/defining-dataset-related-type
 * @tags security
 */

import csharp
import DataSetSerialization

from DataSetOrTableRelatedClass dstc
where dstc.fromSource()
select dstc,
  "Defining a class that inherits or has a property derived from the obsolete DataSet or DataTable types. Please visit https://go.microsoft.com/fwlink/?linkid=2132227 for details."
