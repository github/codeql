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

// NOT OK -- is an alias for a predicate which does not have a return value
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

// OK
predicate implementation4() { none() }

// NOT OK -- is an alias
predicate getAlias4 = implementation4/0;

// OK -- is an alias
predicate alias5 = implementation4/0;

int root() { none() }

predicate edge(int x, int y) { none() }

// OK -- Higher-order predicate
int getDistance(int x) = shortestDistances(root/0, edge/2)(_, x, result)

// NOT OK -- Higher-order predicate that does not return a value even though has 'get' in the name
predicate getDistance2(int x, int y) = shortestDistances(root/0, edge/2)(_, x, y)

// OK
predicate unresolvedAlias = unresolved/0;

// OK -- unresolved alias
predicate getUnresolvedAlias = unresolved/0;
