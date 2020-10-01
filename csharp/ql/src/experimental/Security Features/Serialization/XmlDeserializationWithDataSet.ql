/**
 * @name XML deserialization with a type type derived from DataSet or DataTable
 * @description Making an XML deserialization call with a type derived from DataSet or DataTable types and may lead to a security problem. Please visit https://go.microsoft.com/fwlink/?linkid=2132227 for details."
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/dataset-serialization/xml-deserialization-with-dataset
 * @tags security
 */

import csharp
import DataSetSerialization

from UnsafeXmlReadMethodCall mc
select mc,
  "Making an XML deserialization call with a type derived from DataSet or DataTable types and may lead to a security problem. Please visit https://go.microsoft.com/fwlink/?linkid=2132227 for details."
