Customizing the JavaScript analysis
===================================

This document describes the main extension points offered by the JavaScript analysis for customizing
analysis behavior without editing the queries or libraries themselves.

Customization mechanisms
------------------------

The two mechanisms used for customization are subclassing and overriding.

By subclassing an abstract class used by the JavaScript analysis and implementing its abstract
member predicates we can teach the analysis to handle further instances of abstract concepts it
already understands. For example, the standard library defines an abstract class
``SystemCommandExecution`` that covers various APIs for executing operating-system commands. This
class is used by the command-injection analysis to identify problematic flows where input from a
potentially malicious user is interpreted as the name of a system command to execute. By defining
additional subclasses of ``SystemCommandExecution``, we can make this analysis more powerful without
touching its implementation.

By overriding a member predicate defined in the library, we can change its behavior either for all
its receivers or only a subset. For example, the standard library predicate
``ControlFlowNode::getASuccessor`` implements the basic control-flow graph on which many further
analyses are based. By overriding it, we can add, suppress or modify control-flow graph edges.

Once a customization has been defined, it needs to be brought into scope so that the default
analysis queries pick it up. This can be done by adding the customizing definitions to
``Customizations.qll``, an initially empty library file that is imported by the default library
``javascript.qll``.

Sometimes you may want to perform both kinds of customizations at the same time: subclass a base
class to provide new implementations of an API, and override some member predicates of the same base
class to selectively change the implementation of the API. This is not always easy to do, since the
former requires the base class to be abstract, while the latter requires it to be concrete.

To work around this, the JavaScript library uses the so-called `range pattern`: the base class
``Base`` itself is concrete, but it has an abstract companion class called ``Base::Range`` covering
the same set of values. To change the implementation of the API, subclass ``Base`` and override its
member predicates. To provide new implementations of the API, subclass ``Base::Range`` and implement
its abstract member predicates.

For example, the class ``Base64::Encode`` in the standard library models base64-encoding libraries
using the range pattern. To add support for a new library, subclass ``Base64::Encode::Range`` and
implement the member predicates ``getInput`` and ``getOutput``. (Subclasses for many popular base64
encoders are included in the standard library.) To customize the definition of ``getInput`` or
``getOutput`` for a library that is already supported, extend ``Base64::Encode`` itself and override
the predicate you want to customize.

Note that currently the range pattern is not used everywhere yet, so you will find some abstract
classes without a concrete companion. We are planning on eventually migrating most abstract classes
to use the range pattern.

Analysis layers
---------------

The JavaScript analysis libraries have a layered structure with higher-level analyses based on
lower-level ones. Usually, classes and predicates in a lower layer should not depend on a higher
layer to avoid performance problems and negative recursion issues.

We briefly survey the most important analysis layers here, starting from the lowest layer. Below we
will discuss the extension points offered by the individual layers.

AST
~~~

The abstract syntax tree, implemented by class ``ASTNode`` and its subclasses, is the lowest layer
and more or less directly represents the information stored in the snapshot data base. It
corresponds closely to the syntactic structure of the program, only abstracting away from
typographical details such as whitespace and indentation.

CFG
~~~

The (intra-procedural) control-flow graph, implemented by class ``ControlFlowNode`` and its
subclasses, is the next higher level. It models flow of control inside functions and top-level
scripts, and is overlaid on top of the AST in that each AST node has a corresponding CFG node. There
are also synthetic CFG nodes that do not correspond to an AST node: entry and exit nodes
(``ControlFlowEntryNode`` and ``ControlFlowExitNode``) mark the beginning and end, respectively, of
the execution of a function or top-level, while guard nodes (``GuardControlFlowNode``) record the
fact that some condition is known to hold at some point in the program.

Basic blocks (class ``BasicBlock``) organize control-flow nodes into maximal sequences of
straight-line code, which is vital for efficiently reasoning about control flow.

SSA
~~~

The static single-assignment representation (class ``SsaVariable`` and ``SsaDefinition``) uses
control-flow information to split up local variables into SSA variables that each only have a single
definition. In addition to regular definitions from assignments and increment/decrement expressions,
the SSA form also introduces pseudo-definitions such as `phi nodes` where multiple possible values
for a variable are merged and `refinement nodes` (also known as `pi nodes`) marking program points
where additional information about a variable becomes available that may restrict its possible set
of values.

Local data flow
~~~~~~~~~~~~~~~

The (intra-procedural) data-flow graph, implemented by class ``DataFlow::Node`` and its subclasses,
represents the flow of data within a function or top-level. Each expression has a corresponding
data-flow node. Additionally, there are data-flow nodes that do not correspond to syntactic
elements; for example, each SSA variable has a corresponding data-flow node. Note that flow between
functions (through arguments and return values) is not modelled in this layer, except for the
special case of immediately-invoked function expressions. Flow through object properties is also not
modelled.

This layer also implements the widely-used source-node API: class ``DataFlow::SourceNode`` and its
subclasses represent data-flow nodes where new objects are created (such as object expressions), or
where non-local data flow enters the intra-procedural data-flow graph (such as function parameters
or property reads). The source-node API provides convenience predicates for reasoning about these
nodes without having to explicitly encode data-flow graph traversal.

Type inference
~~~~~~~~~~~~~~

Class ``AnalyzedNode`` and its subclasses implement (intra-procedural) type inference on top of the
local data-flow graph. Some reasoning about properties is implemented as well, but more advanced
features such as the prototype chain are not considered.

Call graph
~~~~~~~~~~

The call graph is implemented as a predicate ``getACallee`` on ``DataFlow::InvokeNode``, the class
of data-flow nodes representing function calls (with or wihout ``new``). It uses local data flow and
type information, as well as type annotations where available.

Type tracking
~~~~~~~~~~~~~

The type-tracking framework (classes ``DataFlow::TypeTracker`` and ``DataFlow::TypeBackTracker``) is
a library for implementing custom type inference systems that track values inter-procedurally,
including tracking through one level of object properties.

Framework models
~~~~~~~~~~~~~~~~

The libraries under ``semmle/javascript/frameworks`` model a broad range of popular JavaScript
libraries and frameworks, such as Express or Vue.js. Some framework modeling libraries are located
under ``semmle/javascript`` directly, for instance ``Base64``, ``EmailClients`` and ``JsonParsers``.

Global data flow and taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The inter-procedural data flow and taint-tracking libraries can be used to implement static
information-flow analyses. Most of our security queries are based on this approach.

Extension points
----------------

Below we discuss the most important extension points for the individual analysis layers introduced above.

AST
~~~

This layer should not normally be customized. It is technically possible to override, say,
``ASTNode.getChild`` to change the way the AST structure is represented, but this should normally be
avoided in the interest of keeping a close correspondence between AST and concrete syntax.

CFG
~~~

You can override ``ControlFlowNode.getASuccessor`` to customize the control-flow graph. Note that overriding ``ControlFlowNode.getAPredecessor`` is not normally useful, since it is rarely used in higher-level libraries.

SSA
~~~

It is not normally necessary to customize this layer.

Local data flow
~~~~~~~~~~~~~~~

The ``DataFlow::SourceNode`` class uses the range pattern, so new kinds of source nodes can be
added by extending ``Dataflow::SourceNode::Range``. Some of its subclasses can similarly be
extended: ``DataFlow::ModuleImportNode`` models module imports, and ``DataFlow::ClassNode`` models
class definitions. The former provides default implementations covering CommonJS, AMD and ECMAScript
2015 modules, while the latter handles ECMAScript 2015 classes as well as traditional function-based
classes. You can extend their corresponding ``::Range`` classes to add support for other module or
class systems.

Type inference
~~~~~~~~~~~~~~

You can override ``AnalyzedNode::getAValue`` to customize the type inference. Note that the type inference is expected to be sound, that is (as far as practical) the abstract values inferred for a data-flow nodes should cover all possible concrete values this node may take on at runtime.

You can also extend the set of abstract values in one of two ways:

1. To add individual abstract values that are independent of the program being analyzed, define a
   subclass of ``CustomAbstractValueTag`` describing the new abstract value. There will then be a
   corresponding value of class ``CustomAbstractValue`` that you can use in overriding
   definitions of the ``getAValue`` predicate.
2. To add abstract values that are induced by a program element, define a subclass of
   ``CustomAbstractValueDefinition``, and use its corresponding
   ``CustomAbstractValueFromDefinition``.

Call graph
~~~~~~~~~~

You can override ``DataFlow::InvokeNode::getACallee(int)`` to customize the call graph. Note that overriding the zero-argument version ``getACallee()`` is not enough since higher layers use the one-argument version. 

Type tracking
~~~~~~~~~~~~~

It is not normally necessary to customize this layer.

Framework models
~~~~~~~~~~~~~~~~

The ``semmle.javascript.frameworks.HTTP`` module defines many abstract classes that can be extended
to implement support for new web frameworks. These classes, in turn, are used by some of the
security queries (such as the cross-site scripting queries) to define sources and sinks, so these
queries will automatically benefit from the additional modeling.

Similarly, the ``semmle.javascript.frameworks.SQL`` module defines abstract classes for modeling SQL
connector libraries, and the ``semmle.javascript.JsonParsers`` and
``semmle.javascript.frameworks.XML`` modules for modeling JSON and XML parsers, respectively.

The ``semmle.javascript.Concepts`` modules defines a few very broad concepts such as system-command
executions or file-system accesses, which are concretely instantiated in some of the existing
framework libraries, but can of course be further extended to model additional frameworks.

Global data flow and taint tracking
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Most security queries consist of one QL file defining the query, one configuration module defining
the taint-tracking configuration, and one customization module defining sources, sinks and
sanitizers. For example, ``Security/CWE-078/CommandInjection.ql`` defines the command-injection
query. It imports module ``semmle.javascript.security.dataflow.CommandInjection``, which defines the
configuration class ``CommandInjection::Configuration``, and itself imports module
``semmle.javascript.security.dataflow.CommandInjectionCustomizations``, which defines sources, sinks
and sanitizers by means of three abstract classes ``CommandInjection::Source``,
``CommandInjetion::Sink`` and ``CommandInjection::Sanitizer``, respectively.

To define additional sources, sinks or sanitizers for this or any other security query, import the
customization module and extend these abstract classes with additional subclasses.

Note that you should normally only import the configuration module from a QL file. Importing it into
the standard library (for example by importing it in ``Customizations.qll``) will slow down all the
other security queries, since the configuration class will now be always in scope and flow from its
sources to sinks will be tracked in addition to all the other configuration classes.

Another useful extension point is the class ``RemoteFlowSource``, which is used as a source by most
queries looking for injection vulnerabilities (such as SQL injection or cross-site scripting). By
extending it with new subclasses modelling other sources of user-controlled input you can
simultaneously improve all of these queries.

Finally, you can extend the classes ``Dataflow::AdditionalSource``, ``DataFlow::AdditionalSink``,
``DataFlow::AdditionalFlowStep`` and ``DataFlow::AdditionalBarrierGuardNode`` (and its subclasses)
to define new sources, sinks, flow steps and sanitizers for all configurations, or only for specific
configurations.
