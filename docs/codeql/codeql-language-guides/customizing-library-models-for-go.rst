.. _customizing-library-models-for-go:

Customizing library models for Go
=================================

You can model the methods and functions that control data flow in any framework or library. This is especially useful for custom frameworks or niche libraries, that are not supported by the standard CodeQL libraries.

.. include:: ../reusables/beta-note-customizing-library-models.rst

About this article
------------------

This article contains reference material about how to define custom models for sources, sinks, and flow summaries for Go dependencies in data extension files.

About data extensions
---------------------

You can customize analysis by defining models (summaries, sinks, and sources) of your code's Go dependencies in data extension files. Each model defines the behavior of one or more elements of your library or framework, such as functions, methods, and fields. When you run dataflow analysis, these models expand the potential sources and sinks tracked by dataflow analysis and improve the precision of results.

Most of the security queries search for paths from a source of untrusted input to a sink that represents a vulnerability. This is known as taint tracking. Each source is a starting point for dataflow analysis to track tainted data and each sink is an end point.

Taint tracking queries also need to know how data can flow through elements that are not included in the source code. These are modeled as summaries. A summary model enables queries to synthesize the flow behavior through elements in dependency code that is not stored in your repository.

Syntax used to define an element in an extension file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each model of an element is defined using a data extension where each tuple constitutes a model.
A data extension file to extend the standard Go queries included with CodeQL is a YAML file with the form:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/go-all
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

Extensible predicates used to create custom models in Go
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The CodeQL library for Go analysis exposes the following extensible predicates:

- ``sourceModel(package, type, subtypes, name, signature, ext, output, kind, provenance)``. This is used to model sources of potentially tainted data. The ``kind`` of the sources defined using this predicate determine which threat model they are associated with. Different threat models can be used to customize the sources used in an analysis. For more information, see ":ref:`Threat models <threat-models-go>`."
- ``sinkModel(package, type, subtypes, name, signature, ext, input, kind, provenance)``. This is used to model sinks where tainted data may be used in a way that makes the code vulnerable.
- ``summaryModel(package, type, subtypes, name, signature, ext, input, output, kind, provenance)``. This is used to model flow through elements.
- ``neutralModel(package, type, name, signature, kind, provenance)``. This is similar to a summary model but used to model the flow of values that have only a minor impact on the dataflow analysis. Manual neutral models (those with a provenance such as ``manual`` or ``ai-manual``) can be used to override generated summary models (those with a provenance such as ``df-generated``), so that the summary model will be ignored. Other than that, neutral models have no effect.

The extensible predicates are populated using the models defined in data extension files.

Examples of custom model definitions
------------------------------------

The examples in this section are taken from the standard CodeQL Go query pack published by GitHub. They demonstrate how to add tuples to extend extensible predicates that are used by the standard queries.

Example: Taint sink in the ``database/sql`` package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Go query pack models the argument of the ``Prepare`` method as a SQL injection sink.
This is the ``Prepare`` method of the ``DB`` type in the ``database/sql`` package which creates a prepared statement.

.. code-block:: go

    func Tainted(db *sql.DB, name string) {
        stmt, err := db.Prepare("SELECT * FROM users WHERE name = " + name) // The argument to this method is a SQL injection sink.
        ...
    }

We need to add a tuple to the ``sinkModel``\(package, type, subtypes, name, signature, ext, input, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/go-all
         extensible: sinkModel
       data:
         - ["database/sql", "DB", True, "Prepare", "", "", "Argument[0]", "sql-injection", "manual"]

Since we want to add a new sink, we need to add a tuple to the ``sinkModel`` extensible predicate.
The first five values identify the function (in this case a method) to be modeled as a sink.

- The first value ``database/sql`` is the package name.
- The second value ``DB`` is the name of the type that the method is associated with.
- The third value ``True`` is a flag that indicates whether or not the sink also applies to subtypes. This includes when the subtype embeds the given type, so that the method or field is promoted to be a method or field of the subtype. For interface methods it also includes types which implement the interface type.
- The fourth value ``Prepare`` is the method name.
- The fifth value ``""`` is the input type signature. For Go it should always be an empty string. It is needed for other languages where multiple functions may have the same name and they need to be distinguished by the number and types of the arguments.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the sink.

- The seventh value ``Argument[0]`` is the ``access path`` to the first argument passed to the method, which means that this is the location of the sink.
- The eighth value ``sql-injection`` is the kind of the sink. The sink kind is used to define the queries where the sink is in scope. In this case - the SQL injection queries.
- The ninth value ``manual`` is the provenance of the sink, which is used to identify the origin of the sink.

Example: Taint source from the ``net/http`` package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the Go query pack models the return value from the ``FormValue`` method as a ``remote`` source.
This is the ``FormValue`` method of the ``Request`` type which is located in the ``net/http`` package.

.. code-block:: go

    func Tainted(r *http.Request) {
        name := r.FormValue("name") // The return value of this method is a source of tainted data.
        ...
    }


We need to add a tuple to the ``sourceModel``\(package, type, subtypes, name, signature, ext, output, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/go-all
         extensible: sourceModel
       data:
         - ["net/http", "Request", True, "FormValue", "", "", "ReturnValue", "remote", "manual"]


Since we are adding a new source, we need to add a tuple to the ``sourceModel`` extensible predicate.
The first five values identify the function to be modeled as a source.

- The first value ``net/http`` is the package name.
- The second value ``Request`` is the type name, since the function is a method of the ``Request`` type.
- The third value ``True`` is a flag that indicates whether or not the sink also applies to subtypes. This includes when the subtype embeds the given type, so that the method or field is promoted to be a method or field of the subtype. For interface methods it also includes types which implement the interface type.
- The fourth value ``FormValue`` is the function name.
- The fifth value ``""`` is the input type signature. For Go it should always be an empty string. It is needed for other languages where multiple functions may have the same name and they need to be distinguished by the number and types of the arguments.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the source.

- The seventh value ``ReturnValue`` is the access path to the return of the method, which means that it is the return value that should be considered a source of tainted input.
- The eighth value ``remote`` is the kind of the source. The source kind is used to define the threat model where the source is in scope. ``remote`` applies to many of the security related queries as it means a remote source of untrusted data. As an example the SQL injection query uses ``remote`` sources. For more information, see ":ref:`Threat models <threat-models-go>`."
- The ninth value ``manual`` is the provenance of the source, which is used to identify the origin of the source.

Example: Add flow through the ``Max`` function
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Go query pack models flow through a function for a simple case.
This pattern covers many of the cases where we need to summarize flow through a function that is stored in a library or framework outside the repository.

.. code-block:: go

    func ValueFlow {
        a := []int{1, 2, 3}
        max := slices.Max(a) // There is value flow from the elements of `a` to `max`.
        ...
    }

We need to add a tuple to the ``summaryModel``\(package, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/go-all
         extensible: summaryModel
       data:
         - ["slices", "", False, "Max", "", "", "Argument[0].ArrayElement", "ReturnValue", "value", "manual"] 

Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate.
The first row defines flow from the first argument (``a`` in the example) to the return value (``max`` in the example).

The first five values identify the function to be modeled as a summary.

- The first value ``slices`` is the package name.
- The second value ``""`` is left blank, since the function is not a method of a type.
- The third value ``False`` is a flag that indicates whether or not the sink also applies to subtypes. This has no effect for non-method functions.
- The fourth value ``Max`` is the function name.
- The fifth value ``""`` is the input type signature. For Go it should always be an empty string. It is needed for other languages where multiple functions may have the same name and they need to be distinguished by the number and types of the arguments.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the summary.

- The seventh value is the access path to the input (where data flows from). ``Argument[0].ArrayElement`` is the access path to the array elements of the first argument (the elements of the slice in the example).
- The eighth value ``ReturnValue`` is the access path to the output (where data flows to), in this case ``ReturnValue``, which means that the input flows to the return value.
- The ninth value ``value`` is the kind of the flow. ``value`` flow indicates an entire value is moved, ``taint`` means that taint is propagated through the call.
- The tenth value ``manual`` is the provenance of the summary, which is used to identify the origin of the summary.

Example: Add flow through the ``Concat`` function
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Go query pack models flow through a function for a simple case.
This pattern covers many of the cases where we need to summarize flow through a function that is stored in a library or framework outside the repository.

.. code-block:: go

    func ValueFlow {
        a := []int{1, 2, 3}
        b := []int{4, 5, 6}
        c := slices.Concat(a, b) // There is taint flow from `a` and `b` to `c`.
        ...
    }

We need to add a tuple to the ``summaryModel``\(package, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/go-all
         extensible: summaryModel
       data:
         - ["slices", "", False, "Concat", "", "", "Argument[0].ArrayElement.ArrayElement", "ReturnValue.ArrayElement", "value", "manual"]

Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate.
The first row defines flow from the arguments (``a`` and ``b`` in the example) to the return value (``c`` in the example).

The first five values identify the function to be modeled as a summary.

- The first value ``slices`` is the package name.
- The second value ``""`` is left blank, since the function is not a method of a type.
- The third value ``False`` is a flag that indicates whether or not the sink also applies to subtypes. This has no effect for non-method functions.
- The fourth value ``Max`` is the function name.
- The fifth value ``""`` is the input type signature. For Go it should always be an empty string. It is needed for other languages where multiple functions may have the same name and they need to be distinguished by the number and types of the arguments.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the summary.

- The seventh value is the access path to the input (where data flows from). ``Argument[0].ArrayElement.ArrayElement`` is the access path to the array elements of the array elements of the first argument. Note that a variadic parameter of type `...T` is treated as if it has type `[]T` and arguments corresponding to the variadic parameter are accessed as elements of this slice.
- The eighth value ``ReturnValue.ArrayElement`` is the access path to the output (where data flows to), in this case ``ReturnValue.ArrayElement``, which means that the input flows to the array elements of the return value.
- The ninth value ``value`` is the kind of the flow. ``value`` flow indicates an entire value is moved, ``taint`` means that taint is propagated through the call.
- The tenth value ``manual`` is the provenance of the summary, which is used to identify the origin of the summary.

Example: Add flow through the ``Join`` function
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the Go query pack models flow through a method for a simple case.
This pattern covers many of the cases where we need to summarize flow through a function that is stored in a library or framework outside the repository.

.. code-block:: go

    func TaintFlow() {
        elems := []string{"Hello", "World"}
        sep := " "
        t := strings.Join(elems, sep) // There is taint flow from elems and sep to t.
        ...
    }

We need to add tuples to the ``summaryModel``\(package, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/go-all
         extensible: summaryModel
       data:
         - ["strings", "", False, "Join", "", "", "Argument[0]", "ReturnValue", "taint", "manual"]
         - ["strings", "", False, "Join", "", "", "Argument[1]", "ReturnValue", "taint", "manual"]

Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate.
Each tuple defines flow from one argument to the return value.
The first row defines flow from the first argument (``elems`` in the example) to the return value (``t`` in the example) and the second row defines flow from the second argument (``sep`` in the example) to the return value (``t`` in the example).

The first five values identify the function to be modeled as a summary.
These are the same for both of the rows above as we are adding two summaries for the same method.

- The first value ``strings`` is the package name.
- The second value ``""`` is left blank, since the function is not a method of a type.
- The third value ``False`` is a flag that indicates whether or not the sink also applies to subtypes. This has no effect for non-method functions.
- The fourth value ``Join`` is the function name.
- The fifth value ``""`` is the input type signature. For Go it should always be an empty string. It is needed for other languages where multiple functions may have the same name and they need to be distinguished by the number and types of the arguments.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the summary.

- The seventh value is the access path to the input (where data flows from). ``Argument[0]`` is the access path to the first argument (``elems`` in the example) and ``Argument[1]`` is the access path to the second argument (``sep`` in the example).
- The eighth value ``ReturnValue`` is the access path to the output (where data flows to), in this case ``ReturnValue``, which means that the input flows to the return value.
- The ninth value ``taint`` is the kind of the flow. ``taint`` means that taint is propagated through the call.
- The tenth value ``manual`` is the provenance of the summary, which is used to identify the origin of the summary.

It would also be possible to merge the two rows into one by using ".." to indicate a range in the seventh value. This would be useful if the method has many arguments and the flow is the same for all of them.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/go-all
         extensible: summaryModel
       data:
         - ["strings", "", False, "Join", "", "", "Argument[0..1]", "ReturnValue", "taint", "manual"]

This row defines flow from both the first and the second argument to the return value. The seventh value ``Argument[0..1]`` is shorthand for specifying an access path to both ``Argument[0]`` and ``Argument[1]``.

Example: Add flow through the ``Hostname`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how the Go query pack models flow through a method for a simple case.

.. code-block:: go

    func TaintFlow(u *url.URL) {
        host := u.Hostname() // There is taint flow from u to host.
        ...
    }
    
We need to add a tuple to the ``summaryModel``\(package, type, subtypes, name, signature, ext, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/go-all
         extensible: summaryModel
       data:
         - ["net/url", "URL", True, "Hostname", "", "", "Argument[receiver]", "ReturnValue", "taint", "manual"]

Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate.
Each tuple defines flow from one argument to the return value.
The first row defines flow from the qualifier of the method call (``u`` in the example) to the return value (``host`` in the example).

The first five values identify the function (in this case a method) to be modeled as a summary.

- The first value ``net/url`` is the package name.
- The second value ``URL`` is the receiver type.
- The third value ``True`` is a flag that indicates whether or not the sink also applies to subtypes. This includes when the subtype embeds the given type, so that the method or field is promoted to be a method or field of the subtype. For interface methods it also includes types which implement the interface type.
- The fourth value ``Hostname`` is the method name.
- The fifth value ``""`` is the input type signature. For Go it should always be an empty string. It is needed for other languages where multiple functions may have the same name and they need to be distinguished by the number and types of the arguments.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the summary.

- The seventh value is the access path to the input (where data flows from). ``Argument[receiver]`` is the access path to the receiver (``u`` in the example).
- The eighth value ``ReturnValue`` is the access path to the output (where data flows to), in this case ``ReturnValue``, which means that the input flows to the return value. When there are multiple return values, use ``ReturnValue[i]`` to refer to the ``i`` th return value (starting from 0).
- The ninth value ``taint`` is the kind of the flow. ``taint`` means that taint is propagated through the call.
- The tenth value ``manual`` is the provenance of the summary, which is used to identify the origin of the summary.

Example: Accessing the ``Body`` field of an HTTP request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This example shows how we can model a field read as a source of tainted data.

.. code-block:: go

   func TaintFlow(w http.ResponseWriter, r *http.Request) {
       body := r.Body // The Body field of an HTTP request is a source of tainted data.
       ...
   }

We need to add a tuple to the ``sourceModel``\(package, type, subtypes, name, signature, ext, output, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

  extensions:
  - addsTo:
      pack: codeql/go-all
      extensible: sourceModel
    data:
      - ["net/http", "Request", True, "Body", "", "", "", "remote", "manual"]

Since we are adding a new source, we need to add a tuple to the ``sourceModel`` extensible predicate.
The first five values identify the field to be modeled as a source.

- The first value ``net/http`` is the package name.
- The second value ``Request`` is the name of the type that the field is associated with.
- The third value ``True`` is a flag that indicates whether or not the sink also applies to subtypes. For fields this means when the field is accessed as a promoted field in another type.
- The fourth value ``Body`` is the field name.
- The fifth value ``""`` is the input type signature. For Go it should always be an empty string. It is needed for other languages where multiple functions may have the same name and they need to be distinguished by the number and types of the arguments.

The sixth value should be left empty and is out of scope for this documentation.
The remaining values are used to define the ``access path``, the ``kind``, and the ``provenance`` (origin) of the source.

- The seventh value ``""`` is left blank. Leaving the access path of a source model blank indicates that it is a field access.
- The eighth value ``remote`` is the source kind. This indicates that the source is a remote source of untrusted data.
- The ninth value ``manual`` is the provenance of the source, which is used to identify the origin of the source.

Package versions
~~~~~~~~~~~~~~~~

When the major version number is greater than 1 it is included in the package import path. It usually looks like ``/v2`` after the module import path. This is called the major version suffix. We normally want our models to apply to all versions of a package. Rather than having to repeat models with the package column changed to include all available versions, we can just use the package name without the major version suffix and this will be matched to any version. So models with ``github.com/couchbase/gocb`` in the package column will match packages imported from ``github.com/couchbase/gocb`` and ``github.com/couchbase/gocb/v2`` (or any other version).

Note that packages hosted at ``gopkg.in`` use a slightly different syntax: the major version suffix looks like ``.v2``, and it is present even for version 1. This is also supported. So models with ``gopkg.in/yaml`` in the package column will match packages imported from ``gopkg.in/yaml.v1``, ``gopkg.in/yaml.v2`` and ``gopkg.in/yaml.v3``.

To write models that only apply to ``github.com/couchbase/gocb/v2``, it is sufficient to include the major version suffix (``/v2``) in the package column. To write models that only apply to ``github.com/couchbase/gocb``, you may prefix the package column with ``fixed-version:``. For example, here are two models for a method that has changed name from v1 to v2.

.. code-block:: yaml
  
    extensions:
    - addsTo:
        pack: codeql/go-all
        extensible: sinkModel
      data:
        - ["fixed-version:github.com/couchbase/gocb", "Cluster", True, "ExecuteAnalyticsQuery", "", "", "Argument[0]", "nosql-injection", "manual"]
        - ["github.com/couchbase/gocb/v2", "Cluster", True, "AnalyticsQuery", "", "", "Argument[0]", "nosql-injection", "manual"]

Package grouping
~~~~~~~~~~~~~~~~

Since Go uses URLs for package identifiers, it is possible for packages to be imported with different paths. For example, the ``glog`` package can be imported using both the ``github.com/golang/glog`` and ``gopkg.in/glog`` paths.

To handle this, the CodeQL Go library uses a mapping from the package path to a group name for the package. This mapping can be specified using the ``packageGrouping`` extensible predicate, and then the models for the APIs in the package
will use the the prefix ``group:`` followed by the group name in place of the package path.

.. code-block:: yaml

   extensions:
     - addsTo:
         pack: codeql/go
         extensible: packageGrouping
       data:
         - ["glog", "github.com/golang/glog"]
         - ["glog", "gopkg.in/glog"]
    - addsTo:
        pack: codeql/go
        extensible: sinkModel
      data:
        - ["group:glog", "", False, "Info", "", "", "Argument[0]", "log-injection", "manual"]

.. _threat-models-go:

Threat models
-------------

.. include:: ../reusables/threat-model-description.rst
