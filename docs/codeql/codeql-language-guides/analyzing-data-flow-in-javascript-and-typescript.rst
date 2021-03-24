.. _analyzing-data-flow-in-javascript-and-typescript:

Analyzing data flow in JavaScript and TypeScript
================================================

This topic describes how data flow analysis is implemented in the CodeQL libraries for JavaScript/TypeScript and includes examples to help you write your own data flow queries.

Overview
--------
The various sections in this article describe how to utilize the libraries for local data flow, global data flow, and taint tracking.
As our running example, we will develop a query that identifies command-line arguments that are passed as a file path to the standard Node.js ``readFile`` function.
While this is not a problematic pattern as such, it is typical of the kind of reasoning that is frequently used in security queries.

For a more general introduction to modeling data flow, see ":ref:`About data flow analysis <about-data-flow-analysis>`."

Data flow nodes
---------------

Both local and global data flow, as well as taint tracking, work on a representation of the program known as the :ref:`data flow graph <data-flow-graph>`. 
Nodes on the data flow flow graph may also correspond to nodes on the abstract syntax tree, but they are not the same.
While AST nodes belong to class ``ASTNode`` and its subclasses, data flow nodes belong to class ``DataFlow::Node`` and its subclasses:

  - ``DataFlow::ValueNode``: a *value node*, that is, a data flow node that corresponds either to an expression, or to a declaration of a function, class, TypeScript namespace,
    or TypeScript enum.
  - ``DataFlow::SsaDefinitionNode``: a data flow node that corresponds to an SSA variable, that is, a local variable with additional information to reason more precisely
    about different assignments to the same variable. This kind of data flow node does not correspond to an AST node.
  - ``DataFlow::PropRef``: a data flow node that corresponds to a read or a write of an object property, for example, in an assignment, in an object literal, or in a
    destructuring assignment.
  - ``DataFlow::PropRead``, ``DataFlow::PropWrite``: subclasses of ``DataFlow::PropRef`` that correspond to reads and writes, respectively.

Apart from these fairly general classes, there are some more specialized classes:

  - ``DataFlow::ParameterNode``: a data flow node that corresponds to a function parameter.
  - ``DataFlow::InvokeNode``: a data flow node that corresponds to a function call; its subclasses ``DataFlow::NewNode`` and ``DataFlow::CallNode`` represent calls with
    and without ``new`` respectively, while ``DataFlow::MethodCallNode`` represents method calls. Note that these classes also model reflective calls using ``.call`` and
    ``.apply``, which do not correspond to any AST nodes.
  - ``DataFlow::ThisNode``: a data flow node that corresponds to the value of ``this`` in a function or top level. This kind of data flow node also does not correspond to an AST node.
  - ``DataFlow::GlobalVarRefNode``: a data flow node that corresponds to a direct reference to a global variable. This class is rarely used directly, instead you would normally
    use the predicate ``globalVarRef`` (introduced below), which also considers indirect references through ``window`` or global ``this``.
  - ``DataFlow::FunctionNode``, ``DataFlow::ObjectLiteralNode``, ``DataFlow::ArrayLiteralNode``: a data flow node that corresponds to a function (expression or declaration),
    an object literal, or an array literal, respectively.
  - ``DataFlow::ClassNode``: a data flow node corresponding to a class, either defined using an ECMAScript 2015 ``class`` declaration or an old-style constructor
    function.
  - ``DataFlow::ModuleImportNode``: a data flow node corresponding to an ECMAScript 2015 import or an AMD or CommonJS ``require`` import.

The following predicates are available for mapping from AST nodes and other elements to their corresponding data flow nodes:

  - ``DataFlow::valueNode(x)``: maps ``x``, which must be an expression or a declaration of a function, class, namespace or enum, to its corresponding ``DataFlow::ValueNode``.
  - ``DataFlow::ssaDefinitionNode(ssa)``: maps an SSA definition ``ssa`` to its corresponding ``DataFlow::SsaDefinitionNode``.
  - ``DataFlow::parameterNode(p)``: maps a function parameter ``p`` to its corresponding ``DataFlow::ParameterNode``.
  - ``DataFlow::thisNode(s)``: maps a function or top-level ``s`` to the ``DataFlow::ThisNode`` representing the value of ``this`` in ``s``.

Class ``DataFlow::Node`` also has a member predicate ``asExpr()`` that you can use to map from a ``DataFlow::ValueNode`` to the expression it corresponds to. Note that
this predicate is undefined for other kinds of nodes, and for value nodes that do not correspond to expressions.

There are also some other predicates available for accessing commonly used data flow nodes:

  - ``DataFlow::globalVarRef(g)``: gets a data flow node corresponding to an access to global variable ``g``, either directly or through ``window`` or (top-level) ``this``.
    For example, you can use ``DataFlow::globalVarRef("document")`` to find references to the DOM ``document`` object.
  - ``DataFlow::moduleMember(p, m)``: gets a data flow node that references a member ``m`` of a module loaded from path ``p``. For example, you can use
    ``DataFlow::moduleMember("fs", "readFile")`` to find references to the ``fs.readFile`` function from the Node.js standard library.

Local data flow
---------------

Local data flow is data flow within a single function. Data flow through function calls and returns or through property writes and reads is not modeled.

Local data flow is faster to compute and easier to use than global data flow, but less complete. It is, however, sufficient for many purposes.

To reason about local data flow, use the member predicates ``getAPredecessor`` and ``getASuccessor`` on ``DataFlow::Node``. For a data flow node ``nd``,
``nd.getAPredecessor()`` returns all data flow nodes from which data flows to ``nd`` in one local step. Conversely, ``nd.getASuccessor()`` returns all
nodes to which data flows from ``nd`` in one local step.

To follow one or more steps of local data flow, use the transitive closure operator ``+``, and for zero or more steps the reflexive transitive closure operator ``*``.

For example, the following query finds all data flow nodes ``source`` whose value may flow into the first argument of a call to a method with name ``readFile``:

.. code-block:: ql

  import javascript

  from DataFlow::MethodCallNode readFile, DataFlow::Node source
  where
    readFile.getMethodName() = "readFile" and
    source.getASuccessor*() = readFile.getArgument(0)
  select source

Source nodes
~~~~~~~~~~~~

Explicit reasoning about data flow edges can be cumbersome and is rare in practice. Typically, we are not interested in flow originating from arbitrary nodes, but
from nodes that in some sense are the "source" of some kind of data, either because they create a new object, such as object literals or functions, or because they
represent a point where data enters the local data flow graph, such as parameters or property reads.

The data flow library represents such nodes by the class ``DataFlow::SourceNode``, which provides a convenient API to reason about local data flow involving
source nodes.

By default, the following kinds of data flow nodes are considered source nodes:

  - classes, functions, object and array literals, regular expressions, and JSX elements
  - property reads, global variable references and ``this`` nodes
  - function parameters
  - function calls
  - imports

You can extend the set of source nodes by defining additional subclasses of ``DataFlow::SourceNode::Range``.

The ``DataFlow::SourceNode`` class defines a number of member predicates that can be used to track where data originating from a source node flows, and to find
places where properties are accessed or methods are called on them.

For example, the following query finds all references to properties of ``process.argv``, the array through which Node.js applications receive their command-line
arguments:

.. code-block:: ql

  import javascript

  select DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyReference()

First, we use ``DataFlow::globalVarRef`` (mentioned above) to find all references to the global variable ``process``. Since global variable references are source
nodes, we can then use the predicate ``getAPropertyRead`` (defined in class ``DataFlow::SourceNode``) to find all places where the property ``argv`` of that
global variable is read. The results of this predicate are again source nodes, so we can chain it with a call to ``getAPropertyReference``, which is a predicate
that finds all references to any property (even references with a computed name) on its base source node.

Note that many predicates on ``DataFlow::SourceNode`` have source nodes as their result in turn, allowing calls to be chained to concisely express the relationship
between several data flow nodes.

Most importantly, predicates like ``getAPropertyRead`` implicitly follow local data flow, so the above query not only finds direct property references like
``process.argv[2]``, but also more indirect ones as in this example:

.. code-block:: javascript

  var args = process.argv;
  var firstArg = args[2];

Analogous to ``getAPropertyRead`` there is also a predicate ``getAPropertyWrite`` for identifying property writes.

Another common task is to find calls to a function originating from a source node. For this purpose, ``DataFlow::SourceNode`` offers predicates ``getACall``,
``getAnInstantiation`` and ``getAnInvocation``: the first one only considers invocations without ``new``, the second one only invocations with ``new``, and
the third one considers all invocations.

We can use these predicates in combination with ``DataFlow::moduleMember`` (mentioned above) to find calls to the function ``readFile`` imported from the
standard Node.js ``fs`` library:

.. code-block:: ql

  import javascript

  select DataFlow::moduleMember("fs", "readFile").getACall()

For identifying method calls there is also a predicate ``getAMethodCall``, and the slightly more general ``getAMemberCall``. The difference between the
two is that the former only finds calls that have the syntactic shape of a method call such as ``x.m(...)``, while the latter also finds calls where
``x.m`` is first stored into a local variable ``f`` and then invoked as ``f(...)``.

Finally, the predicate ``flowsTo(nd)`` holds for any node ``nd`` into which data originating from the source node may flow. Conversely, ``DataFlow::Node``
offers a predicate ``getALocalSource()`` that can be used to find any source node that flows to it.

Putting all of the above together, here is a query that finds (local) data flow from command line arguments to ``readFile`` calls:

.. code-block:: ql

  import javascript

  from DataFlow::SourceNode arg, DataFlow::CallNode call
  where
    arg = DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyReference() and
    call = DataFlow::moduleMember("fs", "readFile").getACall() and
    arg.flowsTo(call.getArgument(0))
  select arg, call

There are two points worth making about the source node API:

  1. All data flow tracking is purely local, and in particular flow through global variables is not tracked. If ``args`` in our ``process.argv`` example
     above is a global variable, then the query will not find the reference through ``args[2]``.
  2. Strings are not source nodes and cannot be tracked using this API. You can, however, use the ``mayHaveStringValue`` predicate on class ``DataFlow::Node``
     to reason about the possible string values flowing into a data flow node.

For a full description of the ``DataFlow::SourceNode`` API, see the `JavaScript standard library <https://codeql.github.com/codeql-standard-libraries/javascript/semmle/javascript/dataflow/Sources.qll/type.Sources$SourceNode.html>`__.

Exercises
~~~~~~~~~

Exercise 1: Write a query that finds all hard-coded strings used as the ``tagName`` argument to the ``createElement`` function from the DOM ``document`` object,
using local data flow. (`Answer <#exercise-1>`__).

Global data flow
----------------

Global data flow tracks data flow throughout the entire program, and is therefore more powerful than local data flow. However, global data flow is less precise
than local data flow. That is, the analysis may report spurious flows that cannot in fact happen. Moreover, global data flow analysis typically requires significantly
more time and memory than local analysis.

.. pull-quote:: Note

   .. include:: ../reusables/path-problem.rst

Using global data flow
~~~~~~~~~~~~~~~~~~~~~~

For performance reasons, it is not generally feasible to compute all global data flow across the entire program. Instead, you can define a data flow `configuration`,
which specifies `source` data flow nodes and `sink` data flow nodes ("sources" and "sinks" for short) of interest. The data flow library provides a generic
data flow solver that can check whether there is (global) data flow from a source to a sink.

Optionally, configurations may specify extra data flow edges to be added to the data flow graph, and may also specify  `barriers`. Barriers are data flow nodes or edges through
which data should not be tracked for the purposes of this analysis.

To define a configuration, extend the class ``DataFlow::Configuration`` as follows:

.. code-block:: ql

  class MyDataFlowConfiguration extends DataFlow::Configuration {
    MyDataFlowConfiguration() { this = "MyDataFlowConfiguration" }

    override predicate isSource(DataFlow::Node source) { /* ... */ }

    override predicate isSink(DataFlow::Node sink) { /* ... */ }

    // optional overrides:
    override predicate isBarrier(DataFlow::Node nd) { /* ... */ }
    override predicate isBarrierEdge(DataFlow::Node pred, DataFlow::Node succ) { /* ... */ }
    override predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) { /* ... */ }
  }

The characteristic predicate ``MyDataFlowConfiguration()`` defines the name of the configuration, so ``"MyDataFlowConfiguration"`` should be replaced by a suitable
name describing your particular analysis configuration.

The data flow analysis is performed using the predicate ``hasFlow(source, sink)``:

.. code-block:: ql

   from MyDataFlowConfiguration dataflow, DataFlow::Node source, DataFlow::Node sink
   where dataflow.hasFlow(source, sink)
   select source, "Data flow from $@ to $@.", source, source.toString(), sink, sink.toString()

Using global taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Global taint tracking extends global data flow with additional non-value-preserving steps, such as flow through string-manipulating operations. To use it, simply extend
``TaintTracking::Configuration`` instead of ``DataFlow::Configuration``:

.. code-block:: ql

  class MyTaintTrackingConfiguration extends TaintTracking::Configuration {
    MyTaintTrackingConfiguration() { this = "MyTaintTrackingConfiguration" }

    override predicate isSource(DataFlow::Node source) { /* ... */ }

    override predicate isSink(DataFlow::Node sink) { /* ... */ }
  }

Analogous to ``isAdditionalFlowStep``, there is a predicate ``isAdditionalTaintStep`` that you can override to specify custom flow steps to consider in the analysis.
Instead of the ``isBarrier`` and ``isBarrierEdge`` predicates, the taint tracking configuration includes ``isSanitizer`` and ``isSanitizerEdge`` predicates that specify
data flow nodes or edges that act as taint sanitizers and hence stop flow from a source to a sink.

Similar to global data flow, the characteristic predicate ``MyTaintTrackingConfiguration()`` defines the unique name of the configuration, so ``"MyTaintTrackingConfiguration"``
should be replaced by an appropriate descriptive name.

The taint tracking analysis is again performed using the predicate ``hasFlow(source, sink)``.

Examples
~~~~~~~~

The following taint-tracking configuration is a generalization of our example query above, which tracks flow from command-line arguments to ``readFile`` calls, this
time using global taint tracking.

.. code-block:: ql

  import javascript

  class CommandLineFileNameConfiguration extends TaintTracking::Configuration {
    CommandLineFileNameConfiguration() { this = "CommandLineFileNameConfiguration" }

    override predicate isSource(DataFlow::Node source) {
      DataFlow::globalVarRef("process").getAPropertyRead("argv").getAPropertyRead() = source
    }

    override predicate isSink(DataFlow::Node sink) {
      DataFlow::moduleMember("fs", "readFile").getACall().getArgument(0) = sink
    }
  }

  from CommandLineFileNameConfiguration cfg, DataFlow::Node source, DataFlow::Node sink
  where cfg.hasFlow(source, sink)
  select source, sink

This query will now find flows that involve inter-procedural steps, like in the following example (where the individual steps have been marked with comments
``#1`` to ``#4``):

.. code-block:: javascript

  const fs = require('fs'),
        path = require('path');

  function readFileHelper(p) {     // #2
    p = path.resolve(p);           // #3
    fs.readFile(p,                 // #4
      'utf8', (err, data) => {
      if (err) throw err;
      console.log(data);
    });
  }

  readFileHelper(process.argv[2]); // #1

Note that for step #3 we rely on the taint-tracking library's built-in model of the Node.js ``path`` library, which adds a taint step from ``p`` to
``path.resolve(p)``. This step is not value preserving, but it preserves taint in the sense that if ``p`` is user-controlled, then so is
``path.resolve(p)`` (at least partially).

Other standard taint steps include flow through string-manipulating operations such as concatenation, ``JSON.parse`` and ``JSON.stringify``, array
transformations, promise operations, and many more.

Sanitizers
~~~~~~~~~~

The above JavaScript program allows the user to read any file, including sensitive system files like ``/etc/passwd``. If the program may be invoked
by an untrusted user, this is undesirable, so we may want to constrain the path. For example, instead of using ``path.resolve`` we could implement
a function ``checkPath`` that first makes the path absolute and then checks that it starts with the current working directory, aborting the program
with an error if it does not. We could then use that function in ``readFileHelper`` like this:

.. code-block:: javascript

  function readFileHelper(p) {
    p = checkPath(p);
    ...
  }

For the purposes of our above analysis, ``checkPath`` is a `sanitizer`: its output is always untainted, even if its input is tainted. To model this
we can add an override of ``isSanitizer`` to our taint-tracking configuration like this:

.. code-block:: ql

  class CommandLineFileNameConfiguration extends TaintTracking::Configuration {

    // ...

    override predicate isSanitizer(DataFlow::Node nd) {
      nd.(DataFlow::CallNode).getCalleeName() = "checkPath"
    }
  }

This says that any call to a function named ``checkPath`` is to be considered a sanitizer, so any flow through this node is blocked. In particular,
the query would no longer flag the flow from ``process.argv[2]`` to ``fs.readFile`` in our updated example above.

Sanitizer guards
~~~~~~~~~~~~~~~~

A perhaps more natural way of implementing the path check in our example would be to have ``checkPath`` return a Boolean value indicating whether
the path is safe to read (instead of returning the path if it is safe and aborting otherwise). We could then use it in ``readFileHelper`` like this:

.. code-block:: javascript

  function readFileHelper(p) {
    if (!checkPath(p))
      return;
    ...
  }

Note that ``checkPath`` is now no longer a sanitizer in the sense described above, since the flow from ``process.argv[2]`` to ``fs.readFile`` does not go
through ``checkPath`` any more. The flow is, however, `guarded` by ``checkPath`` in the sense that the expression ``checkPath(p)`` has to evaluate
to ``true`` (or, more precisely, to a truthy value) in order for the flow to happen.

Such sanitizer guards can be supported by defining a new subclass of ``TaintTracking::SanitizerGuardNode`` and overriding the predicate
``isSanitizerGuard`` in the taint-tracking configuration class to add all instances of this class as sanitizer guards to the configuration.

For our above example, we would begin by defining a subclass of ``SanitizerGuardNode`` that identifies guards of the form ``checkPath(...)``:

.. code-block:: ql

  class CheckPathSanitizerGuard extends TaintTracking::SanitizerGuardNode, DataFlow::CallNode {
    CheckPathSanitizerGuard() { this.getCalleeName() = "checkPath" }

    override predicate sanitizes(boolean outcome, Expr e) {
      outcome = true and
      e = getArgument(0).asExpr()
    }
  }

The characteristic predicate of this class checks that the sanitizer guard is a call to a function named ``checkPath``. The overriding definition
of ``sanitizes`` says such a call sanitizes its first argument (that is, ``getArgument(0)``) if it evaluates to ``true`` (or rather, a truthy
value).

Now we can override ``isSanitizerGuard`` to add these sanitizer guards to our configuration:

.. code-block:: ql

  class CommandLineFileNameConfiguration extends TaintTracking::Configuration {

    // ...

    override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode nd) {
      nd instanceof CheckPathSanitizerGuard
    }
  }

With these two additions, the query recognizes the ``checkPath(p)`` check as sanitizing ``p`` after the ``return``, since execution can only
reach there if ``checkPath(p)`` evaluates to a truthy value. Consequently, there is no longer a path from ``process.argv[2]`` to
``readFile``.

Additional taint steps
~~~~~~~~~~~~~~~~~~~~~~

Sometimes the default data flow and taint steps provided by ``DataFlow::Configuration`` and ``TaintTracking::Configuration`` are not sufficient
and we need to add additional flow or taint steps to our configuration to make it find the expected flow. For example, this can happen because
the analyzed program uses a function from an external library whose source code is not available to the analysis, or because it uses a function
that is too difficult to analyze.

In the context of our running example, assume that the JavaScript program we are analyzing uses a (fictitious) npm package ``resolve-symlinks``
to resolve any symlinks in the path ``p`` before passing it to ``readFile``:

.. code-block:: javascript

  const resolveSymlinks = require('resolve-symlinks');

  function readFileHelper(p) {
    p = resolveSymlinks(p);
    fs.readFile(p,
    ...
  }

Resolving symlinks does not make an unsafe path any safer, so we would still like our query to flag this, but since the standard library does
not have a model of ``resolve-symlinks`` it will no longer return any results.

We can fix this quite easily by adding an overriding definition of the ``isAdditionalTaintStep`` predicate to our configuration, introducing an
additional taint step from the first argument of ``resolveSymlinks`` to its result:

.. code-block:: ql

  class CommandLineFileNameConfiguration extends TaintTracking::Configuration {

    // ...

    override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode c |
        c = DataFlow::moduleImport("resolve-symlinks").getACall() and
        pred = c.getArgument(0) and
        succ = c
      )
    }
  }

We might even consider adding this as a default taint step to be used by all taint-tracking configurations. In order to do this, we need
to wrap it in a new subclass of ``TaintTracking::SharedTaintStep`` like this:

.. code-block:: ql

  class StepThroughResolveSymlinks extends TaintTracking::SharedTaintStep {
    override predicate step(DataFlow::Node pred, DataFlow::Node succ) {
      exists(DataFlow::CallNode c |
        c = DataFlow::moduleImport("resolve-symlinks").getACall() and
        pred = c.getArgument(0) and
        succ = c
      )
    }
  }

If we add this definition to the standard library, it will be picked up by all taint-tracking configurations. Obviously, one has to be
careful when adding such new additional taint steps to ensure that they really make sense for `all` configurations.

Analogous to ``TaintTracking::SharedTaintStep``, there is also a class ``DataFlow::SharedFlowStep`` that can be extended to add
extra steps to all data-flow configurations, and hence also to all taint-tracking configurations.

Exercises
~~~~~~~~~

Exercise 2: Write a query that finds all hard-coded strings used as the ``tagName`` argument to the ``createElement`` function from the DOM ``document`` object,
using global data flow. (`Answer <#exercise-2>`__).

Exercise 3: Write a class which represents flow sources from the array elements of the result of a call, for example the expression ``myObject.myMethod(myArgument)[myIndex]``.
Hint: array indices are properties with numeric names; you can use regular expression matching to check this. (`Answer <#exercise-3>`__)

Exercise 4: Using the answers from 2 and 3, write a query which finds all global data flows from array elements of the result of a call to the ``tagName`` argument to the
``createElement`` function. (`Answer <#exercise-4>`__)

Answers
-------

Exercise 1
~~~~~~~~~~

.. code-block:: ql

  import javascript

  from DataFlow::CallNode create, string name
  where
    create = DataFlow::globalVarRef("document").getAMethodCall("createElement") and
    create.getArgument(0).mayHaveStringValue(name)
  select name

Exercise 2
~~~~~~~~~~

.. code-block:: ql

  import javascript

  class HardCodedTagNameConfiguration extends DataFlow::Configuration {
    HardCodedTagNameConfiguration() { this = "HardCodedTagNameConfiguration" }

    override predicate isSource(DataFlow::Node source) { source.asExpr() instanceof ConstantString }

    override predicate isSink(DataFlow::Node sink) {
      sink = DataFlow::globalVarRef("document").getAMethodCall("createElement").getArgument(0)
    }
  }

  from HardCodedTagNameConfiguration cfg, DataFlow::Node source, DataFlow::Node sink
  where cfg.hasFlow(source, sink)
  select source, sink

Exercise 3
~~~~~~~~~~

.. code-block:: ql

  import javascript

  class ArrayEntryCallResult extends DataFlow::Node {
    ArrayEntryCallResult() {
      exists(DataFlow::CallNode call, string index |
        this = call.getAPropertyRead(index) and
        index.regexpMatch("\\d+")
      )
    }
  }

Exercise 4
~~~~~~~~~~

.. code-block:: ql

  import javascript

  class ArrayEntryCallResult extends DataFlow::Node {
    ArrayEntryCallResult() {
      exists(DataFlow::CallNode call, string index |
        this = call.getAPropertyRead(index) and
        index.regexpMatch("\\d+")
      )
    }
  }

  class HardCodedTagNameConfiguration extends DataFlow::Configuration {
    HardCodedTagNameConfiguration() { this = "HardCodedTagNameConfiguration" }

    override predicate isSource(DataFlow::Node source) { source instanceof ArrayEntryCallResult }

    override predicate isSink(DataFlow::Node sink) {
      sink = DataFlow::globalVarRef("document").getAMethodCall("createElement").getArgument(0)
    }
  }

  from HardCodedTagNameConfiguration cfg, DataFlow::Node source, DataFlow::Node sink
  where cfg.hasFlow(source, sink)
  select source, sink

Further reading
---------------

- ":ref:`Exploring data flow with path queries <exploring-data-flow-with-path-queries>`"


.. include:: ../reusables/java-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst