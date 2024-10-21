.. _extensible-predicates:

:orphan:
:nosearch:

Extensible predicates and their interaction with data extensions
================================================================

You can use data extensions to model the methods and callables that control dataflow in any framework or library. This is especially useful for custom frameworks or niche libraries, that are not supported by the standard CodeQL libraries.

.. include:: ../reusables/beta-note-customizing-library-models.rst

About this article
------------------

This reference article describes the available inputs for the extensible predicates, including access paths, kinds, and provenance.

Sources, sinks, summaries, and neutrals are commonly known as models. These models support several shared arguments and a few model-specific arguments. The arguments populate a series of columns for each extensible predicate.

About extensible predicates
---------------------------

At a high level, there are two main components to using data extensions. The query writer defines one or more extensible predicates in their query libraries. CLI and code scanning users who want to augment these predicates supply one or more extension files whose data gets injected into the extensible predicate during evaluation. The extension files are either stored directly in the repository where the codebase to be analyzed is hosted, or downloaded as CodeQL model packs.

This example of an extensible predicate for a source is taken from the core Java libraries https://github.com/github/codeql/blob/main/java/ql/lib/semmle/code/java/dataflow/internal/ExternalFlowExtensions.qll#L8-L11

.. code-block:: ql

    extensible predicate sourceModel(
      string package, string type, boolean subtypes, string name,
      string signature, string ext, string output, string kind,
      string provenance
    );

An extensible predicate is a CodeQL predicate with the following restrictions:

- It uses the ``extensible`` keyword.
- It has no body.
- All predicate parameters have type ``string``, ``int``, ``float``, ``boolean``, or ``date``.
- It is not in a module.

Columns shared by all extensible predicates
-------------------------------------------

The semantics of many of the columns of the extensible predicates are shared. The columns ``package``, ``type``, ``subtypes``, ``name``, and ``signature`` define which element(s) the model applies to.

- ``package``: Name of the package containing the element(s) to be modeled.
- ``type``: Name of the type containing the element(s) to be modeled.
- ``subtypes``: A boolean flag indicating whether the model should also apply to all overrides of the selected element(s).
- ``name``: Name of the element (optional). If this is left blank, it means all elements matching the previous selection criteria.
- ``signature``: Type signature of the selected element (optional). If this is left blank, it means all elements matching the previous selection criteria.
- ``ext``: Specifies additional API-graph-like edges (mostly empty) and out of scope for this document.
- ``provenance``: Provenance (origin) of the model definition. For more information, see ":ref:`provenance`."

The sematics for access paths are also common to all extensible predicates. For more information, see ":ref:`access-paths`."

sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance)
------------------------------------------------------------------------------------

Taint source. Most taint tracking queries will use all sources added to this extensible predicate regardless of their kind.

- ``output``: Access path to the source, where the possibly tainted data flows from.
- ``kind``: Kind of the source.

As most sources are used by all taint tracking queries there are only a few different source kinds.
The following source kinds are supported:

- ``remote``: A remote source of possibly tainted data. This is the most common kind for a source. Sources of this kind are used for almost all taint tracking queries.
- ``contentprovider``, ``android-external-storage-dir``: These kinds are also supported but usage is advanced.

sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance)
---------------------------------------------------------------------------------

Taint sink. As opposed to source kinds, there are many different kinds of sinks as these tend to be more query specific.

- ``input``: Access path to the sink, where we want to check if tainted data can flow into.
- ``kind``: Kind of the sink.

The following sink kinds are supported:

- ``bean-validation``: A sink that can be used for insecure bean validation, such as in calls to ``ConstraintValidatorContext.buildConstraintViolationWithTemplate``.
- ``command-injection``: A sink that can be used to inject shell commands, such as in calls to ``Runtime.exec``.
- ``file-content-store``: A sink that can be used to control the contents of a file, such as in a ``Files.write`` call.
- ``fragment-injection``: A sink that can be used for Android fragment injection, such as in a ``FragmentTransaction.replace`` call.
- ``groovy-injection``: A sink that can be used for Groovy injection, such as in a ``GroovyShell.evaluate`` call.
- ``hostname-verification``: A sink that can be used for unsafe hostname verification, such as in calls to ``HttpsURLConnection.setHostnameVerifier``.
- ``html-injection``: A sink that can be used for XSS via HTML injection, such as in a ``ResponseStream.write`` call.
- ``information-leak``: A sink that can be used to leak information to an HTTP response, such as in calls to ``HttpServletResponse.sendError``.
- ``intent-redirection``: A sink that can be used for Android intent redirection, such as in a ``Context.startActivity`` call.
- ``jexl-injection``: A sink that can be used for JEXL expression injection, such as in a ``JexlExpression.evaluate`` call.
- ``jndi-injection``: A sink that can be used for JNDI injection, such as in a ``Context.lookup`` call.
- ``js-injection``: A sink that can be used for XSS via JavaScript injection, such as in a ``Webview.evaluateJavaScript`` call.
- ``ldap-injection``: A sink that can be used for LDAP injection, such as in a ``DirContext.search`` call.
- ``log-injection``: A sink that can be used for log injection, such as in a ``Logger.warn`` call.
- ``mvel-injection``: A sink that can be used for MVEL expression injection, such as in a ``MVEL.eval`` call.
- ``ognl-injection``: A sink that can be used for OGNL injection, such as in an ``Ognl.getValue`` call.
- ``path-injection``: A sink that can be used for path injection in a file system access, such as in calls to ``new FileReader``.
- ``pending-intents``: A sink that can be used to send an implicit and mutable `PendingIntent` to a third party, such as in an ``Activity.setResult`` call.
- ``request-forgery``: A sink that controls the URL of a request, such as in an ``HttpRequest.newBuilder`` call.
- ``response-splitting``: A sink that can be used for HTTP response splitting, such as in calls to ``HttpServletResponse.setHeader``.
- ``sql-injection``: A sink that can be used for SQL injection, such as in a ``Statement.executeQuery`` call.
- ``template-injection``: A sink that can be used for server-side template injection, such as in a ``Velocity.evaluate`` call.
- ``trust-boundary-violation``: A sink that can be used to cross a trust boundary, such as in a ``HttpSession.setAttribute`` call.
- ``url-redirection``: A sink that can be used to redirect the user to a malicious URL, such as in a ``Response.temporaryRedirect`` call.
- ``xpath-injection``: A sink that can be used for XPath injection, such as in a ``XPath.evaluate`` call.
- ``xslt-injection``: A sink that can be used for XSLT injection, such as in a ``Transformer.transform`` call.

summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance)
--------------------------------------------------------------------------------------------

Flow through (summary). This extensible predicate is used to model flow through elements.

- ``input``: Access path to the input of the element (where data will flow from to the output).
- ``output``: Access path to the output of the element (where data will flow to from the input).
- ``kind``: Kind of the flow through.

The following kinds are supported:

- ``taint``: This means the output is not necessarily equal to the input, but it was derived from the input in an unrestrictive way. An attacker who controls the input will have significant control over the output as well.
- ``value``: This means that the output equals the input or a copy of the input such that all of its properties are preserved.

neutralModel(package, type, name, signature, kind, provenance)
--------------------------------------------------------------

This extensible predicate is not typically needed externally, but is included here for completeness.
It has limited impact on dataflow analysis.
Manual neutrals are considered high-confidence dispatch call targets and can reduce the number of dispatch call targets during dataflow analysis (a performance optimization).

- ``kind``: Kind of the neutral. For neutrals the kind can be ``summary``, ``source``, or ``sink`` to indicate that the callable is neutral with respect to flow (no summary), source (is not a source) or sink (is not a sink).

.. _access-paths:

Access paths
------------
The ``input``, and ``output`` columns consist of a ``.``-separated list of components, which is evaluated from left to right, with each step selecting a new set of values derived from the previous set of values.

The following components are supported:

- ``Argument[``\ `n`\ ``]`` selects the argument at index `n` (zero-indexed).
- ``Argument[``\ `this`\ ``]`` selects the qualifier (instance parameter).
- ``Argument[``\ `n1..n2`\ ``]`` selects the arguments in the given range (both ends included).
- ``Parameter[``\ `n`\ ``]`` selects the parameter at index `n` (zero-indexed).
- ``Parameter[``\ `n1..n2`\ ``]`` selects the parameters in the given range (both ends included).
- ``ReturnValue`` selects the return value.
- ``Field[``\ `name`\ ``]`` selects the field with the fully qualified name `name`.
- ``SyntheticField[``\ `name`\ ``]`` selects the synthetic field with name `name`.
- ``SyntheticGlobal[``\ `name`\ ``]`` selects the synthetic global with name `name`.
- ``ArrayElement`` selects the elements of an array.
- ``Element`` selects the elements of a collection-like container.
- ``WithoutElement`` selects a collection-like container without its elements. This is for input only.
- ``WithElement`` selects the elements of a collection-like container, but points to the container itself. This is for input only.
- ``MapKey`` selects the element keys of a map.
- ``MapValue`` selects the element values of a map.

.. _provenance:

Provenance
----------

The ``provenance`` column is used to specify the provenance (origin) of the model definition and how the model was verified.
The following values are supported.

- ``manual``: The model was manually created and added to the extensible predicate.

Values can also take the form ``ORIGIN-VERIFICATION``, where ``ORIGIN`` is one of:

- ``ai``: The model was generated by artificial intelligence (AI).
- ``df``: The model was generated by the dataflow model generator.
- ``tb``: The model was generated by the type based model generator.
- ``hq``: The model was generated using a heuristic query.

And ``VERIFICATION`` is one of:

- ``manual``: The model was verified by a human.
- ``generated``: The model was generated, but not verified by a human.

The provenance is used to distinguish between models that are manually added (or verified) to the extensible predicate and models that are automatically generated.
Furthermore, it impacts the dataflow analysis in the following way:

- A ``manual`` model takes precedence over ``generated`` models. If a ``manual`` model exists for an element then all ``generated`` models are ignored.
- A ``generated`` model is ignored during analysis, if the source code of the element it is modeling is available.

That is, generated models are less trusted than manual models and only used if neither source code nor a manual model is available.
