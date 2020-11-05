Analyzing data flow in C#
=========================

You can use CodeQL to track the flow of data through a C# program to its use. 

About this article
------------------

This article describes how data flow analysis is implemented in the CodeQL libraries for C# and includes examples to help you write your own data flow queries.
The following sections describe how to use the libraries for local data flow, global data flow, and taint tracking.
For a more general introduction to modeling data flow, see ":doc:`About data flow analysis <../intro-to-data-flow>`."

Local data flow
---------------

Local data flow is data flow within a single method or callable. Local data flow is easier, faster, and more precise than global data flow, and is sufficient for many queries.

Using local data flow
~~~~~~~~~~~~~~~~~~~~~

The local data flow library is in the module ``DataFlow``, which defines the class ``Node`` denoting any element that data can flow through. ``Node``\ s are divided into expression nodes (``ExprNode``) and parameter nodes (``ParameterNode``). You can map between data flow nodes and expressions/parameters using the member predicates ``asExpr`` and ``asParameter``:

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

The predicate ``localFlowStep(Node nodeFrom, Node nodeTo)`` holds if there is an immediate data flow edge from the node ``nodeFrom`` to the node ``nodeTo``. You can apply the predicate recursively, by using the ``+`` and ``*`` operators, or you can use the predefined recursive predicate ``localFlow``.

For example, you can find flow from a parameter ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     DataFlow::localFlow(DataFlow::parameterNode(source), DataFlow::exprNode(sink))

Using local taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~

Local taint tracking extends local data flow by including non-value-preserving flow steps. For example:

.. code-block:: csharp

     var temp = x;
     var y = temp + ", " + temp;

If ``x`` is a tainted string then ``y`` is also tainted.

The local taint tracking library is in the module ``TaintTracking``. Like local data flow, a predicate ``localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo)`` holds if there is an immediate taint propagation edge from the node ``nodeFrom`` to the node ``nodeTo``. You can apply the predicate recursively, by using the ``+`` and ``*`` operators, or you can use the predefined recursive predicate ``localTaint``.

For example, you can find taint propagation from a parameter ``source`` to an expression ``sink`` in zero or more local steps:

.. code-block:: ql

     TaintTracking::localTaint(DataFlow::parameterNode(source), DataFlow::exprNode(sink))

Examples
~~~~~~~~

This query finds the filename passed to ``System.IO.File.Open``:

.. code-block:: ql

   import csharp

   from Method fileOpen, MethodCall call
   where fileOpen.hasQualifiedName("System.IO.File.Open")
     and call.getTarget() = fileOpen
   select call.getArgument(0)

Unfortunately this will only give the expression in the argument, not the values which could be passed to it. So we use local data flow to find all expressions that flow into the argument:

.. code-block:: ql

   import csharp

   from Method fileOpen, MethodCall call, Expr src
   where fileOpen.hasQualifiedName("System.IO.File.Open")
     and call.getTarget() = fileOpen
     and DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(call.getArgument(0)))
   select src

Then we can make the source more specific, for example an access to a public parameter. This query finds instances where a public parameter is used to open a file:

.. code-block:: ql

   import csharp

   from Method fileOpen, MethodCall call, Parameter p
   where fileOpen.hasQualifiedName("System.IO.File.Open")
     and call.getTarget() = fileOpen
     and DataFlow::localFlow(DataFlow::parameterNode(p), DataFlow::exprNode(call.getArgument(0)))
     and call.getEnclosingCallable().(Member).isPublic()
   select p, "Opening a file from a public method."

This query finds calls to ``String.Format`` where the format string isn't hard-coded:

.. code-block:: ql

   import csharp

   from Method format, MethodCall call, Expr formatString
   where format.hasQualifiedName("System.String.Format")
     and call.getTarget() = format
     and formatString = call.getArgument(0)
     and formatString.getType() instanceof StringType
     and not exists(StringLiteral source | DataFlow::localFlow(DataFlow::exprNode(source), DataFlow::exprNode(formatString)))
   select call, "Argument to 'string.Format' isn't hard-coded."

Exercises
~~~~~~~~~

Exercise 1: Write a query that finds all hard-coded strings used to create a ``System.Uri``, using local data flow. (`Answer <#exercise-1>`__)

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow. However, global data flow is less precise than local data flow, and the analysis typically requires significantly more time and memory to perform.

.. pull-quote:: Note

   .. include:: ../../reusables/path-problem.rst

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

The global data flow library is used by extending the class ``DataFlow::Configuration``:

.. code-block:: ql

   import csharp

   class MyDataFlowConfiguration extends DataFlow::Configuration {
     MyDataFlowConfiguration() { this = "..." }

     override predicate isSource(DataFlow::Node source) {
       ...
     }

     override predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

These predicates are defined in the configuration:

-  ``isSource`` - defines where data may flow from.
-  ``isSink`` - defines where data may flow to.
-  ``isBarrier`` - optionally, restricts the data flow.
-  ``isAdditionalFlowStep`` - optionally, adds additional flow steps.

The characteristic predicate (``MyDataFlowConfiguration()``) defines the name of the configuration, so ``"..."`` must be replaced with a unique name.

The data flow analysis is performed using the predicate ``hasFlow(DataFlow::Node source, DataFlow::Node sink)``:

.. code-block:: ql

   from MyDataFlowConfiguation dataflow, DataFlow::Node source, DataFlow::Node sink
   where dataflow.hasFlow(source, sink)
   select source, "Dataflow to $@.", sink, sink.toString()

Using global taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global taint tracking is to global data flow what local taint tracking is to local data flow. That is, global taint tracking extends global data flow with additional non-value-preserving steps. The global taint tracking library is used by extending the class ``TaintTracking::Configuration``:

.. code-block:: ql

   import csharp

   class MyTaintTrackingConfiguration extends TaintTracking::Configuration {
     MyTaintTrackingConfiguration() { this = "..." }

     override predicate isSource(DataFlow::Node source) {
       ...
     }

     override predicate isSink(DataFlow::Node sink) {
       ...
     }
   }

These predicates are defined in the configuration:

-  ``isSource`` - defines where taint may flow from.
-  ``isSink`` - defines where taint may flow to.
-  ``isSanitizer`` - optionally, restricts the taint flow.
-  ``isAdditionalTaintStep`` - optionally, adds additional taint steps.

Similar to global data flow, the characteristic predicate (``MyTaintTrackingConfiguration()``) defines the unique name of the configuration and the taint analysis is performed using the predicate ``hasFlow(DataFlow::Node source, DataFlow::Node sink)``.

Flow sources
~~~~~~~~~~~~

The data flow library contains some predefined flow sources. The class ``PublicCallableParameterFlowSource`` (defined in module ``semmle.code.csharp.dataflow.flowsources.PublicCallableParameter``) represents data flow from public parameters, which is useful for finding security problems in a public API.

The class ``RemoteSourceFlow`` (defined in module ``semmle.code.csharp.dataflow.flowsources.Remote``) represents data flow from remote network inputs. This is useful for finding security problems in networked services.

Example
~~~~~~~

This query shows a data flow configuration that uses all public API parameters as data sources:

.. code-block:: ql

   import csharp
   import semmle.code.csharp.dataflow.flowsources.PublicCallableParameter

   class MyDataFlowConfiguration extends DataFlow::Configuration {
     MyDataFlowConfiguration() {
       this = "..."
     }

     override predicate isSource(DataFlow::Node source) {
       source instanceof PublicCallableParameterFlowSource
     }

     ...
   }

Class hierarchy
~~~~~~~~~~~~~~~

-  ``DataFlow::Configuration`` - base class for custom global data flow analysis.
-  ``DataFlow::Node`` - an element behaving as a data flow node.

   -  ``DataFlow::ExprNode`` - an expression behaving as a data flow node.
   -  ``DataFlow::ParameterNode`` - a parameter data flow node representing the value of a parameter at function entry.

      -  ``PublicCallableParameter`` - a parameter to a public method/callable in a public class.

   -  ``RemoteSourceFlow`` - data flow from network/remote input.

      -  ``AspNetRemoteFlowSource`` - data flow from remote ASP.NET user input.

         -  ``AspNetQueryStringRemoteFlowSource`` - data flow from ``System.Web.HttpRequest``.
         -  ``AspNetUserInputRemoveFlowSource`` - data flow from ``System.Web.IO.WebControls.TextBox``.

      -  ``WcfRemoteFlowSource`` - data flow from a WCF web service.
      -  ``AspNetServiceRemoteFlowSource`` - data flow from an ASP.NET web service.

-  ``TaintTracking::Configuration`` - base class for custom global taint tracking analysis.

Examples
~~~~~~~~

This data flow configuration tracks data flow from environment variables to opening files:

.. code-block:: ql

   import csharp

   class EnvironmentToFileConfiguration extends DataFlow::Configuration {
     EnvironmentToFileConfiguration() { this = "Environment opening files" }

     override predicate isSource(DataFlow::Node source) {
       exists(Method m |
         m = source.asExpr().(MethodCall).getTarget() and
         m.hasQualifiedName("System.Environment.GetEnvironmentVariable")
       )
     }

     override predicate isSink(DataFlow::Node sink) {
       exists(MethodCall mc |
         mc.getTarget().hasQualifiedName("System.IO.File.Open") and
         sink.asExpr() = mc.getArgument(0)
       )
     }
   }

   from Expr environment, Expr fileOpen, EnvironmentToFileConfiguration config
   where config.hasFlow(DataFlow::exprNode(environment), DataFlow::exprNode(fileOpen))
   select fileOpen, "This 'File.Open' uses data from $@.",
     environment, "call to 'GetEnvironmentVariable'"

Exercises
~~~~~~~~~

Exercise 2: Find all hard-coded strings passed to ``System.Uri``, using global data flow. (`Answer <#exercise-2>`__)

Exercise 3: Define a class that represents flow sources from ``System.Environment.GetEnvironmentVariable``. (`Answer <#exercise-3>`__)

Exercise 4: Using the answers from 2 and 3, write a query to find all global data flow from ``System.Environment.GetEnvironmentVariable`` to ``System.Uri``. (`Answer <#exercise-4>`__)

Extending library data flow
---------------------------

Library data flow defines how data flows through libraries where the source code is not available, such as the .NET Framework, third-party libraries or proprietary libraries.

To define new library data flow, extend the class ``LibraryTypeDataFlow`` from the module ``semmle.code.csharp.dataflow.LibraryTypeDataFlow``. Override the predicate ``callableFlow`` to define how data flows through the methods in the class. ``callableFlow`` has the signature

.. code-block:: ql

   predicate callableFlow(CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable callable, boolean preservesValue)

-  ``callable`` - the ``Callable`` (such as a method, constructor, property getter or setter) performing the data flow.
-  ``source`` - the data flow input.
-  ``sink`` - the data flow output.
-  ``preservesValue`` - whether the flow step preserves the value, for example if ``x`` is a string then ``x.ToString()`` preserves the value where as ``x.ToLower()`` does not.

Class hierarchy
~~~~~~~~~~~~~~~

-  ``Callable`` - a callable (methods, accessors, constructors etc.)

   -  ``SourceDeclarationCallable`` - an unconstructed callable.

-  ``CallableFlowSource`` - the input of data flow into the callable.

   -  ``CallableFlowSourceQualifier`` - the data flow comes from the object itself.
   -  ``CallableFlowSourceArg`` - the data flow comes from an argument to the call.

-  ``CallableFlowSink`` - the output of data flow from the callable.

   -  ``CallableFlowSinkQualifier`` - the output is to the object itself.
   -  ``CallableFlowSinkReturn`` - the output is returned from the call.
   -  ``CallableFlowSinkArg`` - the output is an argument.
   -  ``CallableFlowSinkDelegateArg`` - the output flows through a delegate argument (for example, LINQ).

Example
~~~~~~~

This example is adapted from ``LibraryTypeDataFlow.qll``. It declares data flow through the class ``System.Uri``, including the constructor, the ``ToString`` method, and the properties ``Query``, ``OriginalString``, and ``PathAndQuery``.

.. code-block:: ql

   import semmle.code.csharp.dataflow.LibraryTypeDataFlow
   import semmle.code.csharp.frameworks.System

   class SystemUriFlow extends LibraryTypeDataFlow, SystemUriClass {
     override predicate callableFlow(CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c, boolean preservesValue) {
       (
         constructorFlow(source, c) and
         sink instanceof CallableFlowSinkQualifier
         or
         methodFlow(c) and
         source instanceof CallableFlowSourceQualifier and
         sink instanceof CallableFlowSinkReturn
         or
         exists(Property p |
           propertyFlow(p) and
           source instanceof CallableFlowSourceQualifier and
           sink instanceof CallableFlowSinkReturn and
           c = p.getGetter()
         )
       )
       and
       preservesValue = false
     }

     private predicate constructorFlow(CallableFlowSourceArg source, Constructor c) {
       c = getAMember()
       and
       c.getParameter(0).getType() instanceof StringType
       and
       source.getArgumentIndex() = 0
     }

     private predicate methodFlow(Method m) {
       m.getDeclaringType() = getABaseType*()
       and
       m = getSystemObjectClass().getToStringMethod().getAnOverrider*()
     }

     private predicate propertyFlow(Property p) {
       p = getPathAndQueryProperty()
       or
       p = getQueryProperty()
       or
       p = getOriginalStringProperty()
     }
   }

This defines a new class ``SystemUriFlow`` which extends ``LibraryTypeDataFlow`` to add another case. It extends ``SystemUriClass`` (the class representing ``System.Uri``, defined in the module ``semmle.code.csharp.frameworks.System``) to access methods such as ``getQueryProperty``.

The predicate ``callableFlow`` declares data flow through ``System.Uri``. The first case (``constructorFlow``) declares data flow from the first argument of the constructor to the object itself (``CallableFlowSinkQualifier``).

The second case declares data flow from the object (``CallableFlowSourceQualifier``) to the result of calling ``ToString`` on the object (``CallableFlowSinkReturn``).

The third case declares data flow from the object (``CallableFlowSourceQualifier``) to the return (``CallableFlowSinkReturn``) of the getters for the properties ``PathAndQuery``, ``Query`` and ``OriginalString``. Note that the properties (``getPathAndQueryProperty``, ``getQueryProperty`` and ``getOriginalStringProperty``) are inherited from the class ``SystemUriClass``.

In all three cases ``preservesValue = false``, which means that these steps will only be included in taint tracking, not in (normal) data flow.

Exercises
~~~~~~~~~

Exercise 5: In ``System.Uri``, what other properties could expose data? How could they be added to ``SystemUriFlow``? (`Answer <#exercise-5>`__)

Exercise 6: Implement the data flow for the class ``System.Exception``. (`Answer <#exercise-6>`__)

--------------

Answers
-------

Exercise 1
~~~~~~~~~~

.. code-block:: ql

   import csharp

   from Expr src, Call c
   where DataFlow::localFlow(DataFlow::exprNode(src), DataFlow::exprNode(c.getArgument(0)))
     and c.getTarget().(Constructor).getDeclaringType().hasQualifiedName("System.Uri")
     and src.hasValue()
   select src, "This string constructs 'System.Uri' $@.", c, "here"

Exercise 2
~~~~~~~~~~

.. code-block:: ql

   import csharp

   class Configuration extends DataFlow::Configuration {
     Configuration() { this="String to System.Uri" }
     
     override predicate isSource(DataFlow::Node src) {
       src.asExpr().hasValue()
     }
     
     override predicate isSink(DataFlow::Node sink) {
       exists(Call c | c.getTarget().(Constructor).getDeclaringType().hasQualifiedName("System.Uri")
       and sink.asExpr()=c.getArgument(0))
     }
   }

   from DataFlow::Node src, DataFlow::Node sink, Configuration config
   where config.hasFlow(src, sink)
   select src, "This string constructs a 'System.Uri' $@.", sink, "here"

Exercise 3
~~~~~~~~~~

.. code-block:: ql

   class EnvironmentVariableFlowSource extends DataFlow::ExprNode {
     EnvironmentVariableFlowSource() { 
       this.getExpr().(MethodCall).getTarget().hasQualifiedName("System.Environment.GetEnvironmentVariable")
     }
   }

Exercise 4
~~~~~~~~~~

.. code-block:: ql

   import csharp

   class EnvironmentVariableFlowSource extends DataFlow::ExprNode {
     EnvironmentVariableFlowSource() { 
       this.getExpr().(MethodCall).getTarget().hasQualifiedName("System.Environment.GetEnvironmentVariable")
     }
   }

   class Configuration extends DataFlow::Configuration {
     Configuration() { this="Environment to System.Uri" }
     
     override predicate isSource(DataFlow::Node src) {
       src.asExpr() instanceof EnvironmentVariableFlowSource
     }
     
     override predicate isSink(DataFlow::Node sink) {
       exists(Call c | c.getTarget().(Constructor).getDeclaringType().hasQualifiedName("System.Uri")
       and sink.asExpr()=c.getArgument(0))
     }
   }

   from DataFlow::Node src, DataFlow::Node sink, Configuration config
   where config.hasFlow(src, sink)
   select src, "This environment variable constructs a 'System.Uri' $@.", sink, "here"

Exercise 5
~~~~~~~~~~

All properties can flow data:

.. code-block:: ql

     private predicate propertyFlow(Property p) {
       p = getAMember()
     }

Exercise 6
~~~~~~~~~~

This can be adapted from the ``SystemUriFlow`` class:

.. code-block:: ql

   import semmle.code.csharp.dataflow.LibraryTypeDataFlow
   import semmle.code.csharp.frameworks.System

   class SystemExceptionFlow extends LibraryTypeDataFlow, SystemExceptionClass {
     override predicate callableFlow(CallableFlowSource source, CallableFlowSink sink, SourceDeclarationCallable c, boolean preservesValue) {
       (
         constructorFlow(source, c) and
         sink instanceof CallableFlowSinkQualifier
         or
         methodFlow(source, sink, c)
         or
         exists(Property p |
           propertyFlow(p) and
           source instanceof CallableFlowSourceQualifier and
           sink instanceof CallableFlowSinkReturn and
           c = p.getGetter()
         )
       )
       and
       preservesValue = false
     }

     private predicate constructorFlow(CallableFlowSourceArg source, Constructor c) {
       c = getAMember()
       and
       c.getParameter(0).getType() instanceof StringType
       and
       source.getArgumentIndex() = 0
     }

     private predicate methodFlow(CallableFlowSourceQualifier source, CallableFlowSinkReturn sink, SourceDeclarationMethod m) {
       m.getDeclaringType() = getABaseType*()
       and
       m = getSystemObjectClass().getToStringMethod().getAnOverrider*()
     }

     private predicate propertyFlow(Property p) {
       p = getAProperty() and p.hasName("Message")
     }
   }

Further reading
---------------

- "`Exploring data flow with path queries <https://help.semmle.com/codeql/codeql-for-vscode/procedures/exploring-paths.html>`__"


.. include:: ../../reusables/csharp-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst
