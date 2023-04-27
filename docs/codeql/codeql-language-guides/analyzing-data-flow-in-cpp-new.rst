.. _analyzing-data-flow-in-cpp-new:

.. pull-quote:: Note

   The data flow library described here is available from CodeQL 2.12.5 onwards. For information on the previous version of the library, see :ref:`Analyzing data flow in C and C++ <analyzing-data-flow-in-cpp>`.

Analyzing data flow in C and C++ (new)
======================================

You can use data flow analysis to track the flow of potentially malicious or insecure data that can cause vulnerabilities in your codebase.

About data flow
---------------

Data flow analysis computes the possible values that a variable can hold at various points in a program, determining how those values propagate through the program, and where they are used. In CodeQL, you can model both local data flow and global data flow. For a more general introduction to modeling data flow, see ":ref:`About data flow analysis <about-data-flow-analysis>`."

Local data flow
---------------

Local data flow is data flow within a single function. Local data flow is usually easier, faster, and more precise than global data flow, and is sufficient for many queries.

Using local data flow
~~~~~~~~~~~~~~~~~~~~~

The local data flow library is in the module ``DataFlow``, which defines the class ``Node`` denoting any element that data can flow through. ``Node``\ s are divided into expression nodes (``ExprNode``, ``IndirectExprNode``) and parameter nodes (``ParameterNode``, ``IndirectParameterNode``). The indirect nodes represent expressions or parameters after a fixed number of pointer dereferences.

It is possible to map between data flow nodes and expressions or parameters using the member predicates ``asExpr``, ``asIndirectExpr``, and ``asParameter``:

.. code-block:: ql

   class Node {
     /**
      * Gets the expression corresponding to this node, if any.
      */
     Expr asExpr() { ... }

     /**
      * Gets the expression corresponding to a node that is obtained after dereferencing
      * the expression `index` times, if any.
      */
     Expr asIndirectExpr(int index) { ... }

     /**
      * Gets the parameter corresponding to this node, if any.
      */
     Parameter asParameter() { ... }

     /**
      * Gets the parameter corresponding to a node that is obtained after dereferencing
      * the parameter `index` times.
      */
     Parameter asParameter(int index) { ... }

     ...
   }

The predicate ``localFlowStep(Node nodeFrom, Node nodeTo)`` holds if there is an immediate data flow edge from the node ``nodeFrom`` to the node ``nodeTo``. The predicate can be applied recursively (using the ``+`` and ``*`` operators), or through the predefined recursive predicate ``localFlow``, which is equivalent to ``localFlowStep*``.

For example, finding flow from a parameter ``source`` to an expression ``sink`` in zero or more local steps can be achieved as follows, where ``nodeFrom`` and ``nodeTo`` are of type ``DataFlow::Node``:

.. code-block:: ql

   nodeFrom.asParameter() = source and
   nodeTo.asExpr() = sink and
   DataFlow::localFlow(nodeFrom, nodeTo)

Using local taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~

Local taint tracking extends local data flow by including non-value-preserving flow steps. For example:

.. code-block:: cpp

   int i = tainted_user_input();
   some_big_struct *array = malloc(i * sizeof(some_big_struct));

In this case, the argument to ``malloc`` is tainted.

The local taint tracking library is in the module ``TaintTracking``. Like local data flow, a predicate ``localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)`` holds if there is an immediate taint propagation edge from the node ``nodeFrom`` to the node ``nodeTo``. The predicate can be applied recursively (using the ``+`` and ``*`` operators), or through the predefined recursive predicate ``localTaint``, which is equivalent to ``localTaintStep*``.

For example, finding taint propagation from a parameter ``source`` to an expression ``sink`` in zero or more local steps can be achieved as follows, where ``nodeFrom`` and ``nodeTo`` are of type ``DataFlow::Node``:

.. code-block:: ql

   nodeFrom.asParameter() = source and
   nodeTo.asExpr() = sink and
   TaintTracking::localTaint(nodeFrom, nodeTo)

Examples
~~~~~~~~

The following query finds the filename passed to ``fopen``:

.. code-block:: ql

   import cpp

   from Function fopen, FunctionCall fc
   where
     fopen.hasGlobalName("fopen") and
     fc.getTarget() = fopen
   select fc.getArgument(0)

However, this will only give the expression in the argument, not the values which could be passed to it. Instead we can use local data flow to find all expressions that flow into the argument, where we use ``asIndirectExpr(1)``. This is because we are interested in the value of the string passed to `fopen`, not the pointer pointing to it:

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.new.DataFlow

   from Function fopen, FunctionCall fc, Expr src, DataFlow::Node source, DataFlow::Node sink
   where
     fopen.hasGlobalName("fopen") and
     fc.getTarget() = fopen and
     source.asIndirectExpr(1) = src and
     sink.asIndirectExpr(1) = fc.getArgument(0) and
     DataFlow::localFlow(source, sink)
   select src

Then we can vary the source and, for example, use the parameter of a function. The following query finds where a parameter is used when opening a file:

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.new.DataFlow

   from Function fopen, FunctionCall fc, Parameter p, DataFlow::Node source, DataFlow::Node sink
   where
     fopen.hasGlobalName("fopen") and
     fc.getTarget() = fopen and
     source.asParameter(1) = p and
     sink.asIndirectExpr(1) = fc.getArgument(0) and
     DataFlow::localFlow(source, sink)
   select p

The following example finds calls to formatting functions where the format string is not hard-coded.

.. code-block:: ql

   import semmle.code.cpp.dataflow.new.DataFlow
   import semmle.code.cpp.commons.Printf

   from FormattingFunction format, FunctionCall call, Expr formatString, DataFlow::Node sink
   where
     call.getTarget() = format and
     call.getArgument(format.getFormatParameterIndex()) = formatString and
     sink.asIndirectExpr(1) = formatString and
     not exists(DataFlow::Node source |
       DataFlow::localFlow(source, sink) and
       source.asIndirectExpr(1) instanceof StringLiteral
     )
   select call, "Argument to " + format.getQualifiedName() + " isn't hard-coded."

Exercises
~~~~~~~~~

Exercise 1: Write a query that finds all hard-coded strings used to create a ``host_ent`` via ``gethostbyname``, using local data flow. (`Answer <#exercise-1>`__)

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow. However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

.. pull-quote:: Note

   .. include:: ../reusables/path-problem.rst

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

The global data flow library is used by extending the class ``DataFlow::Configuration`` as follows:

.. code-block:: ql

   import semmle.code.cpp.dataflow.new.DataFlow

   class MyDataFlowConfiguration extends DataFlow::Configuration {
     MyDataFlowConfiguration() { this = "MyDataFlowConfiguration" }

     override predicate isSource(DataFlow::Node source) {
       ...
     }

     override predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

The following predicates are defined in the configuration:

-  ``isSource``—defines where data may flow from
-  ``isSink``—defines where data may flow to
-  ``isBarrier``—optional, restricts the data flow
-  ``isBarrierGuard``—optional, restricts the data flow
-  ``isAdditionalFlowStep``—optional, adds additional flow steps

The characteristic predicate ``MyDataFlowConfiguration()`` defines the name of the configuration, so ``"MyDataFlowConfiguration"`` should be replaced by the name of your class.

The data flow analysis is performed using the predicate ``hasFlow(DataFlow::Node source, DataFlow::Node sink)``:

.. code-block:: ql

   from MyDataFlowConfiguration dataflow, DataFlow::Node source, DataFlow::Node sink
   where dataflow.hasFlow(source, sink)
   select source, "Data flow to $@.", sink, sink.toString()

Using global taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global taint tracking is to global data flow as local taint tracking is to local data flow. That is, global taint tracking extends global data flow with additional non-value-preserving steps. The global taint tracking library is used by extending the class ``TaintTracking::Configuration`` as follows:

.. code-block:: ql

   import semmle.code.cpp.dataflow.new.TaintTracking

   class MyTaintTrackingConfiguration extends TaintTracking::Configuration {
     MyTaintTrackingConfiguration() { this = "MyTaintTrackingConfiguration" }

     override predicate isSource(DataFlow::Node source) {
       ...
     }

     override predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

The following predicates are defined in the configuration:

-  ``isSource``—defines where taint may flow from
-  ``isSink``—defines where taint may flow to
-  ``isSanitizer``—optional, restricts the taint flow
-  ``isSanitizerGuard``—optional, restricts the taint flow
-  ``isAdditionalTaintStep``—optional, adds additional taint steps

Similar to global data flow, the characteristic predicate ``MyTaintTrackingConfiguration()`` defines the unique name of the configuration, so ``"MyTaintTrackingConfiguration"`` should be replaced by the name of your class.

The taint tracking analysis is performed using the predicate ``hasFlow(DataFlow::Node source, DataFlow::Node sink)``.

Examples
~~~~~~~~

The following data flow configuration tracks data flow from environment variables to opening files in a Unix-like environment:

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.new.DataFlow

   class EnvironmentToFileConfiguration extends DataFlow::Configuration {
     EnvironmentToFileConfiguration() { this = "EnvironmentToFileConfiguration" }

     override predicate isSource(DataFlow::Node source) {
       exists(Function getenv |
         source.asIndirectExpr(1).(FunctionCall).getTarget() = getenv and
         getenv.hasGlobalName("getenv")
       )
     }

     override predicate isSink(DataFlow::Node sink) {
       exists(FunctionCall fc |
         sink.asIndirectExpr(1) = fc.getArgument(0) and
         fc.getTarget().hasGlobalName("fopen")
       )
     }
   }

   from
     Expr getenv, Expr fopen, EnvironmentToFileConfiguration config, DataFlow::Node source,
     DataFlow::Node sink
   where
     source.asIndirectExpr(1) = getenv and
     sink.asIndirectExpr(1) = fopen and
     config.hasFlow(source, sink)
   select fopen, "This 'fopen' uses data from $@.", getenv, "call to 'getenv'"

The following taint-tracking configuration tracks data from a call to ``ntohl`` to an array index operation. It uses the ``Guards`` library to recognize expressions that have been bounds-checked, and defines ``isSanitizer`` to prevent taint from propagating through them. It also uses ``isAdditionalTaintStep`` to add flow from loop bounds to loop indexes.

.. code-block:: ql

   import cpp
   import semmle.code.cpp.controlflow.Guards
   import semmle.code.cpp.dataflow.new.TaintTracking

   class NetworkToBufferSizeConfiguration extends TaintTracking::Configuration {
     NetworkToBufferSizeConfiguration() { this = "NetworkToBufferSizeConfiguration" }

     override predicate isSource(DataFlow::Node node) {
       node.asExpr().(FunctionCall).getTarget().hasGlobalName("ntohl")
     }

     override predicate isSink(DataFlow::Node node) {
       exists(ArrayExpr ae | node.asExpr() = ae.getArrayOffset())
     }

     override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
       exists(Loop loop, LoopCounter lc |
         loop = lc.getALoop() and
         loop.getControllingExpr().(RelationalOperation).getGreaterOperand() = pred.asExpr()
       |
         succ.asExpr() = lc.getVariableAccessInLoop(loop)
       )
     }

     override predicate isSanitizer(DataFlow::Node node) {
       exists(GuardCondition gc, Variable v |
         gc.getAChild*() = v.getAnAccess() and
         node.asExpr() = v.getAnAccess() and
         gc.controls(node.asExpr().getBasicBlock(), _) and
         not exists(Loop loop | loop.getControllingExpr() = gc)
       )
     }
   }

   from DataFlow::Node ntohl, DataFlow::Node offset, NetworkToBufferSizeConfiguration conf
   where conf.hasFlow(ntohl, offset)
   select offset, "This array offset may be influenced by $@.", ntohl,
     "converted data from the network"

Exercises
~~~~~~~~~

Exercise 2: Write a query that finds all hard-coded strings used to create a ``host_ent`` via ``gethostbyname``, using global data flow. (`Answer <#exercise-2>`__)

Exercise 3: Write a class that represents flow sources from ``getenv``. (`Answer <#exercise-3>`__)

Exercise 4: Using the answers from 2 and 3, write a query which finds all global data flows from ``getenv`` to ``gethostbyname``. (`Answer <#exercise-4>`__)

Answers
-------

Exercise 1
~~~~~~~~~~

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.new.DataFlow

   from StringLiteral sl, FunctionCall fc, DataFlow::Node source, DataFlow::Node sink
   where
     fc.getTarget().hasName("gethostbyname") and
     source.asIndirectExpr(1) = sl and
     sink.asIndirectExpr(1) = fc.getArgument(0) and
     DataFlow::localFlow(source, sink)
   select sl, fc

Exercise 2
~~~~~~~~~~

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.new.DataFlow

   class LiteralToGethostbynameConfiguration extends DataFlow::Configuration {
     LiteralToGethostbynameConfiguration() { this = "LiteralToGethostbynameConfiguration" }

     override predicate isSource(DataFlow::Node source) {
       source.asIndirectExpr(1) instanceof StringLiteral
     }

     override predicate isSink(DataFlow::Node sink) {
       exists(FunctionCall fc |
         sink.asIndirectExpr(1) = fc.getArgument(0) and
         fc.getTarget().hasName("gethostbyname")
       )
     }
   }

   from
     StringLiteral sl, FunctionCall fc, LiteralToGethostbynameConfiguration cfg, DataFlow::Node source,
     DataFlow::Node sink
   where
     source.asIndirectExpr(1) = sl and
     sink.asIndirectExpr(1) = fc.getArgument(0) and
     cfg.hasFlow(source, sink)
   select sl, fc

Exercise 3
~~~~~~~~~~

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.new.DataFlow

   class GetenvSource extends DataFlow::Node {
     GetenvSource() { this.asIndirectExpr(1).(FunctionCall).getTarget().hasGlobalName("getenv") }
   }

Exercise 4
~~~~~~~~~~

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.new.DataFlow

   class GetenvSource extends DataFlow::Node {
     GetenvSource() { this.asIndirectExpr(1).(FunctionCall).getTarget().hasGlobalName("getenv") }
   }

   class GetenvToGethostbynameConfiguration extends DataFlow::Configuration {
     GetenvToGethostbynameConfiguration() { this = "GetenvToGethostbynameConfiguration" }

     override predicate isSource(DataFlow::Node source) { source instanceof GetenvSource }

     override predicate isSink(DataFlow::Node sink) {
       exists(FunctionCall fc |
         sink.asIndirectExpr(1) = fc.getArgument(0) and
         fc.getTarget().hasName("gethostbyname")
       )
     }
   }

   from
     Expr getenv, FunctionCall fc, GetenvToGethostbynameConfiguration cfg, DataFlow::Node source,
     DataFlow::Node sink
   where
     source.asIndirectExpr(1) = getenv and
     sink.asIndirectExpr(1) = fc.getArgument(0) and
     cfg.hasFlow(source, sink)
   select getenv, fc

Further reading
---------------

- ":ref:`Exploring data flow with path queries <exploring-data-flow-with-path-queries>`"


.. include:: ../reusables/cpp-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst