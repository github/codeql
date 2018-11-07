function RegExpParser(src) {
    this.src = src;
    this.pos = 0;
    this.errors = [];
    this.backrefs = [];
    this.maxbackref = 0;
}

RegExpParser.prototype.parse = function() {
    var res = this.Pattern();
    this.backrefs.forEach(function(backref) {
        if (backref.value > this.maxbackref)
            this.error(RegExpParser.INVALID_BACKREF, backref.range[0], backref.range[1]);
    }, this);
    return res;
};

RegExpParser.prototype.setRange = function(start, node) {
    node.range = [start, this.pos];
    return node;
};

RegExpParser.UNEXPECTED_EOS = 0;
RegExpParser.UNEXPECTED_CHARACTER = 1;
RegExpParser.EXPECTED_DIGIT = 2;
RegExpParser.EXPECTED_HEX_DIGIT = 3;
RegExpParser.EXPECTED_CONTROL_LETTER = 4;
RegExpParser.EXPECTED_CLOSING_PAREN = 5;
RegExpParser.EXPECTED_CLOSING_BRACE = 6;
RegExpParser.EXPECTED_EOS = 7;
RegExpParser.OCTAL_ESCAPE = 8;
RegExpParser.INVALID_BACKREF = 9;
RegExpParser.EXPECTED_RBRACKET = 10;
RegExpParser.EXPECTED_IDENTIFIER = 11;
RegExpParser.EXPECTED_CLOSING_ANGLE = 12;

RegExpParser.prototype.error = function(code, start, end) {
    if (typeof start !== 'number')
        start = this.pos;
    if (typeof end !== 'number')
        end = start+1;
    this.errors.push({
        type: 'Error',
        code: code,
        range: [start, end || start+1]
    });
};

RegExpParser.prototype.atEOS = function() {
    return this.pos >= this.src.length;
};

RegExpParser.prototype.nextChar = function() {
    if (this.atEOS()) {
        this.error(RegExpParser.UNEXPECTED_EOS);
        return '\0';
    } else {
        return this.src.substring(this.pos, ++this.pos);
    }
};

RegExpParser.prototype.readHexDigit = function() {
    if (/[0-9a-fA-F]/.test(this.src[this.pos]))
        return this.nextChar();
    this.error(RegExpParser.EXPECTED_HEX_DIGIT, this.pos);
    return '';
};

RegExpParser.prototype.readHexDigits = function(n) {
    var res = '';
    while (n-->0)
        res += this.readHexDigit();
    return res || '0';
};

RegExpParser.prototype.readDigits = function(opt) {
    var res = "";
    for (var c=this.src[this.pos]; /\d/.test(c); this.nextChar(), c=this.src[this.pos])
        res += c;
    if (!res.length && !opt)
        this.error(RegExpParser.EXPECTED_DIGIT);
    return res;
};

RegExpParser.prototype.readIdentifier = function() {
    var res = '';
    for (var c=this.src[this.pos]; c && /\w/.test(c); this.nextChar(), c=this.src[this.pos])
        res += c;
    if (!res.length)
        this.error(RegExpParser.EXPECTED_IDENTIFIER);
    return res;
};

RegExpParser.prototype.expectRParen = function() {
    if (!this.match(")"))
        this.error(RegExpParser.EXPECTED_CLOSING_PAREN, this.pos-1);
};

RegExpParser.prototype.expectRBrace = function() {
    if (!this.match("}"))
        this.error(RegExpParser.EXPECTED_CLOSING_BRACE, this.pos-1);
};

RegExpParser.prototype.expectRAngle = function() {
    if (!this.match(">"))
        this.error(RegExpParser.EXPECTED_CLOSING_ANGLE, this.pos-1);
}

RegExpParser.prototype.lookahead = function() {
    for (var i=0,n=arguments.length; i<n; ++i) {
        var prefix = arguments[i];
        if (prefix === null) {
            if (this.atEOS())
                return true;
        } else if (this.src.substring(this.pos, this.pos+prefix.length) === prefix) {
            return true;
        }
    }
    return false;
};

RegExpParser.prototype.match = function() {
    for (var i=0,n=arguments.length; i<n; ++i) {
        var prefix = arguments[i];
        if (this.lookahead(prefix)) {
            this.pos += (prefix||"").length;
            return true;
        }
    }
    return false;
};

RegExpParser.prototype.Pattern = function() {
    var res = this.Disjunction();
    if (!this.atEOS())
        this.error(RegExpParser.EXPECTED_EOS);
    return res;
};

RegExpParser.prototype.Disjunction = function() {
    var start = this.pos,
        disjuncts = [this.Alternative()];
    while (this.match("|"))
        disjuncts.push(this.Alternative());
    if (disjuncts.length === 1)
        return disjuncts[0];
    return this.setRange(start, {
        type: 'Disjunction',
        disjuncts: disjuncts
    });
};

RegExpParser.prototype.Alternative = function() {
    var start = this.pos,
        elements = [];
    while (!this.lookahead(null, "|", ")"))
        elements.push(this.Term());
    if (elements.length === 1)
        return elements[0];
    return this.setRange(start, {
        type: 'Sequence',
        elements: elements
    });
};

RegExpParser.prototype.Term = function() {
    var start = this.pos,
        dis;

    if (this.match("^"))
        return this.setRange(start, { type: 'Caret' });

    if (this.match("$"))
        return this.setRange(start, { type: 'Dollar' });

    if (this.match("\\b"))
        return this.setRange(start, { type: 'WordBoundary' });

    if (this.match("\\B"))
        return this.setRange(start, { type: 'NonWordBoundary' });

    if (this.match("(?=")) {
        dis = this.Disjunction();
        this.expectRParen();
        return this.setRange(start, {
            type: 'ZeroWidthPositiveLookahead',
            operand: dis
        });
    }

    if (this.match("(?!")) {
        dis = this.Disjunction();
        this.expectRParen();
        return this.setRange(start, {
            type: 'ZeroWidthNegativeLookahead',
            operand: dis
        });
    }

    if (this.match("(?<=")) {
        dis = this.Disjunction();
        this.expectRParen();
        return this.setRange(start, {
            type: 'ZeroWidthPositiveLookbehind',
            operand: dis
        });
    }

    if (this.match("(?<!")) {
        dis = this.Disjunction();
        this.expectRParen();
        return this.setRange(start, {
            type: 'ZeroWidthNegativeLookbehind',
            operand: dis
        });
    }

    return this.setRange(start, this.QuantifierOpt(this.Atom()));
};

RegExpParser.prototype.QuantifierOpt = function(atom) {
    var start = this.pos,
        res = atom;
    if (this.match("*"))
        res = { type: 'Star', operand: atom };
    else if (this.match("+"))
        res = { type: 'Plus', operand: atom };
    else if (this.match("?"))
        res = { type: 'Opt', operand: atom };
    else if (this.match("{")) {
        var lo = +this.readDigits(),
            hi = null;
        if (this.match(",") && !this.lookahead("}"))
            hi = +this.readDigits();
        this.expectRBrace();
        res = { type: 'Range', lo: lo, hi: hi, operand: atom };
    }
    if (this.match("?"))
        res.greedy = false;
    else if (res != atom)
        res.greedy = true;
    return this.setRange(start, res);
};

RegExpParser.prototype.Atom = function() {
    var start = this.pos;

    if (this.match("."))
        return this.setRange(start, { type: 'Dot' });

    if (this.match("\\"))
        return this.setRange(start, this.AtomEscape());

    if (this.lookahead("["))
        return this.CharacterClass();

    if (this.match("(")) {
        var capture = !this.match("?:"), name = null;

        if (this.match("?<")) {
            name = this.readIdentifier();
            this.expectRAngle();
        }

        if (capture)
            ++this.maxbackref;
        var number = this.maxbackref;
        var dis = this.Disjunction();
        this.expectRParen();
        return this.setRange(start, {
            type: 'Group',
            capture: capture,
            number: number,
            name: name,
            operand: dis
        });
    }

    var c = this.nextChar();
    if ("^$\\.*+?()[]{}|".indexOf(c) !== -1)
        this.error(RegExpParser.UNEXPECTED_CHARACTER, this.pos-1);
    return this.setRange(start, { type: 'Constant', value: c });
};

RegExpParser.prototype.AtomEscape = function(inCharClass) {
    var raw, value, codepoint;

    if (this.match("x")) {
        raw = this.readHexDigits(2);
        codepoint = parseInt(raw, 16);
        value = String.fromCharCode(codepoint);
        return {
            type: 'HexEscapeSequence',
            value: value,
            codepoint: codepoint,
            raw: '\\x' + raw
        };
    }

    if (this.match("u")) {
        if (this.match("{")) {
            var closePos = this.src.indexOf("}", this.pos);
            var n;
            if (closePos == -1) {
                // don't attempt to read any digits, but
                // report missing `}`
                n = 0;
            } else if (closePos == this.pos) {
                // empty escape sequence, trigger an error
                n = 1;
            } else {
                n = closePos - this.pos;
            }
            raw = this.readHexDigits(n);
            this.expectRBrace();
            codepoint = parseInt(raw, 16);
            raw = "{" + raw + "}"
        } else {
            raw = this.readHexDigits(4);
            codepoint = parseInt(raw, 16);
        }
        value = String.fromCharCode(codepoint);
        return {
            type: 'UnicodeEscapeSequence',
            value: value,
            codepoint: codepoint,
            raw: '\\u' + raw
        };
    }

    if (this.match("k<")) {
        var name = this.readIdentifier();
        this.expectRAngle();
        return {
            type: 'NamedBackReference',
            name: name,
            raw: "\\k<" + name + ">"
        };
    }

    if (this.match("p{", "P{")) {
        var name = this.readIdentifier(), value = null;
        if (this.match("="))
            value = this.readIdentifier();
        this.expectRBrace();
        return {
            type: 'UnicodePropertyEscape',
            name: name,
            value: value,
            raw: '\\p{' + name + (value ? '=' + value : '') + '}'
        };
    }

    var startpos = this.pos-1,
        c = this.nextChar();

    if (/[0-9]/.test(c)) {
        raw = c + this.readDigits(true);
        if (c === '0' || inCharClass) {
            var base = c === '0' && raw.length > 1 ? 8 : 10;
            codepoint = parseInt(raw, base);
            value = String.fromCharCode(codepoint);
            var type;
            if (base === 8) {
                type = 'OctalEscape';
                this.error(RegExpParser.OCTAL_ESCAPE, startpos, this.pos);
            } else {
                type = 'DecimalEscape';
            }

            return {
                type: type,
                value: value,
                codepoint: codepoint,
                raw: '\\' + raw
            };
        } else {
            var br = {
                type: 'BackReference',
                value: parseInt(raw, 10),
                raw: '\\' + raw
            };
            this.backrefs.push(br);
            return br;
        }
    }

    var ctrltab = "f\fn\nr\rt\tv\v", idx;
    if ((idx=ctrltab.indexOf(c)) % 2 == 0) {
        value = ctrltab.charAt(idx+1);
        return {
            type: 'ControlEscape',
            value: value,
            codepoint: value.charCodeAt(0),
            raw: '\\' + c
        };
    }

    if (c === 'c') {
        c = this.nextChar();
        if (!/[a-zA-Z]/.test(c))
            this.error(RegExpParser.EXPECTED_CONTROL_LETTER, this.pos-1);
        codepoint = c.charCodeAt(0) % 32;
        return {
            type: 'ControlLetter',
            value: String.fromCharCode(codepoint),
            codepoint: codepoint,
            raw: '\\c' + c
        };
    }

    if (/[dsw]/i.test(c)) {
        return {
            type: 'CharacterClassEscape',
            class: c,
            raw: '\\' + c
        };
    }

    return {
        type: 'IdentityEscape',
        value: c,
        codepoint: c.charCodeAt(0),
        raw: '\\' + c
    };
};

RegExpParser.prototype.CharacterClass = function() {
    var start = this.pos,
        elements = [];

    this.match("[");
    var inverted = this.match("^");
    while (!this.match("]")) {
        if (this.atEOS()) {
            this.error(RegExpParser.EXPECTED_RBRACKET);
            break;
        }
        elements.push(this.CharacterClassElement());
    }
    return this.setRange(start, {
        type: 'CharacterClass',
        elements: elements,
        inverted: inverted
    });
};

RegExpParser.prototype.CharacterClassElement = function() {
    var start = this.pos,
        atom = this.CharacterClassAtom();
    if (!this.lookahead("-]") && this.match("-"))
        return this.setRange(start, {
            type: 'CharacterClassRange',
            left: atom,
            right: this.CharacterClassAtom()
        });
    return atom;
};

RegExpParser.prototype.CharacterClassAtom = function() {
    var start = this.pos,
        c = this.nextChar();
    if (c === "\\") {
        if (this.match("b"))
          return this.setRange(start, {
              type: 'ControlEscape',
              value: '\b',
              codepoint: 8,
              raw: '\\b'
          });
        return this.setRange(start, this.AtomEscape(true));
    }
    return this.setRange(start, { type: 'Constant', value: c });
};

if (typeof exports !== 'undefined')
    exports.RegExpParser = RegExpParser;
