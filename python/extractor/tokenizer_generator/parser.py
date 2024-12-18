
'''
    Explanation of the syntax

    start_decl: The starting transition table
    alias_decl: Declare short hand, e.g. digits = '0' or '1' or ...
    table_decl: Declare transition table: name and list of transitions.
    transition: Transitions from one state to another. From is: state (or choice of states) -> new-state for possible-characters [ do action or actions; ]
    action: Actions are:
        "emit(kind [, text]): emits a token of kind using the givn text or text from the stream. The token starts at the last mark and ends at the current location.
        "push(table)": pushes a transition table to the stack.
        "pop" : pops a transition table from the stack.
        "pushback": pushes the last character back to the stream.
        "mark": marks the current location as the start of the next token.
        "emit_indent": Emits zero or more INDENT or DEDENT tokens depending on current indentation.
        "newline": Increments the line number and sets the column offset back to zero.

    States:
        All states are given names.
        The state "0" is the start state and always exists.
        All other states are implicitly defined when used (this is for Python after all :)
        '*' means all states for which a transition is not explicitly defined.
        So the transitions:
            0 -> end for '\n'
            0 -> other for *
            0 -> a_b for 'a' or 'b'
        mean that '0' will transition to 'other' for all characters other than 'a', 'b' and `\n`.
        The order of transitions in the state machine description is irrelevant.
'''


grammar = r"""
start           : machine
machine         : declaration+
declaration     : alias_decl | table_decl | start_decl
start_decl      : "start" ":" IDENTIFIER
table_decl      : table_header "{" transition+ "}"
table_header    : "table" IDENTIFIER ( "(" IDENTIFIER ")" )?
alias_decl      : IDENTIFIER "=" choice
choice          : item ( "or" item)*
item            : alias | char
alias           : IDENTIFIER
char            : LITERAL
transition      : state_choice "->" state "for" (choice | any) action_list?
any             : "*"
state_choice    : state ( "or" state)*
state           : IDENTIFIER | DIGIT
action_list     : "do" action ";" (action ";")*
action          : emit | pop | push | pushback | mark | emit_indent | newline
emit            : "emit" "(" IDENTIFIER optional_text? ")"
optional_text   : "," LITERAL
pop             : "pop"
push            : "push" "(" IDENTIFIER ")"
pushback        : "pushback"
mark           : "mark"
emit_indent     : "emit_indent"
newline         : "newline"

LITERAL         :  ("\"" /[^"]/* "\"") | ("'" /[^']/* "'")
IDENTIFIER      :  LETTER ( LETTER | DIGIT | "_" )*
LETTER          :  "A".."Z" | "a".."z"
DIGIT           :  "0".."9"
WHITESPACE      :  (" " | "\t" | "\r" | "\n")+

%import common.NEWLINE
COMMENT         :  "#"  /(.)*/ NEWLINE
%ignore WHITESPACE
%ignore COMMENT
"""



from lark import Lark

class Parser(Lark):

    def __init__(self):
        Lark.__init__(self, grammar, parser="earley", lexer="standard")

def parse(src):
    parser = Parser()
    return parser.parse(src)

def main():
    import sys
    file = sys.argv[1]
    with open(file) as fd:
        tree = parse(fd.read())
    print(tree.pretty())

if __name__ == "__main__":
    main()
