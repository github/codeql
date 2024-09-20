:tocdepth: 1

.. _customizing-settings:

Customizing settings
====================

.. include:: ../reusables/vs-code-deprecation-note.rst

You can edit the settings for the CodeQL extension to suit your needs.

About CodeQL extension settings
---------------------------------

The CodeQL extension comes with a number of settings that you can edit. These determine how the extension behaves, including: which version of the CodeQL CLI the extension uses, how the extension displays previous queries, and how it runs queries.

Editing settings
-----------------

1. Open the Extensions view and right click **CodeQL**.

2. Click **Extension Settings**.

   .. image:: ../images/codeql-for-visual-studio-code/open-extension-settings.png
      :width: 400
      :alt: Open the CodeQL extension settings

3. Edit a setting. The new settings are saved automatically.

Alternatively, you can edit the settings in JSON format by opening the command palette and selecting **Preferences: Open User Settings (JSON)**.

Choosing a version of the CodeQL CLI
--------------------------------------

The CodeQL extension uses the CodeQL CLI to run commands. If you already have the CLI installed and added to your ``PATH``, the extension uses that version. This might be the case if you create your own CodeQL databases instead of downloading them from GitHub.com. Otherwise, the extension automatically manages access to the executable of the CLI for you. For more information about creating databases, see "`Creating CodeQL databases <https://docs.github.com/en/code-security/codeql-cli/using-the-codeql-cli/creating-codeql-databases>`__" in the CLI help.

To override the default behavior and use a different CLI, you can specify the CodeQL CLI **Executable Path**.

Changing the labels of query history items
--------------------------------------------

The query history **Format** setting controls how the extension lists queries in the query history. By default, each item has a label with the following format::
    
    %q on %d - %s %r [%t]

- ``%q`` is the query name
- ``%d`` is the database name
- ``%s`` is a status string
- ``%r`` is the number of results
- ``%t`` is the time the query was run

To override the default label, you can specify a different format for the query history items.


Changing the retention period for query history items
-----------------------------------------------------

By default, items in the query history view are retained for 30 days. You can set a different time to live (TTL) by changing the "Code QL > Query History: TTL" setting. To retain items indefinitely, set the value to 0.

.. _configuring-settings-for-running-queries:

Configuring settings for running queries locally
------------------------------------------------

There are a number of settings for **Running Queries**. If your queries run too slowly and time out frequently, you may want to increase the memory. 

.. include:: ../reusables/running-queries-debug.rst

To save query server logs in a custom location, edit the **Running Queries: Custom Log Directory** setting. If you use a custom log directory, the extension saves the logs permanently, instead of deleting them automatically after each workspace session. This is useful if you want to investigate these logs to improve the performance of your queries.

Configuring settings for variant analysis
------------------------------------------

You can define or edit lists of GitHub repositories for variant analysis, and change to a different controller repository using the **Variant analysis** settings.

For information on the purpose and requirements for a controller repository, see ":ref:`Setting up a controller repository for variant analysis <controller-repository>`."

You can also edit the items shown in the Variant Analysis Repositories panel by editing a file in your Visual Studio Code workspace called ``databases.json``. This file contains a JSON representation of all the items displayed in the panel. To open your ``databases.json`` file in an editor window, click the **{ }** icon in the top right of the Variant Analysis Repositories panel. You can then see a structured representation of the repos, orgs and lists in your panel. For example:

.. code-block:: json

  {
    "version": 1,
    "databases": {
      "variantAnalysis": {
        "repositoryLists": [
          {
            "name": "My favorite JavaScript repos",
            "repositories": [
              "facebook/react",
              "babel/babel",
              "angular/angular"
            ]
          }
        ],
        "owners": [
          "microsoft"
        ],
        "repositories": [
          "apache/hadoop"
        ]
      }
    },
    "selected": {
      "kind": "variantAnalysisSystemDefinedList",
      "listName": "top_10"
    }
  }

You can change the items shown in the panel or add new items by directly editing this file.

Configuring settings for adding databases
------------------------------------------------

To automatically add database source folders to your workspace, you can enable the **Adding Databases > Add Database Source to Workspace** setting.

This setting is disabled by default. You may want to enable the setting if you regularly browse the source code of databases, for example to view the abstract syntax tree of the code. For more information, see ":ref:`Exploring the structure of your source code <exploring-the-structure-of-your-source-code>`."

.. pull-quote:: Note

   If you are in a single-folder workspace, adding database source folders will cause the workspace to reload as a multi-root workspace. This may cause query history and database lists to be reset.

   Before enabling this setting, we recommend that you save your workspace as a multi-root workspace. For more information, see "`Multi-root Workspaces <https://code.visualstudio.com/docs/editor/multi-root-workspaces>`__" in the Visual Studio Code help.

Configuring settings for testing queries locally
------------------------------------------------

To increase the number of threads used for testing queries, you can update the **Running Tests > Number Of Threads** setting.

To pass additional arguments to the CodeQL CLI when running tests, you can update the **Running Tests > Additional Test Arguments** setting. For more information about the available arguments, see `test run <https://docs.github.com/en/code-security/codeql-cli/codeql-cli-manual/test-run/>`_ in the documentation for CodeQL CLI. 

Configuring settings for telemetry and data collection
--------------------------------------------------------

You can configure whether the CodeQL extension collects telemetry data. This is disabled by default. For more information, see ":doc:`About telemetry in CodeQL for Visual Studio Code <about-telemetry-in-codeql-for-visual-studio-code>`."

Further reading
----------------

- `User and workspace settings <https://code.visualstudio.com/docs/getstarted/settings>`__ in the Visual Studio Code help
- "`CodeQL CLI <https://docs.github.com/en/code-security/codeql-cli>`__"