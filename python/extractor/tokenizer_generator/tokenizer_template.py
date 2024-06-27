'''
Lookup table based tokenizer with state popping and pushing capabilities.
The ability to push and pop state is required for handling parenthesised expressions,
indentation, and f-strings. We also use it for handling the different quotation mark types,
but it is not essential for that, merely convenient.

'''



class Tokenizer(object):

    def __init__(self, text):
        self.text = text
        self.index = 0
        self.line_start_index = 0
        self.token_start_index = 0
        self.token_start = 1, 0
        self.line = 1
        self.super_state = START_SUPER_STATE
        self.state_stack = []
        self.indents = [0]
#ACTIONS-HERE
    def tokens(self, debug=False):
        text = self.text
        cls_table = CLASS_TABLE
        id_index = ID_INDEX
        id_chunks = ID_CHUNKS
        max_id = len(id_index)*256
#ACTION_TABLE_HERE
        state = 0
        try:
            if debug:
                while True:
                    c = ord(text[self.index])
                    if c < 128:
                        cls = cls_table[c]
                    elif c >= max_id:
                        cls = ERROR_CLASS
                    else:
                        b = id_chunks[id_index[c>>8]][(c>>2)&63]
                        cls = (b>>((c&3)*2))&3
                    prev_state = state
                    print("char = '%s', state=%d, cls=%d" % (text[self.index], state, cls))
                    state, transition = action_table[self.super_state[state][cls]]
                    print ("%s -> %s on %r in %s" % (prev_state, state, text[self.index], TRANSITION_STATE_NAMES[id(self.super_state)]))
                    if transition:
                        tkn = transition()
                        if tkn:
                            yield tkn
                    else:
                        self.index += 1
            else:
                while True:
                    c = ord(text[self.index])
                    if c < 128:
                        cls = cls_table[c]
                    elif c >= max_id:
                        cls = ERROR_CLASS
                    else:
                        b = id_chunks[id_index[c>>8]][(c>>2)&63]
                        cls = (b>>((c&3)*2))&3
                    state, transition = action_table[self.super_state[state][cls]]
                    if transition:
                        tkn = transition()
                        if tkn:
                            yield tkn
                    else:
                        self.index += 1
        except IndexError as ex:
            if self.index != len(text):
                #Reraise index error
                cls = cls_table[c]
                trans = self.super_state[state]
                action_index = trans[cls]
                action_table[action_index]
                # Not raised? Must have been raised in transition function.
                raise ex
            tkn = self.emit_indent()
            while tkn is not None:
                yield tkn
                tkn = self.emit_indent()
            end = self.line, self.index-self.line_start_index
            yield ENDMARKER, u"", self.token_start, end
            return

    def emit_indent(self):
        indent = 0
        index = self.line_start_index
        current = self.index
        here = self.line, current-self.line_start_index
        while index < current:
            if self.text[index] == ' ':
                indent += 1
            elif self.text[index] == '\t':
                indent = (indent+8) & -8
            elif self.text[index] == '\f':
                indent = 0
            else:
                #Unexpected state. Emit error token
                while len(self.indents) > 1:
                    self.indents.pop()
                result = ERRORTOKEN, self.text[self.token_start_index:self.index+1], self.token_start, here
                self.token_start = here
                self.line_start_index = self.index
                return result
            index += 1
        if indent == self.indents[-1]:
            self.token_start = here
            self.token_start_index = self.index
            return None
        elif indent > self.indents[-1]:
            self.indents.append(indent)
            start = self.line, 0
            result = INDENT, self.text[self.line_start_index:current], start, here
            self.token_start = here
            self.token_start_index = current
            return result
        else:
            self.indents.pop()
            if indent > self.indents[-1]:
                #Illegal indent
                result = ILLEGALINDENT, u"", here, here
            else:
                result = DEDENT, u"", here, here
                if indent < self.indents[-1]:
                    #More dedents to do
                    self.state_stack.append(self.super_state)
                    self.super_state = PENDING_DEDENT
            self.token_start = here
            self.token_start_index = self.index
            return result


ENCODING_RE = re.compile(br'.*coding[:=]\s*([-\w.]+).*')
NEWLINE_BYTES = b'\n'

def encoding_from_source(source):
    'Returns encoding of source (bytes), plus source strip of any BOM markers.'
    #Check for BOM
    if source.startswith(codecs.BOM_UTF8):
        return 'utf8', source[len(codecs.BOM_UTF8):]
    if source.startswith(codecs.BOM_UTF16_BE):
        return 'utf-16be', source[len(codecs.BOM_UTF16_BE):]
    if source.startswith(codecs.BOM_UTF16_LE):
        return 'utf-16le', source[len(codecs.BOM_UTF16_LE):]
    try:
        first_new_line = source.find(NEWLINE_BYTES)
        first_line = source[:first_new_line]
        second_new_line = source.find(NEWLINE_BYTES, first_new_line+1)
        second_line = source[first_new_line+1:second_new_line]
        match = ENCODING_RE.match(first_line) or ENCODING_RE.match(second_line)
        if match:
            ascii_encoding = match.groups()[0]
            encoding = ascii_encoding.decode("ascii")
            # Handle non-standard encodings that are recognised by the interpreter.
            if encoding.startswith("utf-8-"):
                encoding = "utf-8"
            elif encoding == "iso-latin-1":
                encoding = "iso-8859-1"
            elif encoding.startswith("latin-1-"):
                encoding = "iso-8859-1"
            elif encoding.startswith("iso-8859-1-"):
                encoding = "iso-8859-1"
            elif encoding.startswith("iso-latin-1-"):
                encoding = "iso-8859-1"
            return encoding, source
    except Exception as ex:
        print(ex)
        #Failed to determine encoding -- Just treat as default.
        pass
    return 'utf-8', source
