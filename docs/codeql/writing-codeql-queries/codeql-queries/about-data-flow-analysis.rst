.. _about-data-flow-analysis:

About data flow analysis
########################

Data flow analysis is used to compute the possible values that a variable can hold at various points in a program, determining how those values propagate through the program and where they are used. 

Overview
********

Many CodeQL security queries implement data flow analysis, which can highlight the fate of potentially malicious or insecure data that can cause vulnerabilities in your code base.
These queries help you understand if data is used in an insecure way, whether dangerous arguments are passed to functions, or whether sensitive data can leak.
As well as highlighting potential security issues, you can also use data flow analysis to understand other aspects of how a program behaves, by finding, for example, uses of uninitialized variables and resource leaks.

The following sections provide a brief introduction to data flow analysis with CodeQL.

See the following tutorials for more information about analyzing data flow in specific languages:

- ":ref:`Analyzing data flow in C/C++ <analyzing-data-flow-in-cpp>`"
- ":ref:`Analyzing data flow in C# <analyzing-data-flow-in-csharp>`"
- ":ref:`Analyzing data flow in Java <analyzing-data-flow-in-java>`"
- ":ref:`Analyzing data flow in JavaScript/TypeScript <analyzing-data-flow-in-javascript>`"
- ":ref:`Analyzing data flow and tracking tainted data in Python <analyzing-data-flow-and-tracking-tainted-data-in-python>`"

.. pull-quote::

    Note

    Data flow analysis is used extensively in path queries. To learn more about path queries, see ":doc:`Creating path queries <creating-path-queries>`."  

.. _data-flow-graph:

Data flow graph
***************

The CodeQL data flow libraries implement data flow analysis on a program or function by modeling its data flow graph.
Unlike the `abstract syntax tree <https://en.wikipedia.org/wiki/Abstract_syntax_tree>`__, the
data flow graph does not reflect the syntactic structure of the program, but models the way data flows through the program at runtime. Nodes in the abstract syntax tree
represent syntactic elements such as statements or expressions. Nodes in the data flow graph, on the other hand, represent semantic elements that carry values at runtime.

Some AST nodes (such as expressions) have corresponding data flow nodes, but others (such as ``if`` statements) do not. This is because expressions are evaluated to a value at runtime, whereas
``if`` statements are purely a control-flow construct and do not carry values. There are also data flow nodes that do not correspond to AST nodes at all.

Edges in the data flow graph represent the way data flows between program elements. For example, in the expression ``x || y`` there are data flow nodes corresponding to the
sub-expressions ``x`` and ``y``, as well as a data flow node corresponding to the entire expression ``x || y``. There is an edge from the node corresponding to ``x`` to the
node corresponding to ``x || y``, representing the fact that data may flow from ``x`` to ``x || y`` (since the expression ``x || y`` may evaluate to ``x``). Similarly, there
is an edge from the node corresponding to ``y`` to the node corresponding to ``x || y``.

Local and global data flow differ in which edges they consider: local data flow only considers edges between data flow nodes belonging to the same function and ignores data
flow between functions and through object properties. Global data flow, however, considers the latter as well. Taint tracking introduces additional edges into the data flow
graph that do not precisely correspond to the flow of values, but model whether some value at runtime may be derived from another, for instance through a string manipulating
operation.

The data flow graph is computed using :ref:`classes <classes>` to model the program elements that represent the graph's nodes.
The flow of data between the nodes is modeled using :ref:`predicates <predicates>` to compute the graph's edges.

Computing an accurate and complete data flow graph presents several challenges:

- It isn't possible to compute data flow through standard library functions, where the source code is unavailable.
- Some behavior isn't determined until run time, which means that the data flow library must take extra steps to find potential call targets.
- Aliasing between variables can result in a single write changing the value that multiple pointers point to.
- The data flow graph can be very large and slow to compute.

To overcome these potential problems, two kinds of data flow are modeled in the libraries:

- Local data flow, concerning the data flow within a single function. When reasoning about local data flow, you only consider edges between data flow nodes belonging to the same function. It is generally sufficiently fast, efficient and precise for many queries, and it is usually possible to compute the local data flow for all functions in a CodeQL database.

- Global data flow, effectively considers the data flow within an entire program, by calculating data flow between functions and through object properties. Computing global data flow is typically more time and energy intensive than local data flow, therefore queries should be refined to look for more specific sources and sinks.

Many CodeQL queries contain examples of both local and global data flow analysis. See `the built-in queries <https://help.semmle.com/wiki/display/QL/Built-in+queries>`__ for details.

Normal data flow vs taint tracking
**********************************

In the standard libraries, we make a distinction between 'normal' data flow and taint tracking.
The normal data flow libraries are used to analyze the information flow in which data values are preserved at each step.

For example, if you are tracking an insecure object ``x`` (which might be some untrusted or potentially malicious data), a step in the program may 'change' its value. So, in a simple process such as ``y = x + 1``, a normal data flow analysis will highlight the use of ``x``, but not ``y``.
However, since ``y`` is derived from ``x``, it is influenced by the untrusted or 'tainted' information, and therefore it is also tainted. Analyzing the flow of the taint from ``x`` to ``y`` is known as taint tracking.

In QL, taint tracking extends data flow analysis by including steps in which the data values are not necessarily preserved, but the potentially insecure object is still propagated. 
These flow steps are modeled in the taint-tracking library using predicates that hold if taint is propagated between nodes.

Further reading
***************

- ":ref:`Exploring data flow with path queries <exploring-data-flow-with-path-queries>`"

