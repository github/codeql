.. _customizing-library-models-for-cpp:

Customizing library models for C and C++
========================================

You can model the methods and callables that control data flow in any framework or library. This is especially useful for custom frameworks or niche libraries, that are not supported by the standard CodeQL libraries.

.. include:: ../reusables/beta-note-customizing-library-models.rst

About this article
------------------

This article contains reference material about how to define custom models for sources, sinks, and flow summaries for C and C++ dependencies in data extension files.

About data extensions
---------------------

You can customize analysis by defining models (summaries, sinks, and sources) of your code's C and C++ dependencies in data extension files. Each model defines the behavior of one or more elements of your library or framework, such as callables. When you run dataflow analysis, these models expand the potential sources and sinks tracked by dataflow analysis and improve the precision of results.

Many of the security queries search for paths from a source of untrusted input to a sink that represents a vulnerability. This is known as taint tracking. Each source is a starting point for dataflow analysis to track tainted data and each sink is an end point.

Taint tracking queries also need to know how data can flow through elements that are not included in the source code. These are modeled as summaries. A summary model enables queries to synthesize the flow behavior through elements in dependency code that is not stored in your repository.

Syntax used to define an element in an extension file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each model of an element is defined using a data extension where each tuple constitutes a model.
A data extension file to extend the standard CPP queries included with CodeQL is a YAML file with the form:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/cpp-all
         extensible: <name of extensible predicate>
       data:
         - <tuple1>
         - <tuple2>
         - ...

Each YAML file may contain one or more top-level extensions.

- ``addsTo`` defines the CodeQL pack name and extensible predicate that the extension is injected into.
- ``data`` defines one or more rows of tuples that are injected as values into the extensible predicate. The number of columns and their types must match the definition of the extensible predicate.

Data extensions use union semantics, which means that the tuples of all extensions for a single extensible predicate are combined, duplicates are removed, and all of the remaining tuples are queryable by referencing the extensible predicate.

Publish data extension files in a CodeQL model pack to share
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can group one or more data extension files into a CodeQL model pack and publish it to the GitHub Container Registry. This makes it easy for anyone to download the model pack and use it to extend their analysis. For more information, see `Creating a CodeQL model pack <https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/creating-and-working-with-codeql-packs#creating-a-codeql-model-pack>`__ and `Publishing and using CodeQL packs <https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/publishing-and-using-codeql-packs/>`__ in the CodeQL CLI documentation.

Extensible predicates used to create custom models in C and C++
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The CodeQL library for CPP analysis exposes the following extensible predicates:

- ``sourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance)``. This is used to model sources of potentially tainted data. The ``kind`` of the sources defined using this predicate determine which threat model they are associated with. Different threat models can be used to customize the sources used in an analysis. For more information, see ":ref:`Threat models <threat-models-cpp>`."
- ``sinkModel(namespace, type, subtypes, name, signature, ext, input, kind, provenance)``. This is used to model sinks where tainted data may be used in a way that makes the code vulnerable.
- ``summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance)``. This is used to model flow through elements.

The extensible predicates are populated using the models defined in data extension files.

Example of custom model definitions
------------------------------------

The examples in this section are taken from the standard CodeQL CPP query pack published by GitHub. They demonstrate how to add tuples to extend extensible predicates that are used by the standard queries.

Example: Taint source from the ``boost::asio`` namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the CPP query pack models the return value from the ``read_until`` function as a ``remote`` source.

.. code-block:: cpp

   boost::asio::read_until(socket, recv_buffer, '\0', error);

We need to add a tuple to the ``sourceModel``\(namespace, type, subtypes, name, signature, ext, output, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/cpp-all
         extensible: sourceModel
       data:
         - ["boost::asio", "", False, "read_until", "", "", "Argument[*1]", "remote", "manual"]

Since we are adding a new source, we need to add a tuple to the ``sourceModel`` extensible predicate.
The first five values identify the callable (in this case a free function) to be modeled as a source.

- The first value ``"boost::asio"`` is the namespace name.
- The second value ``""`` is the name of the type (class) that contains the method. Because we're modelling a free function, the type is left blank.
- The third value ``False`` is a flag that indicates whether or not the sink also applies to all overrides of the method. For a free function, this should be ``False``.
- The fourth value ``"read_until"`` is the function name.
- The fifth value is the function input type signature, which can be used to narrow down between functions that have the same name. In this case, we want the model to include all functions in ``boost::asio`` called ``read_until``.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the output specification, the ``kind``, and the ``provenance`` (origin) of the source.

- The seventh value ``"Argument[*1]"`` is the output specification, which means in this case that the sink is the first indirection (or pointed-to value, ``*``) of the second argument (``Argument[1]``) passed to the function.
- The eighth value ``"remote"`` is the kind of the source. The source kind is used to define the threat model where the source is in scope. ``remote`` applies to many of the security related queries as it means a remote source of untrusted data. For more information, see ":ref:`Threat models <threat-models-cpp>`."
- The ninth value ``"manual"`` is the provenance of the source, which is used to identify the origin of the source model.

Example: Taint sink in the ``boost::asio`` namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the CPP query pack models the second argument of the ``boost::asio::write`` function as a remote flow sink. A remote flow sink is where data is transmitted to other machines across a network, which is used for example by the "Cleartext transmission of sensitive information" (`cpp/cleartext-transmission`) query.

.. code-block:: cpp

   boost::asio::write(socket, send_buffer, error);

We need to add a tuple to the ``sinkModel``\(namespace, type, subtypes, name, signature, ext, input, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/cpp-all
         extensible: sinkModel
       data:
         - ["boost::asio", "", False, "write", "", "", "Argument[*1]", "remote-sink", "manual"]

Since we want to add a new sink, we need to add a tuple to the ``sinkModel`` extensible predicate.
The first five values identify the callable (in this case a free function) to be modeled as a sink.

- The first value ``"boost::asio"`` is the namespace name.
- The second value ``""`` is the name of the type (class) that contains the method. Because we're modelling a free function, the type is left blank.
- The third value ``False`` is a flag that indicates whether or not the sink also applies to all overrides of the method. For a free function, this should be ``False``.
- The fourth value ``"write"`` is the function name.
- The fifth value is the function input type signature, which can be used to narrow down between functions that have the same name. In this case, we want the model to include all functions in ``boost::asio`` called ``write``.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the output specification, the ``kind``, and the ``provenance`` (origin) of the sink.

- The seventh value ``"Argument[*1]"`` is the output specification, which means in this case that the sink is the first indirection (or pointed-to value, ``*``) of the second argument (``Argument[1]``) passed to the function.
- The eighth value ``"remote-sink"`` is the kind of the sink. The sink kind is used to define the queries where the sink is in scope.
- The ninth value ``"manual"`` is the provenance of the sink, which is used to identify the origin of the sink model.

Example: Add flow through the ``boost::asio::buffer`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the CPP query pack models flow through a function for a simple case.

.. code-block:: cpp

   boost::asio::write(socket, boost::asio::buffer(send_str), error);

We need to add tuples to the ``summaryModel``\(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/cpp-all
         extensible: summaryModel
       data:
         - ["boost::asio", "", False, "buffer", "", "", "Argument[*0]", "ReturnValue", "taint", "manual"]

Since we are adding flow through a function, we need to add tuples to the ``summaryModel`` extensible predicate.

The first five values identify the callable (in this case free function) to be modeled as a summary.

- The first value ``"boost::asio"`` is the namespace name.
- The second value ``""`` is the name of the type (class) that contains the method. Because we're modelling a free function, the type is left blank.
- The third value ``False`` is a flag that indicates whether or not the sink also applies to all overrides of the method. For a free function, this should be ``False``.
- The fourth value ``"buffer"`` is the function name.
- The fifth value is the function input type signature, which can be used to narrow down between functions that have the same name. In this case, we want the model to include all functions in ``boost::asio`` called ``buffer``.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the input and output specifications, the ``kind``, and the ``provenance`` (origin) of the summary.

- The seventh value is the input specification (where data flows from). ``Argument[*0]`` specifies the first indirection (or pointed-to value, ``*``) of the first argument (``Argument[0]``) passed to the function.
- The eighth value ``"ReturnValue"`` is the output specification (where data flows to), in this case the return value.
- The ninth value ``"taint"`` is the kind of the flow. ``taint`` means that taint is propagated through the call.
- The tenth value ``"manual"`` is the provenance of the summary, which is used to identify the origin of the summary model.

.. _threat-models-cpp:

Threat models
-------------

.. include:: ../reusables/threat-model-description.rst
