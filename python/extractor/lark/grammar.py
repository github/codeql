class Symbol(object):
    is_term = NotImplemented

    def __init__(self, name):
        self.name = name

    def __eq__(self, other):
        assert isinstance(other, Symbol), other
        return self.is_term == other.is_term and self.name == other.name

    def __ne__(self, other):
        return not (self == other)

    def __hash__(self):
        return hash(self.name)

    def __repr__(self):
        return '%s(%r)' % (type(self).__name__, self.name)

class Terminal(Symbol):
    is_term = True

    def __init__(self, name, filter_out=False):
        self.name = name
        self.filter_out = filter_out


class NonTerminal(Symbol):
    is_term = False

class Rule(object):
    """
        origin : a symbol
        expansion : a list of symbols
    """
    def __init__(self, origin, expansion, alias=None, options=None):
        self.origin = origin
        self.expansion = expansion
        self.alias = alias
        self.options = options

    def __str__(self):
        return '<%s : %s>' % (self.origin, ' '.join(map(str,self.expansion)))

    def __repr__(self):
        return 'Rule(%r, %r, %r, %r)' % (self.origin, self.expansion, self.alias, self.options)


class RuleOptions:
    def __init__(self, keep_all_tokens=False, expand1=False, priority=None):
        self.keep_all_tokens = keep_all_tokens
        self.expand1 = expand1
        self.priority = priority

    def __repr__(self):
        return 'RuleOptions(%r, %r, %r)' % (
            self.keep_all_tokens,
            self.expand1,
            self.priority,
        )
