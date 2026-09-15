# Downgrade Regression Test for rust-analyzer 0.0.328 -> 0.0.301

This test verifies that the dbscheme downgrade script correctly preserves recoverable data when migrating databases from the new schema back to the old schema.

## Running the test

```bash
./run-test.sh
```

This will:
1. Build the current extractor
2. Create a database with the new schema from `upgrade_shapes.rs`
3. Validate the new-schema extraction
4. Downgrade the database to the old schema
5. Check out the old commit (491c373e076)
6. Verify that the recovered old-schema properties still match

## Files

- `new.ql` / `new.expected`: Query for the new schema (validates extraction)
- `downgraded.ql` / `downgraded.expected`: Query for the downgraded old schema
- `upgrade_shapes.rs`: Rust source containing test shapes for all affected schema elements
- `run-test.sh`: Test runner script
