=========================
Introduction to data flow
=========================

Finding string formatting vulnerabilities in C/C++

.. rst-class:: setup

Setup
=====

For this example you should download:

- `CodeQL for Visual Studio Code <https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html>`__
- `dotnet/coreclr database <http://downloads.lgtm.com/snapshots/cpp/dotnet/coreclr/dotnet_coreclr_fbe0c77.zip>`__

.. note::

   For the examples in this presentation, we will be analyzing `dotnet/coreclr <https://github.com/dotnet/coreclr>`__.

   You can query the project in `the query console <https://lgtm.com/query/projects:1505958977333/lang:cpp/>`__ on LGTM.com.

   .. insert database-note.rst to explain differences between database available to download and the version available in the query console.

   .. include:: ../slide-snippets/database-note.rst

   .. resume slides

.. rst-class:: agenda

Agenda
======

- Non-constant format string
- Data flow
- Modules and libraries
- Local data flow
- Local taint tracking

Motivation
==========

Let’s write a query to identify instances of `CWE-134 <https://cwe.mitre.org/data/definitions/134.html>`__ **Use of externally controlled format string**.

.. code-block:: cpp

  printf(userControlledString, arg1);

**Goal**: Find uses of ``printf`` (or similar) where the format string can be controlled by an attacker.

.. note::

  Formatting functions allow the programmer to construct a string output using a *format string* and an optional set of arguments. The *format string* is specified using a simple template language, where the output string is constructed by processing the format string to find *format specifiers*, and inserting values provided as arguments. For example:

  .. code-block:: cpp

    printf("Name: %s, Age: %d", "Freddie", 2);

  would produce the output ``"Name: Freddie, Age: 2”``. So far, so good. However, problems arise if there is a mismatch between the number of formatting specifiers, and the number of arguments. For example:

  .. code-block:: cpp

    printf("Name: %s, Age: %d", "Freddie");

  In this case, we have one more format specifier than we have arguments. In a managed language such as Java or C#, this simply leads to a runtime exception. However, in C/C++, the formatting functions are typically implemented by reading values from the stack without any validation of the number of arguments. This means a mismatch in the number of format specifiers and format arguments can lead to information disclosure.

  Of course, in practice this happens rarely with *constant* formatting strings. Instead, it’s most problematic when the formatting string can be specified by the user, allowing an attacker to provide a formatting string with the wrong number of format specifiers. Furthermore, if an attacker can control the format string, they may be able to provide the ``%n`` format specifier, which causes ``printf`` to write the number characters in the generated output string to a specified location.

  See https://en.wikipedia.org/wiki/Uncontrolled_format_string for more background.

Exercise: Non-constant format string
====================================

Write a query that flags ``printf`` calls where the format argument is not a ``StringLiteral``. 

**Hint**: Import ``semmle.code.cpp.commons.Printf`` and use class ``FormattingFunction`` and ``getFormatParameterIndex()``.

.. rst-class:: build

.. literalinclude:: ../query-examples/cpp/data-flow-cpp-1.ql
  :language: ql

.. note::

  This first query is about finding places where the format specifier is not a constant string. In the CodeQL libraries for C/C++, constant strings are modeled as ``StringLiteral`` nodes, so we are looking for calls to format functions where the format specifier argument is not a string literal.

  The `C/C++ standard libraries <https://help.semmle.com/qldoc/cpp/>`__ include many different formatting functions that may be vulnerable to this particular attack–including ``printf``, ``snprintf``, and others. Furthermore, each of these different formatting functions may include the format string in a different position in the argument list. Instead of laboriously listing all these different variants, we can make use of the standard CodeQL class ``FormattingFunction``, which provides an interface that models common formatting functions in C/C++.

Meh...
======

Results are unsatisfactory:

- Query flags cases where the format string is a symbolic constant.
- Query flags cases where the format string is itself a format argument.
- Query doesn't recognize wrapper functions around ``printf``-like functions.

We need something better.

.. note::

  For example, consider the results which appear in ``/src/ToolBox/SOS/Strike/util.h``, between lines 965 and 970:

  .. code-block:: cpp

          const char *format = align == AlignLeft ? "%-*.*s" : "%*.*s";
      
                if (IsDMLEnabled())
                    DMLOut(format, width, precision, mValue);
                else
                    ExtOut(format, width, precision, mValue);

  Here, ``DMLOut`` and ``ExtOut`` are macros that expand to formatting calls. The format specifier is not constant, in the sense that the format argument is not a string literal. However, it is clearly one of two possible constants, both with the same number of format specifiers.

  What we need is a way to determine whether the format argument is ever set to something that is not constant.

.. include general data flow slides

.. include:: ../slide-snippets/local-data-flow.rst

.. resume language-specific slides

Exercise: source nodes
======================

Define a subclass of ``DataFlow::Node`` representing “source” nodes, that is, nodes without a (local) data flow predecessor.

**Hint**: use ``not exists()``.

.. rst-class:: build

.. code-block:: ql

  class SourceNode extends DataFlow::Node {
      SourceNode() {
        not DataFlow::localFlowStep(_, this)
      }
    }

.. note::

  Note the scoping of the `don’t-care variable <https://help.semmle.com/QL/ql-handbook/expressions.html#don-t-care-expressions>`__ “_” in this example: the body of the characteristic predicate is equivalent to:
  
  .. code-block:: ql

    not exists(DataFlow::Node pred | DataFlow::localFlowStep(pred, this))
    
  which is not the same as:

  .. code-block:: ql

    exists(DataFlow::Node pred | not DataFlow::localFlowStep(pred, this)).

Revisiting non-constant format strings
======================================

Refine the query to find calls to ``printf``-like functions where the format argument derives from a local source that is not a constant string.

.. rst-class:: build

.. code-block:: ql

   import cpp
   import semmle.code.cpp.dataflow.DataFlow
   import semmle.code.cpp.commons.Printf
   
   class SourceNode extends DataFlow::Node { ... }
   
   from FormattingFunction f, Call c, SourceNode src, DataFlow::Node  arg
   where c.getTarget() = f and
         arg.asExpr() = c.getArgument(f.getFormatParameterIndex()) and
         DataFlow::localFlow(src, arg) and
         not src.asExpr() instanceof StringLiteral
   select arg, "Non-constant format string."

Refinements (take home exercise)
================================

Audit the results and apply any refinements you deem necessary.

Suggestions:

- Replace ``DataFlow::localFlowStep`` with a custom predicate that includes steps through global variable definitions.

  **Hint**: Use class ``GlobalVariable`` and its member predicates ``getAnAssignedValue()`` and ``getAnAccess()``.

- Exclude calls in wrapper functions that just forward their format argument to another ``printf``-like function; instead, flag calls to those functions.

Beyond local data flow
======================

- Results are still underwhelming.
- Dealing with parameter passing becomes cumbersome.
- Instead, let’s turn the problem around and find user-controlled data that flows into a ``printf`` format argument, potentially through calls.
- This needs :doc:`global data flow <global-data-flow-cpp>`.
