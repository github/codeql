# Recorded Call Graph Metrics

also known as _call graph tracing_.

Execute a python program and for each call being made, record the call and callee. This allows us to compare call graph resolution from static analysis with actual data -- that is, can we statically determine the target of each actual call correctly.

This is still in the early stages, and currently only supports a very minimal working example (to show that this approach might work).

The next hurdle is being able to handle multiple calls on the same line, such as

- `foo(); bar()`
- `foo(bar())`
- `foo().bar()`

## How do I give it a spin?

Run the `recreate-db.sh` script to create the database `cg-trace-example-db`. Then run the queries inside the `ql/` directory.


## Limitations

### Code that uses `sys.setprofile`

Since that is our mechanism for recording calls, any code that uses `sys.setprofile` will not work together with the call-graph tracer.

### Class instantiation

Does not always fire off an event in the `sys.setprofile` function (neither in `sys.settrace`), so is not recorded. Example:

```
r = range(10)
```

when disassembled (`python -m dis <file>`):

```
  9          48 LOAD_NAME                7 (range)
             50 LOAD_CONST               5 (10)
             52 CALL_FUNCTION            1
             54 STORE_NAME               8 (r)
```

but no event :disappointed:
