function refinementBarrier() {
  const refinementBarrierSource = SOURCE("refinement-barrier");
  if (!refinementBarrierSource) {
    SINK(refinementBarrierSource); // $ barrier=refinement-barrier noRefinementFlow=refinement-barrier noRefinementTaint=refinement-barrier localRefinementFlow=refinement-barrier noRefinementBypass=refinement-barrier
  }
}

function propertyGuardDoesNotSanitizeBase(key) {
  const object = SOURCE("guarded-property-base");
  if (!BARRIER(object[key])) return;
  SINK(object[key]); // $ noRefinementFlow=guarded-property-base noRefinementTaint=guarded-property-base
  SINK(object); // $ refinementFlow=guarded-property-base refinementTaint=guarded-property-base localRefinementFlow=guarded-property-base
  key = OTHER_KEY();
  SINK(object[key]); // $ noRefinementFlow=guarded-property-base refinementTaint=guarded-property-base
}

function phiReadInsideRefinement(condition) {
  const phiReadSource = SOURCE("refined-phi-read");
  if (phiReadSource) {
    if (condition) {
      if (!BARRIER(phiReadSource)) return;
    } else {
      if (!BARRIER(phiReadSource)) return;
    }
    SINK(phiReadSource); // $ noRefinementFlow=refined-phi-read noRefinementTaint=refined-phi-read localRefinementFlow=refined-phi-read noRefinementBypass=refined-phi-read
  }
}

function refinementFollowedByPhi(condition) {
  let refinementPhiSource = SOURCE("refinement-phi");
  if (!refinementPhiSource) {
    if (condition) {
      refinementPhiSource = "safe";
    }
    SINK(refinementPhiSource); // $ noRefinementFlow=refinement-phi noRefinementTaint=refinement-phi localRefinementFlow=refinement-phi noRefinementBypass=refinement-phi
  }
}

function equalityCompatibilityPhi() {
  const value = SOURCE("equality-phi");
  if (value === "a" || value === "b") {
    SINK(value); // $ refinementFlow=equality-phi noRefinementTaint=equality-phi localRefinementFlow=equality-phi noRefinementBypass=equality-phi
  }
}

function nestedCompatibilityPhi(condition) {
  const value = SOURCE("nested-equality-phi");
  if (value === "a" || value === "b") {
    if (condition) {
      use(value);
    } else {
      use(value);
    }
    SINK(value); // $ refinementFlow=nested-equality-phi noRefinementTaint=nested-equality-phi localRefinementFlow=nested-equality-phi noRefinementBypass=nested-equality-phi
  }
}

function unguardedWriteAfterTruthyTest(value) {
  if (value) {
    value = SOURCE("unguarded-shared-phi");
  }
  SINK(value); // $ refinementFlow=unguarded-shared-phi refinementTaint=unguarded-shared-phi localRefinementFlow=unguarded-shared-phi
}

function unguardedWriteInsideFalseRefinement(value, condition) {
  if (!value) {
    if (condition) {
      value = SOURCE("nested-shared-phi");
    }
    SINK(value); // $ refinementFlow=nested-shared-phi refinementTaint=nested-shared-phi localRefinementFlow=nested-shared-phi
  }
}

function transitiveSharedPhis(value, condition) {
  if (value) {
    value = SOURCE("first-shared-phi");
  }
  if (condition) {
    value = SOURCE("second-shared-phi");
  }
  SINK(value); // $ refinementFlow=first-shared-phi refinementTaint=first-shared-phi localRefinementFlow=first-shared-phi refinementFlow=second-shared-phi refinementTaint=second-shared-phi localRefinementFlow=second-shared-phi
}

function phiReadAfterSharedPhi(value, condition) {
  if (value) {
    value = SOURCE("shared-phi-then-read");
  }
  if (condition) {
    use(value);
  } else {
    use(value);
  }
  SINK(value); // $ refinementFlow=shared-phi-then-read refinementTaint=shared-phi-then-read localRefinementFlow=shared-phi-then-read
}

function filteredPhiInputWithReplacement(condition, otherCondition) {
  let value = SOURCE("filtered-phi-input");
  if (!value) {
    if (condition) {
      value = SOURCE("replacement-phi-input");
    }
    if (otherCondition) {
      SINK(value); // $ noRefinementFlow=filtered-phi-input noRefinementTaint=filtered-phi-input localRefinementFlow=filtered-phi-input noRefinementBypass=filtered-phi-input refinementFlow=replacement-phi-input refinementTaint=replacement-phi-input localRefinementFlow=replacement-phi-input
    } else {
      SINK(value); // $ noRefinementFlow=filtered-phi-input noRefinementTaint=filtered-phi-input localRefinementFlow=filtered-phi-input noRefinementBypass=filtered-phi-input refinementFlow=replacement-phi-input refinementTaint=replacement-phi-input localRefinementFlow=replacement-phi-input
    }
  }

  function emptyRefinementBranches() {
    const value = SOURCE("empty-refinement-branches");
    if (value) {}
    SINK(value); // $ refinementFlow=empty-refinement-branches refinementTaint=empty-refinement-branches localRefinementFlow=empty-refinement-branches noRefinementBypass=empty-refinement-branches
  }

  function nestedSingleReadPhis(firstCondition, secondCondition) {
    let value;
    if (firstCondition) {
      if (secondCondition) {
        value = SOURCE("nested-single-read-phis");
      } else {
        value = "safe";
      }
      otherOperation();
    } else {
      value = "safe";
    }
    SINK(value); // $ refinementFlow=nested-single-read-phis refinementTaint=nested-single-read-phis localRefinementFlow=nested-single-read-phis
  }

  function nestedMultipleReadPhis(firstCondition, secondCondition, thirdCondition) {
    let value;
    if (firstCondition) {
      if (secondCondition) {
        value = SOURCE("nested-multiple-read-phis");
      } else {
        value = "safe";
      }
      otherOperation();
    } else {
      value = "safe";
    }
    if (thirdCondition) {
      SINK(value); // $ refinementFlow=nested-multiple-read-phis refinementTaint=nested-multiple-read-phis localRefinementFlow=nested-multiple-read-phis
    } else {
      use(value);
    }
  }

  function refinementAfterGuardedJoin(condition) {
    const value = SOURCE("refinement-after-guarded-join");
    if (value) {
      if (condition) {
        if (!BARRIER(value)) return;
      } else {
        if (!BARRIER(value)) return;
      }
      if (typeof value === "object") {
        SINK(value); // $ localRefinementFlow=refinement-after-guarded-join noRefinementBypass=refinement-after-guarded-join noRefinementFlow=refinement-after-guarded-join noRefinementTaint=refinement-after-guarded-join
      }
    }
  }

  function conditionalReadInsideFalsyRefinement(condition) {
    const value = SOURCE("conditional-read-in-refinement");
    if (!value) {
      if (condition) {
        use(value);
      }
      SINK(value); // $ barrier=conditional-read-in-refinement noRefinementTaint=conditional-read-in-refinement localRefinementFlow=conditional-read-in-refinement noRefinementFlow=conditional-read-in-refinement noRefinementBypass=conditional-read-in-refinement
    }
  }

  function independentPhiInputRefinements(condition, otherCondition) {
    let value = SOURCE("independent-phi-inputs");
    if (condition) {
    } else if (value) {
      value = "safe";
    }
    if (otherCondition) {
      SINK(value); // $ localRefinementFlow=independent-phi-inputs refinementFlow=independent-phi-inputs refinementTaint=independent-phi-inputs
    } else {
      use(value);
    }
  }

  function occurrenceSpecificBarrier() {
    const value = SOURCE("occurrence-barrier");
    BLOCKED_SINK(value); // $ noRefinementFlow=occurrence-barrier noRefinementTaint=occurrence-barrier localRefinementFlow=occurrence-barrier
    SINK(value); // $ localRefinementFlow=occurrence-barrier refinementFlow=occurrence-barrier refinementTaint=occurrence-barrier
  }

  function guardedCallResultDoesNotValidateArgument() {
    const value = SOURCE("guarded-call-result");
    if (!BARRIER(transform(value))) return;
    SINK(value); // $ localRefinementFlow=guarded-call-result refinementFlow=guarded-call-result refinementTaint=guarded-call-result
  }

  function occurrenceSpecificBarriersBeforeJoin(condition) {
    const value = SOURCE("occurrence-barriers-before-join");
    if (condition) {
      BLOCKED_SINK(value); // $ noRefinementFlow=occurrence-barriers-before-join noRefinementTaint=occurrence-barriers-before-join localRefinementFlow=occurrence-barriers-before-join
    } else {
      BLOCKED_SINK(value); // $ noRefinementFlow=occurrence-barriers-before-join noRefinementTaint=occurrence-barriers-before-join localRefinementFlow=occurrence-barriers-before-join
    }
    SINK(value); // $ refinementFlow=occurrence-barriers-before-join refinementTaint=occurrence-barriers-before-join localRefinementFlow=occurrence-barriers-before-join
  }

  function readOccurrenceSourceDoesNotContaminateVariable() {
    const value = "safe";
    READ_SOURCE(value, "read-occurrence-source");
    SINK(value); // $ noRefinementFlow=read-occurrence-source noRefinementTaint=read-occurrence-source
  }

  function indirectBarrierGuardWithReadBeforeJoin() {
    let value = SOURCE("indirect-barrier-read-join");
    const ok = BARRIER(value);
    if (ok) {
      use(value);
    } else {
      value = "safe";
    }
    SINK(value); // $ localRefinementFlow=indirect-barrier-read-join noRefinementFlow=indirect-barrier-read-join noRefinementTaint=indirect-barrier-read-join
  }

  function indirectBarrierGuardEmptyBranchBeforeJoin() {
    let value = SOURCE("indirect-barrier-empty-join");
    const ok = BARRIER(value);
    if (ok) {
    } else {
      value = "safe";
    }
    SINK(value); // $ localRefinementFlow=indirect-barrier-empty-join noRefinementFlow=indirect-barrier-empty-join noRefinementTaint=indirect-barrier-empty-join
  }

  function indirectBarrierGuardAfterRefinementBeforeJoin() {
    let value = SOURCE("indirect-barrier-after-refinement-join");
    const ok = BARRIER(value);
    if (typeof value === "object") {
      if (ok) {
      } else {
        value = "safe";
      }
      SINK(value); // $ localRefinementFlow=indirect-barrier-after-refinement-join noRefinementBypass=indirect-barrier-after-refinement-join noRefinementFlow=indirect-barrier-after-refinement-join noRefinementTaint=indirect-barrier-after-refinement-join
    }
  }

  function barrierGuardInsideWithStatement(scopeObject) {
    let value = SOURCE("barrier-in-with");
    with (scopeObject) {
      if (BARRIER(value)) {
        use(value);
      } else {
        value = "safe";
      }
    }
    SINK(value); // $ localRefinementFlow=barrier-in-with noRefinementFlow=barrier-in-with noRefinementTaint=barrier-in-with
  }

  function mutatePreservedArgument(target, payload) {
    target.property = payload;
  }

  function selfAssignedArgument(value) {
    mutatePreservedArgument(value, SOURCE("self-assigned-argument"), value = value);
    SINK(value.property); // $ refinementFlow=self-assigned-argument refinementTaint=self-assigned-argument
  }

  function wrappedSelfAssignedArgument(value) {
    mutatePreservedArgument(value, (value = (use(), value), SOURCE("wrapped-self-assigned-argument")));
    SINK(value.property); // $ refinementFlow=wrapped-self-assigned-argument refinementTaint=wrapped-self-assigned-argument
  }

  function selfAssignedStore(value) {
    value.property = (value = value, SOURCE("self-assigned-store"));
    SINK(value.property); // $ refinementFlow=self-assigned-store refinementTaint=self-assigned-store
  }

  function copiedArgument(value) {
    const alias = value;
    mutatePreservedArgument(value, SOURCE("copied-argument"), value = alias);
    SINK(value.property); // $ refinementFlow=copied-argument refinementTaint=copied-argument
  }

  function conditionalArgumentCopy(value, condition) {
    mutatePreservedArgument(value, SOURCE("conditional-argument-copy"), value = condition ? value : {});
    SINK(value.property); // $ refinementFlow=conditional-argument-copy refinementTaint=conditional-argument-copy
  }

  function identicalBranchArgumentCopy(value, condition) {
    mutatePreservedArgument(value, SOURCE("identical-branch-copy"), value = condition ? value : value);
    SINK(value.property); // $ refinementFlow=identical-branch-copy refinementTaint=identical-branch-copy
  }

  function logicalDefaultArgument(value) {
    mutatePreservedArgument(value, SOURCE("logical-default-argument"), value = value || {});
    SINK(value.property); // $ refinementFlow=logical-default-argument refinementTaint=logical-default-argument
  }

  function nullishDefaultArgument(value) {
    mutatePreservedArgument(value, SOURCE("nullish-default-argument"), value = value ?? {});
    SINK(value.property); // $ refinementFlow=nullish-default-argument refinementTaint=nullish-default-argument
  }

  function logicalAndArgument(value, condition) {
    mutatePreservedArgument(value, SOURCE("logical-and-argument"), value = condition && value);
    SINK(value.property); // $ refinementFlow=logical-and-argument refinementTaint=logical-and-argument
  }

  function nestedBranchArgument(value, condition) {
    mutatePreservedArgument(value, SOURCE("nested-branch-argument"), value = condition ? (use(), value) : value ?? {});
    SINK(value.property); // $ refinementFlow=nested-branch-argument refinementTaint=nested-branch-argument
  }

  function conditionalAliasArgument(value, condition) {
    const alias = condition ? value : {};
    mutatePreservedArgument(value, SOURCE("conditional-alias-argument"), value = alias);
    SINK(value.property); // $ refinementFlow=conditional-alias-argument refinementTaint=conditional-alias-argument
  }

  function conditionalStoreCopy(value, condition) {
    value.property = (value = condition ? value : {}, SOURCE("conditional-store-copy"));
    SINK(value.property); // $ refinementFlow=conditional-store-copy refinementTaint=conditional-store-copy
  }

  function conditionalReplacement(value) {
    mutatePreservedArgument(value, SOURCE("conditional-replacement"), value = value ? {} : {});
    SINK(value.property); // $ noRefinementFlow=conditional-replacement noRefinementTaint=conditional-replacement
  }

  function discardedValueReplacement(value) {
    mutatePreservedArgument(value, SOURCE("discarded-value-replacement"), value = (value, {}));
    SINK(value.property); // $ noRefinementFlow=discarded-value-replacement noRefinementTaint=discarded-value-replacement
  }

  function identityPreservedArgument(value) {
    return value;
  }

  function replacementPreservedArgument(unused) {
    return {};
  }

  function arrayDestructuringArgumentCopy(value) {
    mutatePreservedArgument(value, SOURCE("array-destructuring-copy"), [value] = [value]);
    SINK(value.property); // $ refinementFlow=array-destructuring-copy refinementTaint=array-destructuring-copy
  }

  function objectDestructuringArgumentCopy(value) {
    mutatePreservedArgument(value, SOURCE("object-destructuring-copy"), { slot: value } = { slot: value });
    SINK(value.property); // $ refinementFlow=object-destructuring-copy refinementTaint=object-destructuring-copy
  }

  function objectLiteralArgumentCopy(value) {
    mutatePreservedArgument(value, SOURCE("object-literal-copy"), value = ({ slot: value }).slot);
    SINK(value.property); // $ refinementFlow=object-literal-copy refinementTaint=object-literal-copy
  }

  function arrayLiteralArgumentCopy(value) {
    mutatePreservedArgument(value, SOURCE("array-literal-copy"), value = [value][0]);
    SINK(value.property); // $ refinementFlow=array-literal-copy refinementTaint=array-literal-copy
  }

  function identityCallArgumentCopy(value) {
    mutatePreservedArgument(value, SOURCE("identity-call-copy"), value = identityPreservedArgument(value));
    SINK(value.property); // $ refinementFlow=identity-call-copy refinementTaint=identity-call-copy
  }

  function identityCopyUpdateTiming(value) {
    mutatePreservedArgument(
      value, SOURCE("identity-copy-timing"), value = identityPreservedArgument(value),
      SINK(value.property) // $ noRefinementFlow=identity-copy-timing noRefinementTaint=identity-copy-timing
    );
    SINK(value.property); // $ refinementFlow=identity-copy-timing refinementTaint=identity-copy-timing
  }

  function identityCallReplacement(value) {
    mutatePreservedArgument(value, SOURCE("identity-call-replacement"), value = replacementPreservedArgument(value));
    SINK(value.property); // $ noRefinementFlow=identity-call-replacement noRefinementTaint=identity-call-replacement
  }

  function destructuringArgumentReplacement(value) {
    mutatePreservedArgument(value, SOURCE("destructuring-argument-replacement"), [value] = [{}]);
    SINK(value.property); // $ noRefinementFlow=destructuring-argument-replacement noRefinementTaint=destructuring-argument-replacement
  }

  function objectLiteralArgumentReplacement(value) {
    mutatePreservedArgument(value, SOURCE("object-literal-replacement"), value = ({ slot: {} }).slot);
    SINK(value.property); // $ noRefinementFlow=object-literal-replacement noRefinementTaint=object-literal-replacement
  }

  function composedModeledCopy(value) {
    mutatePreservedArgument(
      value, SOURCE("composed-modeled-copy"), [value] = [identityPreservedArgument(value)]
    );
    SINK(value.property); // $ refinementFlow=composed-modeled-copy refinementTaint=composed-modeled-copy
  }

  function wrappedReplacementArgument(value) {
    function wrap(input) {
      return { nested: input };
    }
    mutatePreservedArgument(value, SOURCE("wrapped-replacement-argument"), value = wrap(value));
    SINK(value.property); // $ noRefinementFlow=wrapped-replacement-argument noRefinementTaint=wrapped-replacement-argument
  }

  function truthyReplacement(value) {
    mutatePreservedArgument(value, SOURCE("truthy-replacement"), value = {} || value);
    SINK(value.property); // $ SPURIOUS: refinementFlow=truthy-replacement refinementTaint=truthy-replacement
  }

  function nonNullishReplacement(value) {
    mutatePreservedArgument(value, SOURCE("non-nullish-replacement"), value = {} ?? value);
    SINK(value.property); // $ SPURIOUS: refinementFlow=non-nullish-replacement refinementTaint=non-nullish-replacement
  }

  // These copy-model false positives also occur with the baseline data-flow library.
  function clonedArgument(value) {
    mutatePreservedArgument(value, SOURCE("cloned-argument"), value = Object.assign({}, value));
    SINK(value.property); // $ SPURIOUS: refinementFlow=cloned-argument refinementTaint=cloned-argument
  }

  function libraryClonedArgument(value) {
    const clone = require("clone");
    mutatePreservedArgument(value, SOURCE("library-cloned-argument"), value = clone(value));
    SINK(value.property); // $ SPURIOUS: refinementFlow=library-cloned-argument refinementTaint=library-cloned-argument
  }

  function mixedReplacementArgument(value, condition) {
    mutatePreservedArgument(
      value, SOURCE("mixed-replacement-argument"),
      value = condition ? ({} || value) : replacementPreservedArgument(value)
    );
    SINK(value.property); // $ SPURIOUS: refinementFlow=mixed-replacement-argument refinementTaint=mixed-replacement-argument
  }

  function mixedNullishReplacementArgument(value, condition) {
    mutatePreservedArgument(
      value, SOURCE("mixed-nullish-replacement-argument"),
      value = condition ? ({} ?? value) : replacementPreservedArgument(value)
    );
    SINK(value.property); // $ SPURIOUS: refinementFlow=mixed-nullish-replacement-argument refinementTaint=mixed-nullish-replacement-argument
  }

  function assignOriginalArgument(value) {
    mutatePreservedArgument(value, SOURCE("assign-original-argument"), value = Object.assign(value, {}));
    SINK(value.property); // $ refinementFlow=assign-original-argument refinementTaint=assign-original-argument
  }

  function constantConditionReplacement(value) {
    mutatePreservedArgument(value, SOURCE("constant-condition-replacement"), value = true ? {} : value);
    SINK(value.property); // $ noRefinementFlow=constant-condition-replacement noRefinementTaint=constant-condition-replacement
  }

  function falsyReplacement(value) {
    mutatePreservedArgument(value, SOURCE("falsy-replacement"), value = false && value);
    SINK(value.property); // $ noRefinementFlow=falsy-replacement noRefinementTaint=falsy-replacement
  }

  function replacedArgument(value) {
    mutatePreservedArgument(value, SOURCE("replaced-argument"), value = {});
    SINK(value.property); // $ noRefinementFlow=replaced-argument noRefinementTaint=replaced-argument
  }

  function replacedStore(value) {
    value.property = (value = {}, SOURCE("replaced-store"));
    SINK(value.property); // $ noRefinementFlow=replaced-store noRefinementTaint=replaced-store
  }

  function overwrittenCopiedArgument(value) {
    let alias = value;
    alias = {};
    mutatePreservedArgument(value, SOURCE("overwritten-copied-argument"), value = alias);
    SINK(value.property); // $ noRefinementFlow=overwritten-copied-argument noRefinementTaint=overwritten-copied-argument
  }

  class SharedSsaThisTests {
    guardedThisMethod(condition) {
      if (condition) {
        if (!BARRIER(this)) return;
      } else {
        if (!BARRIER(this)) return;
      }
      SINK(this); // $ localRefinementFlow=this-guard noRefinementFlow=this-guard noRefinementTaint=this-guard
    }

    occurrenceBarrierThisMethod() {
      this.property = SOURCE("this-occurrence-barrier");
      BLOCKED_SINK(this.property); // $ noRefinementFlow=this-occurrence-barrier noRefinementTaint=this-occurrence-barrier
      BLOCKED_SINK(this); // $ noRefinementFlow=this-occurrence-barrier noRefinementTaint=this-occurrence-barrier
      SINK(this.property); // $ refinementFlow=this-occurrence-barrier refinementTaint=this-occurrence-barrier
    }
  }
}
