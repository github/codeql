:tocdepth: 1

.. _troubleshooting-variant-analysis:

Troubleshooting variant analysis
================================

.. include:: ../reusables/vs-code-deprecation-note.rst

.. include:: ../reusables/beta-note-mrva.rst

This article explains how to debug problems with variant analysis, that is, analysis run using GitHub Actions
and not locally on your machine.
For information on troubleshooting local analysis, see
":ref:`Troubleshooting CodeQL for Visual Studio Code <troubleshooting-codeql-for-visual-studio-code>`."

When you run variant analysis, there are two key places where errors and warnings are displayed:

#. **Visual Studio Code errors** - any problems with creating a CodeQL pack and sending the analysis to GitHub.com are reported as Visual Studio Code errors in the bottom right corner of the application. The problem information is also available in the **Problems** view.
#. **Variant Analysis Results** - any problems with the variant analysis run are reported in this view.

Variant analysis warning: Problem with controller repository
------------------------------------------------------------

If there are problems with the variant analysis run, you will see a warning banner at the top of the Variant Analysis Results tab. For example:

.. image:: ../images/codeql-for-visual-studio-code/variant-analysis-results-warning.png
    :width: 600
    :alt: Screenshot of the "Variant Analysis Results" view showing a warning banner with the text "warning: Problem with controller repository" and "Publicly visible controller repository can't be used to analyze private repositories. 1 private repository was not analyzed." The "View logs" button is highlighted with a dark orange outline.

In this example, the user ran variant analysis on a custom list of two repositories. One of the repositories was a private repository and could not be analyzed because they had a public controller repository. Only the public repository was analyzed. To analyze both repositories, this user needs to edit their settings and update the controller repository to a private repository. For information on how to edit the controller repository, see ":ref:`Customizing settings <customizing-settings>`."

