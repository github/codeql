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

For information about installing the CodeQL CLI in a CI system to create results
to display in GitHub as code scanning alerts, see
`Installing CodeQL CLI in your CI system <https://docs.github.com/en/code-security/secure-coding/using-codeql-code-scanning-with-your-existing-ci-system/installing-codeql-cli-in-your-ci-system>`__
in the GitHub documentation.

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
- (Optional) You can download some ":ref"`CodeQL packs <about-codeql-packs>` containing pre-compiled queries you would like to run.
  To do this, run ``codeql pack download <pack-name> [...pack-name]``, where ``pack-name`` is the name of
  the pack you want to download. The core query packs are a good place to start. They are:

      - ``codeql/cpp-queries``
      - ``codeql/csharp-queries``
      - ``codeql/java-queries``
      - ``codeql/javascript-queries``
      - ``codeql/python-queries``
      - ``codeql/ruby-queries``

   Alternatively, you can download query packs during the analysis by using the `--download` flag of the `codeql database analyze`
   command.

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
