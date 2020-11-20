.. _setting-up-codeql-in-visual-studio-code:

Setting up CodeQL in Visual Studio Code
=================================================

You can install and configure the CodeQL extension in Visual Studio Code.

.. include:: ../reusables/license-note.rst

Prerequisites
-----------------

The CodeQL extension requires a minimum of Visual Studio Code 1.39. Older versions are not supported.

Installing the extension
------------------------

You can install the CodeQL extension using any of the normal methods for installing a VS Code extension:

* Go to the `Visual Studio Code Marketplace <https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-codeql>`__ in your browser and click **Install**.
* In the Extensions view (**Ctrl+Shift+X** or **Cmd+Shift+X**), search for ``CodeQL``, then select **Install**.
* Download the `CodeQL VSIX file <https://github.com/github/vscode-codeql/releases>`__. Then, in the Extensions view, click **More actions** > **Install from VSIX**, and select the CodeQL VSIX file.

Configuring access to the CodeQL CLI
------------------------------------

The extension uses the CodeQL CLI to compile and run queries.

If you already have the CLI installed and added to your ``PATH``, the extension uses that version. This might be the case if you create your own CodeQL databases instead of downloading them from LGTM.com. For more information, see ":ref:`CodeQL CLI <codeql-cli>`."

Otherwise, the extension automatically manages access to the executable of the CLI for you. This ensures that the CLI is compatible with the CodeQL extension. You can also check for updates with the **CodeQL: Check for CLI Updates** command.

.. pull-quote:: Note

   The extension-managed CLI is not accessible from the terminal.
   If you intend to use the CLI outside of the extension (for example to create databases), we recommend that you install your own copy of the CLI.
   To avoid having two copies of the CLI on your machine, you can point the CodeQL CLI **Executable Path** setting to your existing copy of the CLI.

If you want the extension to use a specific version of the CLI, set the CodeQL CLI **Executable Path** to the location of the executable file for the CLI.
That is, the file named ``codeql`` (Linux/Mac) or ``codeql.exe`` (Windows). For more information, see ":ref:`Customizing settings <customizing-settings>`."

If you have any difficulty setting up access to the CodeQL CLI, check the CodeQL Extension Log for error messages. For more information, see ":doc:`Troubleshooting CodeQL for Visual Studio Code <troubleshooting-codeql-for-visual-studio-code>`."

Setting up a CodeQL workspace
-----------------------------

When you're working with CodeQL, you need access to the standard CodeQL libraries. This also makes a wide variety of queries available to explore.

There are two ways to do this:

* Recommended, use the "starter" workspace. This is maintained as a Git repository which makes it easy to keep up to date with changes to the libraries. For more information, see ":ref:`Using the starter workspace <starter-workspace>`" below.
* More advanced, add the CodeQL libraries and queries to an existing workspace. For more information, see ":ref:`Updating an existing workspace for CodeQL <existing-workspace>`" below.

.. pull-quote:: Note
   
   For CLI users there is a third option: If you have followed the instructions in ":ref:`Getting started with the CodeQL CLI <getting-started-with-the-codeql-cli>`" to create a CodeQL directory (for example ``codeql-home``) containing the CodeQL libraries, you can open this directory in VS Code. This also gives the extension access to the CodeQL libraries.

.. container:: toggle

   .. container:: name

      **Click to show information for LGTM Enterprise users**

   Your local version of the CodeQL queries and libraries should match your version of LGTM Enterprise. For example, if you
   use LGTM Enterprise 1.23, then you should clone the ``1.23.0`` branch of the `starter workspace <https://github.com/github/vscode-codeql-starter/>`__ (or the appropriate ``1.23.x`` branch, corresponding to each maintenance release).
   
   This ensures that the queries and libraries you write in VS Code also work in the query console on LGTM Enterprise.

   If you prefer to add the CodeQL queries and libraries to an :ref:`existing workspace <existing-workspace>` instead of the starter workspace, then you should
   clone the appropriate branch of the `general CodeQL repository <https://github.com/github/codeql>`__ and the 
   `CodeQL repository for Go <https://github.com/github/codeql-go>`__ and add them to your workspace.

.. _starter-workspace:

Using the starter workspace
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
The starter workspace is a Git repository. It contains:

* The `repository of CodeQL libraries and queries <https://github.com/github/codeql>`__ for C/C++, C#, Java, JavaScript, and Python. This is included as a submodule, so it can be updated without affecting your custom queries.
* The `repository of CodeQL libraries and queries <https://github.com/github/codeql-go>`__ for Go. This is also included as a submodule.
* A series of folders named ``codeql-custom-queries-<ql-language-specification>``. These are ready for you to start developing your own custom queries for each language, using the standard libraries. There are some example queries to get you started.

To use the starter workspace:

#. Clone the https://github.com/github/vscode-codeql-starter/ repository to your computer:
    * Make sure you include the submodules, either by using ``git clone --recursive``, or using by ``git submodule update --init --remote`` after cloning.
    * Use ``git submodule update --remote`` regularly to keep the submodules up to date.

#. In VS Code, use the **File** > **Open Workspace** option to open the ``vscode-codeql-starter.code-workspace`` file from your checkout of the workspace repository.

.. _existing-workspace:

Updating an existing workspace for CodeQL
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
You can add the CodeQL libraries to an existing workspace by making a local clone of the CodeQL repository directly: https://github.com/github/codeql. 

To make the standard libraries available in your workspace:

#. Select **File** > **Add Folder to Workspace**, and choose your local checkout of the ``github/codeql`` repository.

#. Create one new folder per target language, using either the **New Folder** or **Add Folder to Workspace** options, to hold custom queries and libraries.

#. Create a ``qlpack.yml`` file in each target language folder. This tells the CodeQL CLI the target language for that folder and what its dependencies are. (The ``main`` branch of ``github/codeql`` already has these files.) CodeQL will look for the dependencies in all the open workspace folders, or on the user's search path.

For example, to make a custom CodeQL folder called ``my-custom-cpp-pack`` depend on the CodeQL standard library for C++, create a ``qlpack.yml`` file with the following contents:

.. code-block:: yaml

    name: my-custom-cpp-pack
    version: 0.0.0
    libraryPathDependencies: codeql-cpp

For more information about why you need to add a ``qlpack.yml`` file, see ":ref:`About QL packs <about-ql-packs>`."

.. pull-quote:: Note

   The CodeQL libraries for Go are not included in the ``github/codeql`` repository, but are stored separately. To analyze Go projects, clone the repository at https://github.com/github/codeql-go and add it to your workspace as above.

Further reading
----------------

* ":doc:`Analyzing your projects <analyzing-your-projects>`"
* ":ref:`CodeQL CLI <codeql-cli>`"
