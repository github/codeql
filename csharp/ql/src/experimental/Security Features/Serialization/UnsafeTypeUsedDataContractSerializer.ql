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
deprecated import DataSetSerialization

predicate xmlSerializerConstructorArgument(Expr e) {
  exists(ObjectCreation oc, Constructor c | e = oc.getArgument(0) |
    c = oc.getTarget() and
    c.getDeclaringType()
        .getABaseType*()
        .hasFullyQualifiedName("System.Xml.Serialization", "XmlSerializer")
  )
}

deprecated predicate unsafeDataContractTypeCreation(Expr e) {
  exists(MethodCall gt |
    gt.getTarget().getName() = "GetType" and
    e = gt and
    gt.getQualifier().getType() instanceof DataSetOrTableRelatedClass
  )
  or
  e.(TypeofExpr).getTypeAccess().getTarget() instanceof DataSetOrTableRelatedClass
}

deprecated module FlowToDataSerializerConstructorConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { unsafeDataContractTypeCreation(node.asExpr()) }

  predicate isSink(DataFlow::Node node) { xmlSerializerConstructorArgument(node.asExpr()) }
}

deprecated module FlowToDataSerializerConstructor =
  DataFlow::Global<FlowToDataSerializerConstructorConfig>;

deprecated query predicate problems(
  DataFlow::Node sink, string message, DataFlow::Node source, string sourceMessage
) {
  FlowToDataSerializerConstructor::flow(source, sink) and
  message =
    "Unsafe type is used in data contract serializer. Make sure $@ comes from the trusted source." and
  sourceMessage = source.toString()
}
