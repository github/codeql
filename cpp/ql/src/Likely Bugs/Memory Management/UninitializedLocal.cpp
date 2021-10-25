int absWrong(int i) {
	int j;
	if (i > 0) {
		j = i;
	} else if (i < 0) {
		j = -i;
	}
	return j; // wrong: j may not be initialized before use
}

int absCorrect1(int i) {
	int j = 0;
	if (i > 0) {
		j = i;
	} else if (i < 0) {
		j = -i;
	}
	return j; // correct: j always initialized before use
}

int absCorrect2(int i) {
	int j;
	if (i > 0) {
		j = i;
	} else if (i < 0) {
		j = -i;
	} else {
		j = 0;
	}
	return j; // correct: j always initialized before use
}