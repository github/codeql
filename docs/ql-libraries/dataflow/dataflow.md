# Using the shared data-flow library

This document is aimed towards language maintainers and contains implementation
details that should be mostly irrelevant to query writers.

## Overview

The shared data-flow library implements sophisticated global data flow on top
of a language-specific data-flow graph. The language-specific bits supply the
graph through a number of predicates and classes, and the shared implementation
takes care of matching call-sites with returns and field writes with reads to
ensure that the generated paths are well-formed. The library also supports a
number of additional features for improving precision, for example pruning
infeasible paths based on type information.

## File organisation

The data-flow library consists of a number of files typically located in
`<lang>/dataflow` and `<lang>/dataflow/internal`:

```
dataflow/DataFlow.qll
dataflow/internal/DataFlowImpl.qll
dataflow/internal/DataFlowCommon.qll
dataflow/internal/DataFlowImplSpecific.qll
```

`DataFlow.qll` provides the user interface for the library and consists of just
a few lines of code importing the implementation:

#### `DataFlow.qll`
```ql
import <lang>

module DataFlow {
  import semmle.code.java.dataflow.internal.DataFlowImpl
}
```

The `DataFlowImpl.qll` and `DataFlowCommon.qll` files contain the library code
that is shared across languages. These contain `Configuration`-specific and
`Configuration`-independent code, respectively. This organization allows
multiple copies of the library to exist without duplicating the
`Configuration`-independent predicates (for the use case when a query wants to
use two instances of global data flow and the configuration of one depends on
the results from the other). Using multiple copies just means duplicating
`DataFlow.qll` and `DataFlowImpl.qll`, for example as:

```
dataflow/DataFlow2.qll
dataflow/DataFlow3.qll
dataflow/internal/DataFlowImpl2.qll
dataflow/internal/DataFlowImpl3.qll
```

The file `DataFlowImplSpecific.qll` provides all the language-specific classes
and predicates that the library needs as input and is the topic of the rest of
this document.

This file must provide two modules named `Public` and `Private`, which the
shared library code will import publicly and privately, respectively, thus
allowing the language-specific part to choose which classes and predicates
should be exposed by `DataFlow.qll`.

A typical implementation looks as follows, thereby organizing the predicates in
two files, which we'll subsequently assume:

#### `DataFlowImplSpecific.qll`
```ql
module Private {
  import DataFlowPrivate
}

module Public {
  import DataFlowPublic
}
```

## Defining the data-flow graph

The main input to the library is the data-flow graph. One must define a class
`Node` and an edge relation `simpleLocalFlowStep(Node node1, Node node2)`. The
`Node` class should be in `DataFlowPublic`.

Recommendations:
* Make `Node` an IPA type. There is commonly a need for defining various
  data-flow nodes that are not necessarily represented in the AST of the
  language.
* Define `predicate localFlowStep(Node node1, Node node2)` as an alias of
  `simpleLocalFlowStep` and expose it publicly. The reason for this indirection
  is that it gives the option of exposing local flow augmented with field flow.
  See the C/C++ implementation, which makes use of this feature. Another use of
  this indirection is to hide synthesized local steps that are only relevant
  for global flow. See the C# implementation for an example of this.
* Define `predicate localFlow(Node node1, Node node2) { localFlowStep*(node1, node2) }`.
* Make the local flow step relation in `simpleLocalFlowStep` follow
  def-to-first-use and use-to-next-use steps for SSA variables. Def-use steps
  also work, but the upside of `use-use` steps is that sources defined in terms
  of variable reads just work out of the box. It also makes certain
  barrier-implementations simpler.
* A predicate `DataFlowCallable Node::getEnclosingCallable()` is required, and in
  order to ensure appropriate join-orders, it is important that the QL compiler knows
  that this predicate is functional. It can therefore be necessary to enclose the body
  of this predicate in a `unique` aggregate.

The shared library does not use `localFlowStep` nor `localFlow` but users of
`DataFlow.qll` may expect the existence of `DataFlow::localFlowStep` and
`DataFlow::localFlow`.

### `Node` subclasses

The `Node` class needs a number of subclasses. As a minimum the following are needed:
```
ExprNode
ParameterNode
PostUpdateNode

OutNode
ArgumentNode
ReturnNode
CastNode
```
and possibly more depending on the language and its AST. Of the above, the
first 3 should be public, but the last 4 can be private. Also, the last 4 will
likely be subtypes of `ExprNode`. For further details about `ParameterNode`,
`ArgumentNode`, `ReturnNode`, and `OutNode` see [The call-graph](#the-call-graph)
below. For further details about `CastNode` see [Type pruning](#type-pruning) below.
For further details about `PostUpdateNode` see [Field flow](#field-flow) below.

Nodes corresponding to expressions and parameters are the most common for users
to interact with so a couple of convenience predicates are generally included:
```
DataFlowExpr Node::asExpr()
Parameter Node::asParameter()
ExprNode exprNode(DataFlowExpr n)
ParameterNode parameterNode(Parameter n)
```
Here `DataFlowExpr` should be an alias for the language-specific class of
expressions (typically called `Expr`). Parameters do not need an alias for the
shared implementation to refer to, so here you can just use the
language-specific class name (typically called `Parameter`).

### The call-graph

In order to make inter-procedural flow work a number of classes and predicates
must be provided.

First, two types, `DataFlowCall` and `DataFlowCallable`, must be defined. These
should be aliases for whatever language-specific class represents calls and
callables (a "callable" is intended as a broad term covering functions,
methods, constructors, lambdas, etc.). It can also be useful to represent
`DataFlowCall` as an IPA type if implicit calls need to be modelled. The
call-graph should be defined as a predicate:
```ql
DataFlowCallable viableCallable(DataFlowCall c)
```

In order to connect data-flow across calls, the 4 `Node` subclasses
`ArgumentNode`, `ParameterNode`, `ReturnNode`, and `OutNode` are used.
Flow into callables from arguments to parameters are matched up using an
integer position, so these two classes must define:
```ql
ArgumentNode::argumentOf(DataFlowCall call, int pos)
ParameterNode::isParameterOf(DataFlowCallable c, int pos)
```
It is typical to use `pos = -1` for an implicit `this`-parameter.

For most languages return-flow is simpler and merely consists of matching up a
`ReturnNode` with the data-flow node corresponding to the value of the call,
represented as `OutNode`.  For this use-case we would define a singleton type
`ReturnKind`, a trivial `ReturnNode::getKind()`, and `getAnOutNode` to relate
calls and `OutNode`s:
```ql
private newtype TReturnKind = TNormalReturnKind()

ReturnKind ReturnNode::getKind() { any() }

OutNode getAnOutNode(DataFlowCall call, ReturnKind kind) {
  result = call.getNode() and
  kind = TNormalReturnKind()
}
```

For more complex use-cases when a language allows a callable to return multiple
values, for example through `out` parameters in C#, the `ReturnKind` class can
be defined and used to match up different kinds of `ReturnNode`s with the
corresponding `OutNode`s.

## Flow through global variables

Flow through global variables are called jump-steps, since such flow steps
essentially jump from one callable to another completely discarding call
contexts.

Adding support for this type of flow is done with the following predicate:
```ql
predicate jumpStep(Node node1, Node node2)
```

If global variables are common and certain databases have many reads and writes
of the same global variable, then a direct step may have performance problems,
since the straight-forward implementation is just a cartesian product of reads
and writes for each global variable. In this case it can be beneficial to
remove the cartesian product by introducing an intermediate `Node` for the
value of each global variable.

Note that, jump steps of course also can be used to implement other
cross-callable flow. As an example Java also uses this mechanism for variable
capture flow. But beware that this will lose the call context, so normal
inter-procedural flow should use argument-parameter-, and return-outnode-flow
as described above.

## Field flow

The library supports tracking flow through field stores and reads. In order to
support this, a class `Content` and two predicates
`storeStep(Node node1, Content f, Node node2)` and
`readStep(Node node1, Content f, Node node2)` must be defined. It generally
makes sense for stores to target `PostUpdateNode`s, but this is not a strict
requirement. Besides this, certain nodes must have associated
`PostUpdateNode`s. The node associated with a `PostUpdateNode` should be
defined by `PostUpdateNode::getPreUpdateNode()`.

`PostUpdateNode`s are generally used when we need two data-flow nodes for a
single AST element in order to distinguish the value before and after some
side-effect (typically a field store, but it may also be addition of taint
through an additional step targeting a `PostUpdateNode`).

It is recommended to introduce `PostUpdateNode`s for all `ArgumentNode`s (this
can be skipped for immutable arguments), and all field qualifiers for both
reads and stores. 

Remember to define local flow for `PostUpdateNode`s as well in
`simpleLocalFlowStep`.  In general out-going local flow from `PostUpdateNode`s
should be use-use flow, and there is generally no need for in-going local flow
edges for `PostUpdateNode`s.

We will illustrate how the shared library makes use of `PostUpdateNode`s
through a couple of examples.

### Example 1

Consider the following setter and its call:
```
setFoo(obj, x) {
  sink1(obj.foo);
  obj.foo = x;
}

setFoo(myobj, source);
sink2(myobj.foo);
```
Here `source` should flow to the argument of `sink2` but not the argument of
`sink1`. The shared library handles most of the complexity involved in this
flow path, but needs a little bit of help in terms of available nodes. In
particular it is important to be able to distinguish between the value of the
`myobj` argument to `setFoo` before the call and after the call, since without
this distinction it is hard to avoid also getting flow to `sink1`. The value
before the call should be the regular `ArgumentNode` (which will get flow into
the call), and the value after the call should be a `PostUpdateNode`. Thus a
`PostUpdateNode` should exist for the `myobj` argument with the `ArgumentNode`
as its pre-update node. In general `PostUpdateNode`s should exist for any
mutable `ArgumentNode`s to support flow returning through a side-effect
updating the argument.

This example also suggests how `simpleLocalFlowStep` should be implemented for
`PostUpdateNode`s: we need a local flow step between the `PostUpdateNode` for
the `myobj` argument and the following `myobj` in the qualifier of `myobj.foo`.

Inside `setFoo` the actual store should also target a
`PostUpdateNode` - in this case associated with the qualifier `obj` - as this
is the mechanism the shared library uses to identify side-effects that should
be reflected at call sites as setter-flow.  The shared library uses the
following rule to identify setters: If the value of a parameter may flow to a
node that is the pre-update node of a `PostUpdateNode` that is reached by some
flow, then this represents an update to the parameter, which will be reflected
in flow continuing to the `PostUpdateNode` of the corresponding argument in
call sites.

### Example 2

In the following two lines we would like flow from `x` to reach the
`PostUpdateNode` of `a` through a sequence of two store steps, and this is
indeed handled automatically by the shared library.
```
a.b.c = x;
a.getB().c = x;
```
The only requirement for this to work is the existence of `PostUpdateNode`s.
For a specified read step (in `readStep(Node n1, Content f, Node n2)`) the
shared library will generate a store step in the reverse direction between the
corresponding `PostUpdateNode`s. A similar store-through-reverse-read will be
generated for calls that can be summarized by the shared library as getters.
This usage of `PostUpdateNode`s ensures that `x` will not flow into the `getB`
call after reaching `a`.

### Example 3

Consider a constructor and its call (for this example we will use Java, but the
idea should generalize):
```java
MyObj(Content content) {
  this.content = content;
}

obj = new MyObj(source);
sink(obj.content);
```

We would like the constructor call to act in the same way as a setter, and
indeed this is quite simple to achieve. We can introduce a synthetic data-flow
node associated with the constructor call, let us call it `MallocNode`, and
make this an `ArgumentNode` with position `-1` such that it hooks up with the
implicit `this`-parameter of the constructor body. Then we can set the
corresponding `PostUpdateNode` of the `MallocNode` to be the constructor call
itself as this represents the value of the object after construction, that is
after the constructor has run. With this setup of `ArgumentNode`s and
`PostUpdateNode`s we will achieve the desired flow from `source` to `sink`

### Field flow barriers

Consider this field flow example:
```
obj.f = source;
obj.f = safeValue;
sink(obj.f);
```
or the similar case when field flow is used to model collection content:
```
obj.add(source);
obj.clear();
sink(obj.get(key));
```
Clearing a field or content like this should act as a barrier, and this can be
achieved by marking the relevant `Node, Content` pair as a clear operation in
the `clearsContent` predicate. A reasonable default implementation for fields
looks like this:
```ql
predicate clearsContent(Node n, Content c) {
  n = any(PostUpdateNode pun | storeStep(_, c, pun)).getPreUpdateNode()
}
```
However, this relies on the local step relation using the smallest possible
use-use steps. If local flow is implemented using def-use steps, then
`clearsContent` might not be easy to use.

## Type pruning

The library supports pruning paths when a sequence of value-preserving steps
originate in a node with one type, but reaches a node with another and
incompatible type, thus making the path impossible.

The type system for this is specified with the class `DataFlowType` and the
compatibility relation `compatibleTypes(DataFlowType t1, DataFlowType t2)`.
Using a singleton type as `DataFlowType` means that this feature is effectively
disabled.

It can be useful to use a simpler type system for pruning than whatever type
system might come with the language, as collections of types that would
otherwise be equivalent with respect to compatibility can then be represented
as a single entity (this improves performance). As an example, Java uses erased
types for this purpose and a single equivalence class for all numeric types.

The type of a `Node` is given by the following predicate
```
DataFlowType getNodeType(Node n)
```
and every `Node` should have a type.

One also needs to define the string representation of a `DataFlowType`:
```
string ppReprType(DataFlowType t)
```
The `ppReprType` predicate is used for printing a type in the labels of
`PathNode`s, this can be defined as `none()` if type pruning is not used.

Finally, one must define `CastNode` as a subclass of `Node` as those nodes
where types should be checked. Usually this will be things like explicit casts.
The shared library will also check types at `ParameterNode`s and `OutNode`s
without needing to include these in `CastNode`.  It is semantically perfectly
valid to include all nodes in `CastNode`, but this can hurt performance as it
will reduce the opportunity for the library to compact several local steps into
one. It is also perfectly valid to leave `CastNode` as the empty set, and this
should be the default if type pruning is not used.

## Virtual dispatch with call context

Consider a virtual call that may dispatch to multiple different targets. If we
know the call context of the call then this can sometimes be used to reduce the
set of possible dispatch targets and thus eliminate impossible call chains.

The library supports a one-level call context for improving virtual dispatch.

Conceptually, the following predicate should be implemented as follows:
```ql
DataFlowCallable viableImplInCallContext(DataFlowCall call, DataFlowCall ctx) {
  exists(DataFlowCallable enclosing |
    result = viableCallable(call) and
    enclosing = call.getEnclosingCallable() and
    enclosing = viableCallable(ctx)
  |
    not ... <`result` is impossible target for `call` given `ctx`> ...
  )
}
```
However, joining the virtual dispatch relation with itself in this way is
usually way too big to be feasible. Instead, the relation above should only be
defined for those values of `call` for which the set of resulting dispatch
targets might be reduced. To do this, define the set of `call`s that might for
some reason benefit from a call context as the following predicate (the `c`
column should be `call.getEnclosingCallable()`):
```ql
predicate mayBenefitFromCallContext(DataFlowCall call, DataFlowCallable c)
```
And then define `DataFlowCallable viableImplInCallContext(DataFlowCall call,
DataFlowCall ctx)` as sketched above, but restricted to
`mayBenefitFromCallContext(call, _)`.

The shared implementation will then compare counts of virtual dispatch targets
using `viableCallable` and `viableImplInCallContext` for each `call` in
`mayBenefitFromCallContext(call, _)` and track call contexts during flow
calculation when differences in these counts show an improved precision in
further calls.

## Additional features

### Access path length limit

The maximum length of an access path is the maximum number of nested stores
that can be tracked. This is given by the following predicate:
```ql
int accessPathLimit() { result = 5 }
```
We have traditionally used 5 as a default value here, and real examples have
been observed to require at least this much. Changing this value has a direct
impact on performance for large databases.

### Hidden nodes

Certain synthetic nodes can be hidden to exclude them from occurring in path
explanations. This is done through the following predicate:
```ql
predicate nodeIsHidden(Node n)
```

### Unreachable nodes

Consider:
```
foo(source1, false);
foo(source2, true);

foo(x, b) {
  if (b)
    sink(x);
}
```
Sometimes certain data-flow nodes can be unreachable based on the call context.
In the above example, only `source2` should be able to reach `sink`. This is
supported by the following predicate where one can specify unreachable nodes
given a call context.
```ql
predicate isUnreachableInCall(Node n, DataFlowCall callcontext) { .. }
```
Note that while this is a simple interface it does have some scalability issues
if the number of unreachable nodes is large combined with many call sites.

### `BarrierGuard`s

The class `BarrierGuard` must be defined. See
https://github.com/github/codeql/pull/1718 for details.

### Consistency checks

The file `dataflow/internal/DataFlowImplConsistency.qll` contains a number of
consistency checks to verify that the language-specific parts satisfy the
invariants that are expected by the shared implementation. Run these queries to
check for inconsistencies.
