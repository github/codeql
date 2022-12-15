.. _customizing-library-models-for-javascript:

Customizing Library Models for JavaScript
=========================================

.. pull-quote::

   Beta Notice - Unstable API

   Library customization using data extensions is currently in beta and subject to change.

   Breaking changes to this format may occur while in beta.

The JavaScript analysis can be customized by adding library models in data extension files.

A data extension for JavaScript is a YAML file of form:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: <name of extension point>
      data:
        - <tuple1>
        - <tuple2>
        - ...

The data extension can contribute to the following extension points:

- **sourceModel**\(type, path, kind)
- **sinkModel**\(type, path, kind)
- **typeModel**\(type1, type2, path)
- **summaryModel**\(type, path, input, output, kind)

TODO: mention how to actually load the data extension and/or link to page about data extensions.

We'll explain how to use these using a few examples, and provide a `reference <#reference-1>`_ at the end of this article.

Example: Taint sink in the 'execa' package
------------------------------------------

In this example, we'll show how to add the argument passed to **execa** below as a command-line injection sink:

.. code-block:: js

  import { shell } from "execa";
  shell(cmd); // <-- add 'cmd' as a taint sink

This sink is already recognized by the CodeQL JS analysis, but for the sake of example we'll show how it could be added as an extension.

This can be achieved with the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sinkModel
      data:
        - ["execa", "Member[shell].Argument[0]", "command-line-injection"]

To break this down:

- Since we're adding a new sink, we add a tuple to the **sinkModel** extension point.
- The first column, **"execa"**, identifies a set of values from which to begin the search for the sink.
  The string **"execa"** means we start at the places where the codebase imports the NPM package **execa**.
- The second column is an access path that is evaluated from left to right, starting at the values that were identified by the first column.

  - **Member[shell]** selects accesses to the **shell** member of the **execa** package.
  - **Argument[0]** selects the first argument to calls to that member.

- **command-line-injection** indicates that this is considered a sink for the command injection query.

Example: Taint sources from window 'message' events
---------------------------------------------------

In this example, we'll show how the **event.data** expression below could be marked as a remote flow source:

.. code-block:: js

  window.addEventListener("message", function (event) {
    let data = event.data; // <-- add 'event.data' as a taint source
  });

This source is already known by the CodeQL JS analysis, but we'll show how it could be added as an extension. This can be achieved with the following extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sourceModel
      data:
        - [
            "global",
            "Member[addEventListener].Argument[1].Parameter[0].Member[data]",
            "remote-flow",
          ]

To break this down:

- Since we're adding a new taint source, we add a tuple to the **sourceModel** extension point.
- The first column, **"global"**, begins the search at references to the global object (also known as **window**). This is a special JavaScript object that contains all global variables and methods.
- **Member[addEventListener]** selects accesses to the **addEventListener** member.
- **Argument[1]** selects the second argument of calls to that member (the argument containing the callback).
- **Parameter[0]** selects the first parameter of the callback (the parameter named **event**).
- **Member[data]** selects accesses to the **data** property of the event object.
- Finally, the kind **remote-flow** indicates that this is considered a source of remote flow.

Continued example: Restricting the event type
---------------------------------------------

The model above treats all events as sources of remote flow, not just **message** events.
For example, it would also pick up this irrelevant source:

.. code-block:: js

  window.addEventListener("onclick", function (event) {
    let data = event.data; // <-- 'event.data' became a spurious taint source
  });


We can refine the model by adding the **WithStringArgument** component to restrict the set of calls being considered:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sourceModel
      data:
        - [
            "global",
            "Member[addEventListener].WithStringArgument[0=message].Argument[1].Parameter[0].Member[data]",
            "remote-flow",
          ]

The **WithStringArgument[0=message]** component here selects the subset of calls to **addEventListener** where the first argument is a string literal with the value **"message"**.

Example: Using types to add MySQL injection sinks
-------------------------------------------------

In this example, we'll show how to add the following SQL injection sink:

.. code-block:: ts

  import { Connection } from "mysql";

  function submit(connection: Connection, q: string) {
    connection.query(q); // <-- add 'q' as a SQL injection sink
  }

We can recognize this using the following extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sinkModel
      data:
        - ["mysql.Connection", "Member[query].Argument[0]", "sql-injection"]

To break this down:

- The first column, **"mysql.Connection"**, begins the search at any expression whose value is known to be an instance of
  the **Connection** type from the **mysql** package. This will select the **connection** parameter above because of its type annotation.
- **Member[query]** selects the **query** member from the connection object.
- **Argument[0]** selects the first argument of a call to that member.
- **sql-injection** indicates that this is considered a sink for the SQL injection query.

This works for the example above because the **connection** parameter has a type annotation that matches what the model is looking for.

In the next section, we'll show how to generalize the model to handle the absense of type annotations.

Continued example: Dealing with untyped code
--------------------------------------------

Suppose we want the model from above to detect the sink in this snippet:

.. code-block:: js

  import { getConnection } from "@example/db";
  let connection = getConnection();
  connection.query(q); // <-- add 'q' as a SQL injection sink

There is no type annotation on **connection**, and there is no indication of what **getConnection()** returns.
Using a **typeModel** tuple we can tell our model that this function returns an instance of **mysql.Connection**:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: typeModel
      data:
        - ["mysql.Connection", "@example/db", "Member[getConnection].ReturnValue"]

To break this down:

- Since we're providing type information, we add a tuple to the **typeModel** extension point.
- The first column, **"mysql.Connection"**, names the type that we're adding a new definition for.
- The second column, **"@example/db"**, begins the search at imports of the hypothetical NPM package **@example/db**.
- **Member[getConnection]** selects references to the **getConnection** member from that package.
- **ReturnValue** selects the return value from a call to that member.

The new model states that the return value of **getConnection()** has type **mysql.Connection**.
Combining this with the sink model we added earlier, the sink in the example is detected by the model.

The mechanism used here is how library models work for both TypeScript and plain JavaScript.
A good library model contains **typeModel** tuples to ensure it works even in codebases without type annotations.
For example, the **mysql** model that is included with the CodeQL JS analysis includes this type definition (among many others):

.. code-block:: yaml

  - ["mysql.Connection", "mysql", "Member[createConnection].ReturnValue"]

Reference
=========

The following sections provide reference material for extension points, access paths, types, and kinds.

Extension points
----------------

sourceModel(type, path, kind)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds a new taint source. Most taint-tracking queries will use the new source.

- **type**: Name of a type from which to evaluate **path**.
- **path**: Access path leading to the source.
- **kind**: Kind of source to add. Currently only **remote-flow** is used.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sourceModel
      data:
        - ["global", "Member[user].Member[name]", "remote-flow"]

sinkModel(type, path, kind)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds a new taint sink. Sinks are query-specific and will usually affect one or two queries.

- **type**: Name of a type from which to evaluate **path**.
- **path**: Access path leading to the sink.
- **kind**: Kind of sink to add. See `sink kinds <#sink-kinds>`_ for a list of supported kinds.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sinkModel
      data:
        - ["global", "Member[eval].Argument[0]", "code-injection"]

summaryModel(type, path, input, output, kind)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds flow through a function call.

- **type**: Name of a type from which to evaluate **path**.
- **path**: Access path leading to a function call.
- **input**: Path relative to the function call that leads to input of the flow.
- **output**: Path relative to the function call leading to the output of the flow.
- **kind**: Kind of summary to add. Can be **taint** for taint-propagating flow, or **value** for value-preserving flow.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: summaryModel
      data:
        - [
            "global",
            "Member[decodeURIComponent]",
            "Argument[0]",
            "ReturnValue",
            "taint",
          ]

typeModel(type1, type2, path)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds a new definition of a type.

- **type1**: Name of the type to define.
- **type2**: Name of the type from which to evaluate **path**.
- **path**: Access path leading from **type2** to **type1**.

Example:

.. code-block:: yaml

  extensions:
  - addsTo:
      pack: codeql/javascript-all
      extensible: typeModel
    data:
      - [
          "mysql.Connection",
          "@example/db",
          "Member[getConnection].ReturnValue",
        ]

Types
-----

A type is a string that identifies a set of values.
In each of the extension points mentioned above, the first column is always the name of a type.
A type can be defined by adding **typeModel** tuples for that type. Additionally, the following built-in types are available:

- The name of an NPM package matches imports of that package. For example, the type **express** matches the expression **require("express")**. If the package name includes dots, it must be surrounded by single quotes, such as in **'lodash.escape'**.
- The type **global** identifies the global object, also known as **window**. In JavaScript, global variables are properties of the global object, so global variables can be identified using this type. (This type also matches imports of the NPM package named **global**, which is a package that happens to export the global object.)
- A qualified type name of form **<package>.<type>** identifies expressions of type **<type>** from **<package>**. For example, **mysql.Connection** identifies expression of type **Connection** from the **mysql** package. Note that this only works if type annotations are present in the codebase, or if sufficient **typeModel** tuples have been provided for that type.

Access paths
------------

The **path**, **input**, and **output** columns consist of a **.**-separated list of components, which is evaluted from left to right, with each step selecting a new set of values derived from the previous set of values.

The following components are supported:

- **Argument[**\ `number`\ **]** selects the argument at the given index.
- **Argument[this]** selects the receiver of a method call.
- **Parameter[**\ `number`\ **]** selects the parameter at the given index.
- **Parameter[this]** selects the **this** parameter of a function.
- **ReturnValue** selects the return value of a function or call.
- **Member[**\ `name`\ **]** selects the property with the given name.
- **AnyMember** selects any property regardless of name.
- **ArrayElement** selects an element of an array.
- **Element** selects an element of an array, iterator, or set object.
- **MapValue** selects a value of a map object.
- **Awaited** selects the value of a promise.
- **Instance** selects instances of a class.

The following components are called "call site filters". They select a subset of the previously-selected calls, if the call fits certain criteria:

- **WithArity[**\ `number`\ **]** selects the subset of calls that have the given number of arguments.
- **WithStringArgument[**\ `number`\ **=**\ `value`\ **]** selects the subset of calls where the argument at the given index is a string literal with the given value.

Components related to decorators:

- **DecoratedClass** selects a class that has the current value as a decorator. For example, **Member[Component].DecoratedClass** selects any class that is decorated with **@Component**.
- **DecoratedParameter** selects a parameter that is decorated by the current value.
- **DecoratedMember** selects a method, field, or accessor that is decorated by the current value.

Some additional notes about the syntax of operands:

- Multiple operands may be given to a single component, as a shorthand for the union of the operands. For example, **Member[foo,bar]** matches the union of **Member[foo]** and **Member[bar]**.
- Numeric operands to **Argument**, **Parameter**, and **WithArity** may be given as an interval. For example, **Argument[0..2]** matches argument 0, 1, or 2.
- **Argument[N-1]** selects the last argument of a call, and **Parameter[N-1]** selects the last parameter of a function, with **N-2** being the second-to-last and so on.

Kinds
-----

Source kinds
~~~~~~~~~~~~

- **remote-flow**: A generic source of remote flow. Most taint-tracking queries will use such a source. Currently this is the only supported source kind.

Sink kinds
~~~~~~~~~~

Unlike sources, sinks tend to be highly query-specific, rarely affecting more than one or two queries. Not every query supports customizable sinks. If there is no suitable sink kind below, it is best to add a new query instead.

- **code-injection**: A sink that can be used to inject code, such as in calls to **eval**.
- **command-line-injection**: A sink that can be used to inject shell commands, such as in calls to **child_process.spawn**.
- **path-injection**: A sink that can be used for path injection in a file system access, such as in a calls to **fs.readFile**.
- **sql-injection**: A sink that can be used for SQL injection, such as in a MySQL **query** call.
- **nosql-injection**: A sink that can be used for NoSQL injection, such as in a MongoDB **findOne** call.
- **html-injection**: A sink that can be used for HTML injection, such as in a jQuery **$()** call.
- **request-forgery**: A sink that controls the URL of a request, such as in a **fetch** call.
- **url-redirection**: A sink that can be used to redirect the user to a malicious URL.
- **unsafe-deserialization**: A deserialization sink that can lead to code execution or other unsafe behaviour, such as an unsafe YAML parser.

Summary kinds
~~~~~~~~~~~~~

- **taint**: A summary that propagates taint. This means the output is not necessarily equal to the input, but it was derived from the input in an unrestrictive way. An attacker who controls the input will have significant control over the output as well.
- **value**: A summary that preserves the value of the input or creates a copy of the input such that all of its object properties are preserved.
