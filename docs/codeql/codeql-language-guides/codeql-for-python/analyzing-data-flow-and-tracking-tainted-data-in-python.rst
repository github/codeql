.. _analyzing-data-flow-and-tracking-tainted-data-in-python:

Analyzing data flow and tracking tainted data in Python
=======================================================

You can use CodeQL to track the flow of data through a Python program. Tracking user-controlled, or tainted, data is a key technique for security researchers.

About data flow and taint tracking
----------------------------------

Taint tracking is used to analyze how potentially insecure, or 'tainted' data flows throughout a program at runtime.
You can use taint tracking to find out whether user-controlled input can be used in a malicious way,
whether dangerous arguments are passed to vulnerable functions, and whether confidential or sensitive data can leak.
You can also use it to track invalid, insecure, or untrusted data in other analyses.

Taint tracking differs from basic data flow in that it considers non-value-preserving steps in addition to 'normal' data flow steps.
For example, in the assignment ``dir = path + "/"``, if ``path`` is tainted then ``dir`` is also tainted,
even though there is no data flow from ``path`` to ``path + "/"``.

Separate CodeQL libraries have been written to handle 'normal' data flow and taint tracking in :doc:`C/C++ <../codeql-for-cpp/analyzing-data-flow-in-cpp>`, :doc:`C# <../codeql-for-csharp/analyzing-data-flow-in-csharp>`, :doc:`Java <../codeql-for-java/analyzing-data-flow-in-java>`, and :doc:`JavaScript <../codeql-for-javascript/analyzing-data-flow-in-javascript>`. You can access the appropriate classes and predicates that reason about these different modes of data flow by importing the appropriate library in your query.
In Python analysis, we can use the same taint tracking library to model both 'normal' data flow and taint flow, but we are still able make the distinction between steps that preserve values and those that don't by defining additional data flow properties.

For further information on data flow and taint tracking with CodeQL, see ":ref:`Introduction to data flow <about-data-flow-analysis>`."

Fundamentals of taint tracking using data flow analysis
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The taint tracking library is in the `TaintTracking <https://help.semmle.com/qldoc/python/semmle/python/dataflow/TaintTracking.qll/module.TaintTracking.html>`__ module.
Any taint tracking or data flow analysis query has three explicit components, one of which is optional, and an implicit component.
The explicit components are:

1. One or more ``sources`` of potentially insecure or unsafe data, represented by the `TaintTracking::Source <https://help.semmle.com/qldoc/python/semmle/python/dataflow/TaintTracking.qll/type.TaintTracking$TaintSource.html>`__ class.
2. One or more ``sinks``, to where the data or taint may flow, represented by the `TaintTracking::Sink <https://help.semmle.com/qldoc/python/semmle/python/dataflow/TaintTracking.qll/type.TaintTracking$TaintSink.html>`__ class.
3. Zero or more ``sanitizers``, represented by the `Sanitizer <https://help.semmle.com/qldoc/python/semmle/python/dataflow/TaintTracking.qll/type.TaintTracking$Sanitizer.html>`__ class.

A taint tracking or data flow query gives results when there is the flow of data from a source to a sink, which is not blocked by a sanitizer.

These three components are bound together using a `TaintTracking::Configuration <https://help.semmle.com/qldoc/python/semmle/python/dataflow/Configuration.qll/type.Configuration$TaintTracking$Configuration.html>`__.
The purpose of the configuration is to specify exactly which sources and sinks are relevant to the specific query.

The final, implicit component is the "kind" of taint, represented by the `TaintKind <https://help.semmle.com/qldoc/python/semmle/python/dataflow/TaintTracking.qll/type.TaintTracking$TaintKind.html>`__ class.
The kind of taint determines which non-value-preserving steps are possible, in addition to value-preserving steps that are built into the analysis.
In the above example ``dir = path + "/"``, taint flows from ``path`` to ``dir`` if the taint represents a string, but not if the taint is ``None``.

Limitations
^^^^^^^^^^^

Although taint tracking is a powerful technique, it is worth noting that it depends on the underlying data flow graphs.
Creating a data flow graph that is both accurate and covers a large enough part of a program is a challenge,
especially for a dynamic language like Python. The call graph might be incomplete, the reachability of code is an approximation,
and certain constructs, like ``eval``, are just too dynamic to analyze.


Using taint-tracking for Python
-------------------------------

A simple taint tracking query has the basic form:

.. code-block:: ql

    /**
     * @name ...
     * @description ...
     * @kind problem
     */

    import semmle.python.security.TaintTracking

    class MyConfiguration extends TaintTracking::Configuration {

        MyConfiguration() { this = "My example configuration" }

        override predicate isSource(TaintTracking::Source src) { ... }

        override predicate isSink(TaintTracking::Sink sink) { ... }

        /* optionally */
        override predicate isExtension(Extension extension) { ... }

    }

    from MyConfiguration config, TaintTracking::Source src, TaintTracking::Sink sink
    where config.hasFlow(src, sink)
    select sink, "Alert message, including reference to $@.", src, "string describing the source"

Example
^^^^^^^

As a contrived example, here is a query that looks for flow from a HTTP request to a function called ``"unsafe"``.
The sources are predefined and accessed by importing library ``semmle.python.web.HttpRequest``.
The sink is defined by using a custom ``TaintTracking::Sink`` class.

.. code-block:: ql

    /* Import the string taint kind needed by our custom sink */
    import semmle.python.security.strings.Untrusted

    /* Sources */
    import semmle.python.web.HttpRequest

    /* Sink */
    /** A class representing any argument in a call to a function called "unsafe" */
    class UnsafeSink extends TaintTracking::Sink {

        UnsafeSink() {
            exists(FunctionValue unsafe |
                unsafe.getName() = "unsafe" and
                unsafe.getACall().(CallNode).getAnArg() = this
            )
        }

        override predicate sinks(TaintKind kind) {
            kind instanceof StringKind
        }

    }

    class HttpToUnsafeConfiguration extends TaintTracking::Configuration {

        HttpToUnsafeConfiguration() {
            this = "Example config finding flow from http request to 'unsafe' function"
        }

        override predicate isSource(TaintTracking::Source src) { src instanceof HttpRequestTaintSource }

        override predicate isSink(TaintTracking::Sink sink) { sink instanceof UnsafeSink }

    }

    from HttpToUnsafeConfiguration config, TaintTracking::Source src, TaintTracking::Sink sink
    where config.hasFlow(src, sink)
    select sink, "This argument to 'unsafe' depends on $@.", src, "a user-provided value"



Converting a taint-tracking query to a path query
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Although the taint tracking query above tells which sources flow to which sinks, it doesn't tell us how.
For that we need a path query.

A standard taint tracking query can be converted to a path query by changing ``@kind problem`` to ``@kind path-problem``,
adding an import and changing the format of the query clauses.
The import is simply:

.. code-block:: ql

    import semmle.python.security.Paths

And the format of the query becomes:

.. code-block:: ql

    from Configuration config, TaintedPathSource src, TaintedPathSink sink
    where config.hasFlowPath(src, sink)
    select sink.getSink(), src, sink, "Alert message, including reference to $@.", src.getSource(), "string describing the source"

Thus, our example query becomes:

.. code-block:: ql

    /**
     * ...
     * @kind path-problem
     * ...
     */

    /* This computes the paths */
    import semmle.python.security.Paths

    /* Expose the string taint kinds needed by our custom sink */
    import semmle.python.security.strings.Untrusted

    /* Sources */
    import semmle.python.web.HttpRequest

    /* Sink */
    /** A class representing any argument in a call to a function called "unsafe" */
    class UnsafeSink extends TaintTracking::Sink {

        UnsafeSink() {
            exists(FunctionValue unsafe |
                unsafe.getName() = "unsafe" and
                unsafe.getACall().(CallNode).getAnArg() = this
            )
        }

        override predicate sinks(TaintKind kind) {
            kind instanceof StringKind
        }

    }

    class HttpToUnsafeConfiguration extends TaintTracking::Configuration {

        HttpToUnsafeConfiguration() {
            this = "Example config finding flow from http request to 'unsafe' function"
        }

        override predicate isSource(TaintTracking::Source src) { src instanceof HttpRequestTaintSource }

        override predicate isSink(TaintTracking::Sink sink) { sink instanceof UnsafeSink }

    }

    from HttpToUnsafeConfiguration config, TaintedPathSource src, TaintedPathSink sink
    where config.hasFlowPath(src, sink)
    select sink.getSink(), src, sink, "This argument to 'unsafe' depends on $@.", src.getSource(), "a user-provided value"



Tracking custom taint kinds and flows
-------------------------------------

In the above examples, we have assumed the existence of a suitable ``TaintKind``,
but sometimes it is necessary to model the flow of other objects, such as database connections, or ``None``.

The ``TaintTracking::Source`` and ``TaintTracking::Sink`` classes have predicates that determine which kind of taint the source and sink model, respectively.

.. code-block:: ql

    abstract class Source {
        abstract predicate isSourceOf(TaintKind kind);
        ...
    }

    abstract class Sink {
        abstract predicate sinks(TaintKind taint);
        ...
    }

The ``TaintKind`` itself is just a string (a QL string, not a CodeQL entity representing a Python string),
which provides methods to extend flow and allow the kind of taint to change along the path.
The ``TaintKind`` class has many predicates allowing flow to be modified.
This simplest ``TaintKind`` does not override any predicates, meaning that it only flows as opaque data.
An example of this is the "Hard-coded credentials" query,
which defines the simplest possible taint kind class, ``HardcodedValue``, and custom source and sink classes. For more information, see `Hard-coded credentials <https://lgtm.com/query/rule:1506421276400/lang:python/>`_ on LGTM.com.

.. code-block:: ql

    class HardcodedValue extends TaintKind {
        HardcodedValue() {
            this = "hard coded value"
        }
    }

    class HardcodedValueSource extends TaintTracking::Source {
        ...
        override predicate isSourceOf(TaintKind kind) {
            kind instanceof HardcodedValue
        }
    }

    class CredentialSink extends TaintTracking::Sink {
        ...
        override predicate sinks(TaintKind kind) {
            kind instanceof HardcodedValue
        }
    }

Further reading
---------------

- ":ref:`Exploring data flow with path queries <exploring-data-flow-with-path-queries>`"


.. include:: ../../reusables/python-further-reading.rst
.. include:: ../../reusables/codeql-ref-tools-further-reading.rst

