import sys
import tokenize
import token

def printtoken(type, token, start, end, _): 
    # Use Python 3 tokenize style output, regardless of version
    if tokenize.tok_name[type] not in ("ENCODING", "NL"):
        token_range = "%d,%d-%d,%d:" % (start + end)
        print("%-20s%-15s%r" %
            (token_range, tokenize.tok_name[type], token)
        )

OP_TYPES = {
    "(" : token.LPAR,
    ")" : token.RPAR,
    "[" : token.LSQB,
    "]" : token.RSQB,
    "{" : token.LBRACE,
    "}" : token.RBRACE,
    ":" : token.COLON,
    "," : token.COMMA,
    "." : token.DOT,
    "@" : token.AT,
    }

def main():
    readline = open(sys.argv[1], "rb").readline
    if sys.version < "3":
        tokenize.tokenize(readline, printtoken)
    else:
        for type, token, start, end, _ in tokenize.tokenize(readline):
            if tokenize.tok_name[type] == "OP":
                type = OP_TYPES.get(token, type)
            if tokenize.tok_name[type] not in ("ENCODING", "NL"):
                printtoken(type, token, start, end, _)

if __name__ == "__main__":
    main()
