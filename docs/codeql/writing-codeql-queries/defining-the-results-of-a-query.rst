.. _defining-the-results-of-a-query:

Defining the results of a query
===============================

You can control how analysis results are displayed in source code by modifying a query's ``select`` statement.

About query results
-------------------

The information contained in the results of a query is controlled by the ``select`` statement. Part of the process of developing a useful query is to make the results clear and easy for other users to understand.
When you write your own queries in the CodeQL `extension for VS Code <https://docs.github.com/en/code-security/codeql-for-vs-code/>`__ there are no constraints on what can be selected.
However, if you want to use a query to create alerts for code scanning or generate valid analysis results using the `CodeQL CLI <https://docs.github.com/en/code-security/codeql-cli>`__, you'll need to make the ``select`` statement report results in the required format. 
You must also ensure that the query has the appropriate metadata properties defined. 
This topic explains how to write your select statement to generate helpful analysis results. 

Overview
--------

Alert queries must have the property ``@kind problem`` defined in their metadata. For more information, see ":doc:`Metadata for CodeQL queries <metadata-for-codeql-queries>`." 
In their most basic form, the ``select`` statement must select two 'columns':

-  **Element**—a code element that's identified by the query. This defines the location of the alert.
-  **String**—a message to display for this code element, describing why the alert was generated.

If you look at some of the existing queries, you'll see that they can select extra element/string pairs, which are combined with ``$@`` placeholder markers in the message to form links. For example, `Dereferenced variable may be null <https://github.com/github/codeql/blob/95e65347cafe502bbd0d9f48d1175fd3d66e0459/java/ql/src/Likely%20Bugs/Nullness/NullMaybe.ql>`__ (Java), or `Duplicate switch case <https://github.com/github/codeql/blob/95e65347cafe502bbd0d9f48d1175fd3d66e0459/javascript/ql/src/Expressions/DuplicateSwitchCase.ql>`__ (JavaScript). 

.. pull-quote::

    Note

    An in-depth discussion of ``select`` statements for path queries is not included in this topic. However, you can develop the string column of the ``select`` statement in the same way as for alert queries. For more specific information about path queries, see ":doc:`Creating path queries <creating-path-queries>`."

Developing a select statement
-----------------------------

Here's a simple query to find Java classes that extend other classes.

Basic select statement
~~~~~~~~~~~~~~~~~~~~~~

.. code-block:: ql

    /**
     * @kind problem
     */
    
    import java
    
    from Class c, Class superclass
    where superclass = c.getASupertype()
    select c, "This class extends another class."

This basic select statement has two columns:

#. An element with a location to display the alert on: ``c`` corresponds to ``Class``.
#. String message to display: ``"This class extends another class."``

.. image:: ../images/ql-select-statement-basic.png
   :alt: Results of basic select statement
   :class: border

Including the name of the superclass
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The alert message defined by the basic select statement is constant and doesn't give users much information. Since the query identifies the superclass, it's easy to include its name in the string message. For example:

.. code-block:: ql

   select c, "This class extends the class " + superclass.getName()

#. Element: ``c`` as before.
#. String message: ``"This class extends the class "``—the string text is combined with the class name for the ``superclass``, returned by ``getName()``.

.. image:: ../images/ql-select-statement-class-name.png
   :alt: Results of extended select statement
   :class: border

While this is more informative than the original select statement, the user still needs to find the superclass manually.

Adding a link to the superclass
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You can use placeholders in the text of alert messages to insert additional information, such as links to the superclass. Placeholders are defined using ``$@``, and filled using the information in the next two columns of the select statement. For example, this select statement returns four columns:

.. code-block:: ql

   select c, "This class extends the class $@.", superclass, superclass.getName()

#. Element: ``c`` as before.
#. String message: ``"This class extends the class $@."``—the string text now includes a placeholder, which will display the combined content of the next two columns.
#. Element for placeholder: the ``superclass``.
#. String text for placeholder: the class name returned by ``superclass.getBaseName()``.

When the alert message is displayed, the ``$@`` placeholder is replaced by a link created from the contents of the third and fourth columns defined by the ``select`` statement. In this example, the link target will be the location of the superclass's definition, and the link text will be its name. Note that some superclasses, such as ``Object``, will not be in the database, since they are built in to the Java language. Clicking those links will have no effect.

If you use the ``$@`` placeholder marker multiple times in the description text, then the ``N``\ th use is replaced by a link formed from columns ``2N+2`` and ``2N+3``. If there are more pairs of additional columns than there are placeholder markers, then the trailing columns are ignored. Conversely, if there are fewer pairs of additional columns than there are placeholder markers, then the trailing markers are treated as normal text rather than placeholder markers.

.. image:: ../images/ql-select-statement-link.png
   :alt: Results including links
   :class: border

Further reading
---------------

- `CodeQL repository <https://github.com/github/codeql>`__
