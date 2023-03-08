.. _customizing-library-models-for-java:

Customizing Library Models for Java
===================================

.. include:: ../reusables/beta-note-customizing-library-models.rst

The Java analysis can be customized by adding library models (summaries, sinks and sources) in data extension files.

A data extension file for Java is a YAML file in the form:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: <name of extension point>
       data:
         - <tuple1>
         - <tuple2>
         - ...

The data extension can contribute to the following extension points:

- **sourceModel**\(package, type, subtypes, name, signature, ext, output, kind, provenance)
- **sinkModel**\(package, type, subtypes, name, signature, ext, input, kind, provenance)
- **summaryModel**\(package, type, subtypes, name, signature, ext, input, output, kind, provenance)
- **neutralModel**\(package, type, name, signature, provenance)

TODO: Link or inline documentation on how to add dataextensions.
Are we going for extensions packs as the recommended default?
If yes, then we probably need to elaborate with a concrete example.

In the sections below, we will show by example how to add tuples to the different extension points.
The extension points are used to customize and improve the existing dataflow queries, by providing sources, sinks, and flow through for library elements.
The **Reference material** section will in more detail describe the *mini DSLs* that are used to comprise a model definition for each extension point.

Example: Taint sink in the **java.sql** package.
------------------------------------------------

In this example we will see, how to define the argument of the **execute** method as a SQL injection sink.
This is the **execute** method in the **Statement** class, which is located in the **java.sql** package.
Please note that this sink is already added to the CodeQL Java analysis.

.. code-block:: java

   public static void taintsink(Connection conn, String query) throws SQLException {
       Statement stmt = conn.createStatement();
       stmt.execute(query); // The argument to this method is a SQL injection sink.
   }

This can be achieved by adding the following data extension.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/java-all
         extensible: sinkModel
       data:
         - ["java.sql", "Statement", True, "execute", "(String)", "", "Argument[0]", "sql", "manual"]

Reasoning:

Since we are adding a new sink, we need to add a tuple to the **sinkModel** extension point.
The first five values are used to identify the method (callable) which we are defining a sink on.

- The first value **java.sql** is the package name.
- The second value **Statement** is the class (type) name.
- The third value **True** is flag indicating, whether the sink also applies to all overrides of the method.
- The fourth value **execute** is the method name.
- The fifth value **(String)** is the method input type signature.

For most practical purposes the sixth value is not relevant.
The remaining values are used to define the **access path**, the **kind**, and the **provenance** (origin) of the sink.

- The seventh value **Argument[0]** is the **access path** to the first argument passed to the method, which means that this is the location of the sink.
- The eighth value **sql** is the kind of the sink. The sink kind is used to define the queries where the sink is in scope. In this case  - the SQL injection queries.
- The ninth value **manual** is the provenance of the sink, which is used to identify the origin of the sink.
 
Example: Taint source from the **java.net** package.
----------------------------------------------------
In this example we will see, how to define the return value from the **getInputStream** method as a **remote** source.
This is the **getInputStream** method in the **Socket** class, which is located in the **java.net** package.
Please note that this source is already added to the CodeQL Java analysis.

.. code-block:: java

   public static InputStream tainted(Socket socket) throws IOException {
       InputStream stream = socket.getInputStream(); // The return value of this method is a remote source of taint.
       return stream;
   }

This can be achieved by adding the following data extension.

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/java-all
        extensible: sourceModel
      data:
        - ["java.net", "Socket", False, "getInputStream", "()", "", "ReturnValue", "remote", "manual"]

Reasoning:

Since we are adding a new source, we need to add a tuple to the **sourceModel** extension point.
The first five values are used to identify the method (callable) which we are defining a source on.

- The first value **java.net** is the package name.
- The second value **Socket** is the class (type) name.
- The third value **False** is flag indicating, whether the source also applies to all overrides of the method.
- The fourth value **getInputStream** is the method name.
- The fifth value **()** is the method input type signature.

For most practical purposes the sixth value is not relevant.
The remaining values are used to define the **access path**, the **kind**, and the **provenance** (origin) of the source.

- The seventh value **ReturnValue** is the access path to the return of the method, which means that it is the return value that should be considered a source of tainted input.
- The eighth value **remote** is the kind of the source. The source kind is used to define the queries where the source is in scope. **remote** applies to many of security related queries as it means a remote source of untrusted data. As an example the SQL injection query uses **remote** sources.
- The ninth value **manual** is the provenance of the source, which is used to identify the origin of the source.

Example: Add flow through the **concat** method.
------------------------------------------------
In this example we will see, how to define flow through a method for a simple case.
This pattern covers many of the cases where we need to define flow through a method.
Please note that the flow through the **concat** method is already added to the CodeQL Java analysis.

.. code-block:: java

   public static String taintflow(String s1, String s2) {
       String t = s1.concat(s2); // There is taint flow from s1 and s2 to t.
       return t;
   }

This can be achieved by adding the following data extension.
These are widely known as summary models.

.. code-block:: yaml

   extensions:
    - addsTo:
        pack: codeql/java-all
        extensible: summaryModel
      data:
        - ["java.lang", "String", False, "concat", "(String)", "", "Argument[-1]", "ReturnValue", "taint", "manual"]
        - ["java.lang", "String", False, "concat", "(String)", "", "Argument[0]", "ReturnValue", "taint", "manual"]

Reasoning:

Since we are adding flow through a method, we need to add tuples to the **summaryModel** extension point.
Each tuple defines flow from one argument to the return value.
The first row defines flow from the qualifier (**s1** in the example) to the return value (**t** in the example) and the second row defines flow from the first argument (**s2** in the example) to the return value (**t** in the example).

The first five values are used to identify the method (callable) which we are defining a summary for.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value **java.lang** is the package name.
- The second value **String** is the class (type) name.
- The third value **False** is flag indicating, whether the summary also applies to all overrides of the method.
- The fourth value **concat** is the method name.
- The fifth value **(String)** is the method input type signature.

For most practical purposes the sixth value is not relevant.
The remaining values are used to define the **access path**, the **kind**, and the **provenance** (origin) of the summary.

- The seventh value is the access path to the input (where data flows from). **Argument[-1]** is the access path to the qualifier (**s1** in the example) and **Argument[0]** is the access path to the first argument (**s2** in the example).
- The eighth value **ReturnValue** is the access path to the output (where data flows to), in this case **ReturnValue**, which means that the input flows to the return value.
- The ninth value **taint** is the kind of the flow. **taint** means that taint is propagated through the flow.
- The tenth value **manual** is the provenance of the summary, which is used to identify the origin of the summary.

Example: Add flow through the **map** method.
---------------------------------------------
In this example, we will see a more complex example of modelling flow through a method.
This pattern shows how to model flow through higher order methods and collection types.
Please note that the flow through the **map** method is already added to the CodeQL Java analysis.

.. code-block:: java

   public static Stream<String> taintflow(Stream<String> s) {
     Stream<String> l = s.map(e -> e.concat("\n"));
     return l;
   }

This can be achieved by adding the following data extension.

.. code-block:: yaml

   extensions:
   - addsTo:
       pack: codeql/java-all
       extensible: summaryModel
     data:
       - ["java.util.stream", "Stream", True, "map", "(Function)", "", "Argument[-1].Element", "Argument[0].Parameter[0]", "value", "manual"]
       - ["java.util.stream", "Stream", True, "map", "(Function)", "", "Argument[0].ReturnValue", "ReturnValue.Element", "value", "manual"]

Reasoning:

Since we are adding flow through a method, we need to add tuples to the **summaryModel** extension point.
Each tuple defines part of the flow that comprises the total flow through the **map** method.
The first five values are used to identify the method (callable) which we are defining a summary for.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value **java.util.stream** is the package name.
- The second value **Stream** is the class (type) name.
- The third value **True** is flag indicating, whether the summary also applies to all overrides of the method.
- The fourth value **map** is the method name.
- The fifth value **Function** is the method input type signature.

For most practical purposes the sixth value is not relevant.
The remaining values are used to define the **access path**, the **kind**, and the **provenance** (origin) of the summary definition.

- The seventh value is the access path to the **input** (where data flows from).
- The eighth value **ReturnValue** is the access path to the **output** (where data flows to).

For the first row the

- The seventh value is **Argument[-1].Element**, which is the access path to the elements of the qualifier (the elements of the stream **s** in the example).
- The eight value is **Argument[0].Paramter[0]**, which is the access path the first parameter of the **Function** argument of **map** (the lambda parameter **e** in the example).

For the second row the

- The seventh value is **Argument[0].ReturnValue**, which is the access path to the return value of the **Function** argument of **map** (the return value of the lambda in the example).
- The eighth value is **ReturnValue.Element**, which is the access path to the elements of the return value of **map** (the elements of the stream **l** in the example).

The remaining values for both rows

- The ninth value **value** is the kind of the flow. **value** means that the value is preserved.
- The tenth value **manual** is the provenance of the summary, which is used to identify the origin of the summary.

That is, the first row models that there is value flow from the elements of the qualifier stream into the first argument of the Function provided to **map** and the second row models that there is value flow from the return value of the Function to the elements of the stream returned from **map**.

Example: Add a **neutral** method.
----------------------------------
In this example we will see, how to define the **now** method as being neutral.
This is purely for consistency and has no impact on the analysis.
A neutral model is used to define that there is no flow through a method.
Please note that the neutral model for the **now** method is already added.

.. code-block:: java
   
   public static Instant taintflow() {
       Instant t = Instant.now(); // There is no flow from now to t.
       return t;
   }

.. code-block:: yaml

   extensions:
   - addsTo:
       pack: codeql/java-all
       extensible: neutralModel
     data:
       - ["java.time", "Instant", "now", "()", "manual"]

Reasoning:

Since we are adding a neutral model, we need to add tuples to the **neutralModel** extension point.
The first four values are used to identify the method (callable) which we are defining as a neutral and the fifth value is the provenance (origin) of the neutral.

- The first value **java.time** is the package name.
- The second value **Instant** is the class (type) name.
- The third value **now** is the method name.
- The fourth value **()** is the method input type signature.
- The fifth value **manual** is the provenance of the neutral.

Reference material
------------------

The following sections provide reference material for extension points.
This includes descriptions of each of the arguments (eg. access paths, kinds and provenance).

Extension points
----------------

Below is a description of the columns for each extension point.
Sources, Sinks, Summaries and Neutrals are commonly known as Models.
The semantics of many of the columns of the extension points are shared.

The shared columns are:

- **package**: Name of the package.
- **type**: Name of the type.
- **subtypes**: A flag indicating whether the model should also apply to all overrides of the selected element(s).
- **name**: Name of the element (optional). If this is left blank, it means all elements matching the previous selection criteria.
- **signature**: Type signature of the selected element (optional). If this is left blank it means all elements matching the previous selection criteria.
- **ext**: Specifies additional API-graph-like edges (mostly empty) and out of scope for this document.
- **provenance**: Provenance (origin) of the model definition.

The columns **package**, **type**, **subtypes**, **name**, and **signature** are used to select the element(s) that the model applies to.

The section Access paths describes in more detail, how access paths are composed.
This is the most complicated part of the extension points and the **mini DSL** for access paths is shared accross the extension points.

sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Taint source. Most taint tracking queries will use the all sources added to this extensions point regardless of their kind.

- **output**: Access path to the source, where the possibly tainted data flows from.
- **kind**: Kind of the source.
- **provenance**: Provenance (origin) of the source definition.

As most sources are used by all taint tracking queries there are only a few different source kinds.
The following source kinds are supported:

- **remote**: A remote source of possibly tainted data. This is the most common kind for a source. Sources of this kind is used for almost all taint tracking queries.
- **contentprovider**: ?
- **android-widget**: ?
- **android-external-storage-dir**: ?

sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Taint sink. As opposed to source kinds, there are many different kinds of sinks as these tend to be more query specific.

- **input**: Access path to the sink, where we want to check if tainted data can flow to.
- **kind**: Kind of the sink.

The following sink kinds are supported:

- **open-url**: ?
- **jndi-injection**: ?
- **ldap**: ?
- **sql**: ?
- **jdbc-url**: ?
- **logging**: ?
- **mvel**: ?
- **xpath**: ?
- **groovy**: ?
- **xss**: ?
- **ognl-injection**: ?
- **intent-start**: ?
- **pending-intent-sent**: ?
- **url-open-stream**: ?
- **url-redirect**: ?
- **create-file**: ?
- **read-file**: ?
- **write-file**: ?
- **set-hostname-verifier**: ?
- **header-splitting**: ?
- **information-leak**: ?
- **xslt**: ?
- **jexl**: ?
- **bean-validation**: ?
- **ssti**: ?
- **fragment-injection**: ?

summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Flow through. This extension point is used to model flow through elements.

- **input**: Access path to the input of the element (where data will flow to the output).
- **output**: Access path to the output of the element (where data will flow from the input).
- **kind**: Kind of the flow through.
- **provenance**: Provenance (origin) of the flow through.

The following kinds are supported:

- **taint**: This means the output is not necessarily equal to the input, but it was derived from the input in an unrestrictive way. An attacker who controls the input will have significant control over the output as well.
- **value**: This means that the output equals the input or a copy of the input such that all of its properties are preserved.

neutralModel(package, type, name, signature, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Access paths
------------
The **input**, and **output** columns consist of a **.**-separated list of components, which is evaluted from left to right, with each step selecting a new set of values derived from the previous set of values.

The following components are supported:

- **Argument[**\ `n`\ **]** selects the argument at index `n` (zero-indexed).
- **Argument[**\ `-1`\ **]** selects the qualifier.
- **Argument[**\ `n1..n2`\ **]** selects the arguments in the given range (both ends included).
- **Parameter[**\ `n`\ **]** selects the parameter at index `n` (zero-indexed).
- **Parameter[**\ `n1..n2`\ **]** selects the parameters in the given range (both ends included).
- **ReturnValue** selects the return value.
- **Field[**\ `name`\ **]** selects the field with the fully qualified name `name`.
- **SyntheticField[**\ `name`\ **]** selects the synthetic field with name `name`.
- **ArrayElement** selects the elements of an array.
- **Element** selects the elements of a collection-like container.
- **MapKey** selects the element keys of a map.
- **MapValue** selects the element values of a map.

Provenance
----------

The **provenance** column is used to specify the provenance (origin) of the model definition.

The following values are supported:

- **manual**: The model was manually created (or verified by a human) and added to the extension point.
- **generated**: The model was generated by the model generator and added to the extension point.
- **ai-generated**: The model was generated by AI and added to the extension point.

The provenance is used to distinguish between models that are manually added to the extension point and models that are automatically generated.
Furthermore, it impacts the dataflow analysis in the following way

- A **manual** model takes precedence over **generated** models. If a **manual** model exist for an element then all generated models are ignored.
- A **generated** or **ai-generated** model is ignored during analysis, if the source code of the element it is modelling is available.

That is, generated models are less trusted than manual models and only used if neither source code or a manual model is available.
