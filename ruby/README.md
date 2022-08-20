# Ruby analysis support for CodeQL

This directory contains the extractor, CodeQL libraries, and queries that power Ruby
support in [LGTM](https://lgtm.com) and the other CodeQL products that [GitHub](https://github.com)
makes available to its customers worldwide.

It contains two major components:
  1. static analysis libraries and queries written in
     [CodeQL](https://codeql.github.com/docs/) that can be used to analyze such
     a database to find coding mistakes or security vulnerabilities.
  2. an extractor, written in Rust, that parses Ruby source code and converts it
     into a database that can be queried using CodeQL. See [Developer
     information](doc/HOWTO.md) for information on building the extractor (you
     do not need to do this if you are only developing queries).