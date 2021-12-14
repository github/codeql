/**
 * @name Defining a potentially unsafe XML serializer
 * @description Defining an XML serializable class that includes members that derive from DataSet or DataTable type may lead to a security problem. Please visit https://go.microsoft.com/fwlink/?linkid=2132227 for details.
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/dataset-serialization/defining-potentially-unsafe-xml-serializer
 * @tags security
 */

import csharp
import DataSetSerialization

from UnsafeXmlSerializerImplementation c, Member m
where
  c.fromSource() and
  isClassUnsafeXmlSerializerImplementation(c, m)
select m,
  "Defining an serializable class $@ that has member $@ of a type that is derived from DataSet or DataTable types and may lead to a security problem. Please visit https://go.microsoft.com/fwlink/?linkid=2132227 for details.",
  c, c.toString(), m, m.toString()
