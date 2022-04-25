// TODO: Update the doc together with the new C++ generation

# Trap entry classes generation

Files under `./generated` are generated from the `dbscheme` file by `misc/codegen/codegen.py`.
Each table therein will result in a generated entry class here:

* the struct name is a camel-case version of the table name;
* the struct fields are derived from table columns:
  * `@` types (both `ref` and not) are mapped to `trap::Label` with the appropriate tag,
  * `int` and `string` types are mapped to `int` and `std::string` respectively,
  * the type can be overridden, see `field_overrides` in the generator script.
    This is currently used to map some types to `unsigned` instead of `int`.

`Entries.h` will include all other generated files.

`Tags.h` models the hierarchy of `@` id types, and is used to type-check `trap::Label` fields.
