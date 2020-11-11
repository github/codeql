.. _customizing-settings:

Customizing settings
====================

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

Choosing a version of the CodeQL CLI
--------------------------------------

The CodeQL extension uses the CodeQL CLI to run commands. If you already have the CLI installed and added to your ``PATH``, the extension uses that version. This might be the case if you create your own CodeQL databases instead of downloading them from LGTM.com. Otherwise, the extension automatically manages access to the executable of the CLI for you. For more information about creating databases, see ":ref:`Creating CodeQL databases <creating-codeql-databases>`" in the CLI help.

To override the default behavior and use a different CLI, you can specify the CodeQL CLI **Executable Path**. Note that this is only available as a user setting, not as a workspace setting.

Changing the labels of query history items
--------------------------------------------

The query history **Format** setting controls how the extension lists queries in the query history. By default, each item has a label with the following format::
    
    [%t] %q on %d - %s
  
- ``%t`` is the time the query was run
- ``%q`` is the query name
- ``%d`` is the database name
- ``%s`` is a status string

To override the default label, you can specify a different format for the query history items.

Configuring settings for running queries
-----------------------------------------

There are a number of settings for **Running Queries**. If your queries run too slowly and time out frequently, you may want to increase the memory. 

.. include:: ../reusables/running-queries-debug.rst

Configuring settings for testing queries
-----------------------------------------

To increase the number of threads used for testing queries, you can update the **Running Tests > Number Of Threads** setting.

Further reading
----------------

- `User and workspace settings <https://code.visualstudio.com/docs/getstarted/settings>`__ in the Visual Studio Code help
- ":ref:`CodeQL CLI <codeql-cli>`"