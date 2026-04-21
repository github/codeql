.. _customizing-library-models-for-rust:

Customizing library models for Rust
====================================

You can model the functions and methods that control data flow in any framework or library. This is especially useful for custom frameworks or niche libraries that are not supported by the standard CodeQL libraries.

.. include:: ../reusables/beta-note-customizing-library-models.rst

About this article
------------------

This article contains reference material about how to define custom models for sources, sinks, and flow summaries for Rust dependencies in data extension files.

About data extensions
---------------------

You can customize analysis by defining models (summaries, sinks, and sources) of your code's Rust dependencies in data extension files. Each model defines the behavior of one or more elements of your library or framework, such as functions and methods. When you run dataflow analysis, these models expand the potential sources and sinks tracked by dataflow analysis and improve the precision of results.

Most of the security queries search for paths from a source of untrusted input to a sink that represents a vulnerability. This is known as taint tracking. Each source is a starting point for dataflow analysis to track tainted data and each sink is an end point.

Taint tracking queries also need to know how data can flow through elements that are not included in the source code. These are modeled as summaries. A summary model enables queries to synthesize the flow behavior through elements in dependency code that is not stored in your repository.

Syntax used to define an element in an extension file
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each model of an element is defined using a data extension where each tuple constitutes a model.
A data extension file to extend the standard Rust queries included with CodeQL is a YAML file with the form:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
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

Extensible predicates used to create custom models in Rust
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The CodeQL library for Rust analysis exposes the following extensible predicates:

- ``sourceModel(path, output, kind, provenance)``. This is used to model sources of potentially tainted data. The ``kind`` of the sources defined using this predicate determine which threat model they are associated with. Different threat models can be used to customize the sources used in an analysis. For more information, see ":ref:`Threat models <threat-models-rust>`."
- ``sinkModel(path, input, kind, provenance)``. This is used to model sinks where tainted data may be used in a way that makes the code vulnerable.
- ``summaryModel(path, input, output, kind, provenance)``. This is used to model flow through elements.
- ``neutralModel(path, kind, provenance)``. This is similar to a summary model but used to indicate that a callable has no flow for a given category. Manual neutral models (those with a provenance such as ``manual``) can be used to override generated summary, source, or sink models (those with a provenance such as ``df-generated``), so that the generated model will be ignored.
- ``barrierModel(path, output, kind, provenance)``. This is used to model barriers, which are elements that stop the flow of taint.
- ``barrierGuardModel(path, input, acceptingValue, kind, provenance)``. This is used to model barrier guards, which are elements that can stop the flow of taint depending on a conditional check.

The extensible predicates are populated using the models defined in data extension files.

Canonical paths
~~~~~~~~~~~~~~~

In Rust models, each callable is identified by its **canonical path** — the fully-qualified path to the function or method. The canonical path follows the internal module structure of the crate, which may differ from the public re-export path.

Canonical paths take the following forms:

- **Free functions**: ``crate::module::function``, for example ``std::env::var`` or ``std::fs::read_to_string``.
- **Inherent methods**: ``<Type>::method``, for example ``<std::fs::File>::open``.
- **Trait methods with a concrete type**: ``<Type as Trait>::method``, for example ``<std::fs::File as std::io::Read>::read_to_end``.
- **Trait methods with a wildcard type**: ``<_ as Trait>::method``, for example ``<_ as core::clone::Clone>::clone``. This form matches any type that implements the trait and is useful for modeling broadly applicable trait methods.

Examples of custom model definitions
-------------------------------------

The examples in this section are based on models from the standard CodeQL Rust query pack published by GitHub. They demonstrate how to add tuples to extend extensible predicates that are used by the standard queries.

Example: Taint sink for SQL injection in the ``sqlx`` crate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Rust query pack models the first argument of the ``sqlx::query`` function as a SQL injection sink. The ``query`` function accepts a SQL query string that will be executed against a database.

.. code-block:: rust

  use sqlx;

  async fn run_query(pool: &sqlx::PgPool, user_input: &str) {
      sqlx::query(user_input) // The argument to this function is a SQL injection sink.
          .execute(pool)
          .await
          .unwrap();
  }

We need to add a tuple to the ``sinkModel``\(path, input, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: sinkModel
      data:
        - ["sqlx_core::query::query", "Argument[0]", "sql-injection", "manual"]

Since we want to add a new sink, we need to add a tuple to the ``sinkModel`` extensible predicate.

- The first value ``sqlx_core::query::query`` is the canonical path of the function to model. Note that this is the internal module path (``sqlx_core::query::query``), not the public re-export path (``sqlx::query``).
- The second value ``Argument[0]`` is the access path to the first argument of the function call, which is the SQL query string. This is the location of the sink.
- The third value ``sql-injection`` is the kind of the sink. The sink kind is used to define the queries where the sink is in scope.
- The fourth value ``manual`` is the provenance of the sink, which is used to identify the origin of the sink.

Example: Taint source from the ``reqwest`` crate
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Rust query pack models the return value of the ``reqwest::get`` function as a ``remote`` source. This function makes an HTTP GET request to a remote server.

.. code-block:: rust

  async fn fetch_data(url: &str) -> Result<reqwest::Response, reqwest::Error> {
      let response = reqwest::get(url).await?; // The return value is a remote source of taint.
      Ok(response)
  }

We need to add a tuple to the ``sourceModel``\(path, output, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: sourceModel
      data:
        - ["reqwest::get", "ReturnValue.Future.Field[core::result::Result::Ok(0)]", "remote", "manual"]

Since we are adding a new source, we need to add a tuple to the ``sourceModel`` extensible predicate.

- The first value ``reqwest::get`` is the canonical path of the function.
- The second value ``ReturnValue.Future.Field[core::result::Result::Ok(0)]`` is the access path to the output. This compound path is read left to right:

  - ``ReturnValue`` selects the return value of the function call. Since ``reqwest::get`` is an ``async`` function, the return value is a ``Future``.
  - ``Future`` unwraps the ``Future`` to reach the value that will be available after ``.await``.
  - ``Field[core::result::Result::Ok(0)]`` selects the first positional field of the ``Ok`` variant of the ``Result`` — that is, the ``reqwest::Response`` value.

- The third value ``remote`` is the kind of the source. ``remote`` indicates that this source represents data that originates from a remote network request. For more information, see ":ref:`Threat models <threat-models-rust>`."
- The fourth value ``manual`` is the provenance of the source.

Example: Taint source from environment variables
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Rust query pack models the return value of ``std::env::var`` as a source of data from the environment.

.. code-block:: rust

  fn get_config() {
      let db_url = std::env::var("DATABASE_URL").unwrap(); // The return value is a source of environment data.
      // ...
  }

We need to add a tuple to the ``sourceModel``\(path, output, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: sourceModel
      data:
        - ["std::env::var", "ReturnValue.Field[core::result::Result::Ok(0)]", "environment", "manual"]

- The first value ``std::env::var`` is the canonical path to the ``var`` function in the ``std::env`` module.
- The second value ``ReturnValue.Field[core::result::Result::Ok(0)]`` selects the ``Ok`` variant of the returned ``Result<String, VarError>``.
- The third value ``environment`` is the source kind. This is a subcategory of the ``local`` threat model. For more information, see ":ref:`Threat models <threat-models-rust>`."
- The fourth value ``manual`` is the provenance of the source.

Example: Add flow through the ``Response::text`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Rust query pack models taint flow through the ``text`` method of ``reqwest::Response``, which reads the response body as a string.

.. code-block:: rust

  async fn read_body(response: reqwest::Response) {
      let body = response.text().await.unwrap(); // There is taint flow from response to body.
      // ...
  }

We need to add a tuple to the ``summaryModel``\(path, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: summaryModel
      data:
        - ["<reqwest::response::Response>::text", "Argument[self]", "ReturnValue.Future.Field[core::result::Result::Ok(0)]", "taint", "manual"]

Since we are adding flow through a method, we need to add a tuple to the ``summaryModel`` extensible predicate.

- The first value ``<reqwest::response::Response>::text`` is the canonical path. Note the format ``<Type>::method`` used for inherent methods. Also note that the canonical path uses the internal module path ``reqwest::response::Response``, not just ``reqwest::Response``.
- The second value ``Argument[self]`` is the access path to the input. ``Argument[self]`` refers to the receiver of the method call (``response`` in the example).
- The third value ``ReturnValue.Future.Field[core::result::Result::Ok(0)]`` is the access path to the output. This models the fact that ``text()`` is an ``async`` method returning ``impl Future<Output = Result<String, Error>>``, so we follow through ``Future`` and then unwrap the ``Ok`` variant.
- The fourth value ``taint`` is the kind of the flow. ``taint`` means that taint is propagated through the call — the output is derived from the input but may not be identical to it.
- The fifth value ``manual`` is the provenance of the summary.

Example: Add flow through the ``Path::join`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Rust query pack models taint flow through the ``join`` method of ``std::path::Path``, where both the receiver and argument contribute to the result.

.. code-block:: rust

  use std::path::Path;

  fn build_path(base: &Path, user_input: &str) {
      let full_path = base.join(user_input); // There is taint flow from both base and user_input to full_path.
      // ...
  }

We need to add tuples to the ``summaryModel``\(path, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: summaryModel
      data:
        - ["<std::path::Path>::join", "Argument[self].Reference", "ReturnValue", "taint", "manual"]
        - ["<std::path::Path>::join", "Argument[0]", "ReturnValue", "taint", "manual"]

Since we are adding flow through a method, we need to add tuples to the ``summaryModel`` extensible predicate. Each tuple defines flow from one input to the output. The first row defines flow from the receiver and the second row defines flow from the first argument.

- The first value ``<std::path::Path>::join`` is the canonical path, the same for both rows.
- The second value differs:

  - ``Argument[self].Reference`` is the access path to the receiver. Since ``join`` takes ``&self``, we use ``Argument[self]`` to select the ``self`` reference, and then ``Reference`` to follow through the reference to the underlying ``Path`` value.
  - ``Argument[0]`` is the access path to the first argument (``user_input`` in the example).

- The third value ``ReturnValue`` is the access path to the output — the return value of the method call.
- The fourth value ``taint`` is the kind of flow. Since ``join`` combines the path and the argument, the output is derived from the inputs but is not identical to either one.
- The fifth value ``manual`` is the provenance of the summary.

.. note::

  When using ``Argument[self]`` to refer to the receiver, the ``Reference`` token may need to be appended to follow through the ``&self`` or ``&mut self`` reference to the underlying value. This depends on whether the data you want to track is on the reference itself or on the value behind the reference.

Example: Add flow through the ``Iterator::map`` method
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Rust query pack models a more complex flow through a higher-order method. Here we model flow through the ``map`` method of the ``Iterator`` trait, which takes a closure and applies it to each element.

.. code-block:: rust

  fn transform(items: Vec<String>) {
      let results: Vec<String> = items.into_iter().map(|item| {
          item.to_uppercase() // There is value flow from elements of `items` to `item`.
      }).collect();
  }

We need to add tuples to the ``summaryModel``\(path, input, output, kind, provenance) extensible predicate by updating a data extension file:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: summaryModel
      data:
        - ["<_ as core::iter::traits::iterator::Iterator>::map", "Argument[self].Element", "Argument[0].Parameter[0]", "value", "manual"]

Since we are adding flow through a trait method, we need to add a tuple to the ``summaryModel`` extensible predicate.

- The first value ``<_ as core::iter::traits::iterator::Iterator>::map`` is the canonical path. The ``<_ as Trait>::method`` form uses a wildcard type (``_``) to match any type that implements the ``Iterator`` trait.
- The second value ``Argument[self].Element`` is the access path to the input — the elements of the iterator (the receiver).
- The third value ``Argument[0].Parameter[0]`` is the access path to the output:

  - ``Argument[0]`` selects the closure argument to ``map``.
  - ``Parameter[0]`` selects the first parameter of the closure (``item`` in the example).

- The fourth value ``value`` is the kind of flow. ``value`` means the value is preserved as it flows — each element of the iterator flows unchanged into the closure parameter.
- The fifth value ``manual`` is the provenance of the summary.

Example: Add a ``neutral`` model
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how the Rust query pack models the ``Option::map`` method as neutral with respect to sinks.

A neutral model prevents generated or inherited models of a specific category (``source``, ``sink``, or ``summary``) from being applied to a callable. This is useful when an automatically generated model incorrectly identifies a callable as, for example, a sink.

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: neutralModel
      data:
        - ["<core::option::Option>::map", "sink", "manual"]

Since we are adding a neutral model, we need to add a tuple to the ``neutralModel`` extensible predicate. The tuple has three values:

- The first value ``<core::option::Option>::map`` is the canonical path of the function.
- The second value ``sink`` is the category of model to suppress. This means that any generated sink model for ``Option::map`` will be ignored. The category can be ``source``, ``sink``, or ``summary``.
- The third value ``manual`` is the provenance of the neutral model.

Example: Add a barrier for SQL injection
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how to model a barrier that stops the flow of taint. A barrier model is used to define that the flow of taint stops at the modeled element for the specified kind of query.

Consider a hypothetical function ``my_crate::sanitize::escape_sql`` which escapes a SQL string, making it safe to use in a SQL query.

.. code-block:: rust

  fn run_query(pool: &sqlx::PgPool, user_input: &str) {
      let safe_input = my_crate::sanitize::escape_sql(user_input); // The return value is safe to use in SQL.
      let query = format!("SELECT * FROM users WHERE name = '{}'", safe_input);
      // ...
  }

We need to add a tuple to the ``barrierModel``\(path, output, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: barrierModel
      data:
        - ["my_crate::sanitize::escape_sql", "ReturnValue", "sql-injection", "manual"]

Since we are adding a barrier, we need to add a tuple to the ``barrierModel`` extensible predicate.

- The first value ``my_crate::sanitize::escape_sql`` is the canonical path of the function.
- The second value ``ReturnValue`` is the access path to the output of the barrier, which means that the return value is considered sanitized.
- The third value ``sql-injection`` is the kind of the barrier. The barrier kind must match the kind used in the query where the barrier should take effect. In this case, it matches the ``sql-injection`` sink kind used by SQL injection queries.
- The fourth value ``manual`` is the provenance of the barrier.

Example: Add a barrier guard
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This example shows how to model a barrier guard that stops the flow of taint when a conditional check is performed on data.
A barrier guard model is used when a function returns a boolean that indicates whether the data is safe to use.

Consider a hypothetical function ``my_crate::validate::is_safe_path`` which returns ``true`` when the given path is safe to use in a file system access.

.. code-block:: rust

  fn read_file(user_path: &str) {
      if my_crate::validate::is_safe_path(user_path) { // The check guards the use, so the input is safe.
          let contents = std::fs::read_to_string(user_path).unwrap();
          // ...
      }
  }

We need to add a tuple to the ``barrierGuardModel``\(path, input, acceptingValue, kind, provenance) extensible predicate by updating a data extension file.

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: barrierGuardModel
      data:
        - ["my_crate::validate::is_safe_path", "Argument[0]", "true", "path-injection", "manual"]

Since we are adding a barrier guard, we need to add a tuple to the ``barrierGuardModel`` extensible predicate.

- The first value ``my_crate::validate::is_safe_path`` is the canonical path of the function.
- The second value ``Argument[0]`` is the access path to the input whose flow is blocked. In this case, the first argument to the function (``user_path`` in the example).
- The third value ``true`` is the accepting value of the barrier guard. This is the value that the conditional check must return for the barrier to apply. In this case, when ``is_safe_path`` returns ``true``, the input is considered safe.
- The fourth value ``path-injection`` is the kind of the barrier guard. The barrier guard kind must match the kind used in the query where the barrier guard should take effect. In this case, it matches the ``path-injection`` sink kind used by tainted path queries.
- The fifth value ``manual`` is the provenance of the barrier guard.

.. _threat-models-rust:

Threat models
-------------

.. include:: ../reusables/threat-model-description.rst

Reference material
------------------

The following sections provide reference material for extensible predicates, access paths, and kinds.

Extensible predicates
---------------------

sourceModel(path, output, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds a new taint source. Most taint-tracking queries will use the new source.

- **path**: Canonical path of the function or method.
- **output**: Access path leading to the source value.
- **kind**: Kind of source to add. See ":ref:`Threat models <threat-models-rust>`" for available source kinds.
- **provenance**: Origin of the model. Use ``manual`` for custom models.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: sourceModel
      data:
        - ["std::env::var", "ReturnValue.Field[core::result::Result::Ok(0)]", "environment", "manual"]

sinkModel(path, input, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds a new taint sink. Sinks are query-specific and will typically affect one or two queries.

- **path**: Canonical path of the function or method.
- **input**: Access path leading to the sink value.
- **kind**: Kind of sink to add. See the section on sink kinds for a list of commonly used kinds.
- **provenance**: Origin of the model. Use ``manual`` for custom models.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: sinkModel
      data:
        - ["sqlx_core::query::query", "Argument[0]", "sql-injection", "manual"]

summaryModel(path, input, output, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds flow through a function or method call.

- **path**: Canonical path of the function or method.
- **input**: Access path leading to the input of the flow (where data flows from).
- **output**: Access path leading to the output of the flow (where data flows to).
- **kind**: Kind of summary to add. Can be ``taint`` for taint-propagating flow, or ``value`` for value-preserving flow.
- **provenance**: Origin of the model. Use ``manual`` for custom models.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: summaryModel
      data:
        - ["<reqwest::response::Response>::text", "Argument[self]", "ReturnValue.Future.Field[core::result::Result::Ok(0)]", "taint", "manual"]

neutralModel(path, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Prevents generated or inherited models of the specified category from being applied to the callable.

- **path**: Canonical path of the function or method.
- **kind**: The category of model to suppress: ``source``, ``sink``, or ``summary``.
- **provenance**: Origin of the model. Use ``manual`` for custom models.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: neutralModel
      data:
        - ["<core::option::Option>::map", "sink", "manual"]

barrierModel(path, output, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds a new barrier that stops the flow of taint at the specified element.

- **path**: Canonical path of the function or method.
- **output**: Access path leading to the output of the barrier (the value that is considered sanitized).
- **kind**: Kind of barrier to add. The barrier kind must match the kind used in the query where the barrier should take effect.
- **provenance**: Origin of the model. Use ``manual`` for custom models.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: barrierModel
      data:
        - ["my_crate::sanitize::escape_sql", "ReturnValue", "sql-injection", "manual"]

barrierGuardModel(path, input, acceptingValue, kind, provenance)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds a new barrier guard that stops the flow of taint when a conditional check is performed on data.

- **path**: Canonical path of the function or method.
- **input**: Access path to the input whose flow is blocked.
- **acceptingValue**: The value that the conditional check must return for the barrier to apply. Usually ``"true"`` or ``"false"``.
- **kind**: Kind of barrier guard to add. The barrier guard kind must match the kind used in the query where the barrier guard should take effect.
- **provenance**: Origin of the model. Use ``manual`` for custom models.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/rust-all
        extensible: barrierGuardModel
      data:
        - ["my_crate::validate::is_safe_path", "Argument[0]", "true", "path-injection", "manual"]

Access paths
------------

The ``input`` and ``output`` columns consist of a ``.``-separated list of access path tokens, which is evaluated from left to right, with each step selecting a new set of values derived from the previous set.

The following tokens are commonly used:

- **Argument[**\ ``n``\ **]** selects the ``n``-th argument to a call (0-indexed). May be a range of the form ``x..y`` (inclusive) and/or a comma-separated list.
- **Argument[self]** selects the receiver (``self``) of a method call.
- **Parameter[**\ ``n``\ **]** selects the ``n``-th parameter of a callback. May be a range of the form ``x..y`` (inclusive) and/or a comma-separated list.
- **ReturnValue** selects the return value of a function call.
- **Element** selects an element in a collection (such as a ``Vec``, ``HashMap``, or iterator).
- **Field[**\ ``type::field``\ **]** selects a named field of a struct or enum variant. For example, ``Field[ihex::Record::Data::value]`` selects the field ``value`` of the ``ihex::Record::Data`` variant.
- **Field[**\ ``type(i)``\ **]** selects the ``i``-th positional field of a tuple struct or tuple enum variant. For example, ``Field[core::result::Result::Ok(0)]`` selects the first positional value inside ``Ok``.
- **Field[**\ ``i``\ **]** selects the ``i``-th element of a tuple.
- **Reference** follows through a reference (``&T`` or ``&mut T``) to reach the referenced value.
- **Future** follows through a ``Future`` to reach the value that will be available after ``.await``.

Additional notes about the syntax:

- Multiple operands may be given to a single token, as a shorthand for the union of the operands. For example, ``Argument[0,1]`` matches both ``Argument[0]`` and ``Argument[1]``.
- Numeric operands to ``Argument`` and ``Parameter`` may be given as a range. For example, ``Argument[0..2]`` matches arguments 0, 1, and 2.

Kinds
-----

Source kinds
~~~~~~~~~~~~

See ":ref:`Threat models <threat-models-rust>`" for available source kinds.

Sink kinds
~~~~~~~~~~

Unlike sources, sinks tend to be highly query-specific, rarely affecting more than one or two queries. Not every query supports customizable sinks.

Commonly used sink kinds for Rust include:

- **sql-injection**: A sink for SQL injection, such as an argument to ``sqlx::query``.
- **path-injection**: A sink for path injection in a file system access, such as an argument to ``std::fs::read``.
- **log-injection**: A sink for log injection, such as an argument to a logging function.
- **html-injection**: A sink for HTML injection (cross-site scripting), such as a response body.
- **command-injection**: A sink for command injection, such as an argument to ``std::process::Command``.
- **request-url**: A sink for server-side request forgery, such as a URL passed to an HTTP client.
- **regex-use**: A sink for regex injection, such as a pattern passed to a regex constructor.

Summary kinds
~~~~~~~~~~~~~

- **taint**: A summary that propagates taint. This means the output is not necessarily equal to the input, but it was derived from the input in an unrestrictive way. An attacker who controls the input will have significant control over the output as well.
- **value**: A summary that preserves the value of the input or creates a copy of the input such that all of its properties are preserved.
