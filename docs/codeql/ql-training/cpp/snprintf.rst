===============================
Exercise: ``snprintf`` overflow
===============================

CodeQL for C/C++

.. rst-class:: setup

Setup
=====

For this example you should download:

- `CodeQL for Visual Studio Code <https://help.semmle.com/codeql/codeql-for-vscode/procedures/setting-up.html>`__
- `rsyslog database <https://downloads.lgtm.com/snapshots/cpp/rsyslog/rsyslog/rsyslog-all-revision-2018-April-27--14-12-31.zip>`__

.. note::

   For this example, we will be analyzing `rsyslog <https://github.com/rsyslog/rsyslog>`__.

   You can also query the project in `the query console <https://lgtm.com/query/project:1506087977050/lang:cpp/>`__ on LGTM.com.

   .. insert database-note.rst to explain differences between database available to download and the version available in the query console.

   .. include:: ../slide-snippets/database-note.rst

   .. resume slides

``snprintf``
============

.. rst-class:: build

- ``printf``: Returns number of characters printed.

  .. code-block:: cpp
  
    printf("Hello %s!", name)

- ``sprintf``: Returns number of characters written to ``buf``.

  .. code-block:: cpp
  
    sprintf(buf, "Hello %s!", name)
  
- ``snprintf``: Returns number of characters it **would have written** to ``buf`` had ``n`` been sufficiently large, **not** the number of characters actually written.

  .. code-block:: cpp
  
    snprintf(buf, n, "Hello %s!", name)

- In pre-C99 versions of glibc ``snprintf`` would return -1 if ``n`` was too small!

RCE in rsyslog
==============

- Vulnerable code looked similar to this (`original <https://github.com/rsyslog/librelp/blob/532aa362f0f7a8d037505b0a27a1df452f9bac9e/src/tcp.c#L1195-L1211>`__):

  .. code-block:: cpp
  
    char buf[1024];
    int pos = 0;
    for (int i = 0; i < n; i++) {
      pos += snprintf(buf + pos, sizeof(buf) - pos, "%s", strs[i]);
    }

- Disclosed as `CVE-2018-1000140 <https://nvd.nist.gov/vuln/detail/CVE-2018-1000140>`__.
- Blog post: https://securitylab.github.com/research/librelp-buffer-overflow-cve-2018-1000140

Finding the RCE yourself
========================

#. Write a query to find calls to ``snprintf``

   **Hint**: Use class ``FunctionCall``

#. Restrict to calls whose result is used

   **Hint**: Use class ``ExprInVoidContext``

#. Restrict to calls where the format string contains “%s”

   **Hint**: Use predicates ``Expr.getValue`` and ``string.regexpMatch``

#. Restrict to calls where the result flows back to the size argument

   **Hint**: Import library ``semmle.code.cpp.dataflow.TaintTracking`` and use predicate ``TaintTracking::localTaint``

Model answer
============

.. literalinclude:: ../query-examples/cpp/snprintf-1.ql
   :language: ql

.. rst-class:: build

- More full-featured version: `https://lgtm.com/rules/1505913226124 <https://lgtm.com/rules/1505913226124>`__.

.. note::

  The regular expression for matching the format string uses the “(?s)” directive to ensure that “.” also matches any newline characters embedded in the string.