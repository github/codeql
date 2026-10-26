int test() {
	int i;
	int j;
	int x;
	for (i = 0; i < 10; i++) {
		while(1) {
			break;
		}

		do {
			break;
		} while (1);

		switch(i) {
		case 1:
			break;
		case 2:
			for(j=0; j < 10; j++) {
				break;
			}
		default:
			continue;
		}
		for(j = 0; j < 10; j++) {
			continue;
		}
		break;

		({continue;});
	}
}
