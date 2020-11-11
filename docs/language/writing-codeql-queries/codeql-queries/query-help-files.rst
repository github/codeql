.. _query-help-files:

Query help files
****************

Query help files tell users the purpose of a query, and recommend how to solve the potential problem the query finds.

This topic provides detailed information on the structure of query help files. 
For more information about how to write useful query help in a style that is consistent with the standard CodeQL queries, see the `Query help style guide <https://github.com/github/codeql/blob/main/docs/query-help-style-guide.md>`__ on GitHub.


.. pull-quote::

   Note
 
   You can access the query help for CodeQL queries by visiting the `Built-in query pages <https://help.semmle.com/wiki/display/QL/Built-in+queries>`__.
   You can also access the raw query help files in the `GitHub repository <https://github.com/github/codeql>`__.
   For example, see the `JavaScript security queries <https://github.com/github/codeql/tree/main/javascript/ql/src/Security>`__ and `C/C++ critical queries <https://github.com/github/codeql/tree/main/cpp/ql/src/Critical>`__. 
   
   For queries run by default on LGTM, there are several different ways to access the query help. For further information, see `Where do I see the query help for a query on LGTM? <https://lgtm.com/help/lgtm/query-help#where-query-help-in-lgtm>`__ in the LGTM user help.
   

Overview
========

Each query help file provides detailed information about the purpose and use of a query. When you write your own queries, we recommend that you also write query help files so that other users know what the queries do, and how they work.

Structure
=========

Query help files are written using a custom XML format, and stored in a file with a ``.qhelp`` extension. Query help files must have the same base name as the query they describe, and must be located in the same directory. The basic structure is as follows:

.. code-block:: xml

   <!DOCTYPE qhelp SYSTEM "qhelp.dtd">
   <qhelp>
       CONTAINS one or more section-level elements 
   </qhelp>

The header and single top-level ``qhelp`` element are both mandatory. 
The following sections explain additional elements that you may include in your query help files.


Section-level elements
======================

Section-level elements are used to group the information in the help file into sections. Many sections have a heading, either defined by a ``title`` attribute or a default value. The following section-level elements are optional child elements of the ``qhelp`` element.

+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| Element            | Attributes                              | Children               | Purpose of section                                                                                                                            |
+====================+=========================================+========================+===============================================================================================================================================+
| ``example``        | None                                    | Any block element      | Demonstrate an example of code that violates the rule implemented by the query with guidance on how to fix it. Default heading.               |
+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| ``fragment``       | None                                    | Any block element      | See ":ref:`Query help inclusion <qhelp-inclusion>`" below. No heading.                                                                        |
+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| ``hr``             | None                                    | None                   | A horizontal rule. No heading.                                                                                                                |
+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| ``include``        | ``src`` The query help file to include. | None                   | Include a query help file at the location of this element. See ":ref:`Query help inclusion <qhelp-inclusion>`" below. No heading.             |
+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| ``overview``       | None                                    | Any block element      | Overview of the purpose of the query. Typically this is the first section in a query document. No heading.                                    |
+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| ``recommendation`` | None                                    | Any block element      | Recommend how to address any alerts that this query identifies. Default heading.                                                              |
+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| ``references``     | None                                    | ``li`` elements        | Reference list. Typically this is the last section in a query document. Default heading.                                                      |
+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| ``section``        | ``title`` Title of the section          | Any block element      | General-purpose section with a heading defined by the ``title`` attribute.                                                                    |
+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+
| ``semmleNotes``    | None                                    | Any block element      | Implementation notes about the query. This section is used only for queries that implement a rule defined by a third party. Default heading.  |
+--------------------+-----------------------------------------+------------------------+-----------------------------------------------------------------------------------------------------------------------------------------------+

Block elements
==============

The following elements are optional child elements of the ``section``, ``example``, ``fragment``, ``recommendation``, ``overview``, and ``semmleNotes`` elements.

.. table::
   :widths: 7 20 10 25

   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | Element        | Attributes                                               | Children           | Purpose of block                                                                                                                                                                                                                                                                                          |
   +================+==========================================================+====================+===========================================================================================================================================================================================================================================================================================================+
   | ``blockquote`` | None                                                     | Any block element  | Display a quoted paragraph.                                                                                                                                                                                                                                                                               |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | ``img``        | | ``src`` The image file to include.                     | None               | Display an image. The content of the image is in a separate image file.                                                                                                                                                                                                                                   |
   |                | | ``alt`` Text for the image's alt text.                 |                    |                                                                                                                                                                                                                                                                                                           |
   |                | | ``height`` Optional, height of the image.              |                    |                                                                                                                                                                                                                                                                                                           |
   |                | | ``width`` Optional, the width of the image.            |                    |                                                                                                                                                                                                                                                                                                           |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | ``include``    | ``src`` The query help file to include.                  | None               | Include a query help file at the location of this element. See :ref:`Query help inclusion <qhelp-inclusion>` below for more information.                                                                                                                                                                  |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | ``ol``         | None                                                     | ``li``             | Display an ordered list. See List elements below.                                                                                                                                                                                                                                                         |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | ``p``          | None                                                     | Any inline content | Display a paragraph, used as in HTML files.                                                                                                                                                                                                                                                               |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | ``pre``        | None                                                     | Text               | Display text in a monospaced font with preformatted whitespace.                                                                                                                                                                                                                                           |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | ``sample``     | | ``language`` The language of the in-line code sample.  | Text               | Display sample code either defined as nested text in the ``sample`` element or defined in the ``src`` file specified. When ``src`` is specified, the language is inferred from the file extension. If ``src`` is omitted, then language must be provided and the sample code provided as nested text.     |
   |                | | ``src`` Optional, the file containing the sample code. |                    |                                                                                                                                                                                                                                                                                                           |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | ``table``      | None                                                     | ``tbody``          | Display a table. See Tables below.                                                                                                                                                                                                                                                                        |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | ``ul``         | None                                                     | ``li``             | Display an unordered list. See List elements below.                                                                                                                                                                                                                                                       |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   | ``warning``    | None                                                     | Text               | Display a warning that will be displayed very visibly on the resulting page. Such warnings are sometimes used on queries that are known to have low precision for many code bases; such queries are often disabled by default.                                                                            |
   +----------------+----------------------------------------------------------+--------------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
   
List elements
=============

Query help files support two types of block elements for lists: ``ul`` and ``ol``. Both block elements support only one child elements of the type ``li``. Each ``li`` element contains either inline content or a block element.

Table elements
==============

The ``table`` block element is used to include a table in a query help file. Each table includes a number of rows, each of which includes a number of cells. The data in the cells will be rendered as a grid.

+-----------+------------+--------------------+-------------------------------------------+
| Element   | Attributes | Children           | Purpose                                   |
+===========+============+====================+===========================================+
| ``tbody`` | None       | ``tr``             | Defines the top-level element of a table. |
+-----------+------------+--------------------+-------------------------------------------+
| ``tr``    | None       | | ``th``           | Defines one row of a table.               |
|           |            | | ``td``           |                                           |
+-----------+------------+--------------------+-------------------------------------------+
| ``td``    | None       | Any inline content | Defines one cell of a table row.          |
+-----------+------------+--------------------+-------------------------------------------+
| ``th``    | None       | Any inline content | Defines one header cell of a table row.   |
+-----------+------------+--------------------+-------------------------------------------+

Inline content
==============

Inline content is used to define the content for paragraphs, list items, table cells, and similar elements. Inline content includes text in addition to the inline elements defined below:

+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| Element    | Attributes                           | Children       | Purpose                                                                                          |
+============+======================================+================+==================================================================================================+
| ``a``      | ``href`` The URL of the link.        | text           | Defines hyperlink. When a user selects the child text, they will be redirected to the given URL. |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| ``b``      | None                                 | Inline content | Defines content that should be displayed as bold face.                                           |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| ``code``   | None                                 | Inline content | Defines content representing code. It is typically shown in a monospace font.                    |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| ``em``     | None                                 | Inline content | Defines content that should be emphasized, typically by italicizing it.                          |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| ``i``      | None                                 | Inline content | Defines content that should be displayed as italics.                                             |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| ``img``    | | ``src``                            | None           | Display an image. See the description above in Block elements.                                   |
|            | | ``alt``                            |                |                                                                                                  |
|            | | ``height``                         |                |                                                                                                  |
|            | | ``width``                          |                |                                                                                                  |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| ``strong`` | None                                 | Inline content | Defines content that should be rendered more strongly, typically using bold face.                |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| ``sub``    | None                                 | Inline content | Defines content that should be rendered as subscript.                                            |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| ``sup``    | None                                 | Inline content | Defines content that should be rendered as superscript.                                          |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+
| ``tt``     | None                                 | Inline content | Defines content that should be displayed with a monospace font.                                  |
+------------+--------------------------------------+----------------+--------------------------------------------------------------------------------------------------+

.. _qhelp-inclusion:

Query help inclusion
====================

To reuse content between different help topics, you can store shared content in one query help file and then include it in a number of other query help files using the ``include`` element. The shared content can be stored either in the same directory as the including files, or in ``SEMMLE_DIST/docs/include``.

The ``include`` element can be used as a section or block element. The content of the query help file defined by the ``src`` attribute must contain elements that are appropriate to the location of the ``include`` element.

Section-level include elements
------------------------------

Section-level ``include`` elements can be located beneath the top-level ``qhelp`` element. For example, in `StoredXSS.qhelp <https://github.com/github/codeql/blob/main/csharp/ql/src/Security%20Features/CWE-079/StoredXSS.qhelp>`__, a full query help file is reused: 

.. code-block:: xml 
   
   <qhelp> 
       <include src="XSS.qhelp" />
   </qhelp>

In this example, the `XSS.qhelp <https://github.com/github/codeql/blob/main/csharp/ql/src/Security%20Features/CWE-079/XSS.qhelp>`__ file must conform to the standard for a full query help file as described above. That is, the ``qhelp`` element may only contain non-``fragment``, section-level elements.

Block-level include elements
----------------------------

Block-level ``include`` elements can be included beneath section-level elements. For example, an ``include`` element is used beneath the ``overview`` section in `ThreadUnsafeICryptoTransform.qhelp <https://github.com/github/codeql/blob/main/csharp/ql/src/Likely%20Bugs/ThreadUnsafeICryptoTransform.qhelp>`__:

.. code-block:: xml 
   
   <qhelp>
       <overview>
           <include src="ThreadUnsafeICryptoTransformOverview.qhelp" />
       </overview>
       ...
   </qhelp>

The included file, `ThreadUnsafeICryptoTransformOverview.qhelp <https://github.com/github/codeql/blob/main/csharp/ql/src/Likely%20Bugs/ThreadUnsafeICryptoTransformOverview.qhelp>`_, may only contain one or more ``fragment`` sections. For example:

.. code-block:: xml 

   <!DOCTYPE qhelp SYSTEM "qhelp.dtd"> 
   <qhelp>
      <fragment>
         <p>
            ...
         </p>
      </fragment>
   </qhelp>

