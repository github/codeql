int f() {
	int val = 0;
	switch(val) { //wrong, use an if instead
	case 0:
		//...
	default:
		//...
	}

	switch(val) { //correct, has 2 cases and a default
	case 0:
		//...
	case 1:
		//...
	default:
		//...
	}
}
