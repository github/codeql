# The Python libraries

The Python libraries are a collection of libraries for analysing Python code.
Everything can be imported by importing `python.qll`.

## The analysis layers

The analysis is built up in layers. the stack looks like this:

- AST (coms from the extractor)
- Control flow graph (CFG) (built by the extractor)
- SSA
- Call graph
- Data flow

## Avoiding non-monotonic recursion

Given the many interacting layers, it is important to decide which predicates are allowed to be mutually recursive in order to avoid non-monotonic recursion when negation is used to express the predicates.
As an example, we have defined local source as those which do not receive local flow. This means that the local flow relation is not allowed to be recursive with anything depending on local sources.

Some particular restrictions to keep in mind:

- Typetracking needs to use a local flow step not including summaries
- Typetracking needs to use a call graph not including summaries
