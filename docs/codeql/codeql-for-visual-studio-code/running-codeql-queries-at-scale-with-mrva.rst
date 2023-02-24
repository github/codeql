:tocdepth: 1

.. _running-codeql-queries-at-scale-with-mrva:

Running CodeQL queries at scale with multi-repository variant analysis
======================================================================

.. include:: ../reusables/beta-note-mrva.rst

About multi-repository variant analysis
---------------------------------------

When you write a query to find variants of a security vulnerability and finish testing it locally, the next step is to run it on a large group of repositories. Multi-repository variant analysis (variant analysis) makes it easy run a query on up to 1000 repositories without leaving Visual Studio Code.

The core functionality of the CodeQL extension helps you write queries and run them locally against a CodeQL database. In contrast, variant analysis allows you to send your CodeQL query to GitHub.com to be tested against a list of repositories.

.. _controller-repository:

About the controller repository
-------------------------------

When you run variant analysis, the analysis is run entirely using dynamic workflows for GitHub Actions. You don't need to create any workflows, but you must specify which GitHub repository the CodeQL extension should use as the "controller repository."

Functions of the controller repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- **Workflow management:** the workflow runs that are triggered when you run variant analysis are shown on the **Actions** tab for the repository in much the same as other workflow runs.
- **Billing:** when you analyze private repositories, the actions minutes used by CodeQL analysis are billed to the owner of the controller repository.

Requirements of the controller repository
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

- The repository must have at least one commit. 
- The ``GITHUB_TOKEN`` must have "Read and write permissions" when running workflows in this repository. For more information, see "`Managing GitHub Actions settings for a repository <https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/enabling-features-for-your-repository/managing-github-actions-settings-for-a-repository#setting-the-permissions-of-the-github_token-for-your-repository>`__."
- The repository visibility must be "public" if you plan to analyze public repositories. The variant analysis will be free.
- The repository visibility must be "private" or "internal" if you need to analyze private and internal repositories. Any actions minutes used by variant analysis, above the free limit, will be charged to the repository owner. For more information about free minutes and billing, see "`About billing for GitHub Actions <https://docs.github.com/en/billing/managing-billing-for-github-actions/about-billing-for-github-actions>`__." 

TODO: Check on "internal" repositories.

.. pull-quote::

    Note

    You can update your settings to use a different controller repository when you want to run variant analysis on a different group of repositories. For example, if you have finished testing the query on open source code and now want to test it on your private code. However, you must wait until any previous analysis is complete before you change the controller repository.

TODO: check that the guess in the note above is accurate.

Setting up variant analysis
---------------------------

You can configure the CodeQL extension to run variant analysis by defining a controller repository.

.. image:: ../images/codeql-for-visual-studio-code/controller-repository.png
    :width: 350
    :alt: Screenshot of the CodeQL extension in Visual Studio Code. The "Variant Analysis Repositories" section is expanded and the "Set up controller repository" button is highlighted with a dark orange outline.

#. In Visual Studio Code, click **QL** in the left sidebar to display the CodeQL extension.

#. Expand **Variant Analysis Repositories** and click **Set up controller repository** to display a field for the controller repository.

#. Type the owner and name of the repository on GitHub.com that you want to use as your controller repository and press the **Enter** key.

#. If you are prompted to authenticate with GitHub, follow the instructions and sign into your pesonal or organization account. When you have finished following the process, a prompt from GitHub Authentication may ask for permission to open a URI in Visual Studio Code, click **Open**.

The name of the controller repository is saved in your settings for the CodeQL extension. For information on how to edit the controller repository, see ":ref:`Customizing settings <customizing-settings>`."

Running a query at scale using variant analysis
-----------------------------------------------

#. Expand the **Variant Analysis Repositories** section, to show the default lists of the top 10, top 100, and top 1000 public repositories on GitHub.com. These are ranked by considering various metrics such as number of stars, number of watchers, number of forks etc.

#. Select the **Top 10 repositories** to test your query against.

#. Open the query you want to run, right-click in the query file, and select **CodeQL: Run Variant Analysis** to start variant analysis.

The CodeQL extension builds a CodeQL pack with your library and any library dependencies. The CodeQL pack and your selected repository list are posted to an API endpoint on GitHub.com which triggers a GitHub Actions dynamic workflow in your controller repository. The workflow spins up multiple parallel jobs to execute the CodeQL query against the repositories in the list, optimizing query execution. As each workflow run finishes, the results are processed and displayed in a variant analysis results view in Visual Studio Code.

.. pull-quote::

    Note

    If you need to cancel the variant analysis run for any reason, click **Stop query** in the Variant Analysis Results view.

Exploring your results
----------------------

When you run variant analysis, as soon as a workflow to run your analysis on GitHub is running, a Variant Analysis Results view opens to display the results as soon as they are ready. You can use this view to monitor progress, see any errors, and access the workflow logs in your controller repository.

.. image:: ../images/codeql-for-visual-studio-code/variant-analysis-results-view.png
    :alt: Screenshot of the "Variant Analysis Results" view showing a partially complete run. Analysis of ``angular/angular`` is still running but all other results are displayed. ``facebook/create-react-app`` has three results for this query.

When your variant analysis run is scheduled, the results view automatically opens. Initially the view shows a list of every repository that was scheduled for analysis. As each repository is analyzed, the view is updated to show a summary of the number of results. To view the detailed results for a repository (including results paths), click the repository name.

For each repository, you can see:

- Number of results found by the query
- Visibility of the repository
- Whether analysis is still running (black, moving circle) or finished (green checkmark)
- Number of stars the repository has on GitHub
- How long ago the CodeQL database that was analyzed was created

To see the results for a repository:

.. image:: ../images/codeql-for-visual-studio-code/variant-analysis-result.png
    :alt: Screenshot of an example result in the "Variant Analysis Results" view. The result has blue links to the source files in GitHub so you can go straight to the repository to fix the problem. There is also a "Show paths" link because this is a data flow query.

#. Click the repository name to show a summary of each result.

#. Explore the information available for each result using links to the source files in GitHub.com and, for data flow queries, the **Show paths** link. For more information, see "ref:`Exploring data flow with path queries <exploring-data-flow-with-path-queries>`."

Exporting your results
----------------------

#. Optionally, click **Export results** to export the results to a gist on GitHub.com or to a markdown file


Creating your own lists of repositories
---------------------------------------

The Variant analysis repositories panel is used to select and manage the repos queried during variant analysis. We provide predefined lists of the most important repositories per language (Top 10, Top 100, or Top 1000) but you can also add your own lists, single repos, or GitHub organizations to the panel. To add new items, use the buttons located on the top right of the panel.

Note: When you run variant analysis against a list of repositories, the query will only be executed against the repos that currently have a CodeQL database available to download. We store CodeQL databases for thousands of public repositories, including all repos that run code scanning. So the best way to make a repository available for variant analysis is to enable code scanning with CodeQL.
Adding a single GitHub repository or organization for variant analysis
Click the + icon. 
From the drop down menu, choose to either add a GitHub repository or a GitHub organisation/owner.
Specify either the org/repo or org identifier in the text box.
Adding a new list of repositories for variant analysis
Click the +📁 icon.
Specify a name for your list in the drop down text box and hit enter.
Add repos to the list by first clicking on the name of the new list in the panel. Then click + and specify the org/repo identifier for each repo you want to add.

#. Optionally, click **Copy repository list** to add a list of the repositories that have results for your query to the clipboard as JSON. For example:

.. code-block:: json

    {
        "name": "new-repo-list",
        "repositories": [
            "facebook/create-react-app"
        ]
    }



Troubleshooting variant analysis
--------------------------------

For information on troubleshooting variant analysis, see
":ref:`Troubleshooting variant analysis <troubleshooting-variant-analysis>`."

