import glr

string grammar1() {
    result = ["G -> E", "E -> x", "E -> E x"]
}

string input1(int i) { result = "xxxx".charAt(i) }

module Test1 = GLR<grammar1/0>::GLRparser<input1/1>;

from Test1::ParseNode parent, int i, Test1::ParseNode child
where Test1::tree(parent,i,child)
select parent, i, child
