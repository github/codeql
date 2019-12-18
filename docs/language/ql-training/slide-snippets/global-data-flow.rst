Information flow
================

- Many security problems can be phrased as an information flow problem:

  Given a (problem-specific) set of sources and sinks, is there a path in the data flow graph from some source to some sink?

- Some examples:

  - SQL injection: sources are user-input, sinks are SQL queries
  - Reflected XSS: sources are HTTP requests, sinks are HTTP responses

- We can solve such problems using the data flow and taint tracking libraries.

Global data flow and taint tracking
===================================

- Recap:

  - Local (“intra-procedural”) data flow models flow within one function; feasible to compute for all functions in a CodeQL database
  - Global (“inter-procedural”) data flow models flow across function calls; not feasible to compute for all functions in a CodeQL database

- For global data flow (and taint tracking), we must therefore provide restrictions to ensure the problem is tractable.
- Typically, this involves specifying the *source* and *sink*.

.. note::

  As we mentioned in the previous slide deck, while local data flow is feasible to compute for all functions in a CodeQL database, global data flow is not. This is because the number of paths becomes exponentially larger for global data flow.

  The global data flow (and taint tracking) avoids this problem by requiring that the query author specifies which ``sources`` and ``sinks`` are applicable. This allows the implementation to compute paths between the restricted set of nodes, rather than the full graph.

Global taint tracking library
=============================

The ``semmle.code.<language>.dataflow.TaintTracking`` library provides a framework for implementing solvers for global taint tracking problems:

  #. Subclass ``TaintTracking::Configuration`` following this template:

     .. code-block:: ql
    
       class Config extends TaintTracking::Configuration {
         Config() { this = "<some unique identifier>" }
         override predicate isSource(DataFlow::Node nd) { ... }
         override predicate isSink(DataFlow::Node nd) { ... }
       }

  #. Use ``Config.hasFlow(source, sink)`` to find inter-procedural paths.

.. note::

  In addition to the taint tracking configuration described here, there is also an equivalent *data flow* configuration in ``semmle.code.<language>.dataflow.DataFlow``, ``DataFlow::Configuration``. Data flow configurations are used to track whether the exact value produced by a source is used by a sink, whereas taint tracking configurations are used to determine whether the source may influence the value used at the sink. Whether you use taint tracking or data flow depends on the analysis problem you are trying to solve.
