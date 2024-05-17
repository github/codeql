import glr

string grammar2() {
    result = ["G -> E", "E -> E - I", "E -> I"]
}


query string conflicts() { result = GLR<grammar2/0>::conflicts() }

query int syntax_error() { result = Test2::syntax_error_position() }

string input2(int i) { result = "I-I-I".charAt(i) }

module Test2 = GLR<grammar2/0>::GLRparser<input2/1>;

from Test2::ParseNode parent, int i, Test2::ParseNode child
where Test2::tree(parent,i,child)
select parent, i, child
