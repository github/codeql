.. _using-api-graphs-in-ruby:

Using API graphs in Ruby
==========================

API graphs are a uniform interface for referring to functions, classes, and methods defined in
external libraries.

About this article
------------------

This article describes how to use API graphs to reference classes and functions defined in library
code. You can use API graphs to conveniently refer to external library functions when defining things like
remote flow sources.


Module and class references
---------------------------

The most common entry point into the API graph will be the point where a toplevel module or class is
accessed. For example, you can access the API graph node corresponding to the ``::Regexp`` class
by using the ``API::getTopLevelMember`` method defined in the ``codeql.ruby.ApiGraphs`` module, as the
following snippet demonstrates.

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("Regexp")

This query selects the API graph nodes corresponding to references to the ``Regexp`` class. For nested
modules and classes, you can use the ``getMember` method. For example the following query selects
references to the ``Net::HTTP`` class.

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("Net").getMember("HTTP")

Note that the given module name *must not* contain any ```::`` symbols. Thus, something like
`API::getTopLevelMember("Net::HTTP")`` will not do what you expect. Instead, this should be decomposed
into an access of the ``HTTP`` member of the API graph node for ``Net``, as in the example above.

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

For many libraries, the main mode of usage is to extend one or more library classes. To track this
in the API graph, you can use the ``getASubclass`` method to get the API graph node corresponding to
all the immediate subclasses of this node. To find *all* subclasses, use ``*`` or ``+`` to apply the
method repeatedly, as in ``getASubclass*``.

Note that ``getASubclass`` does not account for any subclassing that takes place in library code
that has not been extracted. Thus, it may be necessary to account for this in the models you write.
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
to external API components such as library functions and their inputs and outputs. API graph nodes
cannot be used directly in dataflow queries they model entities that are defined externally,
while dataflow nodes correspond to entities defined in the current code base. To brigde this gap
the API node classes provide the ``asSource()`` and ``asSink()`` methods.

The ``asSource()`` method is used to select dataflow nodes where a value from an external source
enters the current code base. A typical example is the return value of a library function such as
``File.read(path)``:

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("File").getMethod("read").getParameter(1).asSource()


The ``asSink()`` method is used to select dataflow nodes where a value leaves the
current code base and flows into an external library. For example the second parameter
of the ``File.write(path, value)`` method.

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("File").getMethod("write").getParameter(1).asSink()

A more complex example is a call to ``File.open`` with a block argument. This function creates a ```File`` instance
and passes it to the supplied block. In this case the first parameter of the block is the place where an
externally created value enters the code base, i.e. the ``|file|`` in the example below:

.. code-block:: ruby

    File.open("/my/file.txt", "w") { |file| file << "Hello world" }

The following snippet finds parameters of blocks of ``File.open`` method calls:

.. code-block:: ql

    import codeql.ruby.ApiGraphs

    select API::getTopLevelMember("File").getMethod("open").getBlock().getParameter(0).asSource()

The following example is a dataflow query that that uses API graphs to find cases where data that 
is read flows into a call to ```File.write``.

.. code-block:: ql

    import codeql.ruby.DataFlow
    import codeql.ruby.ApiGraphs

    class Configuration extends DataFlow::Configuration {
      Configuration() { this = "File read/write Configuration" }

      override predicate isSource(DataFlow::Node source) {
        source = API::getTopLevelMember("File").getMethod("read").getReturn().asSource()
      }

      override predicate isSink(DataFlow::Node sink) {
        sink = API::getTopLevelMember("File").getMethod("write").getParameter(1).asSink()
      }
    }

    from DataFlow::Node src, DataFlow::Node sink, Configuration config
    where config.hasFlow(src, sink)
    select src, "The data read here flows into a $@ call.", sink, "File.write"

Further reading
---------------


.. include:: ../reusables/ruby-further-reading.rst
.. include:: ../reusables/codeql-ref-tools-further-reading.rst
