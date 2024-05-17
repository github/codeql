import glr

string grammar1() {
    result = ["Grammar -> E", "E -> x", "E -> E x", "X ->", "Y -> X"]
}

module GLR1 = GLR<grammar1/0>;

from GLR1::Rule rule
select rule, rule.getLhs() as lhs, rule.getLength() as length
