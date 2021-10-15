# Upgrading the Ruby database schema

The schema (`ql/lib/ruby.dbscheme`) is automatically generated from tree-sitter's `node-types.json`. When the tree-sitter grammar changes, the database schema is likely to change as well, and we need to write an upgrade script. This document explains how to do that.

## Process Overview

 1. Commit the change to `ruby.dbscheme` (along with any library updates required to work with the change).
 2. Run `scripts/prepare-db-upgrade.sh`.
 3. Fill in the details in `upgrade.properties`, and add any required upgrade queries.

It may be helpful to look at some of the existing upgrade scripts, to see how they work.

## Details

### Generating a Ruby database upgrade script

Schema changes need to be accompanied by scripts that allow us to upgrade databases that were generated with older versions of the tools, so they can use new query functionality (albeit with possibly degraded results).

#### The easy (mostly automatic) way

The easy way to generate an upgrade script is to run the `scripts/prepare-db-upgrade.sh` script. This will generate a skeleton upgrade directory, leaving you to fill out the details in the `upgrade.properties` file.

#### upgrade.properties

It will look something like:

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

The `some_relation.rel` line(s) are the actions required to do the database upgrade. Do a diff on the the new vs old `.dbscheme` file to get an idea of what they have to achieve. Sometimes you won't need any upgrade commands – this happens when the dbscheme has changed in "cosmetic" ways, for example by adding/removing comments or changing union type relationships, but still retains the same on-disk format for all tables; the purpose of the upgrade script is then to document the fact that it's safe to replace the old dbscheme with the new one.

Some typical upgrade commands look like this:

```
// Delete a relation that has been replaced in the new scheme
obsolete.rel: delete

// Create a new version of a table by applying a simple RA expression to an
// existing table. The example duplicates the 'id' column of input.rel as
// the last column of etended.rel, perhaps to record our best guess at
// newly-populated "source declaration" information.
extended.rel: reorder input.rel (int id, string name, int parent) id name parent id

// Create relationname.rel by running relationname.qlo and writing the query
// results as a .rel file. The query file should be named relationname.ql and
// should be placed in the upgrade directory. It should avoid using the default
// QLL library, and will run in the context of the *old* dbscheme.
relationname.rel: run relationname.qlo
```

#### Testing your upgrade script

Upgrade scripts can be a little bit fiddly, so it's essential that you test them. You might do so as follows:

 1. Create a snapshot of your favourite project using the old version of the code.

 2. Switch to the new version of the code.

 3. Try to run some queries that will depend on your upgrade script working correctly.

 4. Observe the upgrade being performed in the query server log.

 5. Verify that your queries produced sensible results.

#### Doing the upgrade manually

To create the upgrade directory manually, without using `scripts/prepare-db-upgrade.sh`:

1. Get a hash of the old `.dbscheme` file, from just before your changes. You can do this by checking out the code prior to your changes and running `git hash-object ql/lib/ruby.dbscheme`

2. Go back to your branch and create an upgrade directory with that hash as its name, for example: `mkdir ql/lib/upgrades/454f1e15151422355049dc4f1f0486a03baeffef`

3. Copy the old `.dbscheme` file to that directory, using the name old.dbscheme.
   `cp ql/lib/ruby.dbscheme ql/lib/upgrades/454f1e15151422355049dc4f1f0486a03baeffef/old.dbscheme`

4. Put a copy of your new `.dbscheme` file in that directory and create an `upgrade.properties` file (as described above).
