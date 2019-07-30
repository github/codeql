QL language documentation
#########################

Overview
********

The QL language documentation is written in reStructuredText and converted to
HTML for manual publication on `help.semmle.com <https://help.semmle.com>`__ using Sphinx. 

For more information on writing in reStructuredText, 
see http://docutils.sourceforge.net/rst.html.

For more information on Sphinx, see https://www.sphinx-doc.org.

Project structure
*****************

The QL language documentation currently consists of the following Sphinx projects:

- ``learn-ql``–help topics to help you learn the QL language and write queries
- ``ql-handbook``–a user-friendly guide to the QL language
- ``ql-spec``–formal descriptions of the QL language and QLDoc comments
- ``support``–the languages and frameworks currently supported in QL analysis
- ``training``–QL for variant analysis training material
- ``ql-training-rst``–QL for variant analysis slide shows

Each project contains:

- an ``index.html`` file, the project's 
  `master document <https://www.sphinx-doc.org/en/master/glossary.html#term-master-document>`__.
- a ``conf.py`` file that defines some project-specific configuration values
- one or more reStructuredText source files

Shared configuration values are specified in ``global-conf.py``, which is found 
in the ``global-sphinx-files`` directory.
This directory also contains any other files, such as templates and stylesheets, 
that are used by multiple projects.
Images used in the QL documentation are located in the ``images`` directory.

The ``ql-training-rst`` project contains the source files, themes, and static files 
used to generate the QL training presentations. 
It uses a different configuration from the other projects, and is built using an 
extension specifically designed for HTML slide shows. 
For more information, see  
**Building and previewing the QL training presentations** below.


Building and previewing the QL language documentation
*****************************************************

To build and preview the QL documentation locally, you need to install Sphinx. 
For installation options, see https://github.com/sphinx-doc/sphinx.

After installing Sphinx, you can build the HTML files for a project by running 
`sphinx-build <https://www.sphinx-doc.org/en/master/man/sphinx-build.html>`__
from the project's 
`source directory <https://www.sphinx-doc.org/en/master/glossary.html#term-source-directory>`__. 
For example, to generate the HTML output for a project in the
``<docs-output>`` directory you would use:

.. code::

  sphinx-build -b html . <docs-output>

Building and previewing the QL training presentations
*****************************************************

To build the QL training presentations, you need to install a Sphinx extension
called `hieroglyph <https://github.com/nyergler/hieroglyph>`__.

After installing hieroglyph, you can build the QL training presentations by running 
``sphinx-build``, specifying the ``slides`` builder. For example

.. code::

  sphinx-build -b slides . <slides-output>

generates html slide shows in the ``<slides-output>`` directory when run from
the ``ql-training-rst`` source directory.


Viewing the current version of the QL language documentation
************************************************************

The QL language documentation for the most recent Semmle release is 
published to `help.semmle.com <https://help.semmle.com>`__. 
There, you can also find the documentation for QL for Eclipse, 
QL for Visual Studio, QL command-line tools, and LGTM Enterprise. 
