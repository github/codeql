import codeql.rust.elements
import TestUtils

select any(AstNode n | toBeTested(n))
