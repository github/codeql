CodeQL documentation
####################

Overview
********

The CodeQL documentation in this repository is written in reStructuredText and converted to
HTML using Sphinx. 

For more information on writing in reStructuredText, 
see http://docutils.sourceforge.net/rst.html.

For more information on Sphinx, see https://www.sphinx-doc.org.

Project structure
*****************

The project contains:

- an ``index.html`` file, the project's 
  `master document <https://www.sphinx-doc.org/en/master/glossary.html#term-master-document>`__.
- a ``conf.py`` file that defines some project-specific configuration values
- the reStructuredText source files

The documentation consists of the following categories:

- CodeQL overview
- Writing CodeQL queries
- CodeQL language guides
- QL language reference
- CodeQL CLI
- CodeQL for Visual Studio Code

The ``ql-training`` project contains the source files, themes, and static files 
used to generate the CodeQL training and variant analysis presentations. 
It uses a different configuration from the other projects, and is built using an 
extension specifically designed for HTML slide shows. 
For more information, see  
**Building and previewing the CodeQL training presentations** below.


Building and previewing the CodeQL documentation
************************************************

To build and preview the documentation and training presentations locally, you need to 
install Sphinx 1.7.9. More recent versions of Sphinx do not work with hieroglyph, 
the Sphinx extension that we use to generate HTML slides, as explained below. 
For installation options, see https://github.com/sphinx-doc/sphinx.


Using ``sphinx-build``
----------------------

After installing Sphinx, you can build the HTML files for a project by running 
`sphinx-build <https://www.sphinx-doc.org/en/master/man/sphinx-build.html>`__
from the project's 
`source directory <https://www.sphinx-doc.org/en/master/glossary.html#term-source-directory>`__. 
For example, to generate the HTML output for a project in the
``<docs-output>`` directory you would use:

.. code::

  sphinx-build -b html . <docs-output>

..
 
  Add the ``-W`` flag to turn *warnings* into *errors* during the build process. 
  You can use errors reported during the build to debug problems in your source 
  code, such as broken internal links and malformed tables. You can also check 
  external links using Sphinx's `external link builder 
  <http://www.sphinx-doc.org/en/master/usage/builders/index.html#sphinx.builders.linkcheck.CheckExternalLinksBuilder>`__.

  Add the ``-a`` flag to regenerate all output files. By default, only files that 
  have changed are rebuilt.
  
Using the reStructuredText Extension for Visual Studio Code
-----------------------------------------------------------

Visual Studio Code has an extension that can be used to preview Sphinx-generated 
output alongside ``.rst`` source code in your IDE. For more information, see the 
`Visual Studio Marketplace <https://marketplace.visualstudio.com/items?itemName=lextudio.restructuredtext>`__.

Building and previewing the CodeQL training presentations
*********************************************************

To build the training presentations, you need to install a Sphinx extension
called `hieroglyph <https://github.com/nyergler/hieroglyph>`__. 
You also need to install `graphviz <https://graphviz.gitlab.io/download/>`__, which 
is used to generate graphs on some slides.

After installing hieroglyph and graphviz, you can build the training presentations by running 
``sphinx-build``, specifying the ``slides`` builder. For example

.. code::

  sphinx-build -b slides . <slides-output>

generates html slide shows in the ``<slides-output>`` directory when run from
the ``ql-training`` source directory.

For more information about creating slides for QL training and variant analysis 
examples, see the `template slide deck <https://github.com/github/codeql/blob/main/docs/language/ql-training/template.rst>`__.

Viewing the current version of the CodeQL documentation
*******************************************************

The documentation for the most recent release is 
published to `help.semmle.com <https://help.semmle.com>`__. 
There, you can find the documentation for the CodeQL queries,
the CodeQL standard libraries, and LGTM Enterprise. 
