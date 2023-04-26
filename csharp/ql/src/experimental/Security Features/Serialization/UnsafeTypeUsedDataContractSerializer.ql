/**
 * @name Unsafe type is used in data contract serializer
 * @description Unsafe type is used in data contract serializer. Please visit https://go.microsoft.com/fwlink/?linkid=2132227 for details."
 * @kind problem
 * @problem.severity error
 * @precision medium
 * @id cs/dataset-serialization/unsafe-type-used-data-contract-serializer
 * @tags security
 *       experimental
 */

import csharp
import DataSetSerialization

predicate xmlSerializerConstructorArgument(Expr e) {
  exists(ObjectCreation oc, Constructor c | e = oc.getArgument(0) |
    c = oc.getTarget() and
    c.getDeclaringType()
        .getABaseType*()
        .hasQualifiedName("System.Xml.Serialization", "XmlSerializer")
  )
}

predicate unsafeDataContractTypeCreation(Expr e) {
  exists(MethodCall gt |
    gt.getTarget().getName() = "GetType" and
    e = gt and
    gt.getQualifier().getType() instanceof DataSetOrTableRelatedClass
  )
  or
  e.(TypeofExpr).getTypeAccess().getTarget() instanceof DataSetOrTableRelatedClass
}

module FlowToDataSerializerConstructorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { unsafeDataContractTypeCreation(node.asExpr()) }

  predicate isSink(DataFlow::Node node) { xmlSerializerConstructorArgument(node.asExpr()) }
}

module FlowToDataSerializerConstructor = DataFlow::Global<FlowToDataSerializerConstructorConfig>;

from DataFlow::Node source, DataFlow::Node sink
where FlowToDataSerializerConstructor::flow(source, sink)
select sink,
  "Unsafe type is used in data contract serializer. Make sure $@ comes from the trusted source.",
  source, source.toString()
