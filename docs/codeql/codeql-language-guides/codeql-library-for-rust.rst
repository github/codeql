.. _codeql-library-for-rust:

CodeQL library for Rust
=================================

When analyzing Rust code, you can make use of the large collection of classes in the CodeQL library for Rust.

Overview
--------

CodeQL ships with a library for analyzing Rust code. The classes in this library present the data from a CodeQL database in an object-oriented form and provide
abstractions and predicates to help you with common analysis tasks.

The library is implemented as a set of CodeQL modules, which are files with the extension ``.qll``. The
module `rust.qll <https://github.com/github/codeql/blob/main/rust/ql/lib/rust.qll>`__ imports most other standard library modules, so you can include them
by beginning your query with:

.. code-block:: ql

   import rust

The CodeQL libraries model various aspects of Rust code. The above import includes the abstract syntax tree (AST) library, which is used for locating program elements
to match syntactic elements in the source code. This can be used to find values, patterns, and structures.

The control flow graph (CFG) is imported using:

.. code-block:: ql

   import codeql.rust.controlflow.ControlFlowGraph

The CFG models the control flow between statements and expressions. For example, it can determine whether one expression can
be evaluated before another expression, or whether an expression "dominates" another one, meaning that all paths to an
expression must flow through another expression first.

The data flow library is imported using:

.. code-block:: ql

   import codeql.rust.dataflow.DataFlow

Data flow tracks the flow of data through the program, including across function calls (interprocedural data flow) and between steps in a job or workflow.
Data flow is particularly useful for security queries, where untrusted data flows to vulnerable parts of the program. The taint-tracking library is related to data flow, 
and helps you find how data can *influence* other values in a program, even when it is not copied exactly.

To summarize, the main Rust library modules are:

.. list-table:: Main Rust library modules
   :header-rows: 1

   * - Import
     - Description
   * - ``rust``
     - The standard Rust library
   * - ``codeql.rust.elements``
     - The abstract syntax tree library (also imported by `rust.qll`)
   * - ``codeql.rust.controlflow.ControlFlowGraph``
     - The control flow graph library
   * - ``codeql.rust.dataflow.DataFlow``
     - The data flow library
   * - ``codeql.rust.dataflow.TaintTracking``
     - The taint tracking library
