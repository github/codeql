.. _customizing-library-models-for-java:

:orphan:
:nosearch:

Customizing Library Models for Java
===================================

.. include:: ../reusables/beta-note-customizing-library-models.rst

The Java analysis can be customized by adding library models (summaries, sinks and sources) in data extension files.
A model is a definition of a behavior of a library element, such as a method, that is used to improve the data flow analysis precision by identifying more results.
Most of the security related queries are taint tracking queries that try to find paths from a source of untrusted input to a sink that represents a vulnerability. Sources are the starting points of a taint tracking data flow analysis, and sinks are the end points of a taint tracking data flow analysis.

Furthermore, the taint tracking queries also need to know how data can flow through elements that are not included in the source code. These are named summaries: they are models of elements that allow us to synthesize the elements flow behavior without having them in the source code. This is especially helpful when using a third party (or the standard) library.

The models are defined using data extensions where each tuple constitutes a model.
A data extension file for Java is a YAML file in the form:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: <name of extensible predicate>
       data:
         - <tuple1>
         - <tuple2>
         - ...

Data extensions contribute to the extensible predicates defined in the CodeQL library. For more information on how to define data extensions and extensible predicates as well as how to wire them up, see the :ref:`data-extensions` documentation.

The CodeQL library for Java exposes the following extensible predicates:

- **sourceModel**\(package, type, subtypes, name, signature, ext, output, kind, provenance). This is used for **source** models.
- **sinkModel**\(package, type, subtypes, name, signature, ext, input, kind, provenance). This is used for **sink** models.
- **summaryModel**\(package, type, subtypes, name, signature, ext, input, output, kind, provenance). This is used for **summary** models.
- **neutralModel**\(package, type, name, signature, provenance). This is used for **neutral** models, which only have minor impact on the data flow analysis.

The extensible predicates are populated using data extensions specified in YAML files.

In the sections below, we will provide examples of how to add tuples to the different extensible predicates.
The extensible predicates are used to customize and improve the existing data flow queries, by providing sources, sinks, and flow through (summaries) for library elements.
The :ref:`reference-material` section will provide details on the *mini DSLs* that define models for each extensible predicate.

Example: Taint sink in the **java.sql** package
------------------------------------------------

In this example we will show how to model the argument of the **execute** method as a SQL injection sink.
This is the **execute** method in the **Statement** class, which is located in the **java.sql** package.
Note that this sink is already added to the CodeQL Java analysis.

.. code-block:: java

   public static void taintsink(Connection conn, String query) throws SQLException {
       Statement stmt = conn.createStatement();
       stmt.execute(query); // The argument to this method is a SQL injection sink.
   }

We need to add a tuple to the **sinkModel**\(package, type, subtypes, name, signature, ext, input, kind, provenance) extensible predicate. To do this, add the following to a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: sinkModel
       data:
         - ["java.sql", "Statement", True, "execute", "(String)", "", "Argument[0]", "sql", "manual"]


Since we are adding a new sink, we need to add a tuple to the **sinkModel** extensible predicate.
The first five values identify the callable (in this case a method) to be modeled as a sink.

- The first value **java.sql** is the package name.
- The second value **Statement** is the name of the class (type) that contains the method.
- The third value **True** is a flag that indicates whether or not the sink also applies to all overrides of the method.
- The fourth value **execute** is the method name.
- The fifth value **(String)** is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the **access path**, the **kind**, and the **provenance** (origin) of the sink.

- The seventh value **Argument[0]** is the **access path** to the first argument passed to the method, which means that this is the location of the sink.
- The eighth value **sql** is the kind of the sink. The sink kind is used to define the queries where the sink is in scope. In this case - the SQL injection queries.
- The ninth value **manual** is the provenance of the sink, which is used to identify the origin of the sink.
 
Example: Taint source from the **java.net** package
----------------------------------------------------
In this example we show how to model the return value from the **getInputStream** method as a **remote** source.
This is the **getInputStream** method in the **Socket** class, which is located in the **java.net** package.
Note that this source is already added to the CodeQL Java analysis.

.. code-block:: java

   public static void tainted(Socket socket) throws IOException {
       InputStream stream = socket.getInputStream(); // The return value of this method is a remote source of taint.
       ...
   }

We need to add a tuple to the **sourceModel**\(package, type, subtypes, name, signature, ext, output, kind, provenance) extensible predicate. To do this, add the following to a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: sourceModel
       data:
         - ["java.net", "Socket", False, "getInputStream", "()", "", "ReturnValue", "remote", "manual"]


Since we are adding a new source, we need to add a tuple to the **sourceModel** extensible predicate.
The first five values identify the callable (in this case a method) to be modeled as a source.

- The first value **java.net** is the package name.
- The second value **Socket** is the name of the class (type) that contains the source.
- The third value **False** is a flag that indicates whether or not the source also applies to all overrides of the method.
- The fourth value **getInputStream** is the method name.
- The fifth value **()** is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the **access path**, the **kind**, and the **provenance** (origin) of the source.

- The seventh value **ReturnValue** is the access path to the return of the method, which means that it is the return value that should be considered a source of tainted input.
- The eighth value **remote** is the kind of the source. The source kind is used to define the queries where the source is in scope. **remote** applies to many of the security related queries as it means a remote source of untrusted data. As an example the SQL injection query uses **remote** sources.
- The ninth value **manual** is the provenance of the source, which is used to identify the origin of the source.

Example: Add flow through the **concat** method
------------------------------------------------
In this example we show how to model flow through a method for a simple case.
This pattern covers many of the cases where we need to define flow through a method.
Note that the flow through the **concat** method is already added to the CodeQL Java analysis.

.. code-block:: java

   public static void taintflow(String s1, String s2) {
       String t = s1.concat(s2); // There is taint flow from s1 and s2 to t.
       ...
   }

We need to add tuples to the **summaryModel**\(package, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate. To do this, add the following to a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: summaryModel
       data:
         - ["java.lang", "String", False, "concat", "(String)", "", "Argument[this]", "ReturnValue", "taint", "manual"]
         - ["java.lang", "String", False, "concat", "(String)", "", "Argument[0]", "ReturnValue", "taint", "manual"]

Reasoning:

Since we are adding flow through a method, we need to add tuples to the **summaryModel** extensible predicate.
Each tuple defines flow from one argument to the return value.
The first row defines flow from the qualifier (**s1** in the example) to the return value (**t** in the example) and the second row defines flow from the first argument (**s2** in the example) to the return value (**t** in the example).

The first five values identify the callable (in this case a method) to be modeled as a summary.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value **java.lang** is the package name.
- The second value **String** is the class (type) name.
- The third value **False** is a flag that indicates whether or not the summary also applies to all overrides of the method.
- The fourth value **concat** is the method name.
- The fifth value **(String)** is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the **access path**, the **kind**, and the **provenance** (origin) of the summary.

- The seventh value is the access path to the input (where data flows from). **Argument[this]** is the access path to the qualifier (**s1** in the example) and **Argument[0]** is the access path to the first argument (**s2** in the example).
- The eighth value **ReturnValue** is the access path to the output (where data flows to), in this case **ReturnValue**, which means that the input flows to the return value.
- The ninth value **taint** is the kind of the flow. **taint** means that taint is propagated through the call.
- The tenth value **manual** is the provenance of the summary, which is used to identify the origin of the summary.

Example: Add flow through the **map** method
---------------------------------------------
In this example, we will see a more complex example of modeling flow through a method.
This pattern shows how to model flow through higher order methods and collection types.
Note that the flow through the **map** method is already added to the CodeQL Java analysis.

.. code-block:: java

   public static void taintflow(Stream<String> s) {
     Stream<String> l = s.map(e -> e.concat("\n"));
     ...
   }

To do this, add the following to a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: summaryModel
       data:
         - ["java.util.stream", "Stream", True, "map", "(Function)", "", "Argument[this].Element", "Argument[0].Parameter[0]", "value", "manual"]
         - ["java.util.stream", "Stream", True, "map", "(Function)", "", "Argument[0].ReturnValue", "ReturnValue.Element", "value", "manual"]


Since we are adding flow through a method, we need to add tuples to the **summaryModel** extensible predicate.
Each tuple defines part of the flow that comprises the total flow through the **map** method.
The first five values identify the callable (in this case a method) to be modeled as a summary.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value **java.util.stream** is the package name.
- The second value **Stream** is the class (type) name.
- The third value **True** is a flag that indicates whether or not the summary also applies to all overrides of the method.
- The fourth value **map** is the method name.
- The fifth value **Function** is the method input type signature.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the **access path**, the **kind**, and the **provenance** (origin) of the summary definition.

- The seventh value is the access path to the **input** (where data flows from).
- The eighth value is the access path to the **output** (where data flows to).

For the first row:

- The seventh value is **Argument[this].Element**, which is the access path to the elements of the qualifier (the elements of the stream **s** in the example).
- The eight value is **Argument[0].Parameter[0]**, which is the access path to the first parameter of the **Function** argument of **map** (the lambda parameter **e** in the example).

For the second row:

- The seventh value is **Argument[0].ReturnValue**, which is the access path to the return value of the **Function** argument of **map** (the return value of the lambda in the example).
- The eighth value is **ReturnValue.Element**, which is the access path to the elements of the return value of **map** (the elements of the stream **l** in the example).

For the remaining values for both rows:

- The ninth value **value** is the kind of the flow. **value** means that the value is preserved.
- The tenth value **manual** is the provenance of the summary, which is used to identify the origin of the summary.

That is, the first row models that there is value flow from the elements of the qualifier stream into the first argument of the function provided to **map** and the second row models that there is value flow from the return value of the function to the elements of the stream returned from **map**.

Example: Add a **neutral** method
----------------------------------
In this example we will show how to model the **now** method as being neutral.
A neutral model is used to define that there is no flow through a method.
Note that the neutral model for the **now** method is already added to the CodeQL Java analysis.

.. code-block:: java
   
   public static void taintflow() {
       Instant t = Instant.now(); // There is no flow from now to t.
       ...
   }

We need to add a tuple to the **neutralModel**\(package, type, name, signature, provenance) extensible predicate. To do this, add the following to a data extension file:

.. code-block:: yaml

   extensions:
   - addsTo:
       pack: codeql/java-all
       extensible: neutralModel
     data:
       - ["java.time", "Instant", "now", "()", "manual"]


Since we are adding a neutral model, we need to add tuples to the **neutralModel** extensible predicate.
The first five values identify the callable (in this case a method) to be modeled as a neutral and the fifth value is the provenance (origin) of the neutral.

- The first value **java.time** is the package name.
- The second value **Instant** is the class (type) name.
- The third value **now** is the method name.
- The fourth value **()** is the method input type signature.
- The fifth value **manual** is the provenance of the neutral.

.. _reference-material:

Reference material
------------------

The following sections provide reference material for extensible predicates.
This includes descriptions of each of the arguments (e.g. access paths, kinds and provenance).

Extensible predicates
---------------------

Below is a description of the columns for each extensible predicate.
Sources, sinks, summaries and neutrals are commonly known as models.
The semantics of many of the columns of the extensible predicates are shared.

The shared columns are:

- **package**: Name of the package containing the element(s) to be modeled.
- **type**: Name of the type containing the element(s) to be modeled.
- **subtypes**: A boolean flag indicating whether the model should also apply to all overrides of the selected element(s).
- **name**: Name of the element (optional). If this is left blank, it means all elements matching the previous selection criteria.
- **signature**: Type signature of the selected element (optional). If this is left blank, it means all elements matching the previous selection criteria.
- **ext**: Specifies additional API-graph-like edges (mostly empty) and out of scope for this document.
- **provenance**: Provenance (origin) of the model definition.

The columns **package**, **type**, **subtypes**, **name**, and **signature** are used to select the element(s) that the model applies to.

The :ref:`access-paths` section describes how access paths are composed.
This is the most complicated part of the extensible predicates and the **mini DSL** for access paths is shared across all extensible predicates.

sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Taint source. Most taint tracking queries will use all sources added to this extensible predicate regardless of their kind.

- **output**: Access path to the source, where the possibly tainted data flows from.
- **kind**: Kind of the source.
- **provenance**: Provenance (origin) of the source definition.

As most sources are used by all taint tracking queries there are only a few different source kinds.
The following source kinds are supported:

- **remote**: A remote source of possibly tainted data. This is the most common kind for a source. Sources of this kind are used for almost all taint tracking queries.

Below is an enumeration of the remaining source kinds, but they are out of scope for this documentation:

- **contentprovider**, **android-widget**, **android-external-storage-dir**.

sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Taint sink. As opposed to source kinds, there are many different kinds of sinks as these tend to be more query specific.

- **input**: Access path to the sink, where we want to check if tainted data can flow into.
- **kind**: Kind of the sink.

The following sink kinds are supported:

- **sql**: A SQL injection vulnerability sink.
- **xss**: A cross-site scripting vulnerability sink.
- **logging**: A log output sink.

Below is an enumeration of the remaining sinks, but they are out of scope for this documentation:

- **open-url**, **jndi-injection**, **ldap**, **jdbc-url**
- **mvel**, **xpath**, **groovy**, **ognl-injection**
- **intent-start**, **pending-intent-sent**, **url-open-stream**, **url-redirect**
- **create-file**, **read-file**, **write-file**, **set-hostname-verifier**
- **header-splitting**, **information-leak**, **xslt**, **jexl**
- **bean-validation**, **ssti**, **fragment-injection**, **regex-use[**\ `arg`\ **]**

summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Flow through (summary). This extensible predicate is used to model flow through elements.

- **input**: Access path to the input of the element (where data will flow from to the output).
- **output**: Access path to the output of the element (where data will flow to from the input).
- **kind**: Kind of the flow through.
- **provenance**: Provenance (origin) of the flow through.

The following kinds are supported:

- **taint**: This means the output is not necessarily equal to the input, but it was derived from the input in an unrestrictive way. An attacker who controls the input will have significant control over the output as well.
- **value**: This means that the output equals the input or a copy of the input such that all of its properties are preserved.

neutralModel(package, type, name, signature, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This extensible predicate is not typically needed externally, but included here for completeness.
It only has minor impact on the data flow analysis.
Manual neutrals are considered high confidence dispatch call targets and can reduce the number of dispatch call targets during data flow analysis (a performance optimization).

- **provenance**: Provenance (origin) of the flow through.

.. _access-paths:

Access paths
------------
The **input**, and **output** columns consist of a **.**-separated list of components, which is evaluated from left to right, with each step selecting a new set of values derived from the previous set of values.

The following components are supported:

- **Argument[**\ `n`\ **]** selects the argument at index `n` (zero-indexed).
- **Argument[**\ `this`\ **]** selects the qualifier (instance parameter).
- **Argument[**\ `n1..n2`\ **]** selects the arguments in the given range (both ends included).
- **Parameter[**\ `n`\ **]** selects the parameter at index `n` (zero-indexed).
- **Parameter[**\ `n1..n2`\ **]** selects the parameters in the given range (both ends included).
- **ReturnValue** selects the return value.
- **Field[**\ `name`\ **]** selects the field with the fully qualified name `name`.
- **SyntheticField[**\ `name`\ **]** selects the synthetic field with name `name`.
- **SyntheticGlobal[**\ `name`\ **]** selects the synthetic global with name `name`.
- **ArrayElement** selects the elements of an array.
- **Element** selects the elements of a collection-like container.
- **MapKey** selects the element keys of a map.
- **MapValue** selects the element values of a map.

Provenance
----------

The **provenance** column is used to specify the provenance (origin) of the model definition and how the model was verified.
The following values are supported:

- **manual**: The model was manually created and added to the extensible predicate.

or values in the form **origin-verification**, where origin is one of:

- **ai**: The model was generated by AI.
- **df**: The model was generated by the dataflow model generator.
- **tb**: The model was generated by the type based model generator.
- **hq**: The model was generated using a heuristic query.

and verification is one of:

- **manual**: The model was verified by a human.
- **generated**: The model was generated, but not verified by a human.

The provenance is used to distinguish between models that are manually added (or verified) to the extensible predicate and models that are automatically generated.
Furthermore, it impacts the data flow analysis in the following way:

- A **manual** model takes precedence over **generated** models. If a **manual** model exists for an element then all **generated** models are ignored.
- A **generated** model is ignored during analysis, if the source code of the element it is modeling is available.

That is, generated models are less trusted than manual models and only used if neither source code nor a manual model is available.


.. include:: ../reusables/data-extensions.rst