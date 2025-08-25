.. _customizing-library-models-for-csharp:

Customizing library models for C#
=================================

You can model the methods and callables that control data flow in any framework or library. This is especially useful for custom frameworks or niche libraries, that are not supported by the standard CodeQL libraries.

.. include:: ../reusables/beta-note-customizing-library-models.rst

About this article
------------------

This article contains reference material about how to define custom models for sources, sinks, and flow summaries for C# dependencies in data extension files.

About data extensions
---------------------

You can customize analysis by defining models (summaries, sinks, and sources) of your code's C#/.NET dependencies in data extension files. Each model defines the behavior of one or more elements of your library or framework, such as methods, properties, and callables. When you run dataflow analysis, these models expand the potential sources and sinks tracked by dataflow analysis and improve the precision of results.

Most of the security queries search for paths from a source of untrusted input to a sink that represents a vulnerability. This is known as taint tracking. Each source is a starting point for dataflow analysis to track tainted data and each sink is an end point.

Taint tracking queries also need to know how data can flow through elements that are not included in the source code. These are modeled as summaries. A summary model enables queries to synthesize the flow behavior through elements in dependency code that is not stored in your repository.

Syntax used to define an element in an extension file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each model of an element is defined using a data extension where each tuple constitutes a model.
A data extension file to extend the standard C# queries included with CodeQL is a YAML file with the form:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/csharp-all
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

Extensible predicates used to create custom models in C#
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The CodeQL library for C# analysis exposes the following extensible predicates:

- ``sourceModel(namespace, type, subtypes, name, signature, ext, output, kind, provenance)``. This is used to model sources of potentially tainted data. The ``kind`` of the sources defined using this predicate determine which threat model they are associated with. Different threat models can be used to customize the sources used in an analysis. For more information, see ":ref:`Threat models <threat-models-csharp>`."
- ``sinkModel(namespace, type, subtypes, name, signature, ext, input, kind, provenance)``. This is used to model sinks where tainted data may be used in a way that makes the code vulnerable.
- ``summaryModel(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance)``. This is used to model flow through elements.
- ``neutralModel(namespace, type, name, signature, kind, provenance)``. This is similar to a summary model but used to model the flow of values that have only a minor impact on the dataflow analysis. Manual neutral models (those with a provenance such as ``manual`` or ``ai-manual``) can be used to override generated summary models (those with a provenance such as ``df-generated``), so that the summary model will be ignored. Other than that, neutral models have no effect.

The extensible predicates are populated using the models defined in data extension files.

Examples of custom model definitions
------------------------------------

The examples in this section are taken from the standard CodeQL C# query pack published by GitHub. They demonstrate how to add tuples to extend extensible predicates that are used by the standard queries.

Example: Taint sink in the ``System.Data.SqlClient`` namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the C# query pack models the argument of the ``SqlCommand`` constructor as a SQL injection sink.
This is the constructor of the ``SqlCommand`` class, which is located in the ``System.Data.SqlClient`` namespace.

.. code-block:: csharp

   public static void TaintSink(SqlConnection conn, string query) {
        SqlCommand command = new SqlCommand(query, connection) // The argument to this method is a SQL injection sink.
        ...
   }

We need to add a tuple to the ``sinkModel``\(namespace, type, subtypes, name, signature, ext, input, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/csharp-all
         extensible: sinkModel
       data:
         - ["System.Data.SqlClient", "SqlCommand", False, "SqlCommand", "(System.String,System.Data.SqlClient.SqlConnection)", "", "Argument[0]", "sql-injection", "manual"]

Since we want to add a new sink, we need to add a tuple to the ``sinkModel`` extensible predicate.
The first five values identify the callable (in this case a method) to be modeled as a sink.

- The first value ``System.Data.SqlClient`` is the namespace name.
- The second value ``SqlCommand`` is the name of the class (type) that contains the method.
- The third value ``False`` is a flag that indicates whether or not the sink also applies to all overrides of the method.
- The fourth value ``SqlCommand`` is the method name. Constructors are named after the class.
- The fifth value ``(System.String,System.Data.SqlClient.SqlConnection)`` is the method input type signature. The type names must be fully qualified.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the sink.

- The seventh value ``Argument[0]`` is the ``access path`` to the first argument passed to the method, which means that this is the location of the sink.
- The eighth value ``sql-injection`` is the kind of the sink. The sink kind is used to define the queries where the sink is in scope. In this case - the SQL injection queries.
- The ninth value ``manual`` is the provenance of the sink, which is used to identify the origin of the sink.

Example: Taint source from the ``System.Net.Sockets`` namespace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the C# query pack models the return value from the ``GetStream`` method as a ``remote`` source.
This is the ``GetStream`` method in the ``TcpClient`` class, which is located in the ``System.Net.Sockets`` namespace.

.. code-block:: csharp

   public static void Tainted(TcpClient client) {
       NetworkStream stream = client.GetStream(); // The return value of this method is a remote source of taint.
       ...
   }

We need to add a tuple to the ``sourceModel``\(namespace, type, subtypes, name, signature, ext, output, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/csharp-all
         extensible: sourceModel
       data:
         - ["System.Net.Sockets", "TcpClient", False, "GetStream", "()", "", "ReturnValue", "remote", "manual"]


Since we are adding a new source, we need to add a tuple to the ``sourceModel`` extensible predicate.
The first five values identify the callable (in this case a method) to be modeled as a source.

- The first value ``System.Net.Sockets`` is the namespace name.
- The second value ``TcpClient`` is the name of the class (type) that contains the source.
- The third value ``False`` is a flag that indicates whether or not the source also applies to all overrides of the method.
- The fourth value ``GetStream`` is the method name.
- The fifth value ``()`` is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the source.

- The seventh value ``ReturnValue`` is the access path to the return of the method, which means that it is the return value that should be considered a source of tainted input.
- The eighth value ``remote`` is the kind of the source. The source kind is used to define the threat model where the source is in scope. ``remote`` applies to many of the security related queries as it means a remote source of untrusted data. As an example the SQL injection query uses ``remote`` sources. For more information, see ":ref:`Threat models <threat-models-csharp>`."
- The ninth value ``manual`` is the provenance of the source, which is used to identify the origin of the source.

Example: Add flow through the ``Concat`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the C# query pack models flow through a method for a simple case.
This pattern covers many of the cases where we need to summarize flow through a method that is stored in a library or framework outside the repository.

.. code-block:: csharp

   public static void TaintFlow(string s1, string s2) {
       string t = String.Concat(s1, s2); // There is taint flow from s1 and s2 to t.
       ...
   }

We need to add tuples to the ``summaryModel``\(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/csharp-all
         extensible: summaryModel
       data:
         - ["System", "String", False, "Concat", "(System.Object,System.Object)", "", "Argument[0]", "ReturnValue", "taint", "manual"]
         - ["System", "String", False, "Concat", "(System.Object,System.Object)", "", "Argument[1]", "ReturnValue", "taint", "manual"]

Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate.
Each tuple defines flow from one argument to the return value.
The first row defines flow from the first argument (``s1`` in the example) to the return value (``t`` in the example) and the second row defines flow from the second argument (``s2`` in the example) to the return value (``t`` in the example).

The first five values identify the callable (in this case a method) to be modeled as a summary.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value ``System`` is the namespace name.
- The second value ``String`` is the class (type) name.
- The third value ``False`` is a flag that indicates whether or not the summary also applies to all overrides of the method.
- The fourth value ``Concat`` is the method name.
- The fifth value ``(System.Object,System.Object)`` is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the summary.

- The seventh value is the access path to the input (where data flows from). ``Argument[0]`` is the access path to the first argument (``s1`` in the example) and ``Argument[1]`` is the access path to the second argument (``s2`` in the example).
- The eighth value ``ReturnValue`` is the access path to the output (where data flows to), in this case ``ReturnValue``, which means that the input flows to the return value.
- The ninth value ``taint`` is the kind of the flow. ``taint`` means that taint is propagated through the call.
- The tenth value ``manual`` is the provenance of the summary, which is used to identify the origin of the summary.

It would also be possible to merge the two rows into one by using a comma-separated list in the seventh value. This would be useful if the method has many arguments and the flow is the same for all of them.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/csharp-all
         extensible: summaryModel
       data:
         - ["System", "String", False, "Concat", "(System.Object,System.Object)", "", "Argument[0,1]", "ReturnValue", "taint", "manual"]

This row defines flow from both the first and the second argument to the return value. The seventh value ``Argument[0,1]`` is shorthand for specifying an access path to both ``Argument[0]`` and ``Argument[1]``.

Example: Add flow through the ``Trim`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the C# query pack models flow through a method for a simple case.

.. code-block:: csharp

   public static void TaintFlow(string s) {
       string t = s.Trim(); // There is taint flow from s to t.
       ...
   }

We need to add a tuple to the ``summaryModel``\(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/csharp-all
         extensible: summaryModel
       data:
         - ["System", "String", False, "Trim", "()", "", "Argument[this]", "ReturnValue", "taint", "manual"]

Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate.
Each tuple defines flow from one argument to the return value.
The first row defines flow from the qualifier of the method call (``s1`` in the example) to the return value (``t`` in the example).

The first five values identify the callable (in this case a method) to be modeled as a summary.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value ``System`` is the namespace name.
- The second value ``String`` is the class (type) name.
- The third value ``False`` is a flag that indicates whether or not the summary also applies to all overrides of the method.
- The fourth value ``Trim`` is the method name.
- The fifth value ``()`` is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the summary.

- The seventh value is the access path to the input (where data flows from). ``Argument[this]`` is the access path to the qualifier (``s`` in the example).
- The eighth value ``ReturnValue`` is the access path to the output (where data flows to), in this case ``ReturnValue``, which means that the input flows to the return value.
- The ninth value ``taint`` is the kind of the flow. ``taint`` means that taint is propagated through the call.
- The tenth value ``manual`` is the provenance of the summary, which is used to identify the origin of the summary.

Example: Add flow through the ``Select`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the C# query pack models a more complex flow through a method.
Here we model flow through higher order methods and collection types, as well as how to handle extension methods and generics.

.. code-block:: csharp

   public static void TaintFlow(IEnumerable<string> stream) {
     IEnumerable<string> lines = stream.Select(item => item + "\n");
     ...
   }

We need to add tuples to the ``summaryModel``\(namespace, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/csharp-all
         extensible: summaryModel
       data:
         - ["System.Linq", "Enumerable", False, "Select<TSource,TResult>", "(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TResult>)", "", "Argument[0].Element", "Argument[1].Parameter[0]", "value", "manual"]
         - ["System.Linq", "Enumerable", False, "Select<TSource,TResult>", "(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TResult>)", "", "Argument[1].ReturnValue", "ReturnValue.Element", "value", "manual"]


Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate.
Each tuple defines part of the flow that comprises the total flow through the ``Select`` method.
The first five values identify the callable (in this case a method) to be modeled as a summary.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value ``System.Linq`` is the namespace name.
- The second value ``Enumerable`` is the class (type) name.
- The third value ``False`` is a flag that indicates whether or not the summary also applies to all overrides of the method.
- The fourth value ``Select<TSource,TResult>`` is the method name, along with the type parameters for the method. The names of the generic type parameters provided in the model must match the names of the generic type parameters in the method signature in the source code.
- The fifth value ``(System.Collections.Generic.IEnumerable<TSource>,System.Func<TSource,TResult>)`` is the method input type signature. The generics in the signature must match the generics in the method signature in the source code.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the summary definition.

- The seventh value is the access path to the ``input`` (where data flows from).
- The eighth value is the access path to the ``output`` (where data flows to).

For the first row:

- The seventh value is ``Argument[0].Element``, which is the access path to the elements of the qualifier (the elements of the enumerable ``stream`` in the example).
- The eight value is ``Argument[1].Parameter[0]``, which is the access path to the first parameter of the ``System.Func<TSource,TResult>`` argument of ``Select`` (the lambda parameter ``item`` in the example).

For the second row:

- The seventh value is ``Argument[1].ReturnValue``, which is the access path to the return value of the ``System.Func<TSource,TResult>`` argument of ``Select`` (the return value of the lambda in the example).
- The eighth value is ``ReturnValue.Element``, which is the access path to the elements of the return value of ``Select`` (the elements of the enumerable ``lines`` in the example).

For the remaining values for both rows:

- The ninth value ``value`` is the kind of the flow. ``value`` means that the value is preserved.
- The tenth value ``manual`` is the provenance of the summary, which is used to identify the origin of the summary.

That is, the first row specifies that values can flow from the elements of the qualifier enumerable into the first argument of the function provided to ``Select``.  The second row specifies that values can flow from the return value of the function to the elements of the enumerable returned from ``Select``.

Example: Add a ``neutral`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how we can model a method as being neutral with respect to flow. We will also cover how to model a property by modeling the getter of the ``Now`` property of the ``DateTime`` class as neutral.
A neutral model is used to define that there is no flow through a method.

.. code-block:: csharp

   public static void TaintFlow() {
       System.DateTime t = System.DateTime.Now; // There is no flow from Now to t.
       ...
   }

We need to add a tuple to the ``neutralModel``\(namespace, type, name, signature, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
   - addsTo:
       pack: codeql/csharp-all
       extensible: neutralModel
     data:
       - ["System", "DateTime", "get_Now", "()", "summary", "manual"]


Since we are adding a neutral model, we need to add tuples to the ``neutralModel`` extensible predicate.
The first four values identify the callable (in this case the getter of the ``Now`` property) to be modeled as a neutral, the fifth value is the kind, and the sixth value is the provenance (origin) of the neutral.

- The first value ``System`` is the namespace name.
- The second value ``DateTime`` is the class (type) name.
- The third value ``get_Now`` is the method name. Getter and setter methods are named ``get_<name>`` and ``set_<name>`` respectively.
- The fourth value ``()`` is the method input type signature.
- The fifth value ``summary`` is the kind of the neutral.
- The sixth value ``manual`` is the provenance of the neutral.

.. _threat-models-csharp:

Threat models
-------------

.. include:: ../reusables/threat-model-description.rst
