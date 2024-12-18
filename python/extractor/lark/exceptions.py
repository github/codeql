from .utils import STRING_TYPE

class LarkError(Exception):
    pass

class GrammarError(LarkError):
    pass

class ParseError(LarkError):
    pass

class LexError(LarkError):
    pass

class UnexpectedInput(LarkError):
    pos_in_stream = None

    def get_context(self, text, span=40):
        pos = self.pos_in_stream
        start = max(pos - span, 0)
        end = pos + span
        before = text[start:pos].rsplit('\n', 1)[-1]
        after = text[pos:end].split('\n', 1)[0]
        return before + after + '\n' + ' ' * len(before) + '^\n'

    def match_examples(self, parse_fn, examples):
        """ Given a parser instance and a dictionary mapping some label with
            some malformed syntax examples, it'll return the label for the
            example that bests matches the current error.
        """
        assert self.state is not None, "Not supported for this exception"

        candidate = None
        for label, example in examples.items():
            assert not isinstance(example, STRING_TYPE)

            for malformed in example:
                try:
                    parse_fn(malformed)
                except UnexpectedInput as ut:
                    if ut.state == self.state:
                        try:
                            if ut.token == self.token:  # Try exact match first
                                return label
                        except AttributeError:
                            pass
                        if not candidate:
                            candidate = label

        return candidate


class UnexpectedCharacters(LexError, UnexpectedInput):
    def __init__(self, seq, lex_pos, line, column, allowed=None, considered_tokens=None, state=None):
        message = "No terminal defined for '%s' at line %d col %d" % (seq[lex_pos], line, column)

        self.line = line
        self.column = column
        self.allowed = allowed
        self.considered_tokens = considered_tokens
        self.pos_in_stream = lex_pos
        self.state = state

        message += '\n\n' + self.get_context(seq)
        if allowed:
            message += '\nExpecting: %s\n' % allowed

        super(UnexpectedCharacters, self).__init__(message)



class UnexpectedToken(ParseError, UnexpectedInput):
    def __init__(self, token, expected, considered_rules=None, state=None):
        self.token = token
        self.expected = expected     # XXX str shouldn't necessary
        self.line = getattr(token, 'line', '?')
        self.column = getattr(token, 'column', '?')
        self.considered_rules = considered_rules
        self.state = state
        self.pos_in_stream = getattr(token, 'pos_in_stream', None)

        message = ("Unexpected token %r at line %s, column %s.\n"
                   "Expected: %s\n"
                   % (token, self.line, self.column, ', '.join(self.expected)))

        super(UnexpectedToken, self).__init__(message)
