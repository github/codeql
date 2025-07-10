This crate takes care of generating `ast.py` in the schema and `translate/generate.rs`
in the extractor.

It uses:
* `rust.ungram` from `ra_ap_syntax`
* a couple of slightly modified sources from `rust-analyzer` that are not published.

Both are fetched by bazel while building. In order to have proper IDE support and being
able to run cargo tooling in this crate, you can run
```bash
bazel run //rust/ast-generator:inject_sources
```
which will create the missing sources. Be aware that bazel will still use the source taken
directly from `rust-analyzer`, not the one in your working copy. Those should not need to be
update often though.
