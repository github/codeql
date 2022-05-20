# JavaScript extractor

This directory contains the source code of the JavaScript extractor. The extractor depends on various libraries that are not currently bundled with the source code, so at present it cannot be built in isolation.

The extractor consists of a parser for the latest version of ECMAScript, including a few proposed and historic extensions (see `src/com/semmle/jcorn`), classes for representing JavaScript and TypeScript ASTs (`src/com/semmle/js/ast` and `src/com/semmle/ts/ast`), and various other bits of functionality. Historically, the main entry point of the JavaScript extractor has been `com.semmle.js.extractor.Main`. However, this class is slowly being phased out in favour of `com.semmle.js.extractor.AutoBuild`, which is the entry point used by LGTM.

## License

Like the LGTM queries, the JavaScript extractor is licensed under [Apache License 2.0](LICENSE) by [GitHub](https://github.com). Some code is derived from other projects, whose licenses are noted in other `LICENSE-*.md` files in this folder.
