:tocdepth: 1

.. _exploring-data-flow-with-path-queries:

Exploring data flow with path queries
=====================================

.. include:: ../reusables/vs-code-deprecation-note.rst

You can run CodeQL queries in VS Code to help you track the flow of data through a program, highlighting areas that are potential security vulnerabilities.

About path queries
--------------------

A path query is a CodeQL query with the property ``@kind path-problem``. 
You can find a number of these in the standard CodeQL libraries, for example, a security query that finds cross-site scripting vulnerabilities in Java projects:
`Cross-site scripting <https://github.com/github/codeql/blob/main/java/ql/src/Security/CWE/CWE-079/XSS.ql>`__.

You can run the standard CodeQL path queries to identify security vulnerabilities and manually look through the results.
You can also modify the existing queries to model data flow more precisely for the specific framework of your project, or write completely new path queries to find a different vulnerability.

To ensure that your path query uses the correct format and metadata, follow the instructions in ":ref:`Creating path queries <creating-path-queries>`."
This topic also contains detailed information about how to define new sources and sinks, as well as templates and examples of how to extend the CodeQL libraries to suit your analysis.

Running path queries in VS Code locally
---------------------------------------

#. Open a path query in the editor.
#. Right-click in the query window and select **CodeQL: Run Query on Selected Database**. (Alternatively, run the command from the Command Palette.)
#. Once the query has finished running, you can see the results in the Results view as usual (under ``alerts`` in the dropdown menu). Each query result describes the flow of information between a source and a sink.
#. Expand the result to see the individual steps that the data follows. 
#. Click each step to jump to it in the source code and investigate the problem further.
#. To navigate the results from your keyboard, you can bind shortcuts to the **CodeQL: Navigate Up/Down/Left/Right in Result Viewer** commands.

When you are ready to run a path query at scale, you can use the Variant Analysis Repositories panel to run the query against up to 1,000 repositories on GitHub.com. For information on running analysis at scale across many CodeQL databases, see ":ref:`Running CodeQL queries at scale with multi-repository variant analysis <running-codeql-queries-at-scale-with-mrva>`."

Further reading
-----------------

- ":ref:`About data flow analysis <about-data-flow-analysis>`"
- ":ref:`Creating path queries <creating-path-queries>`"