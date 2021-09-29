# Overview

This directory contains documments describing recurring challenges and our current best soloutions.

As such it will always be a work in progress.

Here follows a list of the challenges identified so far. Only some of these have descriptions at the moment. Feel free to chip in, if you have any suggestions or improvements. You are also welcome to create an issue for any new or existing item and assign yourself.

- CFG splitting
- Using intermediate data flow nodes to prevent quadratic blowup
- Handling aliasing
- Writing guards
- SSA
- Range analysis
- Syntactic sugar
- `LocalSourceNode`s
- Taint steps with side-effects
- Data flow configurations in .qll-files (suffix based?) (@smowton knows about this)
- Type tracking
- API graphs
- Stack graphs
- Data flow summaries (`FlowSummaryImpl.qll`)
- Models as data
- `::Range` pattern (and alternatives, e.g. instanceof)
- `pragma[only_bind_into]`
- Subtyping of parameterised types (generics)
- Performance tuning/debugging (old draft)
- Parsing of regular expressions
- Call graphs (via type tracking?)
- Virtual dispatch
- Extractor design (for free by treesitter?)
- Using consistency queries
- Inline testing
- Cached stages pattern (slides?)
- Something about the “layers” of analysis (AST -> CFG -> Local data flow -> Type - Tracking <-> Call graph -> API graphs -> Global data flow -> ...)
