
import cpp
import CPython.Extensions

/* A call to an argument parsing function */
class PyArgParseTupleCall extends FunctionCall {

    PyArgParseTupleCall() {
        this.getTarget().hasGlobalName("PyArg_Parse") or
        this.getTarget().hasGlobalName("PyArg_ParseTuple") or
        this.getTarget().hasGlobalName("PyArg_VaParse") or
        this.getTarget().hasGlobalName("PyArg_ParseTupleAndKeywords") or
        this.getTarget().hasGlobalName("PyArg_VaParseAndKeywords")
    }

    private int getFormatIndex() {
        exists(Function f | f = this.getTarget() |
                (f.hasGlobalName("PyArg_Parse") or f.hasGlobalName("PyArg_ParseTuple") or f.hasGlobalName("PyArg_VaParse")) and result = 1
                or
                (f.hasGlobalName("PyArg_ParseTupleAndKeywords") or f.hasGlobalName("PyArg_VaParseAndKeywords")) and result = 2
             )
    }

    private string getFormatString() {
        result = this.getArgument(this.getFormatIndex()).(StringLiteral).getValue()
    }

    string getArgumentFormat() {
        exists(string fmt | fmt = this.getFormatString() |
               exists(int i | fmt.charAt(i) = ";" or fmt.charAt(i) = ":" | result = fmt.prefix(i))
               or
               not exists(int i | fmt.charAt(i) = ";" or fmt.charAt(i) = ":") and result = fmt
        )
    }

    string getPyArgumentType(int index) {
        parse_format_string(this.getArgumentFormat(), index, _, result) and result != "typed"
        or
        exists(int cindex, PythonClass cls | parse_format_string(this.getArgumentFormat(), index, cindex, "typed") |
                            cls.getAnAccess() = this.getArgument(this.getFormatIndex() * 2 + cindex).(AddressOfExpr).getOperand() and
                            result = cls.getTpName()
              )
        or
        exists(int cindex | parse_format_string(this.getArgumentFormat(), index, cindex, "typed") and
                            not exists(PythonClass cls | cls.getAnAccess() = this.getArgument(this.getFormatIndex() * 2 + cindex).(AddressOfExpr).getOperand())
                            and result = "object"
              )
    }

    predicate pyArgumentIsOptional(int index) {
        exists(string suffix | split_format_string(this.getArgumentFormat(), _, _, suffix, index, _) |
                                              suffix.charAt(0) = "|")
    }

    predicate pyArgumentIsKwOnly(int index) {
        exists(string suffix | split_format_string(this.getArgumentFormat(), _, _, suffix, index, _) |
                                              suffix.charAt(0) = "$")
    }

}

class PyUnpackTupleCall extends FunctionCall {

    PyUnpackTupleCall() {
        this.getTarget().hasGlobalName("PyArg_UnpackTuple")
    }

    int getMinSize() {
        result = this.getArgument(2).getValue().toInt()
    }

    int getMaxSize() {
        result = this.getArgument(3).getValue().toInt()
    }

}

predicate limiting_format(string text, string limit) {
    text = "t#" and limit = "read-only"
    or
    (text = "B" or text = "H" or text = "I" or text = "k" or text = "K") and limit = "non-negative"
    or
    (text = "c" or text = "C") and limit = "length-one"
}

predicate format_string(string text, string type, int cargs) {
    tuple_format(text, type, cargs) or simple_format(text, type, cargs)
}

private
predicate simple_format(string text, string type, int cargs) {
    text = "s" and (type = "str" or  type = "unicode") and cargs = 1
    or
    text = "s#" and (type = "str" or  type = "unicode") and cargs = 2
    or
    text = "s*" and (type = "str" or  type = "unicode") and cargs = 1
    or
    text = "z" and (type = "str" or  type = "unicode" or type = "NoneType") and cargs = 1
    or
    text = "z#" and (type = "str" or  type = "unicode" or type = "NoneType" or type = "buffer") and cargs = 2
    or
    text = "z*" and (type = "str" or  type = "unicode" or type = "NoneType" or type = "buffer") and cargs = 1
    or
    text = "u" and type = "unicode" and cargs = 1
    or
    text = "u#" and type = "unicode" and cargs = 2
    or
    text = "O" and type = "object" and cargs = 1
    or
    text = "p" and type = "object" and cargs = 1
    or
    text = "O&" and type = "object" and cargs = 2
    or
    text = "O!" and type = "typed" and cargs = 2
    or
    (text = "b" or text = "h" or text = "i" or text = "l" or text = "L" or text = "n") and type = "int" and cargs = 1
    or
    (text = "B" or text = "H" or text = "I" or text = "k" or text = "K") and type = "int" and cargs = 1
    or
    text = "c" and (type = "bytes" or type = "bytearray") and cargs = 1
    or
    text = "C" and type = "unicode" and cargs = 1
    or
    text = "D" and type = "complex" and cargs = 1
    or
    (text = "f" or text = "d") and type = "float" and cargs = 1
    or
    text = "S" and type = "str" and cargs = 1
    or
    text = "U" and type = "unicode" and cargs = 1
    or
    text = "t#" and type = "buffer" and cargs = 2
    or
    text = "w" and type = "buffer" and cargs = 1
    or
    text = "w#" and type = "buffer" and cargs = 2
    or
    text = "w*" and type = "buffer" and cargs = 1
    or
    (text = "es" or text = "et") and (type = "str" or  type = "unicode" or type = "buffer") and cargs = 2
    or
    (text = "es#" or text = "et#") and (type = "str" or  type = "unicode" or type = "buffer") and cargs = 3
    or
    text = "y" and type = "bytes" and cargs = 1
    or
    text = "y*" and (type = "bytes" or type = "bytearray" or type = "buffer") and cargs = 1
    or
    text = "y#" and (type = "bytes" or type = "bytearray" or type = "buffer") and cargs = 2
}

private
predicate tuple_format(string text, string type, int cargs) {
    type = "tuple" and
    exists(PyArgParseTupleCall call | exists(call.getArgumentFormat().indexOf(text)))
    and
    exists(string body | text = "(" + body + ")" | tuple_body(body, _, cargs))
}

private
predicate tuple_body(string body, int pyargs, int cargs) {
    body = "" and cargs = 0 and pyargs = 0
    or
    (exists(PyArgParseTupleCall call | exists(call.getArgumentFormat().indexOf(body))) and
     exists(string p, int pargs, string s, int sargs, int pyargsm1 | pyargs = pyargsm1+1 and tuple_body(p, pyargsm1, pargs) and
                                                                     format_string(s, _, sargs) and body = p + s and cargs = pargs + sargs)
    )
}

predicate format_token(string token, int delta, int cdelta) {
    format_string(token, _, cdelta) and delta = 1
    or
    token = "|" and delta = 0 and cdelta = 0
    or
    token = "$" and delta = 0 and cdelta = 0
}

predicate split_format_string(string full, string prefix, string text, string suffix, int index, int cindex) {
    exists(PyArgParseTupleCall call | call.getArgumentFormat() = full) and
    full = prefix + text + suffix and
    (suffix = "" or exists(string s | suffix.prefix(s.length()) = s | format_token(s, _, _))) and
    format_token(text, _, _) and
    (prefix = "" and index = 0 and cindex = 0 and suffix = full.suffix(text.length())
     or
     exists(string prefixm1, string suffixm1, string textm1, int im1, int cim1, int prev, int cprev |
            full = prefixm1 + textm1 + suffixm1 and
            split_format_string(full, prefixm1, textm1, suffixm1, im1, cim1) and
            format_token(textm1, prev, cprev) and
            index = im1+prev and
            cindex = cim1+cprev and
            prefix = prefixm1 + textm1 and
            suffix = suffixm1.suffix(text.length()) and
            text = suffixm1.prefix(text.length())
           )
    )
}

predicate parse_format_string(string full, int index, int cindex, string type) {
    exists(string prefix, string text, string suffix | split_format_string(full, prefix, text, suffix, index, cindex) and format_string(text, type, _))
}
