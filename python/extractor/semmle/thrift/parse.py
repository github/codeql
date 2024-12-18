
# This grammar is based on https://github.com/apache/thrift/blob/master/doc/specs/idl.md
grammar = r"""
start           :  document
document        :  header* definition*
header          :  include | cppinclude | namespace
include         :  "include" LITERAL
cppinclude      :  "cpp_include" LITERAL
namespace       :  ( "namespace" ( namespacescope name )
                |                ( "smalltalk.prefix" name ) )
                |  ( "php_namespace" LITERAL )
                |  ( "xsd_namespace" LITERAL )
!namespacescope :  "*" | IDENTIFIER
definition      :  const | typedef | enum | senum | struct | union | exception | service
const           :  "const" fieldtype name "=" constvalue _listseparator?
typedef         :  "typedef" definitiontype type_annotations name type_annotations _listseparator?
enum            :  "enum" name "{" enumfield* "}" type_annotations
enumfield       :  name enumvalue type_annotations _listseparator?
enumvalue       : ("=" INTCONSTANT)?
senum           :  "senum" name "{" senumfield* "}"
senumfield      :  LITERAL _listseparator?
struct          :  "struct" name "xsd_all"? "{" field* "}" type_annotations
name            :  IDENTIFIER
union           :  "union" name "xsd_all"? "{" field* "}"
exception       :  "exception" name "{" field* "}"
service         :  "service" name extends? "{" function* "}" type_annotations
extends         :  "extends" IDENTIFIER
field           :  fieldid fieldreq fieldtype type_annotations IDENTIFIER fieldvalue xsdfieldoptions type_annotations _listseparator?
fieldvalue      : ("=" constvalue)?
fieldid         :  (INTCONSTANT ":")?
fieldreq       :  ("required" | "optional")?
?xsdfieldoptions:  "xsd_optional"? "xsd_nillable"? xsdattrs?
xsdattrs        :  "xsd_attrs" "{" field* "}"
function        :  oneway functiontype name "(" field* ")" throws type_annotations _listseparator?
oneway          :  ("oneway")?
!functiontype   :  fieldtype | "void"
throws          :  ( "throws" "(" field* ")" )?
fieldtype       :  IDENTIFIER | basetype | containertype
definitiontype  :  IDENTIFIER | basetype | containertype
!basetype       :  "bool" | "byte" | "i8" | "i16" | "i32" | "i64" | "double" | "string" | "binary" | "slist"
containertype   :  maptype | settype | listtype
maptype         :  "map" cpptype? "<" fieldtype "," fieldtype ">"
settype         :  "set" cpptype? "<" fieldtype ">"
listtype        :  "list" "<" fieldtype ">" cpptype?
cpptype         :  "cpp_type" LITERAL
!constvalue     :  INTCONSTANT | DOUBLECONSTANT | LITERAL | IDENTIFIER | constlist | constmap
INTCONSTANT     :  ("+" | "-")? DIGIT+
DOUBLECONSTANT  :  ("+" | "-")? DIGIT* "." DIGIT+ ( ("E" | "e") INTCONSTANT )?
constlist       :  "[" constlistelt* "]"
constlistelt    :  constvalue _listseparator?
constmap        :  "{" constmapelt* "}"
constmapelt     :  constvalue ":" constvalue _listseparator?

type_annotations : ( "(" type_annotation* ")" )?
type_annotation : name "=" constvalue _listseparator?

LITERAL         :  ("\"" /[^"]/* "\"") | ("'" /[^']/* "'")
IDENTIFIER      :  ( LETTER | "_" ) ( LETTER | DIGIT | "." | "_" )*
_listseparator   :  "," | ";"
LETTER          :  "A".."Z" | "a".."z"
DIGIT           :  "0".."9"
WHITESPACE      :  (" " | "\t" | "\r" | "\n")+

%import common.NEWLINE
COMMENT         :  "/*" /(.|\n|\r)*?/ "*/"
                |  "//" /(.)*/ NEWLINE
                |  "#"  /(.)*/ NEWLINE
%ignore WHITESPACE
%ignore COMMENT
"""




from lark import Lark

class Parser(Lark):

    def __init__(self):
        Lark.__init__(self, grammar, parser="earley", lexer="standard")

def parse(src):
    return parser.parse(src)
