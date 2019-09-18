Analyzing data flow in Java
============================

Overview
--------

This topic describes how data flow analysis is implemented in the QL for Java library and includes examples to help you write your own data flow queries.
The following sections describe how to utilize the QL libraries for local data flow, global data flow and taint tracking.

For a more general introduction to modeling data flow in QL, see :doc:`Introduction to data flow analysis in QL <../intro-to-data-flow>`.

Local data flow
---------------

Local data flow is data flow within a single method or callable. Local data flow is usually easier, faster, and more precise than global data flow, and is sufficient for many queries.

Using local data flow
~~~~~~~~~~~~~~~~~~~~~

The local data flow library is in the module ``DataFlow``, which defines the class ``Node`` denoting any element that data can flow through. ``Node``\ s are divided into expression nodes (``ExprNode``) and parameter nodes (``ParameterNode``). It is possible to map between data flow nodes and expressions/parameters using the member predicates ``asExpr`` and ``asParameter``:

.. code-block:: ql

   class Node {
     /** Gets the expression corresponding to this node, if any. */
     Expr asExpr() { ... }

     /** Gets the parameter corresponding to this node, if any. */
     Parameter asParameter() { ... }

     ...
   }

or using the predicates ``exprNode`` and ``parameterNode``:

.. code-block:: ql

   /**
    * Gets the node corresponding to expression `e`.
    */
   ExprNode exprNode(Expr e) { ... }

   /**
    * Gets the node corresponding to the value of parameter `p` at function entry.
    */
   ParameterNode parameterNode(Parameter p) { ... }

The predicate ``localFlowStep(Node nodeFrom, Node, nodeTo)`` holds if there is an immediate data flow edge from the node ``nodeFrom`` to the node ``nodeTo``. The predicate can be applied recursively (using the ``+`` and ``*`` operators), or through the predefined recursive predicate ``localFlow``, which is equivalent to ``localFlowStep*``.

For example, finding flow from a parameter ``source`` to an expression ``sink`` in zero or more local steps can be achieved as follows:

.. code-block:: ql

   DataFlow::localFlow(DataFlow::parameterNode(source), DataFlow::exprNode(sink))

Using local taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~

Local taint tracking extends local data flow by including non-value-preserving flow steps. For example:

.. code-block:: java

     String temp = x;
     String y = temp + ", " + temp;

If ``x`` is a tainted string then ``y`` is also tainted.

The local taint tracking library is in the module ``TaintTracking``. Like local data flow, a predicate ``localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)`` holds if there is an immediate taint propagation edge from the node ``nodeFrom`` to the node ``nodeTo``. The predicate can be applied recursively (using the ``+`` and ``*`` operators), or through the predefined recursive predicate ``localTaint``, which is equivalent to ``localTaintStep*``.

For example, finding taint propagation from a parameter ``source`` to an expression ``sink`` in zero or more local steps can be achieved as follows:

.. code-block:: ql

   TaintTracking::localTaint(DataFlow::parameterNode(source), DataFlow::exprNode(sink))

Examples
~~~~~~~~

The following query finds the filename passed to ``new FileReader(..)``.

.. code-block:: ql

   import java

   from Constructor fileReader, Call call
   where
     fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
     call.getCallee() = fileReader
   select call.getArgument(0)

Unfortunately, this will only give the expression in the argument, not the values which could be passed to it. So we use local data flow to find all expressions that flow into the argument:

.. code-block:: ql

   import java
   import semmle.code.java.dataflow.DataFlow

   from Constructor fileReader, Call call, Expr src
   where
     fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
     call.getCallee() = fileReader and
     DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(call.getArgument(0)))
   select src

Then we can make the source more specific, for example an access to a public parameter. The following query finds where a public parameter is passed to ``new FileReader(..)``:

.. code-block:: ql

   import java
   import semmle.code.java.dataflow.DataFlow

   from Constructor fileReader, Call call, Parameter p
   where
     fileReader.getDeclaringType().hasQualifiedName("java.io", "FileReader") and
     call.getCallee() = fileReader and
     DataFlow::localFlow(DataFlow::parameterNode(p), DataFlow::exprNode(fc.getArgument(0)))
   select p

The following example finds calls to formatting functions where the format string is not hard-coded.

.. code-block:: ql

   import java
   import semmle.code.java.dataflow.DataFlow
   import semmle.code.java.StringFormat

   from StringFormatMethod format, MethodAccess call, Expr formatString
   where
     call.getMethod() = format and
     call.getArgument(format.getFormatStringIndex()) = formatString and
     not exists(DataFlow::Node source, DataFlow::Node sink |
       DataFlow::localFlow(source, sink) and
       source.asExpr() instanceof StringLiteral and
       sink.asExpr() = formatString
     )
   select call, "Argument to String format method isn't hard-coded."

Exercises
~~~~~~~~~

Exercise 1: Write a query that finds all hard-coded strings used to create a ``java.net.URL``, using local data flow. (`Answer <#exercise-1>`__)

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow. However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

The global data flow library is used by extending the class ``DataFlow::Configuration`` as follows:

.. code-block:: ql

   import semmle.code.java.dataflow.DataFlow

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
-  ``isAdditionalFlowStep``—optional, adds additional flow steps

The characteristic predicate ``MyDataFlowConfiguration()`` defines the name of the configuration, so ``"MyDataFlowConfiguration"`` should be a unique name, for example, the name of your class.

The data flow analysis is performed using the predicate ``hasFlow(DataFlow::Node source, DataFlow::Node sink)``:

.. code-block:: ql

   from MyDataFlowConfiguration dataflow, DataFlow::Node source, DataFlow::Node sink
   where dataflow.hasFlow(source, sink)
   select source, "Data flow to $@.", sink, sink.toString()

Using global taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global taint tracking is to global data flow as local taint tracking is to local data flow. That is, global taint tracking extends global data flow with additional non-value-preserving steps. The global taint tracking library is used by extending the class ``TaintTracking::Configuration`` as follows:

.. code-block:: ql

   import semmle.code.java.dataflow.TaintTracking

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
-  ``isAdditionalTaintStep``—optional, adds additional taint steps

Similar to global data flow, the characteristic predicate ``MyTaintTrackingConfiguration()`` defines the unique name of the configuration.

The taint tracking analysis is performed using the predicate ``hasFlow(DataFlow::Node source, DataFlow::Node sink)``.

Flow sources
~~~~~~~~~~~~

The data flow library contains some predefined flow sources. The class ``RemoteFlowSource`` (defined in ``semmle.code.java.dataflow.FlowSources``) represents data flow sources that may be controlled by a remote user, which is useful for finding security problems.

Examples
~~~~~~~~

The following example shows a taint-tracking configuration that uses remote user input as data sources.

.. code-block:: ql

   import java
   import semmle.code.java.dataflow.FlowSources

   class MyTaintTrackingConfiguration extends TaintTracking::Configuration {
     MyTaintTrackingConfiguration() {
       this = "..."
     }

     override predicate isSource(DataFlow::Node source) {
       source instanceof RemoteFlowSource
     }

     ...
   }

Exercises
~~~~~~~~~

Exercise 2: Write a query that finds all hard-coded strings used to create a ``java.net.URL``, using global data flow. (`Answer <#exercise-2>`__)

Exercise 3: Write a class that represents flow sources from ``java.lang.System.getenv(..)``. (`Answer <#exercise-3>`__)

Exercise 4: Using the answers from 2 and 3, write a query which finds all global data flows from ``getenv`` to ``java.net.URL``. (`Answer <#exercise-4>`__)

What next?
----------

-  Try the worked examples in the following topics: :doc:`Tutorial: Navigating the call graph <call-graph>` and :doc:`Tutorial: Working with source locations <source-locations>`.
-  Find out more about QL in the `QL language handbook <https://help.semmle.com/QL/ql-handbook/index.html>`__ and `QL language specification <https://help.semmle.com/QL/ql-spec/language.html>`__.
-  Learn more about the query console in `Using the query console <https://lgtm.com/help/lgtm/using-query-console>`__.

Answers
-------

Exercise 1
~~~~~~~~~~

.. code-block:: ql

   import semmle.code.java.dataflow.DataFlow

   from Constructor url, Call call, StringLiteral src
   where
     url.getDeclaringType().hasQualifiedName("java.net", "URL") and
     call.getCallee() = url and
     DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(call.getArgument(0)))
   select src

Exercise 2
~~~~~~~~~~

.. code-block:: ql

   import semmle.code.java.dataflow.DataFlow

   class Configuration extends DataFlow::Configuration {
     Configuration() {
       this = "LiteralToURL Configuration"
     }

     override predicate isSource(DataFlow::Node source) {
       source.asExpr() instanceof StringLiteral
     }

     override predicate isSink(DataFlow::Node sink) {
       exists(Call call |
         sink.asExpr() = call.getArgument(0) and
         call.getCallee().(Constructor).getDeclaringType().hasQualifiedName("java.net", "URL")
       )
     }
   }

   from DataFlow::Node src, DataFlow::Node sink, Configuration config
   where config.hasFlow(src, sink)
   select src, "This string constructs a URL $@.", sink, "here"

Exercise 3
~~~~~~~~~~

.. code-block:: ql

   import java

   class GetenvSource extends MethodAccess {
     GetenvSource() {
       exists(Method m | m = this.getMethod() |
         m.hasName("getenv") and
         m.getDeclaringType() instanceof TypeSystem
       )
     }
   }

Exercise 4
~~~~~~~~~~

.. code-block:: ql

   import semmle.code.java.dataflow.DataFlow

   class GetenvSource extends DataFlow::ExprNode {
     GetenvSource() {
       exists(Method m | m = this.asExpr().(MethodAccess).getMethod() |
         m.hasName("getenv") and
         m.getDeclaringType() instanceof TypeSystem
       )
     }
   }

   class GetenvToURLConfiguration extends DataFlow::Configuration {
     GetenvToURLConfiguration() {
       this = "GetenvToURLConfiguration"
     }

     override predicate isSource(DataFlow::Node source) {
       source instanceof GetenvSource
     }

     override predicate isSink(DataFlow::Node sink) {
       exists(Call call |
         sink.asExpr() = call.getArgument(0) and
         call.getCallee().(Constructor).getDeclaringType().hasQualifiedName("java.net", "URL")
       )
     }
   }

   from DataFlow::Node src, DataFlow::Node sink, GetenvToURLConfiguration config
   where config.hasFlow(src, sink)
   select src, "This environment variable constructs a URL $@.", sink, "here"
