# Improvements to C# analysis

## General improvements

* Control flow analysis has been improved for `catch` clauses with filters.

## New queries

| **Query**                   | **Tags**  | **Purpose**                                                        |
|-----------------------------|-----------|--------------------------------------------------------------------|
| Arbitrary file write during zip extraction ("Zip Slip") (`cs/zipslip`) | security, external/cwe/cwe-022  | Identifies zip extraction routines which allow arbitrary file overwrite vulnerabilities. |
| Local scope variable shadows member (`cs/local-shadows-member`) | maintainability, readability | Replaces the existing queries Local variable shadows class member (`cs/local-shadows-class-member`), Local variable shadows struct member (`cs/local-shadows-struct-member`), Parameter shadows class member (`cs/parameter-shadows-class-member`), and Parameter shadows struct member (`cs/parameter-shadows-struct-member`). |

## Changes to existing queries

| **Query**                  | **Expected impact**    | **Change**                                                       |
|----------------------------|------------------------|------------------------------------------------------------------|
| Constant condition (`cs/constant-condition`) | More results | The query has been generalized to report alerts for the old queries Null-coalescing left operand is constant (`cs/constant-null-coalescing`) and Switch selector is constant (`cs/constant-switch-selector`). |
| Exposing internal representation (`cs/expose-implementation`) | Different results | The query has been rewritten, based on the [equivalent Java query](https://help.semmle.com/wiki/display/JAVA/Exposing+internal+representation). |
| Local variable shadows class member (`cs/local-shadows-class-member`) | No results | The query has been replaced by the new query: Local scope variable shadows member  (`cs/local-shadows-member`). |
| Local variable shadows struct member (`cs/local-shadows-struct-member`) | No results | The query has been replaced by the new query: Local scope variable shadows member  (`cs/local-shadows-member`). |
| Missing Dispose call on local IDisposable (`cs/local-not-disposed`) | Fewer false positive results | The query identifies more cases where the local variable may be disposed by a library call. |
| Nested loops with same variable (`cs/nested-loops-with-same-variable`) | Fewer false positive results | Results are no longer highlighted in nested loops that share the same condition, and do not use the variable after the inner loop. |
| Null-coalescing left operand is constant (`cs/constant-null-coalescing`) | No results | The query has been removed, as alerts for this problem are now reported by the new query: Constant condition (`cs/constant-condition`). |
| Parameter shadows class member (`cs/parameter-shadows-class-member`) | No results | The query has been replaced by the new query: Local scope variable shadows member  (`cs/local-shadows-member`). |
| Parameter shadows struct member (`cs/parameter-shadows-struct-member`) | No results | The query has been replaced by the new query: Local scope variable shadows member  (`cs/local-shadows-member`). |
| Potentially incorrect CompareTo(...) signature (`cs/wrong-compareto-signature`) | Fewer false positive results | Results are no longer highlighted in constructed types. |
| Switch selector is constant (`cs/constant-switch-selector`) | No results | The query has been removed, as alerts for this problem are now reported by the new query: Constant condition (`cs/constant-condition`). |
| Useless upcast (`cs/useless-upcast`) | Fewer false positive results | The query has been improved to cover more cases where upcasts may be needed. |

## Changes to code extraction

* The `into` part of `join` clauses is now extracted.
* The `when` part of constant cases is now extracted.
* Fixed a bug where `while(x is T y) ...` was not extracted correctly.

## Changes to QL libraries

* A new non-member predicate `mayBeDisposed()` can be used to determine if a variable is potentially disposed inside a library. It will analyze the CIL code in the library to determine this.
* The predicate `getCondition()` has been moved from `TypeCase` to `CaseStmt`. It is now possible to get the condition of a `ConstCase` using its `getCondition()` predicate.
* Several control flow graph entities have been renamed (the old names are deprecated but are still available in this release for backwards compatibility):
  - `ControlFlowNode` has been renamed to `ControlFlow::Node`.
  - `CallableEntryNode` has been renamed to `ControlFlow::Nodes::EntryNode`.
  - `CallableExitNode` has been renamed to `ControlFlow::Nodes::ExitNode`.
  - `ControlFlowEdgeType` has been renamed to `ControlFlow::SuccessorType`.
  - `ControlFlowEdgeSuccessor` has been renamed to `ControlFlow::SuccessorTypes::NormalSuccessor`.
  - `ControlFlowEdgeConditional` has been renamed to `ControlFlow::SuccessorTypes::ConditionalSuccessor`.
  - `ControlFlowEdgeBoolean` has been renamed to `ControlFlow::SuccessorTypes::BooleanSuccessor`.
  - `ControlFlowEdgeNullness` has been renamed to `ControlFlow::SuccessorTypes::NullnessSuccessor`.
  - `ControlFlowEdgeMatching` has been renamed to `ControlFlow::SuccessorTypes::MatchingSuccessor`.
  - `ControlFlowEdgeEmptiness` has been renamed to `ControlFlow::SuccessorTypes::EmptinessSuccessor`.
  - `ControlFlowEdgeReturn` has been renamed to `ControlFlow::SuccessorTypes::ReturnSuccessor`.
  - `ControlFlowEdgeBreak` has been renamed to `ControlFlow::SuccessorTypes::BreakSuccessor`.
  - `ControlFlowEdgeContinue` has been renamed to `ControlFlow::SuccessorTypes::ContinueSuccessor`.
  - `ControlFlowEdgeGotoLabel` has been renamed to `ControlFlow::SuccessorTypes::GotoLabelSuccessor`.
  - `ControlFlowEdgeGotoCase` has been renamed to `ControlFlow::SuccessorTypes::GotoCaseSuccessor`.
  - `ControlFlowEdgeGotoDefault` has been renamed to `ControlFlow::SuccessorTypes::GotoDefaultSuccessor`.
  - `ControlFlowEdgeException` has been renamed to `ControlFlow::SuccessorTypes::ExceptionSuccessor`.

> You should update any custom queries that use these entities to ensure that they continue working when the old names are removed in a future release.
