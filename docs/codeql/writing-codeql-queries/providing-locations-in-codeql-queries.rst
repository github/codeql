.. _providing-locations-in-codeql-queries:

Providing locations in CodeQL queries
=====================================

.. Not sure how much of this topic needs to change, and what the title should be

CodeQL includes mechanisms for extracting the location of elements in a codebase. Use these mechanisms when writing custom CodeQL queries and libraries to help display information to users.


About locations
---------------

When displaying information to the user, LGTM needs to be able to extract location information from the results of a query. In order to do this, all QL classes which can provide location information should do this by using one of the following mechanisms:

-  `Providing URLs <#providing-urls>`__
-  `Providing location information <#providing-location-information>`__
-  `Using extracted location information <#using-extracted-location-information>`__

This list is in priority order, so that the first available mechanism is used.

.. pull-quote::

   Note

   Since QL is a relational language, there is nothing to enforce that each entity of a QL class is mapped to precisely one location. This is the responsibility of the designer of the library (or the extractor, in the case of the third option below). If entities are assigned no location at all, users will not be able to click through from query results to the source code viewer. If multiple locations are assigned, results may be duplicated.

Providing URLs
~~~~~~~~~~~~~~

A custom URL can be provided by defining a QL predicate returning ``string`` with the name ``getURL`` – note that capitalization matters, and no arguments are allowed. For example:

.. code-block:: ql

   class JiraIssue extends ExternalData {
       JiraIssue() {
           getDataPath() = "JiraIssues.csv"
       }

       string getKey() {
           result = getField(0)
       }

       string getURL() {
           result = "http://mycompany.com/jira/" + getKey()
       }
   }

File URLs
^^^^^^^^^

LGTM supports the display of URLs which define a line and column in a source file.

The schema is ``file://``, which is followed by the absolute path to a file, followed by four numbers separated by colons. The numbers denote start line, start column, end line and end column. Both line and column numbers are **1-based**, for example:

-  ``file://opt/src/my/file.java:0:0:0:0`` is used to link to an entire file.
-  ``file:///opt/src/my/file.java:1:1:2:1`` denotes the location that starts at the beginning of the file and extends to the first character of the second line (the range is inclusive).
-  ``file:///opt/src/my/file.java:1:0:1:0`` is taken, by convention, to denote the entire first line of the file.

By convention, the location of an entire file may also be denoted by a ``file://`` URL without trailing numbers. Optionally, the location within a file can be denoted using three numbers to define the start line number, character offset and character length of the location respectively. Results of these types are not displayed in LGTM.

Other types of URL
^^^^^^^^^^^^^^^^^^

The following, less-common types of URL are valid but are not supported by LGTM and will be omitted from any results:

-  **HTTP URLs** are supported in some client applications. For an example, see the code snippet above.
-  **Folder URLs** can be useful, for example to provide folder-level metrics. They may use a file URL, for example ``file:///opt/src:0:0:0:0``, but they may also start with a scheme of ``folder://``, and no trailing numbers, for example ``folder:///opt/src``.
-  **Relative file URLs** are like normal file URLs, but start with the scheme ``relative://``. They are typically only meaningful in the context of a particular database, and are taken to be implicitly prefixed by the database's source location. Note that, in particular, the relative URL of a file will stay constant regardless of where the database is analyzed. It is often most convenient to produce these URLs as input when importing external information; selecting one from a QL class would be unusual, and client applications may not handle it appropriately.

Providing location information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If no ``getURL()`` member predicate is defined, a QL class is checked for the presence of a member predicate called ``hasLocationInfo(..)``. This can be understood as a convenient way of providing file URLs (see above) without constructing the long URL string in QL. ``hasLocationInfo(..)`` should be a predicate, its first column must be ``string``-typed (it corresponds to the "path" portion of a file URL), and it must have an additional 3 or 4 ``int``-typed columns, which are interpreted like a trailing group of three or four numbers on a file URL.

For example, let us imagine that the locations for methods provided by the extractor extend from the first character of the method name to the closing curly brace of the method body, and we want to "fix" them to ensure that only the method name is selected. The following code shows two ways of achieving this:

.. code-block:: ql

   class MyMethod extends Method {
       // The locations from the database, which we want to modify.
       Location getLocation() { result = super.getLocation() }

       /* First member predicate: Construct a URL for the desired location. */
       string getURL() {
           exists(Location loc | loc = this.getLocation() |
               result = "file://" + loc.getFile().getFullName() +
                   ":" + loc.getStartLine() +
                   ":" + loc.getStartColumn() +
                   ":" + loc.getStartLine() +
                   ":" + (loc.getStartColumn() + getName().length() - 1)
           )
       }

       /* Second member predicate: Define hasLocationInfo. This will be more
          efficient (it avoids constructing long strings), and will
          only be used if getURL() is not defined. */
       predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
           exists(Location loc | loc = this.getLocation() |
               path = loc.getFile().getFullName() and
               sl = loc.getStartLine() and
               sc = loc.getStartColumn() and
               el = sl and
               ec = sc + getName().length() - 1
           )
       }
   }

Using extracted location information
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Finally, if the above two predicates fail, client applications will attempt to call a predicate called ``getLocation()`` with no parameters, and try to apply one of the above two predicates to the result. This allows certain locations to be put into the database, assigned identifiers, and picked up.

By convention, the return value of the ``getLocation()`` predicate should be a class called ``Location``, and it should define a version of ``hasLocationInfo(..)`` (or ``getURL()``, though the former is preferable). If the ``Location`` class does not provide either of these member predicates, then no location information will be available.

The ``toString()`` predicate
----------------------------

All classes except those that extend primitive types, must provide a ``string toString()`` member predicate. The query compiler will complain if you don't. The uniqueness warning, noted above for locations, applies here too.

Further reading
---------------

- `CodeQL repository <https://github.com/github/codeql>`__