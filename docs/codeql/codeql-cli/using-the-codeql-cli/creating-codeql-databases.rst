.. _creating-codeql-databases:

Creating CodeQL databases
=========================

Before you analyze your code using CodeQL, you need to create a CodeQL
database containing all the data required to run queries on your code.

CodeQL analysis relies on extracting relational data from your code, and
using it to build a :ref:`CodeQL database <codeql-database>`. CodeQL 
databases contain all of the important information about a codebase, which can 
be analyzed by executing CodeQL queries against it.
Before you generate a CodeQL database, you need to:

- Install and set up the CodeQL CLI. For more information, see
  ":doc:`Getting started with the CodeQL CLI <getting-started-with-the-codeql-cli>`."
- Check out the version of your codebase you want to analyze. The directory
  should be ready to build, with all dependencies already installed.

Running ``codeql database create``
----------------------------------

CodeQL databases are created by running the following command from the checkout root
of your project:

::

  codeql database create <database> --language=<language-identifier>

You must specify:

- ``<database>``: a path to the new database to be created. This directory will
  be created when you execute the command---you cannot specify an existing
  directory. 
- ``--language``: the identifier for the language to create a database for.
  CodeQL supports creating databases for the following languages:

  .. include:: ../../reusables/extractors.rst

Other options may be specified depending on the location of your source file and
the language you want to analyze:

- ``--source-root``: the root folder for the primary source files used in
  database creation. By default, the command assumes that the current
  directory is the source root---use this option to specify a different location.
- ``--command``: for compiled languages only, the build commands that invoke the
  compiler. Do not specify ``--command`` options for Python and
  JavaScript. Commands will be run from the current folder, or ``--source-root``
  if specified. If you don't include a ``--command``, CodeQL will attempt to
  detect the build system automatically, using a built-in autobuilder. 
   
For full details of all the options you can use when creating databases,
see the `database create reference documentation <../codeql-cli-manual/database-create.html>`__.  

Progress and results
--------------------

Errors are reported if there are any problems with the options you have
specified. For interpreted languages, the extraction progress is displayed in
the console---for each source file, it reports if extraction was successful or if
it failed. For compiled languages, the console will display the output of the
build system.

When the database is successfully created, you'll find a new directory at the
path specified in the command. This directory contains a number of
subdirectories, including the relational data (required for analysis) and a
source archive---a copy of the source files made at the time the database was
created---which is used for displaying analysis results.

Obtaining databases from LGTM.com
---------------------------------

`LGTM.com <https://lgtm.com>`__ analyzes thousands of open-source projects using
CodeQL. For each project on LGTM.com, you can download an archived CodeQL
database corresponding to the most recently analyzed revision of the code. These
databases can also be analyzed using the CodeQL CLI. 

.. include:: ../../reusables/download-lgtm-database.rst

Before running an analysis, unzip the databases and try :doc:`upgrading <upgrading-codeql-databases>` the
unzipped databases to ensure they are compatible with your local copy of the
CodeQL queries and libraries.
   
.. pull-quote::

   Note

   .. include:: ../../reusables/index-files-note.rst

Creating databases for non-compiled languages
---------------------------------------------

The CodeQL CLI includes extractors to create databases for non-compiled
languages---specifically, JavaScript (and TypeScript) and Python. These
extractors are automatically invoked when you specify JavaScript or Python as
the ``--language`` option when executing ``database create``. When creating
databases for these languages you must ensure that all additional dependencies
are available.

.. pull-quote:: Important

   When running ``database create`` for JavaScript, TypeScript, and Python, you must not
   specify a ``--command`` option. If you do, you will override the normal
   extractor invocation, which will create an empty database.

JavaScript and TypeScript
~~~~~~~~~~~~~~~~~~~~~~~~~

Creating databases for JavaScript requires no additional dependencies, but if
the project includes TypeScript files, you must install Node.js 6.x
or later. In the command line you can specify ``--language=javascript`` to
extract both JavaScript and TypeScript files::

   codeql database create --language=javascript --source-root <folder-to-extract> <output-folder>/javascript-database

Here, we have specified a ``--source-root`` path, which is the location where
database creation is executed, but is not necessarily the checkout root of the
codebase. 

Python
~~~~~~

When creating databases for Python you must ensure:

- You have the all of the required versions of Python installed.
- You have access to the `pip <https://pypi.org/project/pip/>`__ 
  packaging management system and can install any
  packages that the codebase depends on.
- You have installed the `virtualenv <https://pypi.org/project/virtualenv/>`__ pip module.

In the command line you must specify ``--language=python``. For example
::

   codeql database create --language=python <output-folder>/python-database

executes the ``database create`` subcommand from the code's checkout root,
generating a new Python database at ``<output-folder>/python-database``.


Creating databases for compiled languages
-----------------------------------------

For compiled languages, CodeQL needs to invoke the required build system to
generate a database, therefore the build method must be available to the CLI.

Detecting the build system
~~~~~~~~~~~~~~~~~~~~~~~~~~

The CodeQL CLI includes autobuilders for C/C++, C#, Go, and Java code. CodeQL
autobuilders allow you to build projects for compiled languages without
specifying any build commands. When an autobuilder is invoked, CodeQL examines
the source for evidence of a build system and attempts to run the optimal set of
commands required to extract a database.

An autobuilder is invoked automatically when you execute ``codeql database
create`` for a compiled ``--language`` if don't include a
``--command`` option. For example, for a Java codebase, you would simply run::

   codeql database create --language=java <output-folder>/java-database

If a codebase uses a standard build system, relying on an autobuilder is often
the simplest way to create a database. For sources that require non-standard
build steps, you may need to explicitly define each step in the command line.


.. pull-quote:: Creating databases for Go
  
   For Go, you should always use the CodeQL autobuilder. Install the Go
   toolchain (version 1.11 or later) and, if there are dependencies, the
   appropriate dependency manager (such as `dep
   <https://golang.github.io/dep/>`__ or `Glide <http://glide.sh/>`__).
   
   Do not specify any build commands, as you will override the autobuilder
   invocation, which will create an empty database.  

Specifying build commands
~~~~~~~~~~~~~~~~~~~~~~~~~

The following examples are designed to give you an idea of some of the build
commands that you can specify for compiled languages. 

.. pull-quote:: Important

   The ``--command`` option accepts a single argument---if you need to
   use more than one command, specify ``--command`` multiple times.

   If you need to pass subcommands and options, the whole argument needs to be
   quoted to be interpreted correctly.

- C/C++ project built using ``make``::

     codeql database create cpp-database --language=cpp --command=make

- C# project built using ``dotnet build`` (.NET Core 3.0 or later)::

     codeql database create csharp-database --language=csharp --command='dotnet build /t:rebuild' 

  On Linux and macOS (but not Windows), you need to disable shared compilation when building C# projects
  with .NET Core 2 or earlier, so expand the command to::

     codeql database create csharp-database --language=csharp --command='dotnet build /p:UseSharedCompilation=false /t:rebuild'

- Java project built using Gradle::

     codeql database create java-database --language=java --command='gradle clean test'

- Java project built using Maven::

     codeql database create java-database --language=java --command='mvn clean install'

- Java project built using Ant::

     codeql database create java-database --language=java --command='ant -f build.xml'

- Project built using a custom build script::

     codeql database create new-database --language=<language> --command='./scripts/build.sh'
   
  This command runs a custom script that contains all of the commands required
  to build the project.


Further reading
---------------

- ":ref:`Analyzing your projects in CodeQL for VS Code <analyzing-your-projects>`"
