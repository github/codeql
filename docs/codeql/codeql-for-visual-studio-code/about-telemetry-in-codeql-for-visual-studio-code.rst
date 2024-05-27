:tocdepth: 1

.. _about-telemetry-in-codeql-for-visual-studio-code:

About telemetry in CodeQL for Visual Studio Code
=================================================

.. include:: ../reusables/vs-code-deprecation-note.rst

If you specifically opt in to permit GitHub to do so, GitHub will collect usage data and metrics for the purposes of helping the core developers to improve the CodeQL extension for VS Code.

This data will not be shared with any parties outside of GitHub. IP addresses and installation IDs will be retained for a maximum of 30 days. Anonymous data will be retained for a maximum of 180 days.

Why we collect data
--------------------------------------

GitHub collects aggregated, anonymous usage data and metrics to help us improve CodeQL for VS Code. IP addresses and installation IDs are collected only to ensure that anonymous data is not duplicated during aggregation.

What data is collected
--------------------------------------

If you opt in, GitHub collects the following information related to the usage of the extension. The data collected are:

- The identifiers of any CodeQL-related VS Code commands that are run.
    - For each command: the timestamp, time taken, and whether or not the command completed successfully.
- Interactions with UI elements, including buttons, links, and other inputs.
    - Link targets and text inputs are not recorded.
    - Mouse movement and hovering are not recorded.
- Occurrence of exceptions and errors.
    - All sensitive information such as file paths and non-static exception message content are removed before uploading.
- VS Code and extension version.
- Randomly generated GUID that uniquely identifies a CodeQL extension installation. (Discarded before aggregation.)
- IP address of the client sending the telemetry data. (Discarded before aggregation.)
- Whether or not the ``codeQL.canary`` setting is enabled and set to ``true``.
- Whether any :doc:`CodeQL extension settings <customizing-settings>` are configured.

How long data is retained
--------------------------

IP address and GUIDs will be retained for a maximum of 30 days. Anonymous, aggregated data that includes command identifiers, run times, and timestamps will be retained for a maximum of 180 days.

Access to the data
-------------------

IP address and GUIDs will only be available to the core developers of CodeQL. Aggregated data will be available to GitHub employees.

What data is **NOT** collected
--------------------------------

We only collect the minimal amount of data we need to answer the questions about how our users are experiencing this product. To that end, we do not collect the following information:

- No GitHub user ID
- No CodeQL database names or contents
- No contents of CodeQL queries
- No filesystem paths
- No user-input text
- No mouse interactions, such as movement or hovers

Disabling telemetry reporting
------------------------------

Telemetry collection is *disabled* by default.

When telemetry collection is disabled, no data will be sent to GitHub servers.

You can disable telemetry collection by setting ``codeQL.telemetry.enableTelemetry`` to ``false`` in your settings. For more information about CodeQL settings, see ":doc:`Customizing settings <customizing-settings>`." 

Additionally, telemetry collection will be disabled if the global ``telemetry.telemetryLevel`` setting is set to ``off``. For more information about global telemetry collection, see "`Microsoft's documentation <https://code.visualstudio.com/docs/supporting/faq#_how-to-disable-telemetry-reporting>`__."

Further reading
----------------

For more information, see GitHub's "`Privacy Statement <https://docs.github.com/github/site-policy/github-privacy-statement>`__" and "`Terms of Service <https://docs.github.com/github/site-policy/github-terms-of-service>`__."
