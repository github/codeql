void f(int i) {
	if (i == 10); //empty then block
		... //won't be part of the if statement

	if (i == 12) {
		...
	} else { //empty else block, most likely a mistake
	}
}
