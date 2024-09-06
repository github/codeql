"""
Schema description

This file should be kept simple:
* no flow control
* no aliases
* only class definitions with annotations and `include` calls

For how documentation of generated QL code works, please read `misc/codegen/schema_documentation.md`.
"""

from misc.codegen.lib.schemadefs import *

include("prefix.dbscheme")

@qltest.skip
class Element:
    pass


@qltest.collapse_hierarchy
class File(Element):
    name: string

@qltest.skip
@qltest.collapse_hierarchy
class Location(Element):
    file: File
    start_line: int
    start_column: int
    end_line: int
    end_column: int

class DbFile(File):
    pass

class DbLocation(Location):
    pass

@synth.on_arguments()
class UnknownFile(File):
    pass

@synth.on_arguments()
class UnknownLocation(Location):
    pass

@qltest.skip
class Locatable(Element):
    location: optional[Location]

class Declaration(Locatable):
    pass

class Module(Declaration):
    # TODO name
    declarations: list[Declaration] | child

class Function(Declaration):
    """
    A function declaration. For example
    ```
    fn foo(x: u32) -> u64 { (x + 1).into()
     }
    ```
    A function declaration within a trait might not have a body:
    ```
    trait Trait {
        fn bar();
    }
    ```
    """
    name: string
