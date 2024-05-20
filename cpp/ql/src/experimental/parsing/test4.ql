import glr

string grammar4() {
    result = ["G -> E", "E -> E + I", "E -> E - I", "E -> I"]
}

string input4(int i) { result = "I+I-I".charAt(i) }

module Test4 = GLR<grammar4/0>::GLRparser<input4/1>;

query string conflicts() { result = GLR<grammar4/0>::conflicts() }

query int syntax_error() { result = Test4::syntax_error_position() }

from Test4::ParseNode parent, int i, Test4::ParseNode child
where Test4::tree(parent,i,child)
select parent, i, child
