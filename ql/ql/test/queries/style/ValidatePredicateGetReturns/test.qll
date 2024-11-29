import ql

// NOT OK -- Predicate starts with "get" but does not return a value
predicate getValue() { none() }

// OK -- starts with get and returns a value
string getData() { result = "data" }

// OK -- starts with get but followed by a lowercase letter, probably should be ignored
predicate getterFunction() { none() }

// OK -- starts with get and returns a value
string getImplementation() { result = "implementation" }

// OK -- is an alias
predicate getAlias = getImplementation/0;

// OK -- Starts with "get" but followed by a lowercase letter, probably be ignored
predicate getvalue() { none() }

// OK -- Does not start with "get", should be ignored
predicate retrieveValue() { none() }

// NOT OK -- starts with get and does not return value
predicate getImplementation2() { none() }

// OK -- is an alias
predicate getAlias2 = getImplementation2/0;

// NOT OK -- starts with as and does not return value
predicate asValue() { none() }

// OK -- starts with as but followed by a lowercase letter, probably should be ignored
predicate assessment() { none() }

// OK -- starts with as and returns a value
string asString() { result = "string" }

// OK -- starts with get and returns a value
HiddenType getInjectableCompositeActionNode() {
  exists(HiddenType hidden | result = hidden.toString())
}
