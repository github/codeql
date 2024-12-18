.. Template for rst slide shows


.. Key points: 
   - Each heading marks the start of a new slide
   - The default slide style is a plain white-ish background with minimal company branding
   - Different slide designs have been preconfigured. To choose a different layout
     use the appropriate .. rst-class:: directive. For examples of the different designs, 
     see the template below. This directive can also be used to create custom classes for individual 
     images and slide backgrounds if necessary. Additional CSS styles may also be required when using custom 
     class directives. Search for 'deck-specific styles for individual images` in default.css for examples
     of how to implement custom class styles.
   - Additional notes can be added to a slide using a .. note:: directive
   - Press P to access the additional notes on the rendered slides.
   - Press F is go into full screen mode when viewing the rendered slides.


.. Title slide. Includes the deck title, subtitles, and the company logo

===================
Template slide deck
===================

.. container:: subheading

   First subheading
   
   Second subheading

.. Set up slide. Include link to CodeQL databases required for examples 

.. rst-class:: setup

Setup
=====

For this example you should download:

- `CodeQL for Visual Studio Code <https://docs.github.com/en/code-security/codeql-for-vs-code/getting-started-with-codeql-for-vs-code/installing-codeql-for-vs-code>`__
- A CodeQL database

.. note::

   Some notes about the project.

.. Agenda slide. Explaining what is to be covered in the presentation

.. rst-class:: Agenda

Agenda
======

- Item 1
- Item 2
- Item 3
- Item 4
- Item 5


Text
====

If you don't specify an rst-class, you default to the 'basic' slide design.

You can fit about this much text on a slide:

Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor 
incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis 
nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. 
Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore 
eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, 
sunt in culpa qui officia deserunt mollit anim id est laborum.

Code sample
===========

Use a ``.. code-block::`` directive to include a code snippet. 
Specify the language after the directive to add syntax highlighting.

.. code-block:: ql

   import cpp
   
   from AddExpr a, Variable v, RelationalOperation cmp
   where
     a.getAnOperand() = v.getAnAccess() and
     cmp.getAnOperand() = a and
     cmp.getAnOperand() = v.getAnAccess()
   select cmp, "Overflow check."

Columns and graphs
==================

.. container:: column-left

   ``.. container:: column-left`` sets up a column on the left of the slide.

   ``.. container:: column-right`` sets up a column on the right of the slide.

   Code can be included in columns:

   .. code-block:: ql

      import cpp  
   
      from IfStmt ifstmt, Block block
      where
        block = ifstmt.getThen() and
        block.isEmpty()
      select ifstmt, "This if-statement is redundant."


.. container:: column-right

   Graphs can be built from text using a ``.. graphviz directive``.
   See the source file for details.   

   .. graphviz::
       
      digraph {
      graph [ dpi = 1000 ]
      node [shape=polygon,sides=4,color=blue4,style="filled,rounded",   fontname=consolas,fontcolor=white]
      a [label=<tainted<BR /><FONT POINT-SIZE="10">ParameterNode</FONT>>]
      b [label=<tainted<BR /><FONT POINT-SIZE="10">ExprNode</FONT>>]
      c [label=<x<BR /><FONT POINT-SIZE="10">ExprNode</FONT>>]
      d [label=<x<BR /><FONT POINT-SIZE="10">ExprNode</FONT>>]   
      a -> b
      b -> {c, d}   
      }

.. You can indicate a new concept by using a purple slide background

.. rst-class:: background2

Purple background
=================

Subheading on purple slide

Including snippets
==================

rst snippets can be included using:

.. code-block:: none

   .. include:: path/to/file.rst

Code snippets can be included using:

.. code-block:: none

   .. literalinclude:: path/to/file.ql
      :language: ql
      :emphasize-lines: 3-6

Specify the language to apply syntax highlighting and the lines of the fragment that you want to emphasize.

Further details
===============

- For more information on writing in reStructuredText, see https://docutils.sourceforge.io/rst.html.

- For more information on Sphinx, see https://www.sphinx-doc.org.

- For more information about hieroglpyh, the Sphinx extension used to generate these slides, see https://github.com/nyergler/hieroglyph.

- For more information about creating graphs, see https://build-me-the-docs-please.readthedocs.io/en/latest/Using_Sphinx/UsingGraphicsAndDiagramsInSphinx.html.


.. The final slide with the company details is generated automatically.