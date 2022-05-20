function countOccurrences(xs, p) {
	var count = 0;
	for (let x of xs)
		if (p())
			++count;
	return count;
}