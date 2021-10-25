Path queries
============

Path queries provide information about the identified paths from sources to sinks. Paths can be examined in the Path Explorer view.

Use this template:

.. code-block:: ql

   /**
    * ... 
    * @kind path-problem
    */
   
   import semmle.code.<language>.dataflow.TaintTracking
   import DataFlow::PathGraph
   ...
   from Configuration cfg, DataFlow::PathNode source, DataFlow::PathNode sink
   where cfg.hasFlowPath(source, sink)
   select sink, source, sink, "<message>"

.. note::

  To see the paths between the source and the sinks, we can convert the query to a path problem query. There are a few minor changes that need to be made for this to work–we need an additional import, to specify ``PathNode`` rather than ``Node``, and to add the source/sink to the query output (so that we can automatically determine the paths).