int matching; int i;
for (i = 0; i < numItems; i++) {
	if (items[i] == item) {
		matching = i;
		goto found; // Problematic 'goto': Use 'break' instead.
	}
}
found:
// ... use 'matching' ...
