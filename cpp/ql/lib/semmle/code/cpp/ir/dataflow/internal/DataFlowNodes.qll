private import cpp

cached
private module Cached {
  cached
  newtype TContent =
    TNonUnionContent(CanonicalField f, int indirectionIndex) {
      // the indirection index for field content starts at 1 (because `TNonUnionContent` is thought of as
      // the address of the field, `FieldAddress` in the IR).
      indirectionIndex = [1 .. max(SsaImpl::getMaxIndirectionsForType(f.getAnUnspecifiedType()))] and
      // Reads and writes of union fields are tracked using `UnionContent`.
      not f.getDeclaringType() instanceof Union
    } or
    TUnionContent(CanonicalUnion u, int bytes, int indirectionIndex) {
      exists(CanonicalField f |
        f = u.getACanonicalField() and
        bytes = getFieldSize(f) and
        // We key `UnionContent` by the union instead of its fields since a write to one
        // field can be read by any read of the union's fields. Again, the indirection index
        // is 1-based (because 0 is considered the address).
        indirectionIndex =
          [1 .. max(SsaImpl::getMaxIndirectionsForType(getAFieldWithSize(u, bytes)
                      .getAnUnspecifiedType())
            )]
      )
    } or
    TElementContent(int indirectionIndex) {
      indirectionIndex = [1 .. getMaxElementContentIndirectionIndex()]
    }

  /**
   * The IR dataflow graph consists of the following nodes:
   * - `Node0`, which injects most instructions and operands directly into the
   *    dataflow graph.
   * - `VariableNode`, which is used to model flow through global variables.
   * - `PostUpdateNodeImpl`, which is used to model the state of an object after
   *    an update after a number of loads.
   * - `SsaSynthNode`, which represents synthesized nodes as computed by the shared SSA
   *    library.
   * - `RawIndirectOperand`, which represents the value of `operand` after
   *    loading the address a number of times.
   * - `RawIndirectInstruction`, which represents the value of `instr` after
   *    loading the address a number of times.
   */
  cached
  newtype TIRDataFlowNode =
    TNode0(Node0Impl node) { DataFlowImplCommon::forceCachingInSameStage() } or
    TGlobalLikeVariableNode(GlobalLikeVariable var, int indirectionIndex) {
      indirectionIndex =
        [getMinIndirectionsForType(var.getUnspecifiedType()) .. SsaImpl::getMaxIndirectionsForType(var.getUnspecifiedType())]
    } or
    TPostUpdateNodeImpl(Operand operand, int indirectionIndex) {
      isPostUpdateNodeImpl(operand, indirectionIndex)
    } or
    TSsaSynthNode(SsaImpl::SynthNode n) or
    TSsaIteratorNode(IteratorFlow::IteratorFlowNode n) or
    TRawIndirectOperand0(Node0Impl node, int indirectionIndex) {
      SsaImpl::hasRawIndirectOperand(node.asOperand(), indirectionIndex)
    } or
    TRawIndirectInstruction0(Node0Impl node, int indirectionIndex) {
      not exists(node.asOperand()) and
      SsaImpl::hasRawIndirectInstruction(node.asInstruction(), indirectionIndex)
    } or
    TFinalParameterNode(Parameter p, int indirectionIndex) {
      exists(SsaImpl::FinalParameterUse use |
        use.getParameter() = p and
        use.getIndirectionIndex() = indirectionIndex
      )
    } or
    TFinalGlobalValue(SsaImpl::GlobalUse globalUse) or
    TInitialGlobalValue(SsaImpl::GlobalDef globalUse) or
    TBodyLessParameterNodeImpl(Parameter p, int indirectionIndex) {
      // Rule out parameters of catch blocks.
      not exists(p.getCatchBlock()) and
      // We subtract one because `getMaxIndirectionsForType` returns the maximum
      // indirection for a glvalue of a given type, and this doesn't apply to
      // parameters.
      indirectionIndex = [0 .. SsaImpl::getMaxIndirectionsForType(p.getUnspecifiedType()) - 1] and
      not any(InitializeParameterInstruction init).getParameter() = p
    } or
    TFlowSummaryNode(FlowSummaryImpl::Private::SummaryNode sn)
}

import Cached

module Public {

}

private import Public
