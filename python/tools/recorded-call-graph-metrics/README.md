# Recorded Call Graph Metrics

also known as _call graph tracing_.

Execute a python program and for each call being made, record the call and callee. This allows us to compare call graph resolution from static analysis with actual data -- that is, can we statically determine the target of each actual call correctly.

This is still in the early stages, and currently only supports a very minimal working example (to show that this approach might work).

The next hurdle is being able to handle multiple calls on the same line, such as

- `foo(); bar()`
- `foo(bar())`
- `foo().bar()`

## How do I give it a spin?

Run the `recreate-db.sh` script to create the database `cg-trace-example-db`, which will include the `example/simple.xml` trace from executing the `example/simple.py` code. Then run the queries inside the `ql/` directory.
