---
category: minorAnalysis
---
* The C# extractor now accepts an extractor option `compression`, which is used to decide the compression format for TRAP files. The legal options are `brotli` (default), `gzip` or `none`.
* The C# extractor no longer accepts `--no-brotli` or `--brotli` flags to switch between `gzip` and `brotli` as compression method for TRAP files.