
from . import test_tokenizer
import sys
from blib2to3.pgen2.token import tok_name

def printtoken(type, token, start, end): # for testing
    token_range = "%d,%d-%d,%d:" % (start + end)
    print("%-20s%-15s%r" %
        (token_range, tok_name[type], token)
    )


def main():
    verbose = sys.argv[1] == "-v"
    if verbose:
        inputfile = sys.argv[2]
    else:
        inputfile = sys.argv[1]
    with open(inputfile, "r") as input:
        t = test_tokenizer.Tokenizer(input.read()+"\n")
    for tkn in t.tokens(verbose):
        printtoken(*tkn)

if __name__ == "__main__":
    main()
