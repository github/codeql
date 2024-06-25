.. _customizing-library-models-for-python:

Customizing Library Models for Python
=========================================

.. include:: ../reusables/beta-note-customizing-library-models.rst

Python analysis can be customized by adding library models in data extension files.

A data extension for Python is a YAML file of the form:

.. code-block:: yaml 

  extensions:
    - addsTo:
        pack: codeql/python-all
        extensible: <name of extensible predicate>
      data:
        - <tuple1>
        - <tuple2>
        - ...

The CodeQL library for Python exposes the following extensible predicates:

- **sourceModel**\(type, path, kind)
- **sinkModel**\(type, path, kind)
- **typeModel**\(type1, type2, path)
- **summaryModel**\(type, path, input, output, kind)

We'll explain how to use these using a few examples, and provide some reference material at the end of this article.

Example: Taint sink in the 'fabric' package
-------------------------------------------

In this example, we'll show how to add the following argument, passed to **sudo** from the **fabric** package, as a command-line injection sink:

.. code-block:: python

  from fabric.operations import sudo
  sudo(cmd) # <-- add 'cmd' as a taint sink

Note that this sink is already recognized by the CodeQL Python analysis, but for this example, you could use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/python-all
        extensible: sinkModel
      data:
        - ["fabric", "Member[operations].Member[sudo].Argument[0]", "command-injection"]


- Since we're adding a new sink, we add a tuple to the **sinkModel** extensible predicate.
- The first column, **"fabric"**, identifies a set of values from which to begin the search for the sink.
  The string **"fabric"** means we start at the places where the codebase imports the package **fabric**.
- The second column is an access path that is evaluated from left to right, starting at the values that were identified by the first column.

  - **Member[operations]** selects accesses to the **operations** module.
  - **Member[sudo]** selects accesses to the **sudo** function in the **operations** module.
  - **Argument[0]** selects the first argument to calls to that function.

- **"command-injection"** indicates that this is considered a sink for the command injection query.

Example: Taint sink in the 'invoke' package
-------------------------------------------

Often sinks are found as arguments to methods rather than functions. In this example, we'll show how to add the following argument, passed to **run** from the **invoke** package, as a command-line injection sink:

.. code-block:: python

  import invoke
  c = invoke.Context()
  c.run(cmd) # <-- add 'cmd' as a taint sink

Note that this sink is already recognized by the CodeQL Python analysis, but for this example, you could use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/python-all
        extensible: sinkModel
      data:
        - ["invoke", "Member[Context].Instance.Member[run].Argument[0]", "command-injection"]

- The first column, **"invoke"**, begins the search at places where the codebase imports the package **invoke**.
- The second column is an access path that is evaluated from left to right, starting at the values that were identified by the first column.

  - **Member[Context]** selects accesses to the **Context** class.
  - **Instance** selects instances of the **Context** class.
  - **Member[run]** selects accesses to the **run** method in the **Context** class.
  - **Argument[0]** selects the first argument to calls to that method.

- **"command-injection"** indicates that this is considered a sink for the command injection query.

Note that the **Instance** component is used to select instances of a class, including instances of its subclasses.
Since methods on instances are common targets, we have a more compact syntax for selecting them. The first column, the type, is allowed to contain a dotted path ending in a class name.
This will begin the search at instances of that class. Using this syntax, the previous example could be written as:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/python-all
        extensible: sinkModel
      data:
        - ["invoke.Context", "Member[run].Argument[0]", "command-injection"]

Continued example: Multiple ways to obtain a type
-------------------------------------------------

The invoke package provides multiple ways to obtain a **Context** instance. The following example shows how to add a new way to obtain a **Context** instance:

.. code-block:: python

  from invoke import context
  c = context.Context()
  c.run(cmd) # <-- add 'cmd' as a taint sink

Comparing to the previous Python snippet, the **Context** class is now found as **invoke.context.Context** instead of **invoke.Context**.
We could add a data extension similar to the previous one, but with the type **invoke.context.Context**. However, we can also use the **typeModel** extensible predicate to describe how to reach **invoke.Context** from **invoke.context.Context**:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/python-all
        extensible: typeModel
      data:
        - ["invoke.Context", "invoke.context.Context", ""]

- The first column, **"invoke.Context"**, is the name of the type to reach.
- The second column, **"invoke.context.Context"**, is the name of the type from which to evaluate the path.
- The third column is just an empty string, indicating that any instance of **invoke.context.Context** is also an instance of **invoke.Context**.

Combining this with the sink model we added earlier, the sink in the example is detected by the model.

Example: Taint sources from Django 'upload_to' argument
-------------------------------------------------------

This example is a bit more advanced, involving both a callback function and a class constructor.
The Django web framework allows you to specify a function that determines the path where uploaded files are stored (see the `Django documentation <https://docs.djangoproject.com/en/5.0/ref/models/fields/#django.db.models.FileField.upload_to>`_).
This function is passed as an argument to the **FileField** constructor.
The function is called with two arguments: the instance of the model and the filename of the uploaded file.
This filename is what we want to mark as a taint source. An example use looks as follows:

.. code-block:: python

  from django.db import models

  def user_directory_path(instance, filename): # <-- add 'filename' as a taint source
    # file will be uploaded to MEDIA_ROOT/user_<id>/<filename>
    return "user_{0}/{1}".format(instance.user.id, filename)

  class MyModel(models.Model):
    upload = models.FileField(upload_to=user_directory_path) # <-- the 'upload_to' parameter defines our custom function

Note that this source is already known by the CodeQL Python analysis, but for this example, you could use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/python-all
        extensible: sourceModel
      data:
        - [
            "django.db.models.FileField!",
            "Call.Argument[0,upload_to:].Parameter[1]",
            "remote",
          ]


- Since we're adding a new taint source, we add a tuple to the **sourceModel** extensible predicate.
- The first column, **"django.db.models.FileField!"**, is a dotted path to the **FileField** class from the **django.db.models** package.
  The **!** at the end of the type name indicates that we are looking for the class itself rather than instances of this class.

- The second column is an access path that is evaluated from left to right, starting at the values that were identified by the first column.
  
    - **Call** selects calls to the class. That is, constructor calls.
    - **Argument[0,upload_to:]** selects the first positional argument, or the named argument named **upload_to**. Note that the colon at the end of the argument name indicates that we are looking for a named argument.
    - **Parameter[1]** selects the second parameter of the callback function, which is the parameter receiving the filename.

- Finally, the kind **"remote"** indicates that this is considered a source of remote flow.

Example: Adding flow through 're.compile'
----------------------------------------------

In this example, we'll show how to add flow through calls to ``re.compile``.
``re.compile`` returns a compiled regular expression for efficient evaluation, but the pattern to be compiled is stored in the ``pattern`` attribute of the resulting object.

.. code-block:: python

  import re

  let y = re.compile(pattern = x); // add value flow from 'x' to 'y.pattern'

Note that this flow is already recognized by the CodeQL Python analysis, but for this example, you could use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/python-all
        extensible: summaryModel
      data:
        - [
            "re",
            "Member[compile]",
            "Argument[0,pattern:]",
            "ReturnValue.Attribute[pattern]",
            "value",
          ]


- Since we're adding flow through a function call, we add a tuple to the **summaryModel** extensible predicate.
- The first column, **"re"**, begins the search for relevant calls at places where the **re** package is imported.
- The second column, **"Member[compile]"**, is a path leading to the function calls we wish to model.
  In this case, we select references to the **compile** function from the ``re`` package.
- The third column, **"Argument[0,pattern:]"**, indicates the input of the flow. In this case, either the first argument to the function call or the argument named **pattern**.
- The fourth column, **"ReturnValue.Attribute[pattern]"**, indicates the output of the flow. In this case, the ``pattern`` attribute of the return value of the function call.
- The last column, **"value"**, indicates the kind of flow to add. The value **value** means the input value is unchanged as
  it flows to the output.

Example: Adding flow through 'sorted'
-------------------------------------------------

In this example, we'll show how to add flow through calls to the built-in function **sorted**:

.. code-block:: python

  y = sorted(x) # add taint flow from 'x' to 'y'

Note that this flow is already recognized by the CodeQL Python analysis, but for this example, you could use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/python-all
        extensible: summaryModel
      data:
        - [
            "builtins",
            "Member[sorted]",
            "Argument[0]",
            "ReturnValue",
            "taint",
          ]


- Since we're adding flow through a function call, we add a tuple to the **summaryModel** extensible predicate.
- The first column, **"builtins"**, begins the search for relevant calls among references to the built-in names.
  In Python, many built-in functions are available. Technically, most of these are part of the **builtins** package, but they can be accessed without an explicit import. When we write **builtins** in the first column, we will find both the implicit and explicit references to the built-in functions.
- The second column, **"Member[sorted]"**, selects references to the **sorted** function from the **builtins** package; that is, the built-in function **sorted**.
- The third column, **"Argument[0]"**, indicates the input of the flow. In this case, the first argument to the function call.
- The fourth column, **"ReturnValue"**, indicates the output of the flow. In this case, the return value of the function call.
- The last column, **"taint"**, indicates the kind of flow to add. The value **taint** means the output is not necessarily equal
  to the input, but was derived from the input in a taint-preserving way.

We might also provide a summary stating that the elements of the input list are preserved in the output list:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/python-all
        extensible: summaryModel
      data:
        - [
            "builtins",
            "Member[sorted]",
            "Argument[0].ListElement",
            "ReturnValue.ListElement",
            "value",
          ]

The tracking of list elements is imprecise in that the analysis does not know where in the list the tracked value is found.
So this summary simply states that if the value is found somewhere in the input list, it will also be found somewhere in the output list, unchanged.

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
        pack: codeql/python-all
        extensible: sourceModel
      data:
        - ["flask", "Member[request]", "remote"]

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
        pack: codeql/python-all
        extensible: sinkModel
      data:
        - ["builtins", "Member[exec].Argument[0]", "code-injection"]

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
        pack: codeql/python-all
        extensible: summaryModel
      data:
        - [
            "builtins",
            "Member[reversed]",
            "Argument[0]",
            "ReturnValue",
            "taint",
          ]

typeModel(type1, type2, path)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A description of how to reach **type1** from **type2**.
If this is the only way to reach **type1**, for instance if **type1** is a name we made up to represent the inner workings of a library, we think of this as a definition of **type1**.
In the context of instances, this describes how to obtain an instance of **type1** from an instance of **type2**.

- **type1**: Name of the type to reach.
- **type2**: Name of the type from which to evaluate **path**.
- **path**: Access path leading from **type2** to **type1**.

Example:

.. code-block:: yaml

  extensions:
  - addsTo:
      pack: codeql/python-all
      extensible: typeModel
    data:
      - [
          "flask.Response",
          "flask",
          "Member[jsonify].ReturnValue",
        ]

Types
-----

A type is a string that identifies a set of values.
In each of the extensible predicates mentioned in previous section, the first column is always the name of a type.
A type can be defined by adding **typeModel** tuples for that type. Additionally, the following built-in types are available:

- The name of a package matches imports of that package. For example, the type **django** matches the expression **import django**.
- The type **builtins** identifies the builtins package. In Python, all built-in values are found in this package, so they can be identified using this type.
- A dotted path ending in a class name identifies instances of that class. If the suffix **!** is added, the type refers to the class itself.

Access paths
------------

The **path**, **input**, and **output** columns consist of a **.**-separated list of components, which is evaluated from left to right, with each step selecting a new set of values derived from the previous set of values.

The following components are supported:

- **Argument[**\ ``number``\ **]** selects the argument at the given index.
- **Argument[**\ ``name``:\ **]** selects the argument with the given name.
- **Argument[this]** selects the receiver of a method call.
- **Parameter[**\ ``number``\ **]** selects the parameter at the given index.
- **Parameter[**\ ``name``:\ **]** selects the named parameter with the given name.
- **Parameter[this]** selects the **this** parameter of a function.
- **ReturnValue** selects the return value of a function or call.
- **Member[**\ ``name``\ **]** selects the function/method/class/value with the given name.
- **Instance** selects instances of a class, including instances of its subclasses.
- **Attribute[**\ ``name``\ **]** selects the attribute with the given name.
- **ListElement** selects an element of a list.
- **SetElement** selects an element of a set.
- **TupleElement[**\ ``number``\ **]** selects the subscript at the given index.
- **DictionaryElement[**\ ``name``\ **]** selects the subscript at the given name.


Additional notes about the syntax of operands:

- Multiple operands may be given to a single component, as a shorthand for the union of the operands. For example, **Member[foo,bar]** matches the union of **Member[foo]** and **Member[bar]**.
- Numeric operands to **Argument**, **Parameter**, and **WithArity** may be given as an interval. For example, **Argument[0..2]** matches argument 0, 1, or 2.
- **Argument[N-1]** selects the last argument of a call, and **Parameter[N-1]** selects the last parameter of a function, with **N-2** being the second-to-last and so on.

Kinds
-----

Source kinds
~~~~~~~~~~~~

- **remote**: A generic source of remote flow. Most taint-tracking queries will use such a source. Currently this is the only supported source kind.

Sink kinds
~~~~~~~~~~

Unlike sources, sinks tend to be highly query-specific, rarely affecting more than one or two queries. Not every query supports customizable sinks. If the following sinks are not suitable for your use case, you should add a new query.

- **code-injection**: A sink that can be used to inject code, such as in calls to **exec**.
- **command-injection**: A sink that can be used to inject shell commands, such as in calls to **os.system**.
- **path-injection**: A sink that can be used for path injection in a file system access, such as in calls to **flask.send_from_directory**.
- **sql-injection**: A sink that can be used for SQL injection, such as in a MySQL **query** call.
- **html-injection**: A sink that can be used for HTML injection, such as a server response body.
- **js-injection**: A sink that can be used for JS injection, such as a server response body.
- **url-redirection**: A sink that can be used to redirect the user to a malicious URL.
- **unsafe-deserialization**: A deserialization sink that can lead to code execution or other unsafe behavior, such as an unsafe YAML parser.
- **log-injection**: A sink that can be used for log injection, such as in a **logging.info** call.

Summary kinds
~~~~~~~~~~~~~

- **taint**: A summary that propagates taint. This means the output is not necessarily equal to the input, but it was derived from the input in an unrestrictive way. An attacker who controls the input will have significant control over the output as well.
- **value**: A summary that preserves the value of the input or creates a copy of the input such that all of its object properties are preserved.
