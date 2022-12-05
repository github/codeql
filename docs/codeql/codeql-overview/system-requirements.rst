:tocdepth: 1

.. _system-requirements:

System requirements
-------------------

System requirements for running the latest version of CodeQL.

Supported platforms
#######################

.. include:: ../reusables/supported-platforms.rst

.. include:: ../reusables/kotlin-beta-note.rst

Additional software requirements
################################

To generate a CodeQL database for a compiled language, you must ensure that the system can successfully build and compile your code, independently of CodeQL.

In addition, CodeQL extraction has the following requirements.

For extraction of compiled languages (C/C++, C#, Go, Java) and Ruby on Linux:

- ``glibc`` version 2.17 or greater must be installed.
- ``musl-c``-based Linux distributions, such as Alpine Linux, are not supported.

For TypeScript extraction on all platforms:

- Node.js must be installed and available on the ``PATH`` as ``node``.

For Python extraction:

- On Linux and macOS, Python 3 must be installed and available on the ``PATH`` as ``python3`` or ``python``.
- For Python 2 extraction on Linux and macOS, we also recommend having Python 2 installed and available on the ``PATH`` as ``python2``.
- On Windows, the Python launcher must be installed and available on the ``PATH`` as ``py.exe``.
