function ordinaryPhiLocalFlow(condition, otherCondition) {
  let value;
  if (condition) {
    value = SOURCE("ordinary-phi");
  } else {
    value = {};
  }
  if (otherCondition) {
    SINK(value); // $ localFlow=ordinary-phi
  } else {
    use(value);
  }
}

function postUpdateOrdering(value) {
  SINK(value); // $ noPostUpdateFlow=post-update
  value.property = SOURCE("post-update");
  SINK(value); // $ SPURIOUS: noPostUpdateFlow=post-update MISSING: postUpdateFlow=post-update
}

function assignmentUpdateCompletion(value) {
  value.property = SOURCE("store-completion", SINK(value)); // $ noPostUpdateFlow=store-completion SPURIOUS: globalPostUpdateFlow=store-completion MISSING: noGlobalPostUpdateFlow=store-completion
  SINK(value); // $ globalPostUpdateFlow=store-completion SPURIOUS: noPostUpdateFlow=store-completion MISSING: postUpdateFlow=store-completion
}

function compoundAssignmentUpdateCompletion(value) {
  value.property += SOURCE("compound-store-completion", SINK(value)); // $ noPostUpdateFlow=compound-store-completion SPURIOUS: globalPostUpdateFlow=compound-store-completion MISSING: noGlobalPostUpdateFlow=compound-store-completion
  SINK(value); // $ globalPostUpdateFlow=compound-store-completion SPURIOUS: noPostUpdateFlow=compound-store-completion MISSING: postUpdateFlow=compound-store-completion
}

function callUpdateCompletion(value) {
  UPDATE("call-completion", value, SINK(value)); // $ noPostUpdateFlow=call-completion SPURIOUS: globalPostUpdateFlow=call-completion MISSING: noGlobalPostUpdateFlow=call-completion
  SINK(value); // $ globalPostUpdateFlow=call-completion SPURIOUS: noPostUpdateFlow=call-completion MISSING: postUpdateFlow=call-completion
}

function methodCallUpdateCompletion(value) {
  value.update("method-completion", SINK(value)); // $ noPostUpdateFlow=method-completion SPURIOUS: globalPostUpdateFlow=method-completion MISSING: noGlobalPostUpdateFlow=method-completion
  SINK(value); // $ globalPostUpdateFlow=method-completion SPURIOUS: noPostUpdateFlow=method-completion MISSING: postUpdateFlow=method-completion
}

function overwrittenMethodReceiver(value) {
  value.update("overwritten-method-receiver", value = {});
  SINK(value); // $ noPostUpdateFlow=overwritten-method-receiver noGlobalPostUpdateFlow=overwritten-method-receiver
}

function nestedCallUpdateCompletion(value) {
  use(UPDATE("nested-call-completion", value), SINK(value)); // $ globalPostUpdateFlow=nested-call-completion SPURIOUS: noPostUpdateFlow=nested-call-completion MISSING: postUpdateFlow=nested-call-completion
}

function overwrittenCallArgument(value) {
  UPDATE("overwritten-call-argument", value, value = {});
  SINK(value); // $ noPostUpdateFlow=overwritten-call-argument noGlobalPostUpdateFlow=overwritten-call-argument
}

function selfAssignedCallUpdate(value) {
  UPDATE("self-assigned-call-update", value, value = value);
  SINK(value); // $ globalPostUpdateFlow=self-assigned-call-update SPURIOUS: noPostUpdateFlow=self-assigned-call-update MISSING: postUpdateFlow=self-assigned-call-update
}

function selfAssignedStoreUpdate(value) {
  value.property = (value = value, SOURCE("self-assigned-store-update"));
  SINK(value); // $ globalPostUpdateFlow=self-assigned-store-update SPURIOUS: noPostUpdateFlow=self-assigned-store-update MISSING: postUpdateFlow=self-assigned-store-update
}

function conditionalCallUpdate(value, condition) {
  UPDATE("conditional-call-update", value, value = condition ? value : {});
  SINK(value); // $ globalPostUpdateFlow=conditional-call-update SPURIOUS: noPostUpdateFlow=conditional-call-update MISSING: postUpdateFlow=conditional-call-update
}

function unusedOverwrittenCallArgument(value) {
  UPDATE("unused-overwritten-call-argument", value, value = {});
}

function refinedCallArgument(value) {
  UPDATE("refined-call-argument", value, typeof value === "object" ? 1 : 2);
  SINK(value); // $ globalPostUpdateFlow=refined-call-argument SPURIOUS: noPostUpdateFlow=refined-call-argument MISSING: postUpdateFlow=refined-call-argument
}

function branchingCallArgument(value, condition) {
  UPDATE("branching-call-argument", value, condition ? 1 : 2);
  SINK(value); // $ globalPostUpdateFlow=branching-call-argument SPURIOUS: noPostUpdateFlow=branching-call-argument MISSING: postUpdateFlow=branching-call-argument
}

function duplicateCallArguments(value) {
  DUPLICATE_UPDATE("dup-first", "dup-second", value, 0, value);
  SINK(value); // $ globalPostUpdateFlow=dup-first globalPostUpdateFlow=dup-second SPURIOUS: noPostUpdateFlow=dup-first noPostUpdateFlow=dup-second MISSING: postUpdateFlow=dup-first postUpdateFlow=dup-second
}

function partiallyOverwrittenDuplicateCallArguments(value) {
  DUPLICATE_UPDATE("overwritten-first", "preserved-second", value, value = {}, value);
  SINK(value); // $ noPostUpdateFlow=overwritten-first noGlobalPostUpdateFlow=overwritten-first globalPostUpdateFlow=preserved-second SPURIOUS: noPostUpdateFlow=preserved-second MISSING: postUpdateFlow=preserved-second
}

function computedStoreCompletion(value) {
  value[
    SINK(value) // $ noPostUpdateFlow=computed-store-completion SPURIOUS: globalPostUpdateFlow=computed-store-completion MISSING: noGlobalPostUpdateFlow=computed-store-completion
  ] = SOURCE(
    "computed-store-completion",
    SINK(value) // $ noPostUpdateFlow=computed-store-completion SPURIOUS: globalPostUpdateFlow=computed-store-completion MISSING: noGlobalPostUpdateFlow=computed-store-completion
  );
  SINK(value); // $ globalPostUpdateFlow=computed-store-completion SPURIOUS: noPostUpdateFlow=computed-store-completion MISSING: postUpdateFlow=computed-store-completion
}

function destructuringStoreCompletion(value) {
  [value.first, value[SINK(value)]] = SOURCE("destructuring-store-completion"); // $ globalPostUpdateFlow=destructuring-store-completion SPURIOUS: noPostUpdateFlow=destructuring-store-completion MISSING: postUpdateFlow=destructuring-store-completion
  SINK(value); // $ globalPostUpdateFlow=destructuring-store-completion SPURIOUS: noPostUpdateFlow=destructuring-store-completion MISSING: postUpdateFlow=destructuring-store-completion
}

function exceptionalCallUpdate(value) {
  try {
    UPDATE("exceptional-call-completion", value);
  } catch (error) {
    SINK(value); // $ globalPostUpdateFlow=exceptional-call-completion SPURIOUS: noPostUpdateFlow=exceptional-call-completion MISSING: postUpdateFlow=exceptional-call-completion
  }
  SINK(value); // $ globalPostUpdateFlow=exceptional-call-completion SPURIOUS: noPostUpdateFlow=exceptional-call-completion MISSING: postUpdateFlow=exceptional-call-completion
}

function loopUpdateCompletion(value) {
  while (condition()) {
    SINK(value); // $ globalPostUpdateFlow=loop-completion SPURIOUS: noPostUpdateFlow=loop-completion MISSING: postUpdateFlow=loop-completion
    UPDATE("loop-completion", value);
    SINK(value); // $ globalPostUpdateFlow=loop-completion SPURIOUS: noPostUpdateFlow=loop-completion MISSING: postUpdateFlow=loop-completion
  }
}

function reflectiveReadInference() {
  const value = () => 42;
  CHECK_TYPE(value); // $ noReflectiveValue
  with ({}) {
    CHECK_TYPE(value); // $ reflectiveValue
  }
  CHECK_TYPE(value); // $ noReflectiveValue
}

function nestedRefinementPostUpdate(value) {
  if (value) {
    if (typeof value === "object") {
      value.property = SOURCE("nested-post-update");
      SINK(value); // $ SPURIOUS: noPostUpdateFlow=nested-post-update MISSING: postUpdateFlow=nested-post-update
    }
  }
}

function refinedPostUpdateReads(value) {
  if (value) {
    SINK(value); // $ noPostUpdateFlow=refined-post-update
    value.property = SOURCE("refined-post-update");
    use(value);
    SINK(value); // $ SPURIOUS: noPostUpdateFlow=refined-post-update MISSING: postUpdateFlow=refined-post-update
  }
}

function compatibilityPhiPostUpdateReads(value) {
  if (typeof value === "object" || typeof value === "function") {
    SINK(value); // $ noPostUpdateFlow=compatibility-phi-post-update
    value.property = SOURCE("compatibility-phi-post-update");
    use(value);
    SINK(value); // $ SPURIOUS: noPostUpdateFlow=compatibility-phi-post-update MISSING: postUpdateFlow=compatibility-phi-post-update
  }
}

function postUpdateBeforeNestedRefinement(value) {
  if (value) {
    value.property = SOURCE("update-before-refinement");
    if (typeof value === "object") {
      SINK(value); // $ SPURIOUS: noPostUpdateFlow=update-before-refinement MISSING: postUpdateFlow=update-before-refinement
    }
  }
}

function postUpdateBeforeCompatibilityPhi(value) {
  if (value) {
    value.property = SOURCE("update-before-phi");
    use(value);
  }
  SINK(value); // $ SPURIOUS: noPostUpdateFlow=update-before-phi MISSING: postUpdateFlow=update-before-phi
}

function postUpdateImmediatePredecessor(value) {
  value.property = SOURCE("update-immediate-predecessor");
  SINK(value); // $ noImmediatePostUpdate=update-immediate-predecessor SPURIOUS: noPostUpdateFlow=update-immediate-predecessor MISSING: postUpdateFlow=update-immediate-predecessor
}

function capturedRefinementLocalFlow() {
  const value = SOURCE("captured-refinement");
  function capture() {
    use(value);
  }
  if (value) {
    if (typeof value === "object") {
      SINK(value); // $ localFlow=captured-refinement
    }
  }
}

function parameterReadBeforeDeclaration(first = second, second = SOURCE("later-parameter")) {
  SINK(first);
  SINK(second); // $ localFlow=later-parameter
}

function unreachableLocalSsaCode() {
  const liveBeforeReturn = "safe";
  return liveBeforeReturn;
  const deadLocal = "dead";
  use(deadLocal);
  use(liveBeforeReturn);
}

class SharedSsaBase {}

class SharedSsaDerived extends SharedSsaBase {
  field = this.condition ? 1 : 2; // $ SPURIOUS: fieldReadContainerMismatch

  constructor(condition) {
    if (condition) {
      super(); // $ noSuperFlow noThisSelfFlow
    } else {
      super(); // $ noSuperFlow noThisSelfFlow
    }
    use(this);
  }
}
