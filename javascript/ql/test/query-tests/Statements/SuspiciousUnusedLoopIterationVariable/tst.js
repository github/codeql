function countOccurrences(xs, p) {
	var count = 0;
	for (let x of xs) // $ Alert
		if (p())
			++count;
	return count;
}


function countOccurrences(xs, p) {
	var count = 0;
	for (let x of xs)
		if (p(x))
			++count;
	return count;
}


function countOccurrences(xs, p) {
	var count = 0;
	for (let unused of xs)
		if (p())
			++count;
	return count;
}


function isEmpty(o) {
	for (var x in o)
		return false;
	return true;
}


function getNumElt(o) {
	var count = 0;
	for (var x of o)
		++count;
	return count;
}


function getNumElt(o) {
	var count = 0;
	for (var x of o) {
		++count;
	}
	return count;
}


function getNumElt(o) {
	var count = 0;
	for (var x of o)
		count = count + 1;
	return count;
}


function getNumElt(o) {
	var count = 0;
	for (var x of o)
		count = 1 + count;
	return count;
}


function getNumElt(o) {
	var count = 0;
	for (var x of o) {
		console.log("Counting...");
		count += 1;
	}
	return count;
}


function f(o) {
	for (var p in o)
		(function() {
			console.log(p);
		})();
}


function lastProp(o) {
	var key;
	for (key in obj);
	return key;
}


function g() {
	for (var unused in {"toString": null})
		hasDontEnumBug = false;
}


function is_empty(obj) {
	var empty = true;
	for (var key in obj) {
		empty = false;
		break;
	}
	return empty;
}


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

// OK - dead loops are not flagged
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

for (const [key, value] of array) {} // $ Alert

// OK - for array-destructurings we only flag the last element
for (const [key, value] of array) {
	console.log(value)
}

// OK - for array-destructurings we only flag the last element
for (const [key, key2, key3, value] of array) {
	console.log(value)
}

for (const [key, key2, key3, value] of array) {} // $ Alert
for (let i of [1, 2]) {} // $ Alert