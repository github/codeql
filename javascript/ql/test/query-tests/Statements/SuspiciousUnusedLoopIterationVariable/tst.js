// BAD
function countOccurrences(xs, p) {
	var count = 0;
	for (let x of xs)
		if (p())
			++count;
	return count;
}

// OK
function countOccurrences(xs, p) {
	var count = 0;
	for (let x of xs)
		if (p(x))
			++count;
	return count;
}

// OK
function countOccurrences(xs, p) {
	var count = 0;
	for (let unused of xs)
		if (p())
			++count;
	return count;
}

// OK
function isEmpty(o) {
	for (var x in o)
		return false;
	return true;
}

// OK
function getNumElt(o) {
	var count = 0;
	for (var x of o)
		++count;
	return count;
}

// OK
function getNumElt(o) {
	var count = 0;
	for (var x of o) {
		++count;
	}
	return count;
}

// OK
function getNumElt(o) {
	var count = 0;
	for (var x of o)
		count = count + 1;
	return count;
}

// OK
function getNumElt(o) {
	var count = 0;
	for (var x of o)
		count = 1 + count;
	return count;
}

// OK
function getNumElt(o) {
	var count = 0;
	for (var x of o) {
		console.log("Counting...");
		count += 1;
	}
	return count;
}

// OK
function f(o) {
	for (var p in o)
		(function() {
			console.log(p);
		})();
}

// OK
function lastProp(o) {
	var key;
	for (key in obj);
	return key;
}

// OK
function g() {
	for (var unused in {"toString": null})
		hasDontEnumBug = false;
}

// OK
function is_empty(obj) {
	var empty = true;
	for (var key in obj) {
		empty = false;
		break;
	}
	return empty;
}

// OK
function f(objs) {
	var non_empties = 0;
	for (var obj in objs) {
		for (var key in obj) {
			non_empties += 1;
			break;
		}
	}
	return non_empties;
}

// OK: dead loops are not flagged
function countOccurrencesDead(xs, p) {
	return;
	var count = 0;
	for (let x of xs)
		if (p())
			++count;
	return count;
}

(function(a) {
	for([a] of o) {
		a;
	}
});

// NOT OK
for (const [key, value] of array) {}

// OK: for array-destructurings we only flag the last element
for (const [key, value] of array) {
	console.log(value)
}

// OK: for array-destructurings we only flag the last element
for (const [key, key2, key3, value] of array) {
	console.log(value)
}

// NOT OK
for (const [key, key2, key3, value] of array) {}
for (let i of [1, 2]) {}