.. _using-flow-labels-for-precise-data-flow-analysis:

Using flow state for precise data flow analysis
================================================

You can associate a flow state with each value tracked by the flow analysis to determine whether the flow contains potential vulnerabilities.

Overview
--------

You can use basic inter-procedural data-flow analysis and taint tracking as described in
":doc:`Analyzing data flow in JavaScript and TypeScript <analyzing-data-flow-in-javascript-and-typescript>`" to check whether there is a path in
the data-flow graph from some source node to a sink node that does not pass through any sanitizer
nodes. Another way of thinking about this is that it statically models the flow of data through the
program, and associates a flag with every data value telling us whether it might have come from a
source node.

In some cases, you may want to track more detailed information about data values. This can be done
by associating flow states with data values, as shown in this tutorial. We will first discuss the
general idea behind flow states and then show how to use them in practice. Finally, we will give an
overview of the API involved and provide some pointers to standard queries that use flow states.

Limitations of basic data-flow analysis
---------------------------------------

In many applications we are interested in tracking more than just the reachability information provided by inter-procedural data flow analysis.

For example, when tracking object values that originate from untrusted input, we might want to
remember whether the entire object is tainted or whether only part of it is tainted. The former
happens, for example, when parsing a user-controlled string as JSON, meaning that the entire
resulting object is tainted. A typical example of the latter is assigning a tainted value to a
property of an object, which only taints that property but not the rest of the object.

While reading a property of a completely tainted object yields a tainted value, reading a property
of a partially tainted object does not. On the other hand, JSON-encoding even a partially tainted
object and including it in an HTML document is not safe.

Another example where more fine-grained information about tainted values is needed is for tracking
partial sanitization. For example, before interpreting a user-controlled string as a file-system
path, we generally want to make sure that it is neither an absolute path (which could refer to any
file on the file system) nor a relative path containing ``..`` components (which still could refer
to any file). Usually, checking both of these properties would involve two separate checks. Both
checks taken together should count as a sanitizer, but each individual check is not by itself enough
to make the string safe for use as a path. To handle this case precisely, we want to associate two
bits of information with each tainted value, namely whether it may be absolute, and whether it may
contain ``..`` components. Untrusted user input has both bits set initially, individual checks turn
off individual bits, and if a value that has at least one bit set is interpreted as a path, a
potential vulnerability is flagged.

Using flow states
-----------------

You can handle these cases and others like them by associating a set of `flow states` (sometimes
also referred to as `flow labels` or `taint kinds`) with each value being tracked by the analysis. Value-preserving
data-flow steps (such as flow steps from writes to a variable to its reads) preserve the set of flow
states, but other steps may add or remove flow states. The initial set of flow states for a value is determined
by the source node that gives rise to it. Similarly, sink nodes can specify that an incoming value
needs to have a certain flow state (or one of a set of flow states) in order for the flow to be
flagged as a potential vulnerability.

Example
-------

As an example of using flow state, we will show how to write a query that flags property accesses
on JSON values that come from user-controlled input where we have not checked whether the value is
``null``, so that the property access may cause a runtime exception.

For example, we would like to flag this code:

.. code-block:: javascript

  function test(str) {
    var data = JSON.parse(str);
    if (data.length > 0) {  // problematic: `data` may be `null`
      ...
    }
  }

This code, on the other hand, should not be flagged:

.. code-block:: javascript

  function test(str) {
    var data = JSON.parse(str);
    if (data && data.length > 0) { // unproblematic: `data` is first checked for nullness
      ...
    }
  }

We will first try to write a query to find this kind of problem without flow state, and use the
difficulties we encounter as a motivation for bringing flow state into play, which will make the
query much easier to implement.

To get started, let's write a query that simply flags any flow from ``JSON.parse`` into the base of
a property access:

.. code-block:: ql

  import javascript

  module JsonTrackingConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node nd) {
      exists(JsonParserCall jpc |
        nd = jpc.getOutput()
      )
    }

    predicate isSink(DataFlow::Node nd) {
      exists(DataFlow::PropRef pr |
        nd = pr.getBase()
      )
    }
  }

  module JsonTrackingFlow = DataFlow::Global<JsonTrackingConfig>;

  from DataFlow::Node source, DataFlow::Node sink
  where JsonTrackingFlow::flow(source, sink)
  select sink, "Property access on JSON value originating $@.", source, "here"

Note that we use the ``JsonParserCall`` class from the standard library to model various JSON
parsers, including the standard ``JSON.parse`` API as well as a number of popular npm packages.

Of course, as written this query flags both the good and the bad example above, since we have not
introduced any sanitizers yet.

There are many ways of checking for nullness directly or indirectly. Since this is not the main
focus of this tutorial, we will only show how to model one specific case: if some variable ``v`` is
known to be truthy, it cannot be ``null``. This kind of condition is expressed using a "barrier guard".
A barrier guard node is a data-flow node ``b`` that blocks flow through some other node ``nd``,
provided that some condition checked at ``b`` is known to hold, that is, evaluate to a truthy value.

In our case, the barrier guard node is a use of some variable ``v``, and the condition is that use
itself: it blocks flow through any use of ``v`` where the guarding use is known to evaluate to a
truthy value. In our second example above, the use of ``data`` on the left-hand side of the ``&&``
is a barrier guard blocking flow through the use of ``data`` on the right-hand side of the ``&&``.
At this point we know that ``data`` has evaluated to a truthy value, so it cannot be ``null``
anymore.

Implementing this additional condition is easy. We implement a class with a predicate called ``blocksExpr``:

.. code-block:: ql

  class TruthinessCheck extends DataFlow::ValueNode {
    SsaVariable v;

    TruthinessCheck() {
      astNode = v.getAUse()
    }

    predicate blocksExpr(boolean outcome, Expr e) {
      outcome = true and
      e = astNode
    }
  }

and then use it to implement the predicate ``isBarrier`` in our configuration module:

.. code-block:: ql

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<TruthinessCheck>::getABarrierNode()
  }

With this change, we now flag the problematic case and don't flag the unproblematic case above.

However, as it stands our analysis has many false negatives: if we read a property of a JSON object,
our analysis will not continue tracking it, so property accesses on the resulting value will not be
checked for null-guardedness:

.. code-block:: javascript

  function test(str) {
    var root = JSON.parse(str);
    if (root) {
      var payload = root.data;   // unproblematic: `root` cannot be `null` here
      if (payload.length > 0) {  // problematic: `payload` may be `null` here
        ...
      }
    }
  }

We could try to remedy the situation by adding ``isAdditionalFlowStep`` in our configuration module to track values through property reads:

.. code-block:: ql

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    succ.(DataFlow::PropRead).getBase() = pred
  }

But this does not actually allow us to flag the problem above as once we have checked ``root`` for
truthiness, all further uses are considered to be sanitized. In particular, the reference to
``root`` in ``root.data`` is sanitized, so no flow tracking through the property read happens.

The problem is, of course, that our sanitizer sanitizes too much. It should not stop flow
altogether, it should simply record the fact that ``root`` itself is known to be non-null.
Any property read from ``root``, on the other hand, may well be null and needs to be checked
separately.

We can achieve this by introducing two different flow states, ``json`` and ``maybe-null``. The former
means that the value we are dealing with comes from a JSON object, the latter that it may be
``null``. The result of any call to ``JSON.parse`` has both states. A property read from a value
with state ``json`` also results in a value with both states. Checking truthiness removes the ``maybe-null`` state.
Accessing a property on a value that has the ``maybe-null`` state should be flagged.

To implement this, we first change the signature of our configuration module to ``DataFlow::StateConfigSig``, and
replace ``DataFlow::Global<...>`` with ``DataFlow::GlobalWithState<...>``:

.. code-block:: ql

  module JsonTrackingConfig implements DataFlow::StateConfigSig {
    /* ... */
  }

  module JsonTrackingFlow = DataFlow::GlobalWithState<JsonTrackingConfig>;

We then add a class called ``FlowState`` which has one value for each flow state:

.. code-block:: ql

  module JsonTrackingConfig implements DataFlow::StateConfigSig {
    class FlowState extends string {
      FlowState() {
        this = ["json", "maybe-null"]
      }
    }

    /* ... */
  }

Then we extend our ``isSource`` predicate with an additional parameter to specify the flow state:

.. code-block:: ql

  predicate isSource(DataFlow::Node nd, FlowState state) {
    exists(JsonParserCall jpc |
      nd = jpc.getOutput() and
      state = ["json", "maybe-null"] // start in either state
    )
  }

Similarly, we update ``isSink`` and require the base of the property read to have the ``maybe-null`` state:

.. code-block:: ql

  predicate isSink(DataFlow::Node nd, FlowState state) {
    exists(DataFlow::PropRef pr |
      nd = pr.getBase() and
      state = "maybe-null"
    )
  }

Our definition of ``isAdditionalFlowStep`` now needs to specify two flow states, a
predecessor state ``predState`` and a successor state ``succState``. In addition to specifying flow from
the predecessor node ``pred`` to the successor node ``succ``, it requires that ``pred`` has state
``predState``, and adds state ``succState`` to ``succ``. In our case, we use this to add both the
``json`` state and the ``maybe-null`` state to any property read from a value in the ``json`` state
(no matter whether it has the ``maybe-null`` state):

.. code-block:: ql

  predicate isAdditionalFlowStep(DataFlow::Node pred, FlowState predState,
                                 DataFlow::Node succ, FlowState succState) {
    succ.(DataFlow::PropRead).getBase() = pred and
    predState = "json" and
    succState = ["json", "maybe-null"]
  }

Finally, we add an additional parameter to the ``isBarrier`` predicate to specify the flow state
to block at the ``TruthinessCheck`` barrier.

.. code-block:: ql

  module JsonTrackingConfig implements DataFlow::StateConfigSig {
    /* ... */

    predicate isBarrier(DataFlow::Node node, FlowState state) {
      node = DataFlow::MakeBarrierGuard<TruthinessCheck>::getABarrierNode() and
      state = "maybe-null"
    }
  }

Here is the final query, expressed as a :ref:`path query <creating-path-queries>` so we can examine paths from sources to sinks
step by step in the UI:

.. code-block:: ql

  /** @kind path-problem */

  import javascript

  class TruthinessCheck extends DataFlow::ValueNode {
    SsaVariable v;

    TruthinessCheck() {
      astNode = v.getAUse()
    }

    predicate blocksExpr(boolean outcome, Expr e, JsonTrackingConfig::FlowState state) {
      outcome = true and
      e = astNode and
      state = "maybe-null"
    }
  }

  module JsonTrackingConfig implements DataFlow::StateConfigSig {
    class FlowState extends string {
      FlowState() {
        this = ["json", "maybe-null"]
      }
    }

    predicate isSource(DataFlow::Node nd, FlowState state) {
      exists(JsonParserCall jpc |
        nd = jpc.getOutput() and
        state = ["json", "maybe-null"] // start in either state
      )
    }

    predicate isSink(DataFlow::Node nd, FlowState state) {
      exists(DataFlow::PropRef pr |
        nd = pr.getBase() and
        state = "maybe-null"
      )
    }

    predicate isAdditionalFlowStep(DataFlow::Node pred, FlowState predState,
                                   DataFlow::Node succ, FlowState succState) {
      succ.(DataFlow::PropRead).getBase() = pred and
      predState = "json" and
      succState = ["json", "maybe-null"]
    }

    predicate isBarrier(DataFlow::Node node, FlowState state) {
      node = DataFlow::MakeBarrierGuard<TruthinessCheck>::getABarrierNode() and
      state = "maybe-null"
    }
  }

  module JsonTrackingFlow = DataFlow::GlobalWithState<JsonTrackingConfig>;

  from DataFlow::Node source, DataFlow::Node sink
  where JsonTrackingFlow::flow(source, sink)
  select sink, "Property access on JSON value originating $@.", source, "here"

We ran this query on the https://github.com/finos/plexus-interop repository. Many of the
results were false positives since the query does not currently model many ways in which we can check
a value for nullness. In particular, after a property reference ``x.p`` we implicitly know that
``x`` cannot be null anymore, since otherwise the reference would have thrown an exception.
Modeling this would allow us to get rid of most of the false positives, but is beyond the scope of
this tutorial.

API
---

Flow state can be used in modules implementing the ``DataFlow::StateConfigSig`` signature. Compared to a ``DataFlow::ConfigSig`` the main differences are:

- The module must be passed to ``DataFlow::GlobalWithState<...>`` or ``TaintTracking::GlobalWithState<...>``.
  instead of ``DataFlow::Global<...>`` or ``TaintTracking::Global<...>``.
- The module must contain a type named ``FlowState``.
- ``isSource`` expects an additional parameter specifying the flow state.
- ``isSink`` optionally can take an additional parameter specifying the flow state.
  If omitted, the sinks are in effect for all flow states.
- ``isAdditionalFlowStep`` optionally can take two additional parameters specifying the predecessor and successor flow states.
  If omitted, the generated steps apply for any flow state and preserve the current flow state.
- ``isBarrier`` optionally can take an additional parameter specifying the flow state to block.
  If omitted, the barriers block all flow states.

Standard queries using flow state
----------------------------------

Some of our standard security queries use flow state. You can look at their implementation
to get a feeling for how to use flow state in practice.

In particular, both of the examples mentioned in the section on limitations of basic data flow above
are from standard security queries that use flow state. The `Prototype-polluting merge call
<https://codeql.github.com/codeql-query-help/javascript/js-prototype-pollution/>`_ query uses two flow states to distinguish completely
tainted objects from partially tainted objects. The `Uncontrolled data used in path expression
<https://codeql.github.com/codeql-query-help/javascript/js-path-injection/>`_ query uses four flow states to track whether a user-controlled
string may be an absolute path and whether it may contain ``..`` components.

Further reading
---------------

- `Exploring data flow with path queries  <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/exploring-data-flow-with-path-queries>`__ in the GitHub documentation.


.. include:: ../reusables/javascript-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
