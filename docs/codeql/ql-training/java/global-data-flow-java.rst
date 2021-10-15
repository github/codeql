================================
Introduction to global data flow
================================

CodeQL for Java

.. rst-class:: setup

Setup
=====

For this example you should download:

- `CodeQL for Visual Studio Code <https://codeql.github.com/docs/codeql-for-visual-studio-code/setting-up-codeql-in-visual-studio-code/>`__
- `Apache Struts database <https://downloads.lgtm.com/snapshots/java/apache/struts/apache-struts-7fd1622-CVE-2018-11776.zip>`__

.. note::

   For this example, we will be analyzing `Apache Struts <https://github.com/apache/struts>`__.

   You can also query the project in `the query console <https://lgtm.com/query/project:1878521151/lang:java/>`__ on LGTM.com.

   .. insert database-note.rst to explain differences between database available to download and the version available in the query console.

   .. include:: ../slide-snippets/database-note.rst

   .. resume slides

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

Code injection in Apache struts
===============================

- In April 2018, Man Yue Mo, a security researcher at Semmle, reported 5 remote code execution (RCE) vulnerabilities (CVE-2018-11776) in Apache Struts.

- These vulnerabilities were caused by untrusted, unsanitized data being evaluated as an OGNL (Object Graph Navigation Library) expression, allowing malicious users to perform remote code execution.

- Conceptually, this is a global taint tracking problem - does untrusted remote input flow to a method call which evaluates OGNL?

.. note::

   More details on the CVE can be found here: https://securitylab.github.com/research/apache-struts-CVE-2018-11776 and 
   https://github.com/github/securitylab/tree/main/CodeQL_Queries/java/Apache_Struts_CVE-2018-11776

   More details on OGNL can be found here: https://commons.apache.org/proper/commons-ognl/

.. rst-class:: java-data-flow-code-example

Code example
============

Finding RCEs (outline)
======================

.. literalinclude:: ../query-examples/java/global-data-flow-java-1.ql
   :language: ql

Defining sources
================

We want to look for method calls where the method name is ``getNamespace()``, and the declaring type of the method is a class called ``ActionProxy``.

.. code-block:: ql

  import semmle.code.java.security.Security

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isSource(DataFlow::Node source) {
      exists(Method m |
    	   m.getName() = "getNamespace" and
    	   m.getDeclaringType().getName() = "ActionProxy" and
    	   source.asExpr() = m.getAReference()
      )
    }
    ...
  }

.. note::

  We first define what it means to be a *source* of tainted data for this particular problem. In this case, we are interested in the value returned by calls to ``getNamespace()``.


Exercise: Defining sinks
========================

Fill in the definition of ``isSink``.

**Hint**: We want to find the first argument of calls to the method ``compileAndExecute``.

.. code-block:: ql

  import semmle.code.java.security.Security

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isSink(DataFlow::Node sink) {
      /* Fill me in */
    }
    ...
  }

.. note::

  The second part is to define what it means to be a sink for this particular problem. The queries from an :doc:`Introduction to data flow <data-flow-java>`  will be useful for this exercise.

Solution: Defining sinks
========================

Find a method access to ``compileAndExecute``, and mark the first argument.

.. code-block:: ql

  import semmle.code.java.security.Security

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isSink(DataFlow::Node sink) {
    	exists(MethodAccess ma |
        ma.getMethod().getName() = "compileAndExecute" and
        ma.getArgument(0) = sink.asExpr()
      )
    }
    ...
  }

.. insert path queries slides

.. include:: ../slide-snippets/path-queries.rst

.. resume language-specific global data flow slides

Defining sanitizers
===================

A sanitizer allows us to *prevent* flow through a particular node in the graph. For example, flows that go via ``ValueStackShadowMap`` are not particularly interesting, because it is a class that is rarely used in practice. We can exclude them like so:

.. code-block:: ql

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isSanitizer(DataFlow::Node nd) {
      nd.getEnclosingCallable()
        .getDeclaringType()
        .getName() = "ValueStackShadowMap"
    }
    ...
  }

Defining additional taint steps
===============================

Add an additional taint step that (heuristically) taints a local variable if it is a pointer, and it is passed to a function in a parameter position that taints it.

.. code-block:: ql

  class TaintedOGNLConfig extends TaintTracking::Configuration {
    override predicate isAdditionalTaintStep(DataFlow::Node node1,
                                             DataFlow::Node node2) {
      exists(Field f, RefType t |
        node1.asExpr() = f.getAnAssignedValue() and
        node2.asExpr() = f.getAnAccess() and
        node1.asExpr().getEnclosingCallable().getDeclaringType() = t and
        node2.asExpr().getEnclosingCallable().getDeclaringType() = t
      )
    }
    ...
  }


.. rst-class:: end-slide

Extra slides
============

.. include:: ../slide-snippets/global-data-flow-extra-slides.rst
