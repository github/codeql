.. _customizing-library-models-for-java:

Customizing Library Models for Java
===================================

.. include:: ../reusables/beta-note-customizing-library-models.rst

The Java analysis can be customized by adding library models (summaries, sinks and sources) in data extensions files.

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

In the sections below, we will go through the different extension points using concrete examples.
The **Reference material** section will in more detail describe the *mini DSLs* that are used to comprise a model definition.

Example: Taint sink in the **java.sql** package.
------------------------------------------------

In this example we will see, how to define the argument passed to the **execute** method as a SQL injection sink.
This is the **execute** method in the **Statement** class, which is located in the 'java.sql' package.
Please note that this sink is already added to the CodeQL Java analysis.

.. code-block:: java

   public static void taintsink(Connection conn, String query) throws SQLException {
       Statement stmt = conn.createStatement();
       stmt.execute(query);
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

- The seventh value **Argument[0]** is the access path to the first argument passed to the method, which means that this is the location of the sink.
- The eighth value **sql** is the kind of the sink. The sink kind is used to define for which queries the sink is in scope.
- The ninth value **manual** is the provenance of the sink, which is used to identify the origin of the sink.
 
Example: Taint source from the **java.net** package.
----------------------------------------------------
In this example we will see, how to define the return value from the **getInputStream** method as a remote source.
This is the **getInputStream** method in the **Socket** class, which is located in the 'java.net' package.
Please note that this source is already added to the CodeQL Java analysis.

.. code-block:: java

   public static InputStream tainted(Socket socket) throws IOException {
       InputStream stream = socket.getInputStream();
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

- The seventh value **ReturnValue** is the access path to the return of the method, which means that it is the return value that should be considered a tainted source.
- The eighth value **remote** is the kind of the source. The source kind is used to define for which queries the source is in scope. **remote** applies to many of security related queries as it means a remote source of untrusted data. As an example the SQL injection query uses **remote** sources. 
- The ninth value **manual** is the provenance of the source, which is used to identify the origin of the source.

Example: Adding flow through '<TODO>' methods.
----------------------------------------------


Example: Adding **neutral** methods.
------------------------------------
This is purely for consistency and has no impact on the analysis.

Reference material
------------------

The following sections provide reference material for extension points.
This includins descriptions of each of the arguments (eg. access paths, types, and kinds).