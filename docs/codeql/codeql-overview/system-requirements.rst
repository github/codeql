:tocdepth: 1

.. _system-requirements:

System requirements
-------------------

System requirements for running the latest version of CodeQL.

Supported platforms
#######################

.. include:: ../support/reusables/platforms.rst

Additional software requirements
################################

- For extraction of compiled languages on all platforms, the system must be configured so that it can successfully build and compile your code, independently of CodeQL.
- On Linux, extraction of compiled languages (C/C++, C#, Go, Java) and Ruby requires ``glibc`` version 2.17 or greater.
    - Extraction of these languages on ``musl-c``-based Linux distributions, such as Alpine Linux, is not supported.
- TypeScript extraction on all platforms requires Node.js to be installed and available on the ``PATH`` as ``node``.
- On Linux and macOS, extraction of Python 2 or Python 3 requires Python 3 to be installed and available on the ``PATH`` as ``python3`` or ``python``.
        - For Python 2 extraction, we also recommend having Python 2 installed and available on the ``PATH`` as ``python2``.
- On Windows, extraction of Python 2 or Python 3 requires the Python launcher to be installed and available on the ``PATH`` as ``py.exe``.
