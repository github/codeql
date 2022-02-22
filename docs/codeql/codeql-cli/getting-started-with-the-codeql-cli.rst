.. _getting-started-with-the-codeql-cli:

Getting started with the CodeQL CLI
===================================

To run CodeQL commands, you need to set up the CLI so that it can access
the tools, queries, and libraries required to create and analyze databases.

.. include:: ../reusables/license-note.rst

.. _setting-up-cli:

Setting up the CodeQL CLI
-------------------------

The CodeQL CLI can be set up to support many different use cases and directory
structures. To get started quickly, we recommend adopting a relatively simple
setup, as outlined in the steps below.

If you use Linux, Windows, or macOS version 10.14 ("Mojave") or earlier, simply
follow the steps below. For macOS version 10.15 ("Catalina") or newer, steps 1
and 4 are slightly different---for further details, see the sections labeled
**Information for macOS "Catalina" (or newer) users**. If you are using macOS
on Apple Silicon (e.g. Apple M1), ensure that the `Xcode command-line developer
tools <https://developer.apple.com/downloads/index.action>`__ and `Rosetta 2
<https://support.apple.com/en-us/HT211861>`__ are installed. 

.. pull-quote:: Note

   The CodeQL CLI is currently not compatible with non-glibc Linux 
   distributions such as (muslc-based) Alpine Linux.

For information about installing the CodeQL CLI in a CI system to create results
to display in GitHub as code scanning alerts, see
`Installing CodeQL CLI in your CI system <https://docs.github.com/en/code-security/secure-coding/using-codeql-code-scanning-with-your-existing-ci-system/installing-codeql-cli-in-your-ci-system>`__
in the GitHub documentation.

.. _download-cli:

1. Download the CodeQL CLI zip package
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The CodeQL CLI download package is a zip archive containing tools, scripts, and
various CodeQL-specific files. If you don't have an Enterprise license then, by
downloading this archive, you are agreeing to the `GitHub CodeQL Terms and
Conditions <https://securitylab.github.com/tools/codeql/license>`__.

.. pull-quote:: Important

   There are several different versions of the CLI available to download, depending
   on your use case:

   - If you want to use the most up to date CodeQL tools and features, download the
     version tagged ``latest``.

   - If you want to create CodeQL databases to upload to LGTM Enterprise, download
     the version that is compatible with the relevant LGTM Enterprise version
     number. Compatibility information is included in the description for each
     release on the `CodeQL CLI releases page
     <https://github.com/github/codeql-cli-binaries/releases>`__ on GitHub. Using the
     correct version of the CLI ensures that your CodeQL databases are
     compatible with your version of LGTM Enterprise. For more information,
     see `Preparing CodeQL databases to upload to LGTM
     <https://help.semmle.com/lgtm-enterprise/admin/help/prepare-database-upload.html>`__
     in the LGTM admin help.

If you use Linux, Windows, or macOS version 10.14 ("Mojave") or earlier, simply
`download the zip archive
<https://github.com/github/codeql-cli-binaries/releases>`__
for the version you require.

If you want the CLI for a specific platform, download the appropriate ``codeql-PLATFORM.zip`` file.
Alternatively, you can download ``codeql.zip``, which contains the CLI for all supported platforms.

.. container:: toggle

   .. container:: name

      **Information for macOS "Catalina" (or newer) users**

   .. pull-quote:: macOS "Catalina" (or newer)

      If you use macOS version 10.15 ("Catalina"), version 11 ("Big Sur"), or the upcoming
      version 12 ("Monterey"), you need to ensure that your web browser does not automatically
      extract zip files. If you use Safari, complete the following steps before downloading
      the CodeQL CLI zip archive:

      i. Open Safari.
      ii. From the Safari menu, select **Preferences...**.
      iii. Click the **General** Tab.
      iv. Ensure the check-box labeled **Open "safe" files after downloading**.
          is unchecked.

2. Extract the zip archive
~~~~~~~~~~~~~~~~~~~~~~~~~~

For Linux, Windows, and macOS users (version 10.14 "Mojave", and earlier)
simply extract the zip archive.

.. container:: toggle

   .. container:: name

      **Information for macOS "Catalina" (or newer) users**

   .. pull-quote:: macOS "Catalina"

      macOS "Catalina", "Big Sur", or "Monterey" users should run the following
      commands in the Terminal, where ``${extraction-root}`` is the path to the
      directory where you will extract the CodeQL CLI zip archive:

      i. ``mv ~/Downloads/codeql*.zip ${extraction-root}``
      ii. ``cd ${extraction-root}``
      iii. ``/usr/bin/xattr -c codeql*.zip``
      iv. ``unzip codeql*.zip``

.. _launch-codeql-cli:

3. Launch ``codeql``
~~~~~~~~~~~~~~~~~~~~

Once extracted, you can run CodeQL processes by running the ``codeql``
executable in a couple of ways:

- By executing ``<extraction-root>/codeql/codeql``, where
  ``<extraction-root>`` is the folder where you extracted the CodeQL CLI
  package.
- By adding ``<extraction-root>/codeql`` to your ``PATH``, so that you
  can run the executable as just ``codeql``.

At this point, you can execute CodeQL commands. For a full list of the CodeQL
CLI commands, see the "`CodeQL CLI manual <../manual>`__."

.. pull-quote:: Note

   If you add ``codeql`` to your ``PATH``, it can be accessed by CodeQL
   for Visual Studio Code to compile and run queries.
   For more information about configuring VS Code to access the CodeQL CLI, see
   ":ref:`Setting up CodeQL in Visual Studio Code <setting-up-codeql-in-visual-studio-code>`."


4. Verify your CodeQL CLI setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CodeQL CLI has subcommands you can execute to verify that you are correctly set
up to create and analyze databases:

- Run ``codeql resolve languages`` to show which languages are
  available for database creation. This will list the languages supported by
  default in your CodeQL CLI package.
- (Optional) You can download some ":ref:`CodeQL packs <about-codeql-packs>`" containing pre-compiled queries you would like to run.
  To do this, run ``codeql pack download <pack-name> [...pack-name]``, where ``pack-name`` is the name of
  the pack you want to download. The core query packs are a good place to start. They are:

      - ``codeql/cpp-queries``
      - ``codeql/csharp-queries``
      - ``codeql/java-queries``
      - ``codeql/javascript-queries``
      - ``codeql/python-queries``
      - ``codeql/ruby-queries``

   Alternatively, you can download query packs during the analysis by using the ``--download`` flag of the ``codeql database analyze``
   command.


Checking out the CodeQL source code directly
--------------------------------------------

Some users prefer working with CodeQL query sources directly in order to work on or contribute to the Open Source shared queries. In
order to do this, the following steps are recommended. Note that the following instructions are a slightly more complicated alternative
to working with CodeQL packages as explained above.

1. Download the CodeQL CLI zip
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Follow :ref:`step 1 from the previous section<download-cli>`.

2. Create a new CodeQL directory
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Create a new directory where you can place the CLI and any queries and libraries
you want to use. For example, ``$HOME/codeql-home``.

The CLI's built-in search operations automatically look in all of its sibling
directories for the files used in database creation and analysis. Keeping these
components in their own directory prevents the CLI searching unrelated sibling
directories while ensuring all files are available without specifying any
further options on the command line.

.. _local-copy-codeql-queries:

3. Obtain a local copy of the CodeQL queries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The `CodeQL repository <https://github.com/github/codeql>`__ contains
the queries and libraries required for CodeQL analysis of C/C++, C#, Java,
JavaScript/TypeScript, Python, and Ruby.
Clone a copy of this repository into ``codeql-home``.

By default, the root of the cloned repository will be called ``codeql``.
Rename this folder ``codeql-repo`` to avoid conflicting with the CodeQL
CLI that you will extract in step 4. If you use git on the command line, you can
clone and rename the repository in a single step by running
``git clone git@github.com:github/codeql.git codeql-repo`` in the ``codeql-home`` folder.

The CodeQL libraries and queries for Go analysis live in the `CodeQL for Go
repository <https://github.com/github/codeql-go/>`__. Clone a copy of this
repository into ``codeql-home``, and run ``codeql-go/scripts/install-deps.sh``
to install its dependencies.

The cloned repositories should have a sibling relationship.
For example, if the root of the cloned CodeQL repository is
``$HOME/codeql-home/codeql-repo``, then the root of the cloned CodeQL for Go
repository should be ``$HOME/codeql-home/codeql-go``.

Within these repositories, the queries and libraries are organized into QL
packs. Along with the queries themselves, QL packs contain important metadata
that tells the CodeQL CLI how to process the query files. For more information,
see ":doc:`About QL packs <about-ql-packs>`."

.. pull-quote:: Important

   There are different versions of the CodeQL queries available for different
   users. Check out the correct version for your use case:

   - For the queries used on `LGTM.com <https://lgtm.com>`__, check out the
     ``lgtm.com`` branch. You should use this branch for databases you've built
     using the CodeQL CLI, fetched from code scanning on GitHub, or recently downloaded from LGTM.com.
     The queries on the ``lgtm.com`` branch are more likely to be compatible
     with the ``latest`` CLI, so you'll be less likely to have to upgrade
     newly-created databases than if you use the ``main`` branch. Older databases
     may need to be upgraded before you can analyze them.

   - For the most up to date CodeQL queries, check out the ``main`` branch.
     This branch represents the very latest version of CodeQL's analysis. Even
     databases created using the most recent version of the CLI may have to be
     upgraded before you can analyze them. For more information, see
     ":doc:`Upgrading CodeQL databases <upgrading-codeql-databases>`."

   - For the queries used in a particular LGTM Enterprise release, check out the
     branch tagged with the relevant release number. For example, the branch
     tagged ``v1.27.0`` corresponds to LGTM Enterprise 1.27. You must use this
     version if you want to upload data to LGTM Enterprise. For further
     information, see `Preparing CodeQL databases to upload to LGTM
     <https://help.semmle.com/lgtm-enterprise/admin/help/prepare-database-upload.html>`__
     in the LGTM admin help.

4. Extract the zip archive
~~~~~~~~~~~~~~~~~~~~~~~~~~

For Linux, Windows, and macOS users (version 10.14 "Mojave", and earlier)
simply
extract the zip archive into the directory you created in step 2.

For example, if the path to your copy of the CodeQL repository is
``$HOME/codeql-home/codeql-repo``, then extract the CLI into
``$HOME/codeql-home/``.


5. Launch ``codeql``
~~~~~~~~~~~~~~~~~~~~

See :ref:`step 3 from the previous section<launch-codeql-cli>`.

6. Verify your CodeQL CLI setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CodeQL CLI has subcommands you can execute to verify that you are correctly set
up to create and analyze databases:

- Run ``codeql resolve languages`` to show which languages are
  available for database creation. This will list the languages supported by
  default in your CodeQL CLI package.
- Run ``codeql resolve qlpacks`` to show which QL packs the CLI can find. This
  will display the names of all the QL packs directly available to the CodeQL CLI.
  This should include:

  - Query packs for each supported language, for example, ``codeql/{language}-queries``.
    These packs contain the standard queries that will be run for each analysis.
  - Library packs for each supported language, for example,  ``codeql/{language}-all``. These
    packs contain query libraries, such as control flow and data flow libraries, that
    may be useful to query writers.
  - Example packs for each supported language, for example, ``codeql/{language}-examples``.
    These packs contain useful snippets of CodeQL that query writers may find useful.
  - Legacy packs that ensure custom queries and libraries created using older products are
    compatible with your version of CodeQL.

.. _using-two-versions-of-the-codeql-cli:

Using two versions of the CodeQL CLI
------------------------------------

If you want to use the latest CodeQL features to execute queries or CodeQL tests,
but also want to prepare databases that are compatible with a specific version of
LGTM Enterprise, you may need to install two versions of the CLI. The
recommended directory setup depends on which versions you want to install:

- If both versions are 2.0.2 (or newer), you can unpack both CLI archives in the
  same parent directory.

- If at least one of the versions is 2.0.1 (or older), the unpacked CLI archives cannot
  be in the same parent directory, but they can share the same grandparent
  directory. For example, if you unpack version 2.0.2 into
  ``$HOME/codeql-home/codeql-cli``, the older version should be
  unpacked into ``$HOME/codeql-older-version/old-codeql-cli``. Here, the common
  grandparent is the ``$HOME`` directory.
