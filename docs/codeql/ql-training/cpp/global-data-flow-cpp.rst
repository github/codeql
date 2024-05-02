================================
Introduction to global data flow
================================

CodeQL for C/C++
   
.. rst-class:: setup

Setup
=====

For this example you need to set up `CodeQL for Visual Studio Code <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/installing-codeql-for-vs-code>`__ and download the CodeQL database for `dotnet/coreclr <https://github.com/dotnet/coreclr>`__ from GitHub.

.. rst-class:: agenda

Agenda
======

- Global taint tracking
- Sanitizers
- Path queries
- Data flow models

.. insert common global data flow slides

.. include:: ../slide-snippets/global-data-flow.rst

.. resume language-specific global data flow slides


Finding tainted format strings (outline)
========================================

.. literalinclude:: ../query-examples/cpp/global-data-flow-cpp-1.ql
  :language: ql

.. note::

  Here’s the outline for a inter-procedural (that is, “global”) version of the tainted formatting strings query we saw in the previous slide deck. The same template will be applicable for most taint tracking problems.

Defining sources
================

The library class ``SecurityOptions`` provides a (configurable) model of what counts as user-controlled data:

.. code-block:: ql

  import semmle.code.cpp.security.Security

  module TaintedFormatConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      exists (SecurityOptions opts |
        opts.isUserInput(source.asExpr(), _)
      )
    }
    ...
  }

.. note::

  We first define what it means to be a *source* of tainted data for this particular problem. In this case, what we care about is whether the format string can be provided by an external user to our application or service. As there are many such ways external data could be introduced into the system, the standard CodeQL libraries for C/C++ include an extensible API for modeling user input. In this case, we will simply use the predefined set of *user inputs*, which includes arguments provided to command line applications.


Defining sinks (exercise)
=========================

Use the ``FormattingFunction`` class to fill in the definition of ``isSink``.

.. code-block:: ql

  import semmle.code.cpp.security.Security

  module TaintedFormatConfig implements DataFlow::ConfigSig {
    predicate isSink(DataFlow::Node sink) {
      /* Fill me in */
    }
    ...
  }

.. note::

  The second part is to define what it means to be a sink for this particular problem. The queries from the previous slide deck will be useful for this exercise.

Defining sinks (answer)
=======================

Use the ``FormattingFunction`` class, we can write the sink as:

.. code-block:: ql

  import semmle.code.cpp.security.Security

  module TaintedFormatConfig implements DataFlow::ConfigSig {
    predicate isSink(DataFlow::Node sink) {
      exists (FormattingFunction ff, Call c |
        c.getTarget() = ff and
        c.getArgument(ff.getFormatParameterIndex()) = sink.asExpr()
      )
    }
    ...
  }

.. note::

  When we run this query, we should find a single result. However, it is tricky to determine whether this result is a true positive (a “real” result) because our query only reports the source and the sink, and not the path through the graph between the two.

.. insert path queries slides

.. include:: ../slide-snippets/path-queries.rst

.. resume language-specific global data flow slides

Defining additional taint steps
===============================

Add an additional taint step that (heuristically) taints a local variable if it is a pointer, and it is passed to a function in a parameter position that taints it.

.. code-block:: ql

  module TaintedFormatConfig implements DataFlow::ConfigSig {
    predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
      exists (Call c, Expr arg, LocalVariable lv |
        arg = c.getAnArgument() and
        arg = pred.asExpr() and
        arg.getFullyConverted().getUnderlyingType() instanceof PointerType and
        arg = lv.getAnAccess() and
        succ.asUninitialized() = lv
      )
    }
    ...
  }

Defining sanitizers
===================

Add a sanitizer, stopping propagation at parameters of formatting functions, to avoid double-reporting:

.. code-block:: ql

  module TaintedFormatConfig implements DataFlow::ConfigSig {
    predicate isBarrier(DataFlow::Node nd) {
      exists (FormattingFunction ff, int idx |
        idx = ff.getFormatParameterIndex() and
        nd = DataFlow::parameterNode(ff.getParameter(idx))
      )
    }
    ...
  }

Data flow models
================

- To provide models of data/taint flow through library functions, you can implement subclasses of ``DataFlowFunction`` (from ``semmle.code.cpp.models.interfaces.DataFlow``) and ``TaintFunction`` (from ``semmle.code.cpp.models.interfaces.Taint``), respectively

- Example: model of taint flow from third to first parameter of ``memcpy``

   .. code-block:: ql
   
      class MemcpyFunction extends TaintFunction {
            MemcpyFunction() { this.hasName("memcpy") }
            override predicate hasTaintFlow(FunctionInput i, FunctionOutput o) 
                i.isInParameter(2) and o.isOutParameterPointer(0)
            }
      }
   
.. note::

  See the API documentation for more details about ``FunctionInput`` and ``FunctionOutput``.

.. rst-class:: end-slide

Extra slides
============

.. include:: ../slide-snippets/global-data-flow-extra-slides.rst
