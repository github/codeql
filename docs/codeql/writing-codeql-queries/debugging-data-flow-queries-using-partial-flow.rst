.. _debugging-data-flow-queries-using-partial-flow:

Debugging data-flow queries using partial flow
==============================================

If a data-flow query doesn't produce the results you expect to see, you can use partial flow to debug the problem.

In CodeQL, you can use :ref:`data flow analysis <about-data-flow-analysis>` to compute the possible values that a variable can hold at various points in a program.
A typical data-flow query looks like this:

.. code-block:: ql


    class MyConfig extends TaintTracking::Configuration {
      MyConfig() { this = "MyConfig" }

      override predicate isSource(DataFlow::Node node) { node instanceof MySource }

      override predicate isSink(DataFlow::Node node) { node instanceof MySink }
    }

    from MyConfig config, DataFlow::PathNode source, DataFlow::PathNode sink
    where config.hasFlowPath(source, sink)
    select sink.getNode(), source, sink, "Sink is reached from $@.", source.getNode(), "here"

The same query can be slightly simplified by rewriting it without :ref:`path explanations <creating-path-queries>`:

.. code-block:: ql

    from MyConfig config, DataFlow::Node source, DataFlow::Node sink
    where config.hasPath(source, sink)
    select sink, "Sink is reached from $@.", source.getNode(), "here"

If a data-flow query that you have written doesn't produce the results you expect it to, there may be a problem with your query.
You can try to debug the potential problem by following the steps described below. 

Checking sources and sinks
--------------------------

Initially, you should make sure that the source and sink definitions contain what you expect. If either the source or sink is empty then there can never be any data flow. The easiest way to check this is using quick evaluation in CodeQL for VS Code. Select the text ``node instanceof MySource``, right-click, and choose "CodeQL: Quick Evaluation". This will evaluate the highlighted text, which in this case means the set of sources. For more information, see :ref:`Analyzing your projects <running-a-specific-part-of-a-query-or-library>` in the CodeQL for VS Code help.

If both source and sink definitions look good then we will need to look for missing flow steps.

``fieldFlowBranchLimit``
------------------------

Data-flow configurations contain a parameter called ``fieldFlowBranchLimit``. If the value is set too high, you may experience performance degradation, but if it's too low you may miss results. When debugging data flow try setting ``fieldFlowBranchLimit`` to a high value and see whether your query generates more results. For example, try adding the following to your configuration:

.. code-block:: ql

    override int fieldFlowBranchLimit() { result = 5000 }

If there are still no results and performance is still useable, then it is best to leave this set to a high value while doing further debugging.

Partial flow
------------

A naive next step could be to change the sink definition to ``any()``. This would mean that we would get a lot of flow to all the places that are reachable from the sources. While this approach may work in some cases, you might find that it produces so many results that it's very hard to explore the findings. It can also dramatically affect query performance. More importantly, you might not even see all the partial flow paths. This is because the data-flow library tries very hard to prune impossible paths and, since field stores and reads must be evenly matched along a path, we will never see paths going through a store that fail to reach a corresponding read. This can make it hard to see where flow actually stops.

To avoid these problems, a data-flow ``Configuration`` comes with a mechanism for exploring partial flow that tries to deal with these caveats. This is the ``Configuration.hasPartialFlow`` predicate:

.. code-block:: ql

      /**
       * Holds if there is a partial data flow path from `source` to `node`. The
       * approximate distance between `node` and the closest source is `dist` and
       * is restricted to be less than or equal to `explorationLimit()`. This
       * predicate completely disregards sink definitions.
       *
       * This predicate is intended for dataflow exploration and debugging and may
       * perform poorly if the number of sources is too big and/or the exploration
       * limit is set too high without using barriers.
       *
       * This predicate is disabled (has no results) by default. Override
       * `explorationLimit()` with a suitable number to enable this predicate.
       *
       * To use this in a `path-problem` query, import the module `PartialPathGraph`.
       */
      final predicate hasPartialFlow(PartialPathNode source, PartialPathNode node, int dist) {

There is also a ``Configuration.hasPartialFlowRev`` for exploring flow backwards from a sink.

As noted in the documentation for ``hasPartialFlow`` (for example, in the 
`CodeQL for Java documentation <https://codeql.github.com/codeql-standard-libraries/java/semmle/code/java/dataflow/internal/DataFlowImpl2.qll/predicate.DataFlowImpl2$Configuration$hasPartialFlow.3.html>`__) you must first enable this by adding an override of ``explorationLimit``. For example:

.. code-block:: ql

    override int explorationLimit() { result = 5 }

This defines the exploration radius within which ``hasPartialFlow`` returns results.

To get good performance when using ``hasPartialFlow`` it is important to ensure the ``isSink`` predicate of the configuration has no results. Likewise, when using ``hasPartialFlowRev`` the ``isSource`` predicate of the configuration should have no results.

It is also useful to focus on a single source at a time as the starting point for the flow exploration. This is most easily done by adding a temporary restriction in the ``isSource`` predicate.

To do quick evaluations of partial flow it is often easiest to add a predicate to the query that is solely intended for quick evaluation (right-click the predicate name and choose "CodeQL: Quick Evaluation"). A good starting point is something like:

.. code-block:: ql

    predicate adhocPartialFlow(Callable c, PartialPathNode n, Node src, int dist) {
      exists(MyConfig conf, PartialPathNode source |
        conf.hasPartialFlow(source, n, dist) and
        src = source.getNode() and
        c = n.getNode().getEnclosingCallable()
      )
    }

If you are focusing on a single source then the ``src`` column is superfluous. You may of course also add other columns of interest based on ``n``, but including the enclosing callable and the distance to the source at the very least is generally recommended, as they can be useful columns to sort on to better inspect the results.


If you see a large number of partial flow results, you can focus them in a couple of ways: 

- If flow travels a long distance following an expected path, that can result in a lot of uninteresting flow being included in the exploration radius. To reduce the amount of uninteresting flow, you can replace the source definition with a suitable ``node`` that appears along the path and restart the partial flow exploration from that point. 
- Creative use of barriers and sanitizers can be used to cut off flow paths that are uninteresting. This also reduces the number of partial flow results to explore while debugging.

Further reading
----------------

- :ref:`About data flow analysis <about-data-flow-analysis>`
- :ref:`Creating path queries <creating-path-queries>`
