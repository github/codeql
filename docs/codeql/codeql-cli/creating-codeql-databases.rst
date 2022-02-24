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

For information about using the CodeQL CLI in a third-party CI system to create results
to display in GitHub as code scanning alerts, see `Configuring CodeQL CLI in your CI system <https://docs.github.com/en/code-security/secure-coding/using-codeql-code-scanning-with-your-existing-ci-system/configuring-codeql-cli-in-your-ci-system>`__ 
in the GitHub documentation. For information about enabling CodeQL code scanning using GitHub Actions,
see `Setting up code scanning for a repository <https://docs.github.com/en/code-security/secure-coding/automatically-scanning-your-code-for-vulnerabilities-and-errors/setting-up-code-scanning-for-a-repository>`__ 
in the GitHub documentation.

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
  When used with ``--db-cluster``, the option accepts a comma-separated list, 
  or can be specified more than once.
  CodeQL supports creating databases for the following languages:

  .. include:: ../reusables/extractors.rst

You can specify additional options depending on the location of your source file, 
if the code needs to be compiled, and if you want to create CodeQL databases for 
more than one language:

- ``--source-root``: the root folder for the primary source files used in
  database creation. By default, the command assumes that the current
  directory is the source root---use this option to specify a different location.
- ``--db-cluster``: use for multi-language codebases when you want to create
  databases for more than one language. 
- ``--command``: used when you create a database for one or more compiled languages,
  omit if the only languages requested are Python and JavaScript. 
  This specifies the build commands needed to invoke the compiler. 
  Commands are run from the current folder, or ``--source-root``
  if specified. If you don't include a ``--command``, CodeQL will attempt to
  detect the build system automatically, using a built-in autobuilder. 
- ``--no-run-unnecessary-builds``: used with ``--db-cluster`` to suppress the build 
  command for languages where the CodeQL CLI does not need to monitor the build 
  (for example, Python and JavaScript/TypeScript).

You can specify extractor options to customize the behavior of extractors that create CodeQL databases. For more information, see
":doc:`Extractor options <extractor-options>`."

For full details of all the options you can use when creating databases,
see the `database create reference documentation <../manual/database-create>`__.  

Progress and results
--------------------

Errors are reported if there are any problems with the options you have
specified. For interpreted languages, the extraction progress is displayed in
the console---for each source file, it reports if extraction was successful or if
it failed. For compiled languages, the console will display the output of the
build system.

When the database is successfully created, you'll find a new directory at the
path specified in the command. If you used the ``--db-cluster`` option to create
more than one database, a subdirectory is created for each language.
Each CodeQL database directory contains a number of
subdirectories, including the relational data (required for analysis) and a
source archive---a copy of the source files made at the time the database was
created---which is used for displaying analysis results.

Creating databases for non-compiled languages
---------------------------------------------

The CodeQL CLI includes extractors to create databases for non-compiled
languages---specifically, JavaScript (and TypeScript), Python, and Ruby. These
extractors are automatically invoked when you specify JavaScript, Python, or Ruby as
the ``--language`` option when executing ``database create``. When creating
databases for these languages you must ensure that all additional dependencies
are available.

.. pull-quote:: Important

   When you run ``database create`` for JavaScript, TypeScript, Python, and Ruby, you should not
   specify a ``--command`` option. Otherwise this overrides the normal
   extractor invocation, which will create an empty database. If you create
   databases for multiple languages and one of them is a compiled language,
   use the ``--no-run-unnecessary-builds`` option to skip the command for the languages that don't need to be compiled.

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

By default, files in ``node_modules`` and ``bower_components`` directories are not extracted.

Python
~~~~~~

When creating databases for Python you must ensure:

- You have the all of the required versions of Python installed.
- You have access to the `pip <https://pypi.org/project/pip/>`__ 
  packaging management system and can install any
  packages that the codebase depends on.
- You have installed the `virtualenv <https://pypi.org/project/virtualenv/>`__ pip module.

In the command line you must specify ``--language=python``. For example::
::

   codeql database create --language=python <output-folder>/python-database

This executes the ``database create`` subcommand from the code's checkout root,
generating a new Python database at ``<output-folder>/python-database``.

Ruby
~~~~

Creating databases for Ruby requires no additional dependencies. 
In the command line you must specify ``--language=ruby``. For example::

   codeql database create --language=ruby --source-root <folder-to-extract> <output-folder>/ruby-database

Here, we have specified a ``--source-root`` path, which is the location where
database creation is executed, but is not necessarily the checkout root of the
codebase. 

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
  
   For Go, install the Go toolchain (version 1.11 or later) and, if there
   are dependencies, the appropriate dependency manager (such as `dep
   <https://golang.github.io/dep/>`__).
   
   The Go autobuilder attempts to automatically detect code written in Go in a repository,
   and only runs build scripts in an attempt to fetch dependencies. To force
   CodeQL to limit extraction to the files compiled by your build script, set the environment variable
   `CODEQL_EXTRACTOR_GO_BUILD_TRACING=on` or use the ``--command`` option to specify a
   build command.

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

- C# project built using ``dotnet build``::

     For C# projects using either `dotnet build` or `msbuild`, you should specify `/p:UseSharedCompilation=false`
     in the build command. It is also a good idea to add `/t:rebuild` to ensure that all code will be built (code
     that is not built will not be included in the CodeQL database):

     codeql database create csharp-database --language=csharp --command='dotnet build /p:UseSharedCompilation=false /t:rebuild' 

- Go project built using the ``CODEQL_EXTRACTOR_GO_BUILD_TRACING=on`` environment variable::

   CODEQL_EXTRACTOR_GO_BUILD_TRACING=on codeql database create go-database --language=go

- Go project built using a custom build script::

   codeql database create go-database --language=go --command='./scripts/build.sh'

- Java project built using Gradle::

     codeql database create java-database --language=java --command='gradle clean test'

- Java project built using Maven::

     codeql database create java-database --language=java --command='mvn clean install'

- Java project built using Ant::

     codeql database create java-database --language=java --command='ant -f build.xml'

- Project built using Bazel::

     # Navigate to the Bazel workspace.

     # Before building, remove cached objects
     # and stop all running Bazel server processes.
     bazel clean --expunge

     # Build using the following Bazel flags, to help CodeQL detect the build:
     # `--spawn_strategy=local`: build locally, instead of using a distributed build
     # `--nouse_action_cache`: turn off build caching, which might prevent recompilation of source code
     # `--noremote_accept_cached`, `--noremote_upload_local_results`: avoid using a remote cache
     codeql database create new-database --language=<language> \
       --command='bazel build --spawn_strategy=local --nouse_action_cache --noremote_accept_cached --noremote_upload_local_results //path/to/package:target'

     # After building, stop all running Bazel server processes.
     # This ensures future build commands start in a clean Bazel server process
     # without CodeQL attached.
     bazel shutdown

- Project built using a custom build script::

     codeql database create new-database --language=<language> --command='./scripts/build.sh'
   
  This command runs a custom script that contains all of the commands required
  to build the project.

Using indirect build tracing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If the CodeQL CLI autobuilders for compiled languages do not work with your CI workflow and you cannot wrap invocations of build commands with ``codeql database trace-command``, you can use indirect build tracing to create a CodeQL database. To use indirect build tracing, your CI system must be able to set custom environment variables for each build action.

To create a CodeQL database with indirect build tracing, run the following command from the checkout root of your project:

::

  codeql database init ... --begin-tracing <database>

You must specify:

- ``<database>``: a path to the new database to be created. This directory will
  be created when you execute the command---you cannot specify an existing
  directory. 
- ``--begin-tracing``: creates scripts that can be used to set up an environment in which build commands will be traced.

You may specify other options for the ``codeql database init`` command as normal.

.. pull-quote:: Note

    If the build runs on Windows, you must set either ``--trace-process-level <number>`` or ``--trace-process-name <parent process name>`` so that the option points to a parent CI process that will observe all build steps for the code being analyzed.


The ``codeql database init`` command will output a message::

  Created skeleton <database>. This in-progress database is ready to be populated by an extractor.
  In order to initialise tracing, some environment variables need to be set in the shell your build will run in.
  A number of scripts to do this have been created in <database>/temp/tracingEnvironment.
  Please run one of these scripts before invoking your build command.

  Based on your operating system, we recommend you run: ...

The ``codeql database init`` command creates ``<database>/temp/tracingEnvironment`` with files that contain environment variables and values that will enable CodeQL to trace a sequence of build steps. These files are named ``start-tracing.{json,sh,bat,ps1}``. Use one of these files with your CI system's mechanism for setting environment variables for future steps. You can:

* Read the JSON file, process it, and print out environment variables in the format expected by your CI system. For example, Azure DevOps expects ``echo "##vso[task.setvariable variable=NAME]VALUE"``.
* Or, if your CI system persists the environment,  source the appropriate ``start-tracing`` script to set the CodeQL variables in the shell environment of the CI system.

Build your code; optionally, unset the environment variables using an ``end-tracing.{json,sh,bat,ps1}`` script from the directory where the ``start-tracing`` scripts are stored; and then run the command ``codeql database finalize <database>``.

Once you have created a CodeQL database using indirect build tracing, you can work with it like any other CodeQL database. For example, analyze the database, and upload the results to GitHub if you use code scanning.

Example of creating a CodeQL database using indirect build tracing
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following example shows how you could use indirect build tracing in an Azure DevOps pipeline to create a CodeQL database::

   steps:
       # Download the CodeQL CLI and query packs...
       # Check out the repository ...

       # Run any pre-build tasks, for example, restore NuGet dependencies...

       # Initialize the CodeQL database.
       # In this example, the CodeQL CLI has been downloaded and placed on the PATH.
       - task: CmdLine@1
          displayName: Initialize CodeQL database
         inputs:
             # Assumes the source code is checked out to the current working directory.
             # Creates a database at `<current working directory>/db`.
             # Running on Windows, so specifies a trace process level.
             script: "codeql database init --language csharp --trace-process-name Agent.Worker.exe --source-root . --begin-tracing db"

       # Read the generated environment variables and values,
       # and set them so they are available for subsequent commands
       # in the build pipeline. This is done in PowerShell in this example.
       - task: PowerShell@1
          displayName: Set CodeQL environment variables
          inputs:
             targetType: inline
             script: >
                $json = Get-Content $(System.DefaultWorkingDirectory)/db/temp/tracingEnvironment/start-tracing.json | ConvertFrom-Json
                $json.PSObject.Properties | ForEach-Object {
                    $template = "##vso[task.setvariable variable="
                    $template += $_.Name
                    $template += "]"
                    $template += $_.Value
                    echo "$template"
                }

       # Execute the pre-defined build step. Note the `msbuildArgs` variable.
       - task: VSBuild@1
           inputs:
             solution: '**/*.sln'
             # Disable MSBuild shared compilation for C# builds.
             msbuildArgs: /p:OutDir=$(Build.ArtifactStagingDirectory) /p:UseSharedCompilation=false
             platform: Any CPU
             configuration: Release
             # Execute a clean build, in order to remove any existing build artifacts prior to the build.
             clean: True
          displayName: Visual Studio Build

       # Read and set the generated environment variables to end build tracing. This is done in PowerShell in this example.
       - task: PowerShell@1
          displayName: Clear CodeQL environment variables
          inputs:
             targetType: inline
             script: >
                $json = Get-Content $(System.DefaultWorkingDirectory)/db/temp/tracingEnvironment/end-tracing.json | ConvertFrom-Json
                $json.PSObject.Properties | ForEach-Object {
                    $template = "##vso[task.setvariable variable="
                    $template += $_.Name
                    $template += "]"
                    $template += $_.Value
                    echo "$template"
                }

       - task: CmdLine@2
          displayName: Finalize CodeQL database
          inputs:
             script: 'codeql database finalize db'

       # Other tasks go here, for example:
       # `codeql database analyze`
       # then `codeql github upload-results` ...

Obtaining databases from LGTM.com
---------------------------------

`LGTM.com <https://lgtm.com>`__ analyzes thousands of open-source projects using
CodeQL. For each project on LGTM.com, you can download an archived CodeQL
database corresponding to the most recently analyzed revision of the code. These
databases can also be analyzed using the CodeQL CLI or used with the CodeQL
extension for Visual Studio Code. 

.. include:: ../reusables/download-lgtm-database.rst

Before running an analysis, unzip the databases and try :doc:`upgrading <upgrading-codeql-databases>` the
unzipped databases to ensure they are compatible with your local copy of the
CodeQL queries and libraries.
   
.. pull-quote::

   Note

   .. include:: ../reusables/index-files-note.rst


Further reading
---------------

- ":ref:`Analyzing your projects in CodeQL for VS Code <analyzing-your-projects>`"
