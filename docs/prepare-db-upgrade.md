# Upgrading a language database schema

When a `.dbscheme` file changes, you need to provide two things:

1. An upgrade script that modifies old databases (built against an earlier schema), so they can use new query functionality (albeit with possibly degraded results).
2. A downgrade script that reverses those changes, so that newer databases can be queried using older query and library packs.

This document explains how to write or generate those scripts.

## Process Overview

 1. Commit the change to your language's `.dbscheme` file, along with any library updates required to work with the change.
 2. Run `misc/scripts/prepare-db-upgrade.sh --lang <lang>`. This will generate skeleton upgrade/downgrade scripts in the appropriate directories.
 3. Fill in the details in the two `upgrade.properties` files that it generated, and add any required upgrade queries.

It may be helpful to look at some of the existing upgrade/downgrade scripts, to see how they work.

## Details

An `upgrade.properties` file will look something like:

```
description: what it does
compatibility: partial
some_relation.rel: run some_relation.qlo
```

The `description` field is a textual description of the aim of the upgrade.

The `compatibility` field takes one of four values:

 * **full**: results from the upgraded snapshot will be identical to results from a snapshot built with the new version of the toolchain.

 * **backwards**: the step is safe and preserves the meaning of the old database, but new features may not work correctly on the upgraded snapshot.

 * **partial**: the step is safe and preserves the meaning of the old database, but you would get better results if you rebuilt the snapshot with the new version of the toolchain.

 * **breaking**: the step is unsafe and will prevent certain queries from working.

The `some_relation.rel` line(s) are the actions required to perform the database upgrade. Do a diff on the the new vs old `.dbscheme` file to get an idea of what they have to achieve. Sometimes you won't need any upgrade commands – this happens when the dbscheme has changed in "cosmetic" ways, for example by adding/removing comments or changing union type relationships, but still retains the same on-disk format for all tables; the purpose of the upgrade script is then to document the fact that it's safe to replace the old dbscheme with the new one.

Ideally, your downgrade script will perfectly revert the changes applied by the upgrade script, such that applying the upgrade and then the downgrade will result in the same database you started with.

Some typical upgrade commands look like this:

```
// Delete a relation that has been replaced in the new scheme
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
```

### Testing your scripts

Although we have some automated testing of the scripts (e.g. to test that you can upgrade databases all the way from an initial dbscheme to the newest, and back), it's essential that you apply some more rigorous testing for any non-trivial upgrade or downgrade. You might do so as follows:

#### Running qltests

To test the upgrade script, run:

```
codeql test run --search-path=<old-extractor-pack> --search-path=ql <test-dir>
```

Where `<old-extractor-pack>` is an extractor pack containing the old extractor and dbscheme that pre-date your changes, and `<test-dir>` is the directory containing the qltests for your language. This will run the tests using an old extractor, and the test databases will all be upgraded in place using your new upgrade script.

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

#### Doing the upgrade manually

To create the upgrade directory manually, without using `prepare-db-upgrade.sh`:

1. Get a hash of the old `.dbscheme` file from `main` (i.e. from just before your changes). You can do this by checking out the code prior to your changes and running `git hash-object ql/lib/<mylang>.dbscheme`

2. Go back to your branch and create an upgrade directory with that hash as its name, for example:
```
mkdir ql/lib/upgrades/454f1e15151422355049dc4f1f0486a03baeffef
```


3. Copy the old `.dbscheme` file to that directory, using the name old.dbscheme.

```
cp ql/lib/<mylang>.dbscheme ql/lib/upgrades/454f1e15151422355049dc4f1f0486a03baeffef/old.dbscheme
```

4. Put a copy of your new `.dbscheme` file in that directory and create an `upgrade.properties` file (as described above).

#### Doing the downgrade manually

The process is similar for downgrade scripts, but there is a reversal in terminology: your **new** dbscheme will now be the one called `old.dbscheme`.

1. Get a hash of your new `.dbscheme` file, with `git hash-object ql/lib/<mylang>.dbscheme`

2. Create a downgrade directory with that hash as its name, for example:
```
mkdir downgrades/9fdd1d40fd3c3f8f9db8fabf5a353580d14c663a
```

3. Copy your new `.dbscheme` file to that directory, using the name `old.dbscheme`.
```
cp ql/lib/<mylang>.dbscheme ql/lib/upgrades/454f1e15151422355049dc4f1f0486a03baeffef/old.dbscheme
```

4. Put a copy of the `.dbscheme` from `main` in that directory and create an `upgrade.properties` file that performs the downgrade (as described above).
