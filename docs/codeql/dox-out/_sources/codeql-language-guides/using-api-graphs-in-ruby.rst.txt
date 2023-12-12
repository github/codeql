.. _using-api-graphs-in-ruby:

Using API graphs in Ruby
==========================

API graphs are a uniform interface for referring to functions, classes, and methods defined in
external libraries.

About this article
------------------

This article describes how you can use API graphs to reference classes and functions defined in library
code. API graphs are particularly useful when you want to model the remote flow sources available from external library functions.


Module and class references
---------------------------

The most common entry point into the API graph is when a top-level module or class is accessed. 
For example, you can access the API graph node corresponding to the ``::Regexp`` class
by using the ``API::getTopLevelMember`` method defined in the ``codeql.ruby.ApiGraphs`` module, as the
following snippet demonstrates.

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("Regexp")

The example above finds references to a top-level class. For nested
modules and classes, you can use the ``getMember`` method. For example the following query selects
references to the ``Net::HTTP`` class.

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("Net").getMember("HTTP")

Note that you should specify module names without ``::`` symbols. If you write ``API::getTopLevelMember("Net::HTTP")``, it will not do what you expect. Instead, you need to decompose this name
into an access of the ``HTTP`` member of the API graph node for ``Net``, as shown in the example above.

Calls and class instantiations
------------------------------

To track the calls of externally defined functions, you can use the ``getMethod`` method. The
following snippet finds all calls of ``Regexp.compile``:

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("Regexp").getMethod("compile")

The example above is for a call to a class method. Tracking calls to instance methods, is a two-step
process, first you need to find instances of the class before you can find the calls
to methods on those instances. The following snippet finds instantiations of the ``Regexp`` class:

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("Regexp").getInstance()

Note that the ``getInstance`` method also includes subclasses. For example if there is a 
``class SpecialRegexp < Regexp`` then ``getInstance`` also finds ``SpecialRegexp.new``.

The following snippet builds on the above to find calls of the ``Regexp#match?`` instance method:

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("Regexp").getInstance().getMethod("match?")

Subclasses
----------

Many libraries are used by extending one or more library classes. To track this
in the API graph, you can use the ``getASubclass`` method to get the API graph node corresponding to
the immediate subclasses of a node. To find *all* subclasses, use ``*`` or ``+`` to apply the
method repeatedly. You can see an example where all subclasses are identified using ``getASubclass*`` below.

Note that ``getASubclass`` can only return subclasses that are extracted as part of the CodeQL database 
that you are analyzing. When libraries have predefined subclasses, you will need to explicitly include them in your model.
For example, the ``ActionController::Base`` class has a predefined subclass ``Rails::ApplicationController``. To find
all subclasses of ``ActionController::Base``, you must explicitly include the subclasses of ``Rails::ApplicationController`` as well.

.. code-block:: ql

    import codeql.ruby.ApiGraphs


    API::Node actionController() {
      result =
        [
          API::getTopLevelMember("ActionController").getMember("Base"),
          API::getTopLevelMember("Rails").getMember("ApplicationController")
        ].getASubclass*()
    }

    select actionController()


Using the API graph in dataflow queries
---------------------------------------

Dataflow queries often search for points where data from external sources enters the code base
as well as places where data leaves the code base. API graphs provide a convenient way to refer 
to external API components such as library functions and their inputs and outputs. 
However, you do not use API graph nodes directly in dataflow queries. 

- API graph nodes model entities that are defined outside your code base.
- Dataflow nodes model entities defined within the current code base. 

You bridge the gap between the entities outside and inside your code base using 
the API node class methods: ``asSource()`` and ``asSink()``.

The ``asSource()`` method is used to select dataflow nodes where a value from an external source
enters the current code base. A typical example is the return value of a library function such as
``File.read(path)``:

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("File").getMethod("read").getReturn().asSource()


The ``asSink()`` method is used to select dataflow nodes where a value leaves the
current code base and flows into an external library. For example the second parameter
of the ``File.write(path, value)`` method.

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("File").getMethod("write").getParameter(1).asSink()

A more complex example is a call to ``File.open`` with a block argument. This function creates a ``File`` instance
and passes it to the supplied block. In this case, we are interested in the first parameter of the block because this is where an
externally created value enters the code base, that is, the ``|file|`` in the Ruby example below:

.. code-block:: ruby

    File.open("/my/file.txt", "w") { |file| file << "Hello world" }

The following snippet of CodeQL finds parameters of blocks of ``File.open`` method calls:

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("File").getMethod("open").getBlock().getParameter(0).asSource()

The following example is a dataflow query that that uses API graphs to find cases where data that 
is read flows into a call to ``File.write``.

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.ApiGraphs

    module Configuration implements DataFlow::ConfigSig {
      predicate isSource(DataFlow::Node source) {
        source = API::getTopLevelMember("File").getMethod("read").getReturn().asSource()
      }

      predicate isSink(DataFlow::Node sink) {
        sink = API::getTopLevelMember("File").getMethod("write").getParameter(1).asSink()
      }
    }

    module Flow = DataFlow::Global<Configuration>;

    from DataFlow::Node src, DataFlow::Node sink
    where Flow::flow(src, sink)
    select src, "The data read here flows into a $@ call.", sink, "File.write"

Further reading
---------------


.. include:: ../reusables/ruby-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
