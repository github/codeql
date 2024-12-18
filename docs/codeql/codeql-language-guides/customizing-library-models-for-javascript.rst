.. _customizing-library-models-for-javascript:

Customizing Library Models for JavaScript
=========================================

.. include:: ../reusables/beta-note-customizing-library-models.rst

JavaScript analysis can be customized by adding library models in data extension files.

A data extension for JavaScript is a YAML file of the form:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: <name of extensible predicate>
      data:
        - <tuple1>
        - <tuple2>
        - ...

The CodeQL library for JavaScript exposes the following extensible predicates:

- **sourceModel**\(type, path, kind)
- **sinkModel**\(type, path, kind)
- **typeModel**\(type1, type2, path)
- **summaryModel**\(type, path, input, output, kind)

We'll explain how to use these using a few examples, and provide some reference material at the end of this article.

Example: Taint sink in the 'execa' package
------------------------------------------

In this example, we'll show how to add the following argument, passed to **execa**, as a command-line injection sink:

.. code-block:: js

  import { shell } from "execa";
  shell(cmd); // <-- add 'cmd' as a taint sink

Note that this sink is already recognized by the CodeQL JS analysis, but for this example, you could use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sinkModel
      data:
        - ["execa", "Member[shell].Argument[0]", "command-injection"]


- Since we're adding a new sink, we add a tuple to the **sinkModel** extensible predicate.
- The first column, **"execa"**, identifies a set of values from which to begin the search for the sink.
  The string **"execa"** means we start at the places where the codebase imports the NPM package **execa**.
- The second column is an access path that is evaluated from left to right, starting at the values that were identified by the first column.

  - **Member[shell]** selects accesses to the **shell** member of the **execa** package.
  - **Argument[0]** selects the first argument to calls to that member.

- **command-injection** indicates that this is considered a sink for the command injection query.

Example: Taint sources from window 'message' events
---------------------------------------------------

In this example, we'll show how the **event.data** expression below could be marked as a remote flow source:

.. code-block:: js

  window.addEventListener("message", function (event) {
    let data = event.data; // <-- add 'event.data' as a taint source
  });

Note that this source is already known by the CodeQL JS analysis, but for this example, you could use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sourceModel
      data:
        - [
            "global",
            "Member[addEventListener].Argument[1].Parameter[0].Member[data]",
            "remote",
          ]


- Since we're adding a new taint source, we add a tuple to the **sourceModel** extensible predicate.
- The first column, **"global"**, begins the search at references to the global object (also known as **window** in browser contexts). This is a special JavaScript object that contains all global variables and methods.
- **Member[addEventListener]** selects accesses to the **addEventListener** member.
- **Argument[1]** selects the second argument of calls to that member (the argument containing the callback).
- **Parameter[0]** selects the first parameter of the callback (the parameter named **event**).
- **Member[data]** selects accesses to the **data** property of the event object.
- Finally, the kind **remote** indicates that this is considered a source of remote flow.

In the next section, we'll show how to restrict the model to recognize events of a specific type.

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
            "remote",
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


- The first column, **"mysql.Connection"**, begins the search at any expression whose value is known to be an instance of
  the **Connection** type from the **mysql** package. This will select the **connection** parameter above because of its type annotation.
- **Member[query]** selects the **query** member from the connection object.
- **Argument[0]** selects the first argument of a call to that member.
- **sql-injection** indicates that this is considered a sink for the SQL injection query.

This works in this example because the **connection** parameter has a type annotation that matches what the model is looking for.

Note that there is a significant difference between the following two rows:

.. code-block:: yaml

        data:
        - ["mysql.Connection", "", ...]
        - ["mysql", "Member[Connection]", ...]

The first row matches instances of **mysql.Connection**, which are objects that encapsulate a MySQL connection.
The second row would match something like **require('mysql').Connection**, which is not itself a connection object.

In the next section, we'll show how to generalize the model to handle the absence of type annotations.

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


- Since we're providing type information, we add a tuple to the **typeModel** extensible predicate.
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

Example: Using fuzzy models to simplify modeling
------------------------------------------------

In this example, we'll show how to add the following SQL injection sink using a "fuzzy" model:

.. code-block:: ts

  import * as mysql from 'mysql';
  const pool = mysql.createPool({...});
  pool.getConnection((err, conn) => {
    conn.query(q, (err, rows) => {...}); // <-- add 'q' as a SQL injection sink
  });

We can recognize this using a fuzzy model, as shown in the following extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sinkModel
      data:
        - ["mysql", "Fuzzy.Member[query].Argument[0]", "sql-injection"]

- The first column, **"mysql"**, begins the search at places where the `mysql` package is imported.
- **Fuzzy** selects all objects that appear to originate from the `mysql` package, such as the `pool`, `conn`, `err`, and `rows` objects.
- **Member[query]** selects the **query** member from any of those objects. In this case, the only such member is `conn.query`.
  In principle, this would also find expressions such as `pool.query` and `err.query`, but in practice such expressions
  are not likely to occur, because the `pool` and `err` objects do not have a member named `query`.
- **Argument[0]** selects the first argument of a call to the selected member, that is, the `q` argument to `conn.query`.
- **sql-injection** indicates that this is considered as a sink for the SQL injection query.

For reference, a more detailed model might look like this, as described in the preceding examples:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sinkModel
      data:
        - ["mysql.Connection", "Member[query].Argument[0]", "sql-injection"]

    - addsTo:
        pack: codeql/javascript-all
        extensible: typeModel
      data:
        - ["mysql.Pool", "mysql", "Member[createPool].ReturnValue"]
        - ["mysql.Connection", "mysql.Pool", "Member[getConnection].Argument[0].Parameter[1]"]

The model using the **Fuzzy** component is simpler, at the cost of being approximate.
This technique is useful when modeling a large or complex library, where it is difficult to write a detailed model.

Example: Adding flow through 'decodeURIComponent'
-------------------------------------------------

In this example, we'll show how to add flow through calls to `decodeURIComponent`:

.. code-block:: js

  let y = decodeURIComponent(x); // add taint flow from 'x' to 'y'

Note that this flow is already recognized by the CodeQL JS analysis, but for this example, you could use the following data extension:

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


- Since we're adding flow through a function call, we add a tuple to the **summaryModel** extensible predicate.
- The first column, **"global"**, begins the search for relevant calls at references to the global object.
  In JavaScript, global variables are properties of the global object, so this lets us access global variables or functions.
- The second column, **Member[decodeURIComponent]**, is a path leading to the function calls we wish to model.
  In this case, we select references to the **decodeURIComponent** member from the global object, that is,
  the global variable named **decodeURIComponent**.
- The third column, **Argument[0]**, indicates the input of the flow. In this case, the first argument to the function call.
- The fourth column, **ReturnValue**, indicates the output of the flow. In this case, the return value of the function call.
- The last column, **taint**, indicates the kind of flow to add. The value **taint** means the output is not necessarily equal
  to the input, but was derived from the input in a taint-preserving way.

Example: Adding flow through 'underscore.forEach'
-------------------------------------------------

In this example, we'll show how to add flow through calls to **forEach** from the **underscore** package:

.. code-block:: js

  require('underscore').forEach([x, y], (v) => { ... }); // add value flow from 'x' and 'y' to 'v'

Note that this flow is already recognized by the CodeQL JS analysis, but for this example, you could use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: summaryModel
      data:
        - [
            "underscore",
            "Member[forEach]",
            "Argument[0].ArrayElement",
            "Argument[1].Parameter[0]",
            "value",
          ]


- Since we're adding flow through a function call, we add a tuple to the **summaryModel** extensible predicate.
- The first column, **"underscore"**, begins the search for relevant calls at places where the **underscore** package is imported.
- The second column, **Member[forEach]**, selects references to the **forEach** member from the **underscore** package.
- The third column specifies the input of the flow:

  - **Argument[0]** selects the first argument of **forEach**, which is the array being iterated over.
  - **ArrayElement** selects the elements of that array (the expressions **x** and **y**).

- The fourth column specifies the output of the flow:

  - **Argument[1]** selects the second argument of **forEach** (the argument containing the callback function).
  - **Parameter[0]** selects the first parameter of the callback function (the parameter named **v**).

- The last column, **value**, indicates the kind of flow to add. The value **value** means the input value is unchanged as
  it flows to the output.

Reference material
------------------

The following sections provide reference material for extensible predicates, access paths, types, and kinds.

Extensible predicates
---------------------

sourceModel(type, path, kind)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds a new taint source. Most taint-tracking queries will use the new source.

- **type**: Name of a type from which to evaluate **path**.
- **path**: Access path leading to the source.
- **kind**: Kind of source to add. Currently only **remote** is used.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/javascript-all
        extensible: sourceModel
      data:
        - ["global", "Member[user].Member[name]", "remote"]

sinkModel(type, path, kind)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds a new taint sink. Sinks are query-specific and will typically affect one or two queries.

- **type**: Name of a type from which to evaluate **path**.
- **path**: Access path leading to the sink.
- **kind**: Kind of sink to add. See the section on sink kinds for a list of supported kinds.

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
In each of the extensible predicates mentioned in previous section, the first column is always the name of a type.
A type can be defined by adding **typeModel** tuples for that type. Additionally, the following built-in types are available:

- The name of an NPM package matches imports of that package. For example, the type **express** matches the expression **require("express")**. If the package name includes dots, it must be surrounded by single quotes, such as in **'lodash.escape'**.
- The type **global** identifies the global object, also known as **window**. In JavaScript, global variables are properties of the global object, so global variables can be identified using this type. (This type also matches imports of the NPM package named **global**, which is a package that happens to export the global object.)
- A qualified type name of form **<package>.<type>** identifies expressions of type **<type>** from **<package>**. For example, **mysql.Connection** identifies expression of type **Connection** from the **mysql** package. Note that this only works if type annotations are present in the codebase, or if sufficient **typeModel** tuples have been provided for that type.

Access paths
------------

The **path**, **input**, and **output** columns consist of a **.**-separated list of components, which is evaluated from left to right, with each step selecting a new set of values derived from the previous set of values.

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
- **Instance** selects instances of a class, including instances of its subclasses.
- **Fuzzy** selects all values that are derived from the current value through a combination of the other operations described in this list.
  For example, this can be used to find all values that appear to originate from a particular package. This can be useful for finding method calls
  from a known package, but where the receiver type is not known or is difficult to model.

The following components are called "call site filters". They select a subset of the previously-selected calls, if the call fits certain criteria:

- **WithArity[**\ `number`\ **]** selects the subset of calls that have the given number of arguments.
- **WithStringArgument[**\ `number`\ **=**\ `value`\ **]** selects the subset of calls where the argument at the given index is a string literal with the given value.

Components related to decorators:

- **DecoratedClass** selects a class that has the current value as a decorator. For example, **Member[Component].DecoratedClass** selects any class that is decorated with **@Component**.
- **DecoratedParameter** selects a parameter that is decorated by the current value.
- **DecoratedMember** selects a method, field, or accessor that is decorated by the current value.

Additional notes about the syntax of operands:

- Multiple operands may be given to a single component, as a shorthand for the union of the operands. For example, **Member[foo,bar]** matches the union of **Member[foo]** and **Member[bar]**.
- Numeric operands to **Argument**, **Parameter**, and **WithArity** may be given as an interval. For example, **Argument[0..2]** matches argument 0, 1, or 2.
- **Argument[N-1]** selects the last argument of a call, and **Parameter[N-1]** selects the last parameter of a function, with **N-2** being the second-to-last and so on.

Kinds
-----

Source kinds
~~~~~~~~~~~~

See documentation below for :ref:`Threat models <threat-models-javascript>`.

Sink kinds
~~~~~~~~~~

Unlike sources, sinks tend to be highly query-specific, rarely affecting more than one or two queries. Not every query supports customizable sinks. If the following sinks are not suitable for your use case, you should add a new query.

- **code-injection**: A sink that can be used to inject code, such as in calls to **eval**.
- **command-injection**: A sink that can be used to inject shell commands, such as in calls to **child_process.spawn**.
- **path-injection**: A sink that can be used for path injection in a file system access, such as in calls to **fs.readFile**.
- **sql-injection**: A sink that can be used for SQL injection, such as in a MySQL **query** call.
- **nosql-injection**: A sink that can be used for NoSQL injection, such as in a MongoDB **findOne** call.
- **html-injection**: A sink that can be used for HTML injection, such as in a jQuery **$()** call.
- **request-forgery**: A sink that controls the URL of a request, such as in a **fetch** call.
- **url-redirection**: A sink that can be used to redirect the user to a malicious URL.
- **unsafe-deserialization**: A deserialization sink that can lead to code execution or other unsafe behaviour, such as an unsafe YAML parser.
- **log-injection**: A sink that can be used for log injection, such as in a **console.log** call.

Summary kinds
~~~~~~~~~~~~~

- **taint**: A summary that propagates taint. This means the output is not necessarily equal to the input, but it was derived from the input in an unrestrictive way. An attacker who controls the input will have significant control over the output as well.
- **value**: A summary that preserves the value of the input or creates a copy of the input such that all of its object properties are preserved.

.. _threat-models-javascript:

Threat models
-------------

.. include:: ../reusables/threat-model-description.rst
