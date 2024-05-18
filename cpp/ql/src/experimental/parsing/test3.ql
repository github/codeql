import glr

string grammar3() {
    result = ["G -> S", "S -> x", "S -> x S x"]
}

string input3(int i) { result = "xxxxxxx".charAt(i) }

module Test3 = GLR<grammar3/0>::GLRparser<input3/1>;

query string conflicts() { result = GLR<grammar3/0>::conflicts() }

query int syntax_error() { result = Test3::syntax_error_position() }

from Test3::ParseNode parent, int i, Test3::ParseNode child
where Test3::tree(parent,i,child)
select parent, i, child
