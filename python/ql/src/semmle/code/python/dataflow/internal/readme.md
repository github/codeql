# Using the shared dataflow library

## File organisation

The files currently live in `semmle/code/python` (whereas the exisitng implementation lives in `semmle/python/dataflow`).

In there is found `DataFlow.qll`, `DataFlow2.qll` etc. which refer to `internal\DataFlowImpl`, `internal\DataFlowImpl2` etc. respectively. The `DataFlowImplN`-files are all identical copies to avoid mutual recursion. They start off by including two files `internal\DataFlowImplCommon` and `internal\DataFlowImplSpecific`. The former contains all the language-agnostic definitions, while the latter is where we describe our favorite language. `Sepcific` simply forwards to two other files `internal/DataFlowPrivate.qll` and `internal/DataFlowPublic.qll`. Definitions in the former will be hidden behind a `private` modifier, while those in the latter can be referred to in data flow queries. For instance, the definition of `DataFlow::Node` should likely be in `DataFlowPublic.qll`.

## Define the dataflow graph

In order to use the dataflow library, we need to define the dataflow graph,
that is define the nodes and the edges.

### Define the nodes

The nodes are defined in the type `DataFlow::Node` (found in `DataFlowPublic.qll`).
This should likely be an IPA type, so we can extend it as needed.

Typical cases needed to construct the call graph include
 - argument node
 - parameter node
 - return node

Typical extensions include
 - postupdate nodes
 - implicit `this`-nodes

### Define the edges

The edges split into local flow (within a function) and global flow (the call graph, between functions/procedures).

Extra flow, such as reading from and writing to global variables, can be captured in `jumpStep`.
The local flow should be obtainalble from an SSA computation.

The global flow should be obtainable from a `PointsTo` analysis. It is specified via `viableCallable` and
`getAnOutNode`. Consider making `ReturnKind` a singleton IPA type as in java.

If complicated dispatch needs to be modelled, try using the `[reduced|pruned]viable*` predicates.

## Field flow

To track flow through fields we need to provide a model of fields, that is the `Content` class.

Field access is specified via `read_step` and `store_step`.

Work is being done to make field flow handle lists and dictionaries and the like.

`PostUpdateNode`s become important when field flow is used, as they track modifications to fields resulting from function calls.

## Type pruning

If type information is available, flows can be discarded on the grounds of type mismatch.

Tracked types are given by the class `DataFlowType` and the predicate `getTypeBound`, and compatibility is recorded in the predicate `compatibleTypes`.

Further, possible casts are given by the class `CastNode`.

---

# Plan

## Stage I, data flow

### Phase 0, setup
Define minimal IPA type for `DataFlow::Node`
Define all required predicates empty (via `none()`),
except `compatibleTypes` which should be `any()`.
Define `ReturnKind`, `DataFlowType`, and `Content` as singleton IPA types.


### Phase 1, local flow
Implement `simpleLocalFlowStep` based on the existing SSA computation

### Phase 2, local flow
Implement `viableCallable` and `getAnOutNode` based on the existing predicate `PointsTo`.

### Phase 3, field flow
Redefine `Content` and implement `read_step` and `store_step`.

Review use of post-update nodes.

### Phase 4, type pruning
Use type trackers to obtain relevant type information and redefine `DataFlowType` to contain appropriate cases. Record the type information in `getTypeBound`.

Implement `compatibleTypes` (perhaps simply as the identity).

If necessary, re-implement `getErasedRepr` and `ppReprType`.

If necessary, redefine `CastNode`.

### Phase 5, bonus
Review possible use of `[reduced|pruned]viable*` predicates.

Review need for more elaborate `ReturnKind`.

Review need for non-empty `jumpStep`.

Review need for non-empty `isUnreachableInCall`.

## Stage II, taint tracking

# Phase 0, setup
Implement all predicates empty.

# Phase 1, experiments
Try recovering an existing taint tracking query by implementing sources, sinks, sanitizers, and barriers. 