:tocdepth: 1

.. _using-the-codeql-model-editor:

Using the CodeQL model editor
=============================

.. include:: ../reusables/beta-note-model-pack-editor-vsc.rst

You can view, write, and edit all types of CodeQL packs in Visual Studio Code using the CodeQL extension. 

TODO - EDIT THIS CONTENT!

Explain how to find the data extension files that you've created and test them. Also how to save to the right location in a GitHub repository for default and advanced setup to use.

Copy file into GitHub folder

For testing:     "codeQL.runningQueries.useModelPacks": true, - does it work for MRVA

About the CodeQL model editor
-----------------------------

The CodeQL model editor guides you through the process of creating CodeQL models for libraries and frameworks that you rely on that are not supported by the standard CodeQL Libraries.

The editor takes a CodeQL database and runs some telemetry queries to identify uses of APIs that can be used to reason about the dataflow through the codebase. There are two modes of operation:

- Application mode: the editor identifies the external APIs used by the codebase. An external (or third party) API is any API that is not part of the CodeQL database you are analyzing. This mode is most useful for improving CodeQL results for the specific codebase.
- Framework mode: the editor identifies the publicly accessible APIs in the codebase. This mode is most useful for improving the CodeQL results for any codebases that use those APIs.

Using the CodeQL model editor
-----------------------------

The easiest way to explain this is by using an example, so we'll run through an example. This is the same example as used in the demo.

#. Open your CodeQL workspace in VS Code, e.g., the vscode-codeql-starter workspace 
#. Open the CodeQL extension and add the CodeQL database for dsp-testing/sql2o-example from GitHub
#. Use the command palette to run the “CodeQL: Open Model Editor (Beta)” command
#. The CodeQL model editor will open and run some telemetry queries to identify APIs in the code
#. When the queries are complete, the APIs that have been identified are shown in the editor:
   - By default the editor runs in application mode, so displays the external APIs used by the codebase. 
   - If you switch to framework mode, the editor will display the publicly accessible APIs in the codebase.

#. You can now start modeling the external API calls manually by selecting a model type and entering the correct values in each field, as defined in the Java models-as-data documentation
#. You can generate the CodeQL automatically:
   - If you are working in application mode click on “Model from source” and enter the name of the repo that contains the source code for the package you want to model. For example, in this case you can enter dsp-testing/sql2o-import to download the relevant CodeQL database and model any APIs from that repo
   - If you are working in framework mode click on “Generate” to generate any models directly from the source code of the framework you are modeling.

#. Once any modeling is complete, click “Save” or  “Save all”. You can now see that the calls are shown as supported. The generated models files are saved in your workspace at .github/codeql/extensions/<pack-name>, where the pack name is the same as the repo.
   - If you are in application mode, the editor will create a separate model file for each package that you model.
   - If you are in framework mode, the edit will generate a single model file for the entire framework.

#. If you have set up VS Code to use data extensions (using the “codeQL.runningQueries.useExtensionPacks” setting), then you can also run a query and see that the unsafe calls are now detected.

Known limitations
-----------------

Only Java is supported
It's not possible to place the extension pack in a different directory than the root of a workspace folder

How to use data extensions in CodeQL for VS Code
When a query is run in CodeQL for VS Code, by default, the IDE will load data extensions for the given pack and its transitive dependencies as defined in the How to use Data Extensions in the CodeQL CLI section.

To include extension packs in a VS Code workspace, there is a new setting called codeQL.runningQueries.useExtensionPacks. By default, this value is "none", which means that extension packs are not loaded for query evaluations. The other option is "all", which means that before running a query, the IDE will locate all extension packs in the workspace and load them during evaluation.

In the future, we may define other options to selectively load a subset of extension packs.

To use this option, simply set codeQL.runningQueries.useExtensionPacks to "all" and run queries as before. This option applies both to locally run queries and to variant analysis queries run remotely.

For more information on the engineering and product decisions around extension packs in the VS Code extension, see Customization support in the CodeQL VS Code extension.

