This directory contains an extension pack for each supported threat model. Each pack should have the
same layout. To add a new threat model, just copy one of the existing packs, and update the following:

- In `qlpack.yml`, update the `name` to `codeql/threat-$name`, where `$name` is the name of the threat model.
- In `threat.model.yml`, change the single row of the `data` property to `- ["$name"]`

If creating these by copying and pasting becomes a burder, we can always automate the process with a script.
