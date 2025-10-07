.. _migrating-javascript-dataflow-queries:

Migrating JavaScript Dataflow Queries
=====================================

The JavaScript analysis used to have its own data flow library, which differed from the shared data flow
library used by other languages. This library has now been deprecated in favor of the shared library.

This article explains how to migrate JavaScript data flow queries to use the shared data flow library,
and some important differences to be aware of. Note that the article on :ref:`analyzing data flow in JavaScript and TypeScript <analyzing-data-flow-in-javascript-and-typescript>`
provides a general guide to the new data flow library, whereas this article aims to help with migrating existing queries from the old data flow library.

Note that the ``DataFlow::Configuration`` class is still backed by the original data flow library, but has been marked as deprecated.
This means data flow queries using this class will continue to work, albeit with deprecation warnings, until the 1-year deprecation period expires in early 2026.
It is recommended that all custom queries are migrated before this time, to ensure they continue to work in the future.

Data flow queries should be migrated to use ``DataFlow::ConfigSig``-style modules instead of the ``DataFlow::Configuration`` class.
This is identical to the interface found in other languages.
When making this switch, the query will become backed by the shared data flow library instead. That is, data flow queries will only work
with the shared data flow library when they have been migrated to ``ConfigSig``-style, as shown in the following table:

.. list-table:: Data flow libraries
   :widths: 20 80
   :header-rows: 1

   * - API
     - Implementation
   * - ``DataFlow::Configuration``
     - Old library (deprecated, to be removed in early 2026)
   * - ``DataFlow::ConfigSig``
     - Shared library

A straightforward translation to ``DataFlow::ConfigSig``-style is usually possible, although there are some complications
that may cause the query to behave differently.
We'll first cover some straightforward migration examples, and then go over some of the complications that may arise.

Simple migration example
------------------------

A simple example of a query using the old data flow library is shown below:

.. code-block:: ql

    /** @kind path-problem */
    import javascript
    import DataFlow::PathGraph

    class MyConfig extends DataFlow::Configuration {
      MyConfig() { this = "MyConfig" }

      override predicate isSource(DataFlow::Node node) { ... }

      override predicate isSink(DataFlow::Node node) { ... }
    }

    from MyConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
    where cfg.hasFlowPath(source, sink)
    select sink, source, sink, "Flow found"

With the new style this would look like this:

.. code-block:: ql

    /** @kind path-problem */
    import javascript

    module MyConfig implements DataFlow::ConfigSig {
      predicate isSource(DataFlow::Node node) { ... }

      predicate isSink(DataFlow::Node node) { ... }
    }

    module MyFlow = DataFlow::Global<MyConfig>;

    import MyFlow::PathGraph

    from MyFlow::PathNode source, MyFlow::PathNode sink
    where MyFlow::flowPath(source, sink)
    select sink, source, sink, "Flow found"

The changes can be summarized as:

- The ``DataFlow::Configuration`` class was replaced with a module implementing ``DataFlow::ConfigSig``.
- The characteristic predicate was removed (modules have no characteristic predicates).
- Predicates such as ``isSource`` no longer have the ``override`` keyword (as they are defined in a module now).
- The configuration module is being passed to ``DataFlow::Global``, resulting in a new module, called ``MyFlow`` in this example.
- The query imports ``MyFlow::PathGraph`` instead of ``DataFlow::PathGraph``.
- The ``MyConfig cfg`` variable was removed from the ``from`` clause.
- The ``hasFlowPath`` call was replaced with ``MyFlow::flowPath``.
- The type ``DataFlow::PathNode`` was replaced with ``MyFlow::PathNode``.

With these changes, we have produced an equivalent query that is backed by the new data flow library.

Taint tracking
--------------

For configuration classes extending ``TaintTracking::Configuration``, the migration is similar but with a few differences:

- The ``TaintTracking::Global`` module should be used instead of ``DataFlow::Global``.
- Some predicates originating from ``TaintTracking::Configuration`` should be renamed to match the ``DataFlow::ConfigSig`` interface:
  - ``isSanitizer`` should be renamed to ``isBarrier``.
  - ``isAdditionalTaintStep`` should be renamed to ``isAdditionalFlowStep``.

Note that there is no such thing as ``TaintTracking::ConfigSig``. The ``DataFlow::ConfigSig`` interface is used for both data flow and taint tracking.

For example:

.. code-block:: ql

    class MyConfig extends TaintTracking::Configuration {
      MyConfig() { this = "MyConfig" }

      predicate isSanitizer(DataFlow::Node node) { ... }
      predicate isAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) { ... }
      ...
    }

The above configuration can be migrated to the shared data flow library as follows:

.. code-block:: ql

    module MyConfig implements DataFlow::ConfigSig {
      predicate isBarrier(DataFlow::Node node) { ... }
      predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) { ... }
      ...
    }

    module MyFlow = TaintTracking::Global<MyConfig>;


Flow labels and flow states
---------------------------

The ``DataFlow::FlowLabel`` class has been deprecated. Queries that relied on flow labels should use the new `flow state` concept instead.
This is done by implementing ``DataFlow::StateConfigSig`` instead of ``DataFlow::ConfigSig``, and passing the module to ``DataFlow::GlobalWithState``
or ``TaintTracking::GlobalWithState``. See :ref:`using flow state <using-flow-labels-for-precise-data-flow-analysis>` for more details about flow state.

Some changes to be aware of:

- The 4-argument version of ``isAdditionalFlowStep`` now takes parameters in a different order.
  It now takes ``node1, state1, node2, state2`` instead of ``node1, node2, state1, state2``.
- Taint steps apply to all flow states, not just the ``taint`` flow label. See more details further down in this article.

Barrier guards
--------------

The predicates ``isBarrierGuard`` and ``isSanitizerGuard`` have been removed.

Instead, the ``isBarrier`` predicate must be used to define all barriers. To do this, barrier guards can be reduced to a set of barrier nodes using the ``DataFlow::MakeBarrierGuard`` module.

For example, consider this data flow configuration using a barrier guard:

.. code-block:: ql

    class MyConfig extends DataFlow::Configuration {
      override predicate isBarrierGuard(DataFlow::BarrierGuardNode node) {
        node instanceof MyBarrierGuard
      }
      ..
    }

    class MyBarrierGuard extends DataFlow::BarrierGuardNode {
      MyBarrierGuard() { ... }

      override predicate blocks(Expr e, boolean outcome) { ... }
    }

This can be migrated to the shared data flow library as follows:

.. code-block:: ql

    module MyConfig implements DataFlow::ConfigSig {
      predicate isBarrier(DataFlow::Node node) {
        node = DataFlow::MakeBarrierGuard<MyBarrierGuard>::getABarrierNode()
      }
      ..
    }

    class MyBarrierGuard extends DataFlow::Node {
      MyBarrierGuard() { ... }

      predicate blocksExpr(Expr e, boolean outcome) { ... }
    }

The changes can be summarized as:
- The contents of ``isBarrierGuard`` have been moved to ``isBarrier``.
- The ``node instanceof MyBarrierGuard`` check was replaced with ``node = DataFlow::MakeBarrierGuard<MyBarrierGuard>::getABarrierNode()``.
- The ``MyBarrierGuard`` class no longer has ``DataFlow::BarrierGuardNode`` as a base class. We simply use ``DataFlow::Node`` instead.
- The ``blocks`` predicate has been renamed to ``blocksExpr`` and no longer has the ``override`` keyword.

See :ref:`using flow state <using-flow-labels-for-precise-data-flow-analysis>` for examples of how to use barrier guards with flow state.

Query-specific load and store steps
-----------------------------------

The predicates ``isAdditionalLoadStep``, ``isAdditionalStoreStep``, and ``isAdditionalLoadStoreStep`` have been removed. There is no way to emulate the original behavior.

Library models can still contribute such steps, but they will be applicable to all queries. Also see the section on jump steps further down.

Changes in behavior
--------------------

When the query has been migrated to the new interface, it may seem to behave differently due to some technical differences in the internals of
the two data flow libraries. The most significant changes are described below.

Taint steps now propagate all flow states
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

There's an important change from the old data flow library when using flow state and taint-tracking together.

When using ``TaintTracking::GlobalWithState``, all flow states can propagate along taint steps.
In the old data flow library, only the ``taint`` flow label could propagate along taint steps.
A straightforward translation of such a query may therefore result in new flow paths being found, which might be unexpected.

To emulate the old behavior, use ``DataFlow::GlobalWithState`` instead of ``TaintTracking::GlobalWithState``,
and manually add taint steps using ``isAdditionalFlowStep``. The predicate ``TaintTracking::defaultTaintStep`` can be used to access to the set of taint steps.

For example:

.. code-block:: ql

    module MyConfig implements DataFlow::StateConfigSig {
      class FlowState extends string {
        FlowState() { this = ["taint", "foo"] }
      }

      predicate isAdditionalFlowStep(DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2) {
        // Allow taint steps to propagate the "taint" flow state
        TaintTracking::defaultTaintStep(node1, node2) and
        state1 = "taint" and
        state2 = state
      }

      ...
    }

    module MyFlow = DataFlow::GlobalWithState<MyConfig>;


Jump steps across function boundaries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

When a flow step crosses a function boundary, that is, it starts and ends in two different functions, it will now be classified as a "jump" step.

Jump steps can be problematic in some cases. Roughly speaking, the data flow library will "forget" which call site it came from when following a jump step.
This can lead to spurious flow paths that go into a function through one call site, and back out of a different call site.

If the step was generated by a library model, that is, the step is applicable to all queries, this is best mitigated by converting the step to a flow summary.
For example, the following library model adds a taint step from ``x`` to ``y`` in ``foo.bar(x, y => {})``:

.. code-block:: ql

    class MyStep extends TaintTracking::SharedTaintStep {
      override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
        exists(DataFlow::CallNode call |
          call = DataFlow::moduleMember("foo", "bar").getACall() and
          node1 = call.getArgument(0) and
          node2 = call.getCallback(1).getParameter(0)
        )
      }
    }

Because this step crosses a function boundary, it becomes a jump step. This can be avoided by converting it to a flow summary as follows:

.. code-block:: ql

    class MySummary extends DataFlow::SummarizedCallable {
      MySummary() { this = "MySummary" }

      override DataFlow::CallNode getACall() { result = DataFlow::moduleMember("foo", "bar").getACall() }

      override predicate propagatesFlow(string input, string output, boolean preservesValue) {
        input = "Argument[this]" and
        output = "Argument[1].Parameter[0]" and
        preservesValue = false // taint step
      }
    }

See :ref:`customizing library models for JavaScript <customizing-library-models-for-javascript>` for details about the format of the ``input`` and ``output`` strings.
The aforementioned article also provides guidance on how to store the flow summary in a data extension.

For query-specific steps that cross function boundaries, that is, steps added with ``isAdditionalFlowStep``, there is currently no way to emulate the original behavior.
A possible workaround is to convert the query-specific step to a flow summary. In this case it should be stored in a data extension to avoid performance issues, although this also means
that all other queries will be able to use the flow summary.

Barriers block all flows
~~~~~~~~~~~~~~~~~~~~~~~~

In the shared data flow library, a barrier blocks all flows, even if the tracked value is inside a content.

In the old data flow library, only barriers specific to the ``data`` flow label blocked flows when the tracked value was inside a content.

This rarely has significant impact, but some users may observe some result changes because of this.

There is currently no way to emulate the original behavior.

Further reading
---------------

- :ref:`Analyzing data flow in JavaScript and TypeScript <analyzing-data-flow-in-javascript-and-typescript>` provides a general guide to the new data flow library.
- :ref:`Using flow state for precise data flow analysis <using-flow-labels-for-precise-data-flow-analysis>` provides a general guide on using flow state.
