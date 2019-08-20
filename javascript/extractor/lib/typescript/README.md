TypeScript parser wrapper
-------------------------

The TypeScript "parser wrapper" is a Node.js program launched from the JavaScript
extractor in order to extract TypeScript code.

The two processes communicate via a command/response protocol via stdin/stdout.

Debugging
---------

To debug the parser script:

1. Launch an extraction process with the environment variable `SEMMLE_TYPESCRIPT_NODE_FLAGS`
   set to `--inspect`, or `--inspect-brk` if you wish to pause on entry.

2. Open VSCode and choose "Debug: Attach to Node process" from the command palette, and
   choose the process that looks like the parser-wrapper.
