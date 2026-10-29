import javascript
import semmle.javascript.dataflow.internal.DataFlowNode
import semmle.javascript.dataflow.internal.sharedlib.Ssa as Ssa2
import utils.test.InlineExpectationsTest

private DataFlow::PostUpdateNode postUpdateForSource(string value) {
  exists(Assignment assignment, PropAccess property, DataFlow::InvokeNode source |
    (
      assignment.getTarget() = property
      or
      assignment.getTarget().(ArrayPattern).getElement(0) = property
    ) and
    assignment.getRhs().getUnderlyingValue() = source.asExpr() and
    source.getCalleeName() = "SOURCE" and
    source.getArgument(0).getStringValue() = value and
    result.getPreUpdateNode() = DataFlow::valueNode(property.getBase())
  )
  or
  exists(DataFlow::InvokeNode call |
    call.getCalleeName() = "UPDATE" and
    call.getArgument(0).getStringValue() = value and
    result.getPreUpdateNode() = call.getArgument(1)
  )
}

module PostUpdateConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source = postUpdateForSource(_) }

  predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::InvokeNode call | call.getCalleeName() = "SINK").getArgument(0)
  }
}

module PostUpdateFlow = DataFlow::Global<PostUpdateConfig>;

module InlineTest implements TestSig {
  string getARelevantTag() {
    result =
      [
        "localFlow", "postUpdateFlow", "noPostUpdateFlow", "noImmediatePostUpdate", "noSuperFlow",
        "noThisSelfFlow", "superPostUpdateToThisFlow", "fieldReadContainerMismatch",
        "globalPostUpdateFlow", "noGlobalPostUpdateFlow", "reflectiveValue", "noReflectiveValue"
      ]
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    element = "" and
    location.getFile().getBaseName() = "local.js" and
    (
      tag = "localFlow" and
      exists(DataFlow::InvokeNode source, DataFlow::InvokeNode sink |
        source.getCalleeName() = "SOURCE" and
        value = source.getArgument(0).getStringValue() and
        sink.getCalleeName() = "SINK" and
        source.getContainer() = sink.getContainer() and
        source.flowsTo(sink.getArgument(0)) and
        location = sink.getLocation()
      )
      or
      tag = "postUpdateFlow" and
      exists(DataFlow::InvokeNode sink, DataFlow::PostUpdateNode update |
        sink.getCalleeName() = "SINK" and
        update = postUpdateForSource(value) and
        update.getContainer() = sink.getContainer() and
        update.getASuccessor+() = sink.getArgument(0) and
        location = sink.getLocation()
      )
      or
      tag = "noPostUpdateFlow" and
      exists(DataFlow::InvokeNode sink, DataFlow::PostUpdateNode update |
        sink.getCalleeName() = "SINK" and
        update = postUpdateForSource(value) and
        update.getContainer() = sink.getContainer() and
        not update.getASuccessor+() = sink.getArgument(0) and
        location = sink.getLocation()
      )
      or
      exists(DataFlow::InvokeNode sink, DataFlow::PostUpdateNode update |
        value =
          [
            "store-completion", "call-completion", "nested-call-completion",
            "overwritten-call-argument", "loop-completion", "refined-call-argument",
            "computed-store-completion", "exceptional-call-completion",
            "destructuring-store-completion", "self-assigned-call-update",
            "self-assigned-store-update", "conditional-call-update"
          ] and
        sink.getCalleeName() = "SINK" and
        update = postUpdateForSource(value) and
        update.getContainer() = sink.getContainer() and
        location = sink.getLocation() and
        (
          tag = "globalPostUpdateFlow" and PostUpdateFlow::flow(update, sink.getArgument(0))
          or
          tag = "noGlobalPostUpdateFlow" and not PostUpdateFlow::flow(update, sink.getArgument(0))
        )
      )
      or
      exists(DataFlow::InvokeNode call |
        call.getCalleeName() = "CHECK_TYPE" and
        location = call.getLocation() and
        value = "" and
        (
          tag = "reflectiveValue" and
          call.getArgument(0).analyze().getALocalValue().isIndefinite("eval")
          or
          tag = "noReflectiveValue" and
          not call.getArgument(0).analyze().getALocalValue().isIndefinite("eval")
        )
      )
      or
      tag = "noImmediatePostUpdate" and
      value = "update-immediate-predecessor" and
      exists(DataFlow::InvokeNode sink, DataFlow::PostUpdateNode update |
        sink.getCalleeName() = "SINK" and
        update = postUpdateForSource(value) and
        update.getContainer() = sink.getContainer() and
        not sink.getArgument(0).getImmediatePredecessor() = update and
        location = sink.getLocation()
      )
      or
      tag = "noSuperFlow" and
      value = "" and
      exists(SuperCall call, Function constructor |
        constructor = call.getEnclosingFunction() and
        not DataFlow::thisNode(constructor).flowsTo(DataFlow::valueNode(call.getCallee())) and
        location = call.getLocation()
      )
      or
      tag = "noThisSelfFlow" and
      value = "" and
      exists(SuperCall call, Function constructor, DataFlow::ThisNode thisNode |
        constructor = call.getEnclosingFunction() and
        thisNode = DataFlow::thisNode(constructor) and
        not thisNode.getASuccessor() = thisNode and
        location = call.getLocation()
      )
      or
      tag = "superPostUpdateToThisFlow" and
      value = "" and
      exists(SuperCall call, Function constructor, ThisExpr thiz |
        constructor = call.getEnclosingFunction() and
        thiz.getBinder() = constructor and
        DataFlow::valueNode(call.getCallee()).getPostUpdateNode().getASuccessor+() =
          DataFlow::valueNode(thiz) and
        location = call.getLocation()
      )
      or
      tag = "fieldReadContainerMismatch" and
      value = "" and
      exists(FieldDefinition field, Ssa2::ExprNode read, DataFlow::Node node |
        read.getExpr() = field and
        node = TSsaUseNode(read.getExpr()) and
        node.getContainer() != field.getDeclaringClass().getConstructor().getBody() and
        location = field.getLocation()
      )
    )
  }
}

import MakeTest<InlineTest>
