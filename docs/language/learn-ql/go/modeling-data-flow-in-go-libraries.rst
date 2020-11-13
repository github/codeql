Modeling data flow in Go libraries
==================================

When analyzing a Go program, CodeQL does not examine the source code for
external packages. To track the flow of untrusted data through a library, you
can create a model of the library.

You can find existing models in the ``ql/src/semmle/go/frameworks/`` folder of the
`CodeQL for Go repository <https://github.com/github/codeql-go/tree/main/ql/src/semmle/go/frameworks>`__.
To add a new model, you should make a new file in that folder, named after the library.

Sources
-------

To mark a source of data that is controlled by an untrusted user, we
create a class extending ``UntrustedFlowSource::Range``. Inheritance and
the characteristic predicate of the class should be used to specify
exactly the dataflow node that introduces the data. Here is a short
example from ``Mux.qll``.

.. code-block:: ql

   class RequestVars extends DataFlow::UntrustedFlowSource::Range, DataFlow::CallNode {
     RequestVars() { this.getTarget().hasQualifiedName("github.com/gorilla/mux", "Vars") }
   }

This has the effect that all calls to `the function Vars from the
package mux <http://www.gorillatoolkit.org/pkg/mux#Vars>`__ are
treated as sources of untrusted data.

Flow propagation
----------------

By default, we assume that all functions in libraries do not have
any data flow. To indicate that a particular function does have data flow,
create a class extending ``TaintTracking::FunctionModel`` (or
``DataFlow::FunctionModel`` if the untrusted user data is passed on
without being modified).

Inheritance and the characteristic predicate of the class should specify
the function. The class should also have a member predicate with the signature
``override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp)``
(or
``override predicate hasDataFlow(FunctionInput inp, FunctionOutput outp)``
if extending ``DataFlow::FunctionModel``). The body should constrain
``inp`` and ``outp``.

``FunctionInput`` is an abstract representation of the inputs to a
function. The options are:

* the receiver (``inp.isReceiver()``)
* one of the parameters (``inp.isParameter(i)``)
* one of the results (``inp.isResult(i)``, or ``inp.isResult`` if there is only one result)

Note that it may seem strange that the result of a function could be
considered as a function input, but it is needed in some cases. For
instance, the function ``bufio.NewWriter`` returns a writer ``bw`` that
buffers write operations to an underlying writer ``w``. If tainted data
is written to ``bw``, then it makes sense to propagate that taint back
to the underlying writer ``w``, which can be modeled by saying that
``bufio.NewWriter`` propagates taint from its result to its first
argument.

Similarly, ``FunctionOutput`` is an abstract representation of the
outputs to a function. The options are:

* the receiver (``outp.isReceiver()``)
* one of the parameters (``outp.isParameter(i)``)
* one of the results (``outp.isResult(i)``, or ``outp.isResult`` if there is only one result)

Here is an example from ``Gin.qll``, which has been slightly simplified.

.. code-block:: ql

   private class ParamsGet extends TaintTracking::FunctionModel, Method {
     ParamsGet() { this.hasQualifiedName("github.com/gin-gonic/gin", "Params", "Get") }

     override predicate hasTaintFlow(FunctionInput inp, FunctionOutput outp) {
       inp.isReceiver() and outp.isResult(0)
     }
   }

This has the effect that calls to the ``Get`` method with receiver type
``Params`` from the ``gin-gonic/gin`` package allow taint to flow from
the receiver to the first result. In other words, if ``p`` has type
``Params`` and taint can flow to it, then after the line
``x := p.Get("foo")`` taint can also flow to ``x``.

Sanitizers
----------

It is not necessary to indicate that library functions are sanitizers.
Their bodies are not analyzed, so it is assumed that data does not
flow through them.

Sinks
-----

Data-flow sinks are specified by queries rather than by library models.
However, you can use library models to indicate when functions belong to
special categories. Queries can then use these categories when specifying
sinks. Classes representing these special categories are contained in
``ql/src/semmle/go/Concepts.qll`` in the `CodeQL for Go repository
<https://github.com/github/codeql-go/blob/main/ql/src/semmle/go/Concepts.qll>`__.
``Concepts.qll`` includes classes for logger mechanisms,
HTTP response writers, HTTP redirects, and marshaling and unmarshaling
functions.

Here is a short example from ``Stdlib.qll``, which has been slightly simplified.

.. code-block:: ql

   private class PrintfCall extends LoggerCall::Range, DataFlow::CallNode {
     PrintfCall() { this.getTarget().hasQualifiedName("fmt", ["Print", "Printf", "Println"]) }

     override DataFlow::Node getAMessageComponent() { result = this.getAnArgument() }
   }

This has the effect that any call to ``Print``, ``Printf``, or
``Println`` in the package ``fmt`` is recognized as a logger call.
Any query that uses logger calls as a sink will then identify when tainted data 
has been passed as an argument to ``Print``, ``Printf``, or ``Println``.
