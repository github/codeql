# Upgrading a language database schema

When a `.dbscheme` file changes, you need to provide two things:

1. An upgrade script that modifies old databases (built against an earlier schema), so they can use new query functionality (albeit with possibly degraded results).
2. A downgrade script that reverses those changes, so that newer databases can be queried using older query and library packs.

This document explains how to write or generate those scripts.

## Process Overview

 1. Commit the change to your language's `.dbscheme` file, along with any library updates required to work with the change.
 2. Run `misc/scripts/prepare-db-upgrade.sh --lang <lang>`. This will generate skeleton upgrade/downgrade scripts in the appropriate directories.
 3. Fill in the details in the two `upgrade.properties` files that it generated, and add any required upgrade queries.

The generated directory names are hashes of the old and new `.dbscheme` files. If the
schema changes after generating the scripts, delete the generated directories and run the
script again so that the directory names and schema snapshots use the correct hashes.

It may be helpful to look at some of the existing upgrade/downgrade scripts, to see how they work.

## Details

An `upgrade.properties` file will look something like:

```
description: what it does
compatibility: partial
some_relation.rel: run some_relation.qlo
```

The `description` field is a textual description of the aim of the step. Describe the
operation in its actual direction: for example, a downgrade that removes a newly added
table should say that it removes the table.

The `compatibility` field takes one of four values. In these definitions, the source schema is
`old.dbscheme`, and the target schema is the other `.dbscheme` in the script directory. Thus,
the source is the older schema for an upgrade and the newer schema for a downgrade.

 * **full**: query results from the transformed database will be identical to results from a database built with the target version of the toolchain.

 * **backwards**: the step is safe and preserves the meaning of the source database, but features provided by the target query and library packs may not work correctly on the transformed database.

 * **partial**: the step is safe and preserves the meaning of the source database, but rebuilding the database with the target version of the toolchain would produce better results.

 * **breaking**: the step is unsafe and will prevent certain target queries from working.

Choose compatibility independently for the upgrade and downgrade, because the two directions
may preserve different amounts of information.

The `some_relation.rel` line(s) are the actions required to transform the database in the
direction of the step. Upgrade and downgrade directories use the same file name and command
syntax, even though a file in a downgrade directory describes a downgrade. Diff `old.dbscheme`
against the target `.dbscheme` in the generated directory to determine which actions are
needed.

No action is needed for a relation added by the target schema if it should be empty in the
transformed database. A missing relation is treated as empty, so do not add a `.rel` line just
to create an empty file. If extraction would populate the new relation, however, the upgrade
is not `full`: it will usually be `backwards`, because queries using the new relation may have
degraded results on upgraded databases.

A relation that exists in `old.dbscheme` but not in the target schema should normally be
deleted explicitly with `relation.rel: delete` so that the transformation does not leave
obsolete data behind.

Sometimes no commands are needed because the schema changed only cosmetically, for example
by adding or removing comments or changing union type relationships without changing the
on-disk format. The script then documents that it is safe to replace the old schema with the
new one.

Ideally, your downgrade script will perfectly revert the changes applied by the upgrade script, such that applying the upgrade and then the downgrade will result in the same database you started with.

Some typical upgrade or downgrade commands look like this:

```
// Delete a relation that does not exist in the target schema
obsolete.rel: delete

// Create a new version of a table by applying an expression (using a simple
// synthetic language) to an existing table. The example duplicates the 'id'
// column of input.rel as the last column of extended.rel, perhaps to record our
// best guess at newly-populated "source declaration" information.
extended.rel: reorder input.rel (int id, string name, int parent) id name parent id

// Create relationname.rel by running relationname.qlo and writing the query
// results as a .rel file. The query file should be named relationname.ql and
// should be placed in the upgrade directory. It should avoid using the default
// QLL library, and will run in the context of the *old* dbscheme.
relationname.rel: run relationname.qlo

// Create relation1.rel by running the query predicate 'predicate1' in upgrade.qlo
// and writing the query results as a .rel file, and running 'predicate2' in
// upgrade.qlo and writing the query results as a .rel file. This command
// expects the upgrade relation to be a query predicate, which has the advantage
// of allowing multiple upgrade relations to appear in the same .ql file as
// multiple query predicates. The query file should be named upgrade.ql and
// should be placed in the upgrade directory. It should avoid using the default
// QLL library, and will run in the context of the *old* dbscheme.
relation1.rel: run upgrade.qlo predicate1
relation2.rel: run upgrade.qlo predicate2
```

### Testing your scripts

Although we have some automated testing of the scripts (e.g. to test that you can upgrade databases all the way from an initial dbscheme to the newest, and back), it's essential that you apply some more rigorous testing for any non-trivial upgrade or downgrade. You might do so as follows:

#### Running qltests

To test the upgrade script, run:

```
codeql test run --search-path=<old-extractor-pack> --search-path=<codeql-root> <test-dir>
```

Where `<old-extractor-pack>` is an extractor pack containing the old extractor and dbscheme that pre-date your changes, `<test-dir>` is the directory containing the qltests for your language, and `<codeql-root>` is the root directory of the `github/codeql` clone that contains `<test-dir>`. This will run the tests using an old extractor, and the test databases will all be upgraded in place using your new upgrade script.

To test the downgrade script, create an extractor pack that includes your new dbscheme and extractor changes. Then checkout the `main` branch of `codeql` (i.e. a branch that does not include your changes), and run:

```
codeql test run --search-path=<new-extractor-pack> <test-dir>
```

This will run the tests using your new extractor, and the databases will be downgraded using your new downgrade script so that they match the dbscheme of the `main` branch.

#### Manual testing

You might also choose to test with a real-world database.

 1. Create a snapshot of your favourite project using the old version of the code.

 2. Switch to the new version of the code.

 3. Try to run some queries that will depend on your upgrade script working correctly.

 4. Observe the upgrade being performed in the query server log.

 5. Verify that your queries produced sensible results.

#### Creating the scripts manually

To create both directions manually, without using `prepare-db-upgrade.sh`, run the following
commands from the repository root. First set `lang` to the language directory and `schema_file`
to the repository-relative path of its `.dbscheme` file. For example, for Go:

	```sh
	lang=go
	schema_file=go/ql/lib/go.dbscheme
	```

1. Get the hashes of the old `.dbscheme` from `main` and the new `.dbscheme` from
	your branch. For example:

	```sh
	old_hash=$(git show "main:$schema_file" | git hash-object --stdin)
	new_hash=$(git hash-object "$schema_file")
	```

2. Create the upgrade directory using the old hash and the downgrade directory using the
	new hash:

	```sh
	upgrade_dir="$lang/ql/lib/upgrades/$old_hash"
	downgrade_dir="$lang/downgrades/$new_hash"
	mkdir -p "$upgrade_dir" "$downgrade_dir"
	```

3. Populate the upgrade directory. Here, `old.dbscheme` is the schema from `main`, and
	the other `.dbscheme` file is the new target schema:

	```sh
	git show "main:$schema_file" > "$upgrade_dir/old.dbscheme"
	cp "$schema_file" "$upgrade_dir/$(basename "$schema_file")"
	```

4. Populate the downgrade directory in the opposite direction. For a downgrade, the new
	schema is called `old.dbscheme`, because it is the schema before the downgrade step:

	```sh
	cp "$schema_file" "$downgrade_dir/old.dbscheme"
	git show "main:$schema_file" > "$downgrade_dir/$(basename "$schema_file")"
	```

5. Create an `upgrade.properties` file in each directory. The file in the upgrade directory
	describes the forward transformation, while the file in the downgrade directory describes
	the reverse transformation.

### Debugging your scripts

Database upgrade/downgrade may fail for several reasons. To find out the exact issue it is recommended to rerun the `codeql test run` commands from above in a verbose mode, e.g. `codeql test run -vvvv ...`.
