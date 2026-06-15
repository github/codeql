"""This module implements a LALR(1) Parser
"""
# Author: Erez Shinan (2017)
# Email : erezshin@gmail.com
from ..exceptions import UnexpectedToken

from .lalr_analysis import LALR_Analyzer, Shift

class Parser:
    def __init__(self, parser_conf):
        assert all(r.options is None or r.options.priority is None
                   for r in parser_conf.rules), "LALR doesn't yet support prioritization"
        analysis = LALR_Analyzer(parser_conf)
        analysis.compute_lookahead()
        callbacks = {rule: getattr(parser_conf.callback, rule.alias or rule.origin, None)
                          for rule in parser_conf.rules}

        self._parse_table = analysis.parse_table
        self.parser_conf = parser_conf
        self.parser = _Parser(analysis.parse_table, callbacks)
        self.parse = self.parser.parse

###{standalone

class _Parser:
    def __init__(self, parse_table, callbacks):
        self.states = parse_table.states
        self.start_state = parse_table.start_state
        self.end_state = parse_table.end_state
        self.callbacks = callbacks

    def parse(self, seq, set_state=None):
        i = 0
        token = None
        stream = iter(seq)
        states = self.states

        state_stack = [self.start_state]
        value_stack = []

        if set_state: set_state(self.start_state)

        def get_action(key):
            state = state_stack[-1]
            try:
                return states[state][key]
            except KeyError:
                expected = states[state].keys()
                raise UnexpectedToken(token, expected, state=state)  # TODO filter out rules from expected

        def reduce(rule):
            size = len(rule.expansion)
            if size:
                s = value_stack[-size:]
                del state_stack[-size:]
                del value_stack[-size:]
            else:
                s = []

            value = self.callbacks[rule](s)

            _action, new_state = get_action(rule.origin.name)
            assert _action is Shift
            state_stack.append(new_state)
            value_stack.append(value)

        # Main LALR-parser loop
        for i, token in enumerate(stream):
            while True:
                action, arg = get_action(token.type)
                assert arg != self.end_state

                if action is Shift:
                    state_stack.append(arg)
                    value_stack.append(token)
                    if set_state: set_state(arg)
                    break # next token
                else:
                    reduce(arg)

        while True:
            _action, arg = get_action('$END')
            if _action is Shift:
                assert arg == self.end_state
                val ,= value_stack
                return val
            else:
                reduce(arg)

###}
