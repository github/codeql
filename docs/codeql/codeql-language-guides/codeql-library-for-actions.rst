.. _codeql-library-for-actions:

CodeQL library for GitHub Actions
=================================

When you're analyzing GitHub Actions workflows and Action metadata files, you can make use of the large collection of classes in the CodeQL library for GitHub Actions.

Overview
--------

CodeQL ships with an extensive library for analyzing GitHub Actions code, particularly GitHub Actions workflow files and Action metadata files, each written in YAML.
The classes in this library present the data from a CodeQL database in an object-oriented form and provide abstractions and predicates
to help you with common analysis tasks.

The library is implemented as a set of CodeQL modules, that is, files with the extension ``.qll``. The
module `actions.qll <https://github.com/github/codeql/blob/main/actions/ql/lib/actions.qll>`__ imports most other standard library modules, so you can include the complete
library by beginning your query with:

.. code-block:: ql

   import actions

The CodeQL libraries model various aspects of the YAML code used to define workflows and actions.
The above import includes the abstract syntax tree (AST) library, which is used for locating program elements, to match syntactic
elements in the YAML source code. This can be used to find values, patterns and structures.
Both the underlying YAML elements and the GitHub Actions-specific meaning of those elements are modeled.

See the GitHub Actions documentation on `workflow syntax <https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions>`__ and `metadata syntax <https://docs.github.com/en/actions/sharing-automations/creating-actions/metadata-syntax-for-github-actions>`__ for more information on GitHub Actions YAML syntax and meaning.

The control flow graph (CFG) is imported using

.. code-block:: ql

   import codeql.actions.Cfg

The CFG models the control flow between statements and expressions, for example whether one expression can
be evaluated before another expression, or whether an expression "dominates" another one, meaning that all paths to an
expression must flow through another expression first.

The data flow library is imported using 

.. code-block:: ql

   import codeql.actions.DataFlow

Data flow tracks the flow of data through the program, including through function calls (interprocedural data flow) and between steps in a job or workflow.
Data flow is particularly useful for security queries, where untrusted data flows to vulnerable parts of the program
to exploit it. Related to data flow, is the taint-tracking library, which finds how data can *influence* other values
in a program, even when it is not copied exactly.

To summarize, the main GitHub Actions library modules are:

.. list-table:: Main GitHub Actions library modules
   :header-rows: 1

   * - Import
     - Description
   * - ``actions``
     - The standard GitHub Actions library
   * - ``codeql.actions.Ast``
     - The abstract syntax tree library (also imported by `actions.qll`)
   * - ``codeql.actions.Cfg``
     - The control flow graph library
   * - ``codeql.actions.DataFlow``
     - The data flow library
   * - ``codeql.actions.TaintTracking``
     - The taint tracking library

The CodeQL examples in this article are only excerpts and are not meant to represent complete queries.

Abstract syntax
---------------

The abstract syntax tree (AST) represents the elements of the source code organized into a tree. The `AST viewer <https://docs.github.com/en/code-security/codeql-for-vs-code/using-the-advanced-functionality-of-the-codeql-for-vs-code-extension/exploring-the-structure-of-your-source-code/>`__
in Visual Studio Code shows the AST nodes, including the relevant CodeQL classes and predicates.

All CodeQL AST classes inherit from the `AstNode` class, which provides the following member predicates
to all AST classes:

.. list-table:: Main predicates in ``AstNode``
   :header-rows: 1

   * - Predicate
     - Description
   * - ``getEnclosingWorkflow()``
     - Gets the enclosing Actions workflow, if any. Applies only to elements within a workflow.
   * - ``getEnclosingJob()``
     - Gets the enclosing Actions workflow job, if any. Applies only to elements within a workflow.
   * - ``getEnclosingStep()``
     - Gets the enclosing Actions workflow job step, if any.
   * - ``getEnclosingCompositeAction()``
     - Gets the enclosing composite action, if any. Applies only to elements within an action metadata file.
   * - ``getLocation()``
     - Gets the location of this node.
   * - ``getAChildNode()``
     - Gets a child node of this node.
   * - ``getParentNode()``
     - Gets the parent of this ``AstNode``, if this node is not a root node.
   * - ``getATriggerEvent()``
     - Gets an Actions trigger event that can start the enclosing Actions workflow, if any.
     

Workflows
~~~~~~~~~

A workflow is a configurable automated process made up of one or more jobs,
defined in a workflow YAML file in the ``.github/workflows`` directory of a GitHub repository.

In the CodeQL AST library, a ``Workflow`` is an ``AstNode`` representing the mapping at the top level of an Actions YAML workflow file.

See the GitHub Actions documentation on `workflows <https://docs.github.com/en/actions/writing-workflows/about-workflows>`__ and `workflow syntax <https://docs.github.com/en/actions/writing-workflows/workflow-syntax-for-github-actions>`__ for more information.

.. list-table:: Callable classes
   :header-rows: 1

   * - CodeQL class
     - Description and selected predicates
   * - ``Workflow``
     -  An Actions workflow, defined as a mapping at the top level of a workflow YAML file in ``.github/workflows``. See https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions.

        - ``getAJob()`` - Gets a job within the ``jobs`` mapping of this workflow.
        - ``getEnv()`` - Gets an ``env`` mapping within this workflow declaring workflow-level environment variables, if any.
        - ``getJob(string jobId)`` - Gets a job within the ``jobs`` mapping of this workflow with the given job ID.
        - ``getOn()``` - Gets the ``on`` mapping defining the events that trigger this workflow.
        - ``getPermissions()`` - Gets a ``permissions`` mapping within this workflow declaring workflow-level token permissions, if any.
        - ``getStrategy()``` - Gets a ``strategy`` mapping for the jobs in this workflow, if any.
        - ``getName()`` - Gets the name of this workflow, if defined within the workflow.

The following example lists all jobs in a workflow with the name declaration ``name: test``:

.. code-block:: ql

   import actions

   from Workflow w
   where w.getName() = "test"
   select w, m.getAJob()
