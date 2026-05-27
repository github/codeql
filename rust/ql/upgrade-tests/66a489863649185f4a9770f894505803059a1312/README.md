# Upgrade Regression Test for rust-analyzer 0.0.301 → 0.0.328

This test verifies that the dbscheme upgrade and downgrade scripts correctly preserve data when migrating databases between the old and new schemas.

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
8. Downgrade the database back to the old schema
9. Verify that the recovered old-schema properties still match

## Files

- `old.ql` / `old.expected`: Query for the old schema (validates extraction and downgrade)
- `new.ql` / `new.expected`: Query for the new schema (validates upgrade preserved data)
- `downgraded.ql` / `downgraded.expected`: Query for the downgraded old schema
- `upgrade_shapes.rs`: Rust source containing test shapes for all affected schema elements
- `run-test.sh`: Test runner script
