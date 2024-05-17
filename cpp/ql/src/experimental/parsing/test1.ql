import glr

string grammar1() {
    result = ["G -> E", "E -> x", "E -> E x"]
}

module GLR1 = GLR<grammar1/0>;

from GLR1::State state1, GLR1::Symbol transition, GLR1::State state2
where state2 = GLR1::makeTransition(state1, transition)
// state1.
select state1, transition, state2
