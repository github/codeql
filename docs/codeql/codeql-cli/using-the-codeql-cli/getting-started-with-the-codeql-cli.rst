.. _getting-started-with-the-codeql-cli:

Getting started with the CodeQL CLI
===================================

To run CodeQL commands, you need to set up the CLI so that it can access
the tools, queries, and libraries required to create and analyze databases. 

.. include:: ../../reusables/license-note.rst

.. _setting-up-cli:

Setting up the CodeQL CLI
-------------------------

The CodeQL CLI can be set up to support many different use cases and directory
structures. To get started quickly, we recommend adopting a relatively simple
setup, as outlined in the steps below.

If you use Linux, Windows, or macOS version 10.14 ("Mojave") or earlier, simply
follow the steps below. For macOS version 10.15 ("Catalina"), steps 1 and 4 are
slightly different---for further details, see the sections labeled **Information
for macOS "Catalina" users**.

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

      **Information for macOS "Catalina" users**

   .. pull-quote:: macOS "Catalina"
      
      If you use macOS version 10.15 ("Catalina"), you need to ensure that your web
      browser does not automatically extract zip files. If you use Safari,
      complete the following steps before downloading the CodeQL CLI zip archive:
          
      i. Open Safari.
      ii. From the Safari menu, select **Preferences...**.
      iii. Click the **General** Tab.
      iv. Ensure the check-box labeled **Open "safe" files after downloading**.
          is unchecked.

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
JavaScript/TypeScript, and Python.
Clone a copy of this repository into ``codeql-home``. 
 
By default, the root of the cloned repository will be called ``codeql``. 
Rename this folder ``codeql-repo`` to avoid conflicting with the CodeQL 
CLI that you will extract in step 4. If you use git on the command line, you can 
clone and rename the repository in a single step by running 
``git clone git@github.com:github/codeql.git codeql-repo`` in the ``codeql-home`` folder.

The CodeQL libraries and queries for Go analysis live in the `CodeQL for Go
repository <https://github.com/github/codeql-go/>`__. Clone a copy of this
repository into ``codeql-home``. 

The cloned repositories should have a sibling relationship. 
For example, if the root of the cloned CodeQL repository is
``$HOME/codeql-home/codeql-repo``, then the root of the cloned CodeQL for Go
repository should be ``$HOME/codeql-home/codeql-go``.

Within these repositories, the queries and libraries are organized into QL
packs. Along with the queries themselves, QL packs contain important metadata
that tells the CodeQL CLI how to process the query files. For more information,
see ":doc:`About QL packs <../codeql-cli-reference/about-ql-packs>`."

.. pull-quote:: Important

   There are different versions of the CodeQL queries available for different
   users. Check out the correct version for your use case:
   
   - For the most up to date CodeQL queries, check out the ``main`` branch. 
     This branch represents the very latest version of CodeQL's analysis. Even
     databases created using the most recent version of the CLI may have to be
     upgraded before you can analyze them. For more information, see
     ":doc:`Upgrading CodeQL databases <upgrading-codeql-databases>`."
    
   - For the queries used on `LGTM.com <https://lgtm.com>`__, check out the
     ``lgtm.com`` branch. You can run these queries on databases you've recently
     downloaded from LGTM.com. Older databases may need to be upgraded before
     you can analyze them. The queries on the ``lgtm.com`` branch are also more
     likely to be compatible with the ``latest`` CLI, so you'll be less likely
     to have to upgrade newly-created databases than if you use the ``main``
     branch.
           
   - For the queries used in a particular LGTM Enterprise release, check out the
     branch tagged with the relevant release number. For example, the branch
     tagged ``v1.23.0`` corresponds to LGTM Enterprise 1.23. You must use this
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

.. container:: toggle

   .. container:: name

      **Information for macOS "Catalina" users**

   .. pull-quote:: macOS "Catalina"
   
      macOS "Catalina" users should run the following commands in the Terminal,
      where ``${install_loc}`` is the path to the directory you created in step 2:
   
      i. ``mv ~/Downloads/codeql*.zip ${install_loc}``
      ii. ``cd ${install_loc}``
      iii. ``xattr -c codeql*.zip``
      iv. ``unzip codeql*.zip``
   
5. Launch ``codeql``
~~~~~~~~~~~~~~~~~~~~

Once extracted, you can run CodeQL processes by running the ``codeql``
executable in a couple of ways:

- By executing ``<extraction-root>/codeql/codeql``, where
  ``<extraction-root>`` is the folder where you extracted the CodeQL CLI
  package.
- By adding ``<extraction-root>/codeql`` to your ``PATH``, so that you
  can run the executable as just ``codeql``. 

At this point, you can execute CodeQL commands. For a full list of the CodeQL
CLI commands, see the "`CodeQL CLI manual <../../codeql-cli-manual>`__."

.. pull-quote:: Note

   If you add ``codeql`` to your ``PATH``, it can be accessed by CodeQL
   for Visual Studio Code to compile and run queries.
   For more information about configuring VS Code to access the CodeQL CLI, see
   ":ref:`Setting up CodeQL in Visual Studio Code <setting-up-codeql-in-visual-studio-code>`."


6. Verify your CodeQL CLI setup
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CodeQL CLI has subcommands you can execute to verify that you are correctly set
up to create and analyze databases:

- Run ``codeql resolve languages`` to show which languages are
  available for database creation. This will list the languages supported by
  default in your CodeQL CLI package. 
- Run ``codeql resolve qlpacks`` to show which QL packs the CLI can find. This
  will display the names of the QL packs included in the CodeQL repositories:
  ``codeql-cpp``, ``codeql-csharp``, ``codeql-go``,
  ``codeql-java``, ``codeql-javascript``, and ``codeql-python``. The CodeQL
  repositories also contain 'upgrade' packs and 'legacy' packs. Upgrade packs
  are used by the CLI when you want to upgrade a database so that it can be
  analyzed with a newer version of the CodeQL toolchain than was used to create
  it. Legacy packs ensure that custom queries and libraries created using older
  products are compatible with your version of CodeQL.


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
