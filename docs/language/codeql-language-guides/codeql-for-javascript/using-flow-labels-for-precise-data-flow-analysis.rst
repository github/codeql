.. _using-flow-labels-for-precise-data-flow-analysis:

Using flow labels for precise data flow analysis
================================================

You can associate flow labels with each value tracked by the flow analysis to determine whether the flow contains potential vulnerabilities.

Overview
--------

You can use basic inter-procedural data-flow analysis and taint tracking as described in
":doc:`Analyzing data flow in JavaScript and TypeScript <analyzing-data-flow-in-javascript>`" to check whether there is a path in
the data-flow graph from some source node to a sink node that does not pass through any sanitizer
nodes. Another way of thinking about this is that it statically models the flow of data through the
program, and associates a flag with every data value telling us whether it might have come from a
source node.

In some cases, you may want to track more detailed information about data values. This can be done
by associating flow labels with data values, as shown in this tutorial. We will first discuss the
general idea behind flow labels and then show how to use them in practice. Finally, we will give an
overview of the API involved and provide some pointers to standard queries that use flow labels.

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

Using flow labels
-----------------

You can handle these cases and others like them by associating a set of `flow labels` (sometimes
also referred to as `taint kinds`) with each value being tracked by the analysis. Value-preserving
data-flow steps (such as flow steps from writes to a variable to its reads) preserve the set of flow
labels, but other steps may add or remove flow labels. Sanitizers, in particular, are simply flow
steps that remove some or all flow labels. The initial set of flow labels for a value is determined
by the source node that gives rise to it. Similarly, sink nodes can specify that an incoming value
needs to have a certain flow label (or one of a set of flow labels) in order for the flow to be
flagged as a potential vulnerability.

Example
-------

As an example of using flow labels, we will show how to write a query that flags property accesses
on JSON values that come from user-controlled input where we have not checked whether the value is
``null``, so that the property access may cause a runtime exception.

For example, we would like to flag this code:

.. code-block:: javascript

  var data = JSON.parse(str);
  if (data.length > 0) {  // problematic: `data` may be `null`
    ...
  }

This code, on the other hand, should not be flagged:

.. code-block:: javascript

  var data = JSON.parse(str);
  if (data && data.length > 0) { // unproblematic: `data` is first checked for nullness
    ...
  }

We will first try to write a query to find this kind of problem without flow labels, and use the
difficulties we encounter as a motivation for bringing flow labels into play, which will make the
query much easier to implement.

To get started, let's write a query that simply flags any flow from ``JSON.parse`` into the base of
a property access:

.. code-block:: ql

  import javascript

  class JsonTrackingConfig extends DataFlow::Configuration {
    JsonTrackingConfig() { this = "JsonTrackingConfig" }

    override predicate isSource(DataFlow::Node nd) {
      exists(JsonParserCall jpc |
        nd = jpc.getOutput()
      )
    }

    override predicate isSink(DataFlow::Node nd) {
      exists(DataFlow::PropRef pr |
        nd = pr.getBase()
      )
    }
  }

  from JsonTrackingConfig cfg, DataFlow::Node source, DataFlow::Node sink
  where cfg.hasFlow(source, sink)
  select sink, "Property access on JSON value originating $@.", source, "here"

Note that we use the ``JsonParserCall`` class from the standard library to model various JSON
parsers, including the standard ``JSON.parse`` API as well as a number of popular npm packages.

Of course, as written this query flags both the good and the bad example above, since we have not
introduced any sanitizers yet.

There are many ways of checking for nullness directly or indirectly. Since this is not the main
focus of this tutorial, we will only show how to model one specific case: if some variable ``v`` is
known to be truthy, it cannot be ``null``. This kind of condition is easily expressed using a
``BarrierGuardNode`` (or its counterpart ``SanitizerGuardNode`` for taint-tracking configurations).
A barrier guard node is a data-flow node ``b`` that blocks flow through some other node ``nd``,
provided that some condition checked at ``b`` is known to hold, that is, evaluate to a truthy value.

In our case, the barrier guard node is a use of some variable ``v``, and the condition is that use
itself: it blocks flow through any use of ``v`` where the guarding use is known to evaluate to a
truthy value. In our second example above, the use of ``data`` on the left-hand side of the ``&&``
is a barrier guard blocking flow through the use of ``data`` on the right-hand side of the ``&&``.
At this point we know that ``data`` has evaluated to a truthy value, so it cannot be ``null``
anymore.

Implementing this additional condition is easy. We implement a subclass of ``DataFlow::BarrierGuardNode``:

.. code-block:: ql

  class TruthinessCheck extends DataFlow::BarrierGuardNode, DataFlow::ValueNode {
    SsaVariable v;

    TruthinessCheck() {
      astNode = v.getAUse()
    }

    override predicate blocks(boolean outcome, Expr e) {
      outcome = true and
      e = astNode
    }
  }

and then use it to override predicate ``isBarrierGuard`` in our configuration class:

.. code-block:: ql

  override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
    guard instanceof TruthinessCheck
  }

With this change, we now flag the problematic case and don't flag the unproblematic case above.

However, as it stands our analysis has many false negatives: if we read a property of a JSON object,
our analysis will not continue tracking it, so property accesses on the resulting value will not be
checked for null-guardedness:

.. code-block:: javascript

  var root = JSON.parse(str);
  if (root) {
    var payload = root.data;   // unproblematic: `root` cannot be `null` here
    if (payload.length > 0) {  // problematic: `payload` may be `null` here
      ...
    }
  }

We could try to remedy the situation by overriding ``isAdditionalFlowStep`` in our configuration class to track values through property reads:

.. code-block:: ql

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    succ.(DataFlow::PropRead).getBase() = pred
  }

But this does not actually allow us to flag the problem above as once we have checked ``root`` for
truthiness, all further uses are considered to be sanitized. In particular, the reference to
``root`` in ``root.data`` is sanitized, so no flow tracking through the property read happens.

The problem is, of course, that our sanitizer sanitizes too much. It should not stop flow
altogether, it should simply record the fact that ``root`` itself is known to be non-null.
Any property read from ``root``, on the other hand, may well be null and needs to be checked
separately.

We can achieve this by introducing two different flow labels, ``json`` and ``maybe-null``. The former
means that the value we are dealing with comes from a JSON object, the latter that it may be
``null``. The result of any call to ``JSON.parse`` has both labels. A property read from a value
with label ``json`` also has both labels. Checking truthiness removes the ``maybe-null`` label.
Accessing a property on a value that has the ``maybe-null`` label should be flagged.

To implement this, we start by defining two new subclasses of the class ``DataFlow::FlowLabel``:

.. code-block:: ql

  class JsonLabel extends DataFlow::FlowLabel {
    JsonLabel() {
      this = "json"
    }
  }

  class MaybeNullLabel extends DataFlow::FlowLabel {
    MaybeNullLabel() {
      this = "maybe-null"
    }
  }

Then we extend our ``isSource`` predicate from above to track flow labels by overriding the two-argument version instead of the one-argument version:

.. code-block:: ql

  override predicate isSource(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    exists(JsonParserCall jpc |
      nd = jpc.getOutput() and
      (lbl instanceof JsonLabel or lbl instanceof MaybeNullLabel)
    )
  }

Similarly, we make ``isSink`` flow-label aware and require the base of the property read to have the ``maybe-null`` label:

.. code-block:: ql

  override predicate isSink(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
    exists(DataFlow::PropRef pr |
      nd = pr.getBase() and
      lbl instanceof MaybeNullLabel
    )
  }

Our overriding definition of ``isAdditionalFlowStep`` now needs to specify two flow labels, a
predecessor label ``predlbl`` and a successor label ``succlbl``. In addition to specifying flow from
the predecessor node ``pred`` to the successor node ``succ``, it requires that ``pred`` has label
``predlbl``, and adds label ``succlbl`` to ``succ``. In our case, we use this to add both the
``json`` label and the ``maybe-null`` label to any property read from a value labeled with ``json``
(no matter whether it has the ``maybe-null`` label):

.. code-block:: ql

  override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ,
                                DataFlow::FlowLabel predlbl, DataFlow::FlowLabel succlbl) {
    succ.(DataFlow::PropRead).getBase() = pred and
    predlbl instanceof JsonLabel and
    (succlbl instanceof JsonLabel or succlbl instanceof MaybeNullLabel)
  }

Finally, we turn ``TruthinessCheck`` from a ``BarrierGuardNode`` into a ``LabeledBarrierGuardNode``,
specifying that it only removes the ``maybe-null`` label (but not the ``json`` label) from the
sanitized value:

.. code-block:: ql

  class TruthinessCheck extends DataFlow::LabeledBarrierGuardNode, DataFlow::ValueNode {
    ...

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel lbl) {
      outcome = true and
      e = astNode and
      lbl instanceof MaybeNullLabel
    }
  }

Here is the final query, expressed as a :ref:`path query <creating-path-queries>` so we can examine paths from sources to sinks
step by step in the UI:

.. code-block:: ql

  /** @kind path-problem */

  import javascript
  import DataFlow::PathGraph

  class JsonLabel extends DataFlow::FlowLabel {
    JsonLabel() {
      this = "json"
    }
  }

  class MaybeNullLabel extends DataFlow::FlowLabel {
    MaybeNullLabel() {
      this = "maybe-null"
    }
  }

  class TruthinessCheck extends DataFlow::LabeledBarrierGuardNode, DataFlow::ValueNode {
    SsaVariable v;

    TruthinessCheck() {
      astNode = v.getAUse()
    }

    override predicate blocks(boolean outcome, Expr e, DataFlow::FlowLabel lbl) {
      outcome = true and
      e = astNode and
      lbl instanceof MaybeNullLabel
    }
  }

  class JsonTrackingConfig extends DataFlow::Configuration {
    JsonTrackingConfig() { this = "JsonTrackingConfig" }

    override predicate isSource(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
      exists(JsonParserCall jpc |
        nd = jpc.getOutput() and
        (lbl instanceof JsonLabel or lbl instanceof MaybeNullLabel)
      )
    }

    override predicate isSink(DataFlow::Node nd, DataFlow::FlowLabel lbl) {
      exists(DataFlow::PropRef pr |
        nd = pr.getBase() and
        lbl instanceof MaybeNullLabel
      )
    }

    override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ,
                               DataFlow::FlowLabel predlbl, DataFlow::FlowLabel succlbl) {
      succ.(DataFlow::PropRead).getBase() = pred and
      predlbl instanceof JsonLabel and
      (succlbl instanceof JsonLabel or succlbl instanceof MaybeNullLabel)
    }

    override predicate isBarrierGuard(DataFlow::BarrierGuardNode guard) {
      guard instanceof TruthinessCheck
    }
  }

  from JsonTrackingConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
  where cfg.hasFlowPath(source, sink)
  select sink, source, sink, "Property access on JSON value originating $@.", source, "here"

`Here <https://lgtm.com/query/5347702611074820306>`_ is a run of this query on the `plexus-interop
<https://lgtm.com/projects/g/finos-plexus/plexus-interop/>`_ project on LGTM.com. Many of the 19
results are false positives since we currently do not model many ways in which a value can be
checked for nullness. In particular, after a property reference ``x.p`` we implicitly know that
``x`` cannot be null anymore, since otherwise the reference would have thrown an exception.
Modeling this would allow us to get rid of most of the false positives, but is beyond the scope of
this tutorial.

API
---

Plain data-flow configurations implicitly use a single flow label "data", which indicates that a
data value originated from a source. You can use the predicate ``DataFlow::FlowLabel::data()``,
which returns this flow label, as a symbolic name for it.

Taint-tracking configurations add a second flow label "taint" (``DataFlow::FlowLabel::taint()``),
which is similar to "data", but includes values that have passed through non-value preserving steps
such as string operations.

Each of the three member predicates ``isSource``, ``isSink`` and
``isAdditionalFlowStep``/``isAdditionalTaintStep`` has one version that uses the default flow
labels, and one version that allows specifying custom flow labels through additional arguments.

For ``isSource``, there is one additional argument specifying which flow label(s) should be
associated with values originating from this source. If multiple flow labels are specified, each
value is associated with `all` of them.

For ``isSink``, the additional argument specifies which flow label(s) a value that flows into this
source may be associated with. If multiple flow labels are specified, then any value that is
associated with `at least one` of them will be considered by the configuration.

For ``isAdditionalFlowStep`` there are two additional arguments ``predlbl`` and ``succlbl``, which
allow flow steps to act as flow label transformers. If a value associated with ``predlbl`` arrives
at the start node of the additional step, it is propagated to the end node and associated with
``succlbl``. Of course, ``predlbl`` and ``succlbl`` may be the same, indicating that the flow step
preserves this label. There can also be multiple values of ``succlbl`` for a single ``predlbl`` or
vice versa.

Note that if you do not restrict ``succlbl`` then it will be allowed to range over all flow labels.
This may cause labels that were previously blocked on a path to reappear, which is not usually what
you want.

The flow label-aware version of ``isBarrier`` is called ``isLabeledBarrier``: unlike ``isBarrier``,
which prevents any flow past the given node, it only blocks flow of values associated with one of
the specified flow labels.

Standard queries using flow labels
----------------------------------

Some of our standard security queries use flow labels. You can look at their implementation
to get a feeling for how to use flow labels in practice.

In particular, both of the examples mentioned in the section on limitations of basic data flow above
are from standard security queries that use flow labels. The `Prototype pollution
<https://lgtm.com/rules/1508857356317>`_ query uses two flow labels to distinguish completely
tainted objects from partially tainted objects. The `Uncontrolled data used in path expression
<https://lgtm.com/rules/1971530250>`_ query uses four flow labels to track whether a user-controlled
string may be an absolute path and whether it may contain ``..`` components.

Further reading
---------------

- ":ref:`Exploring data flow with path queries <exploring-data-flow-with-path-queries>`"


.. include:: ../../reusables/javascript-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
