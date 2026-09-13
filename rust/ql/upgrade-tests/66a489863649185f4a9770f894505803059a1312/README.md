# Upgrade Regression Test for rust-analyzer 0.0.301 → 0.0.328

This test verifies that the dbscheme upgrade script correctly preserves data when migrating databases from the old schema to the new schema.

## Running the test

```bash
./run-test.sh
```

This will:
1. Stash any uncommitted changes
2. Check out the old commit (491c373e076)
3. Build the old extractor
4. Create a database with the old schema from `upgrade_shapes.rs`
5. Restore your branch
6. Upgrade the database to the new schema
7. Verify that the old properties are still accessible via the new schema

## Files

- `old.ql` / `old.expected`: Query for the old schema (validates extraction)
- `new.ql` / `new.expected`: Query for the new schema (validates upgrade preserved data)
- `upgrade_shapes.rs`: Rust source containing test shapes for all affected schema elements
- `run-test.sh`: Test runner script
