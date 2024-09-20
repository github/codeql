.. _customizing-library-models-for-java-and-kotlin:

Customizing library models for Java and Kotlin
==============================================

You can model the methods and callables that control data flow in any framework or library. This is especially useful for custom frameworks or niche libraries, that are not supported by the standard CodeQL libraries.

.. include:: ../reusables/beta-note-customizing-library-models.rst

About this article
------------------

This article contains reference material about how to define custom models for sources, sinks and flow summaries for Java dependencies in data extension files.

The best way to create your own models is using the CodeQL model editor in the CodeQL extension for Visual Studio Code. The model editor automatically guides you through the process of defining models, displaying the properties you need to define and the options available. You can save the resulting models as data extension files in CodeQL model packs and use them without worrying about the syntax.

For more information, see `Using the CodeQL model editor  <https://docs.github.com/en/code-security/codeql-for-vs-code/using-the-advanced-functionality-of-the-codeql-for-vs-code-extension/using-the-codeql-model-editor>`__ in the GitHub documentation.


About data extensions
---------------------

You can customize analysis by defining models (summaries, sinks, and sources) of your code's dependencies in data extension files. Each model defines the behavior of one or more elements of your library or framework, such as methods and callables. When you run dataflow analysis, these models expand the potential sources and sinks tracked by dataflow analysis and improve the precision of results.

Most of the security queries search for paths from a source of untrusted input to a sink that represents a vulnerability. This is known as taint tracking. Each source is a starting point for dataflow analysis to track tainted data and each sink is an end point.

Taint tracking queries also need to know how data can flow through elements that are not included in the source code. These are modeled as summaries. A summary model enables queries to synthesize the flow behavior through elements in dependency code that is not stored in your repository.

Syntax used to define an element in an extension file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each model of an element is defined using a data extension where each tuple constitutes a model.
A data extension file to extend the standard Java queries included with CodeQL is a YAML file with the form:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
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

Extensible predicates used to create custom models in Java and Kotlin
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The CodeQL library for Java and Kotlin analysis exposes the following extensible predicates:

- ``sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance)``. This is used to model sources of potentially tainted data. The ``kind`` of the sources defined using this predicate determine which threat model they are associated with. Different threat models can be used to customize the sources used in an analysis. For more information, see ":ref:`Threat models <threat-models-java>`."
- ``sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance)``. This is used to model sinks where tainted data maybe used in a way that makes the code vulnerable.
- ``summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance)``. This is used to model flow through elements.
- ``neutralModel(package, type, name, signature, kind, provenance)``. This is similar to a summary model but used to model the flow of values that have only a minor impact on the dataflow analysis. Manual neutral models (those with a provenance such as ``manual`` or ``ai-manual``) override generated summary models (those with a provenance such as ``df-generated``) so that the summary will be ignored. Other than that, neutral models have a slight impact on the dataflow dispatch logic, which is out of scope for this documentation.

The extensible predicates are populated using the models defined in data extension files.

Examples of custom model definitions
------------------------------------

The examples in this section are taken from the standard CodeQL Java query pack published by GitHub. They demonstrate how to add tuples to extend extensible predicates that are used by the standard queries.

Example: Taint sink in the ``java.sql`` package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Java query pack models the argument of the ``execute`` method as a SQL injection sink.
This is the ``execute`` method in the ``Statement`` class, which is located in the ``java.sql`` package.

.. code-block:: java

   public static void taintsink(Connection conn, String query) throws SQLException {
       Statement stmt = conn.createStatement();
       stmt.execute(query); // The argument to this method is a SQL injection sink.
   }

We need to add a tuple to the ``sinkModel``\(package, type, subtypes, name, signature, ext, input, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: sinkModel
       data:
         - ["java.sql", "Statement", True, "execute", "(String)", "", "Argument[0]", "sql-injection", "manual"]


Since we want to add a new sink, we need to add a tuple to the ``sinkModel`` extensible predicate.
The first five values identify the callable (in this case a method) to be modeled as a sink.

- The first value ``java.sql`` is the package name.
- The second value ``Statement`` is the name of the class (type) that contains the method.
- The third value ``True`` is a flag that indicates whether or not the sink also applies to all overrides of the method.
- The fourth value ``execute`` is the method name.
- The fifth value ``(String)`` is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the sink.

- The seventh value ``Argument[0]`` is the ``access path`` to the first argument passed to the method, which means that this is the location of the sink.
- The eighth value ``sql-injection`` is the kind of the sink. The sink kind is used to define the queries where the sink is in scope. In this case - the SQL injection queries.
- The ninth value ``manual`` is the provenance of the sink, which is used to identify the origin of the sink.

Example: Taint source from the ``java.net`` package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the Java query pack models the return value from the ``getInputStream`` method as a ``remote`` source.
This is the ``getInputStream`` method in the ``Socket`` class, which is located in the ``java.net`` package.

.. code-block:: java

   public static void tainted(Socket socket) throws IOException {
       InputStream stream = socket.getInputStream(); // The return value of this method is a remote source of taint.
       ...
   }

We need to add a tuple to the ``sourceModel``\(package, type, subtypes, name, signature, ext, output, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: sourceModel
       data:
         - ["java.net", "Socket", False, "getInputStream", "()", "", "ReturnValue", "remote", "manual"]


Since we are adding a new source, we need to add a tuple to the ``sourceModel`` extensible predicate.
The first five values identify the callable (in this case a method) to be modeled as a source.

- The first value ``java.net`` is the package name.
- The second value ``Socket`` is the name of the class (type) that contains the source.
- The third value ``False`` is a flag that indicates whether or not the source also applies to all overrides of the method.
- The fourth value ``getInputStream`` is the method name.
- The fifth value ``()`` is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the source.

- The seventh value ``ReturnValue`` is the access path to the return of the method, which means that it is the return value that should be considered a source of tainted input.
- The eighth value ``remote`` is the kind of the source. The source kind is used to define the threat model where the source is in scope. ``remote`` applies to many of the security related queries as it means a remote source of untrusted data. As an example the SQL injection query uses ``remote`` sources. For more information, see ":ref:`Threat models <threat-models-java>`."
- The ninth value ``manual`` is the provenance of the source, which is used to identify the origin of the source.

Example: Add flow through the ``concat`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the Java query pack models flow through a method for a simple case.
This pattern covers many of the cases where we need to summarize flow through a method that is stored in a library or framework outside the repository.

.. code-block:: java

   public static void taintflow(String s1, String s2) {
       String t = s1.concat(s2); // There is taint flow from s1 and s2 to t.
       ...
   }

We need to add tuples to the ``summaryModel``\(package, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: summaryModel
       data:
         - ["java.lang", "String", False, "concat", "(String)", "", "Argument[this]", "ReturnValue", "taint", "manual"]
         - ["java.lang", "String", False, "concat", "(String)", "", "Argument[0]", "ReturnValue", "taint", "manual"]

Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate.
Each tuple defines flow from one argument to the return value.
The first row defines flow from the qualifier (``s1`` in the example) to the return value (``t`` in the example) and the second row defines flow from the first argument (``s2`` in the example) to the return value (``t`` in the example).

The first five values identify the callable (in this case a method) to be modeled as a summary.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value ``java.lang`` is the package name.
- The second value ``String`` is the class (type) name.
- The third value ``False`` is a flag that indicates whether or not the summary also applies to all overrides of the method.
- The fourth value ``concat`` is the method name.
- The fifth value ``(String)`` is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the summary.

- The seventh value is the access path to the input (where data flows from). ``Argument[this]`` is the access path to the qualifier (``s1`` in the example) and ``Argument[0]`` is the access path to the first argument (``s2`` in the example).
- The eighth value ``ReturnValue`` is the access path to the output (where data flows to), in this case ``ReturnValue``, which means that the input flows to the return value.
- The ninth value ``taint`` is the kind of the flow. ``taint`` means that taint is propagated through the call.
- The tenth value ``manual`` is the provenance of the summary, which is used to identify the origin of the summary.

Example: Add flow through the ``map`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the Java query pack models a more complex flow through a method.
Here we model flow through higher order methods and collection types.

.. code-block:: java

   public static void taintflow(Stream<String> s) {
     Stream<String> l = s.map(e -> e.concat("\n"));
     ...
   }

We need to add tuples to the ``summaryModel``\(package, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: summaryModel
       data:
         - ["java.util.stream", "Stream", True, "map", "(Function)", "", "Argument[this].Element", "Argument[0].Parameter[0]", "value", "manual"]
         - ["java.util.stream", "Stream", True, "map", "(Function)", "", "Argument[0].ReturnValue", "ReturnValue.Element", "value", "manual"]


Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate.
Each tuple defines part of the flow that comprises the total flow through the ``map`` method.
The first five values identify the callable (in this case a method) to be modeled as a summary.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value ``java.util.stream`` is the package name.
- The second value ``Stream`` is the class (type) name.
- The third value ``True`` is a flag that indicates whether or not the summary also applies to all overrides of the method.
- The fourth value ``map`` is the method name.
- The fifth value ``Function`` is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the summary definition.

- The seventh value is the access path to the ``input`` (where data flows from).
- The eighth value is the access path to the ``output`` (where data flows to).

For the first row:

- The seventh value is ``Argument[this].Element``, which is the access path to the elements of the qualifier (the elements of the stream ``s`` in the example).
- The eight value is ``Argument[0].Parameter[0]``, which is the access path to the first parameter of the ``Function`` argument of ``map`` (the lambda parameter ``e`` in the example).

For the second row:

- The seventh value is ``Argument[0].ReturnValue``, which is the access path to the return value of the ``Function`` argument of ``map`` (the return value of the lambda in the example).
- The eighth value is ``ReturnValue.Element``, which is the access path to the elements of the return value of ``map`` (the elements of the stream ``l`` in the example).

For the remaining values for both rows:

- The ninth value ``value`` is the kind of the flow. ``value`` means that the value is preserved.
- The tenth value ``manual`` is the provenance of the summary, which is used to identify the origin of the summary.

That is, the first row specifies that values can flow from the elements of the qualifier stream into the first argument of the function provided to ``map``.  The second row specifies that values can flow from the return value of the function to the elements of the stream returned from ``map``.

Example: Add a ``neutral`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the Java query pack models the ``now`` method as being neutral with respect to flow.
A neutral model is used to define that there is no flow through a method.

.. code-block:: java

   public static void taintflow() {
       Instant t = Instant.now(); // There is no flow from now to t.
       ...
   }

We need to add a tuple to the ``neutralModel``\(package, type, name, signature, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
   - addsTo:
       pack: codeql/java-all
       extensible: neutralModel
     data:
       - ["java.time", "Instant", "now", "()", "summary", "manual"]


Since we are adding a neutral model, we need to add tuples to the ``neutralModel`` extensible predicate.
The first four values identify the callable (in this case a method) to be modeled as a neutral, the fifth value is the kind, and the sixth value is the provenance (origin) of the neutral.

- The first value ``java.time`` is the package name.
- The second value ``Instant`` is the class (type) name.
- The third value ``now`` is the method name.
- The fourth value ``()`` is the method input type signature.
- The fifth value ``summary`` is the kind of the neutral.
- The sixth value ``manual`` is the provenance of the neutral.

.. _threat-models-java:

Threat models
-------------

.. include:: ../reusables/threat-model-description.rst
