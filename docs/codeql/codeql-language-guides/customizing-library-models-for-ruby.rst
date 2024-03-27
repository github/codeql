.. _customizing-library-models-for-ruby:


Customizing Library Models for Ruby
===================================

.. include:: ../reusables/beta-note-customizing-library-models.rst

Ruby analysis can be customized by adding library models in data extension files.

A data extension for Ruby is a YAML file of the form:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/ruby-all
        extensible: <name of extensible predicate>
      data:
        - <tuple1>
        - <tuple2>
        - ...

The CodeQL library for Ruby exposes the following extensible predicates:

- **sourceModel**\(type, path, kind)
- **sinkModel**\(type, path, kind)
- **typeModel**\(type1, type2, path)
- **summaryModel**\(type, path, input, output, kind)

We'll explain how to use these using a few examples, and provide some reference material at the end of this article.

Example: Taint sink in the 'tty-command' gem
--------------------------------------------

In this example, we'll show how to add the following argument, passed to **tty-command**, as a command-line injection sink:

.. code-block:: ruby

  tty = TTY::Command.new
  tty.run(cmd) # <-- add 'cmd' as a taint sink

For this example, you can use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/ruby-all
        extensible: sinkModel
      data:
        - ["TTY::Command", "Method[run].Argument[0]", "command-injection"]


- Since we're adding a new sink, we add a tuple to the **sinkModel** extensible predicate.
- The first column, **"TTY::Command"**, identifies a set of values from which to begin the search for the sink.
  The string **"TTY::Command""** means we start at the places where the codebase constructs instances of the class **TTY::Command**.
- The second column is an access path that is evaluated from left to right, starting at the values that were identified by the first column.

  - **Method[run]** selects calls to the **run** method of the **TTY::Command** class.
  - **Argument[0]** selects the first argument to calls to that member.

- **command-injection** indicates that this is considered a sink for the command injection query.

Example: Taint sources from 'sinatra' block parameters
------------------------------------------------------

In this example, we'll show how the 'x' parameter below could be marked as a remote flow source:

.. code-block:: ruby

  class MyApp < Sinatra::Base
    get '/' do |x| # <-- add 'x' as a taint source
      # ...
    end
  end

For this example you could use the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/ruby-all
        extensible: sourceModel
      data:
        - [
            "Sinatra::Base!",
            "Method[get].Argument[block].Parameter[0]",
            "remote",
          ]

- Since we're adding a new taint source, we add a tuple to the **sourceModel** extensible predicate.
- The first column, **"Sinatra::Base!"**, begins the search at references to the **Sinatra::Base** class.
  The **!** suffix indicates that we want to search for references to the class itself, rather than instances of the class.
- **Method[get]** selects calls to the **get** method of the **Sinatra::Base** class.
- **Argument[block]** selects the block argument to the **get** method call.
- **Parameter[0]** selects the first parameter of the block argument (the parameter named **x**).
- Finally, the kind **remote** indicates that this is considered a source of remote flow.

Example: Using types to add MySQL injection sinks
-------------------------------------------------

In this example, we'll show how to add the following SQL injection sink:

.. code-block:: ruby

  def submit(q)
    client = Mysql2::Client.new
    client.query(q) # <-- add 'q' as a SQL injection sink
  end

We can recognize this using the following extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/ruby-all
        extensible: sinkModel
      data:
        - ["Mysql2::Client", "Method[query].Argument[0]", "sql-injection"]

- The first column, **"Mysql2::Client"**, begins the search at any instance of the **Mysql2::Client** class.
- **Method[query]** selects any call to the **query** method on that instance.
- **Argument[0]** selects the first argument to the method call.
- **sql-injection** indicates that this is considered a sink for the SQL injection query.

Continued example: Using type models
------------------------------------

Consider this variation on the previous example, the mysql2 EventMachine API is used.
The client is obtained via a call to **Mysql2::EM::Client.new**.

.. code-block:: ruby

  def submit(client, q)
    client = Mysql2::EM::Client.new
    client.query(q)
  end

So far we have only one model for **Mysql2::Client**, but in the real world we
may have many models for the various methods available. Because **Mysql2::EM::Client** is a subclass of **Mysql2::Client**, it inherits all of the same methods.
Instead of updating all our models to include both classes, we can add a type
model to indicate that **Mysql2::EM::Client** is a subclass of **Mysql2::Client**:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/ruby-all
        extensible: typeModel
      data:
        - ["Mysql2::Client", "Mysql2::EM::Client", ""]

Example: Adding flow through 'URI.decode_uri_component'
-------------------------------------------------------

In this example, we'll show how to add flow through calls to 'URI.decode_uri_component':

.. code-block:: ruby

  y = URI.decode_uri_component(x); # add taint flow from 'x' to 'y'

We can model this using the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/ruby-all
        extensible: summaryModel
      data:
        - [
            "URI!",
            "Method[decode_uri_component]",
            "Argument[0]",
            "ReturnValue",
            "taint",
          ]


- Since we're adding flow through a method call, we add a tuple to the **summaryModel** extensible predicate.
- The first column, **"URI!"**, begins the search for relevant calls at references to the **URI** class.
- The **!** suffix indicates that we are looking for the class itself, rather than instances of the class.
- The second column, **Method[decode_uri_component]**, is a path leading to the method calls we wish to model.
  In this case, we select references to the **decode_uri_component** method from the **URI** class.
- The third column, **Argument[0]**, indicates the input of the flow. In this case, the first argument to the method call.
- The fourth column, **ReturnValue**, indicates the output of the flow. In this case, the return value of the method call.
- The last column, **taint**, indicates the kind of flow to add. The value **taint** means the output is not necessarily equal
  to the input, but was derived from the input in a taint-preserving way.

Example: Adding flow through 'File#each'
----------------------------------------

In this example, we'll show how to add flow through calls to **File#each** from the standard library, which iterates over the lines of a file:

.. code-block:: ruby

  f = File.new("example.txt")
  f.each { |line| ... } # add taint flow from `f` to `line`

We can model this using the following data extension:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/ruby-all
        extensible: summaryModel
      data:
        - [
            "File",
            "Method[each]",
            "Argument[self]",
            "Argument[block].Parameter[0]",
            "taint",
          ]


- Since we're adding flow through a method call, we add a tuple to the **summaryModel** extensible predicate.
- The first column, **"File"**, begins the search for relevant calls at places where the **File** class is used.
- The second column, **Method[each]**, selects references to the **each** method on the **File** class.
- The third column specifies the input of the flow. **Argument[self]** selects the **self** argument of **each**, which is the **File** instance being iterated over.

- The fourth column specifies the output of the flow:

  - **Argument[block]** selects the block argument of **each** (the block which is executed for each line in the file).
  - **Parameter[0]** selects the first parameter of the block (the parameter named **line**).

- The last column, **taint**, indicates the kind of flow to add.

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
        pack: codeql/ruby-all
        extensible: sourceModel
      data:
        - ["User", "Method[name]", "remote"]

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
        pack: codeql/ruby-all
        extensible: sinkModel
      data:
        - ["ExecuteShell", "Method[run].Argument[0]", "command-injection"]

summaryModel(type, path, input, output, kind)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Adds flow through a method call.

- **type**: Name of a type from which to evaluate **path**.
- **path**: Access path leading to a method call.
- **input**: Path relative to the method call that leads to input of the flow.
- **output**: Path relative to the method call leading to the output of the flow.
- **kind**: Kind of summary to add. Can be **taint** for taint-propagating flow, or **value** for value-preserving flow.

Example:

.. code-block:: yaml

  extensions:
    - addsTo:
        pack: codeql/ruby-all
        extensible: summaryModel
      data:
        - [
            "URI",
            "Method[decode_uri_component]",
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
      pack: codeql/ruby-all
      extensible: typeModel
    data:
      - [
          "Mysql2::Client",
          "MyDbWrapper",
          "Method[getConnection].ReturnValue",
        ]

Types
-----

A type is a string that identifies a set of values.
In each of the extensible predicates mentioned in previous section, the first column is always the name of a type.
A type can be defined by adding **typeModel** tuples for that type.

Access paths
------------

The **path**, **input**, and **output** columns consist of a **.**-separated list of components, which is evaluated from left to right,
with each step selecting a new set of values derived from the previous set of values.

The following components are supported:

- **Argument[**\ `number`\ **]** selects the argument at the given index.
- **Argument[**\ `string`:\ **]** selects the keyword argument with the given name.
- **Argument[self]** selects the receiver of a method call.
- **Argument[block]** selects the block argument.
- **Argument[any]** selects any argument, except self or block arguments.
- **Argument[any-named]** selects any keyword argument.
- **Argument[hash-splat]** selects a special argument representing all keyword arguments passed in the method call.
- **Parameter[**\ `number`\ **]** selects the argument at the given index.
- **Parameter[**\ `string`:\ **]** selects the keyword argument with the given name.
- **Parameter[self]** selects the **self** parameter of a method.
- **Parameter[block]** selects the block parameter.
- **Parameter[any]** selects any parameter, except self or block parameters.
- **Parameter[any-named]** selects any keyword parameter.
- **Parameter[hash-splat]** selects the hash splat parameter, often written as **\*\*kwargs**.
- **ReturnValue** selects the return value of a call.
- **Method[**\ `name`\ **]** selects a call to the method with the given name.
- **Element[any]** selects any element of an array or hash.
- **Element[**\ `number`\ **]** selects an array element at the given index.
- **Element[**\ `string`\ **]** selects a hash element at the given key.
- **Field[@**\ `string`\ **]** selects an instance variable with the given name.
- **Fuzzy** selects all values that are derived from the current value through a combination of the other operations described in this list.
  For example, this can be used to find all values that appear to originate from a particular class. This can be useful for finding method calls
  from a known class, but where the receiver type is not known or is difficult to model.

Additional notes about the syntax of operands:

- Multiple operands may be given to a single component, as a shorthand for the union of the operands. For example, **Method[foo,bar]** matches the union of **Method[foo]** and **Method[bar]**.
- Numeric operands to **Argument**, **Parameter**, and **Element** may be given as a lower bound. For example, **Argument[1..]** matches all arguments except 0.

Kinds
-----

Source kinds
~~~~~~~~~~~~

- **remote**: A generic source of remote flow. Most taint-tracking queries will use such a source. Currently this is the only supported source kind.

Sink kinds
~~~~~~~~~~

Unlike sources, sinks tend to be highly query-specific, rarely affecting more than one or two queries.
Not every query supports customizable sinks. If the following sinks are not suitable for your use case, you should add a new query.

- **code-injection**: A sink that can be used to inject code, such as in calls to **eval**.
- **command-injection**: A sink that can be used to inject shell commands, such as in calls to **Process.spawn**.
- **path-injection**: A sink that can be used for path injection in a file system access, such as in calls to **File.open**.
- **sql-injection**: A sink that can be used for SQL injection, such as in an ActiveRecord **where** call.
- **url-redirection**: A sink that can be used to redirect the user to a malicious URL.
- **log-injection**: A sink that can be used for log injection, such as in a **Rails.logger** call.

Summary kinds
~~~~~~~~~~~~~

- **taint**: A summary that propagates taint. This means the output is not necessarily equal to the input, but it was derived from the input in an unrestrictive way. An attacker who controls the input will have significant control over the output as well.
- **value**: A summary that preserves the value of the input or creates a copy of the input such that all of its object properties are preserved.
