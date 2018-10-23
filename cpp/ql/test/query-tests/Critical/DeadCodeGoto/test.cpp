int test1(int x) {
	goto label; // BAD
	x++;
	label: return x;
}

int test2(int x) {
	do {
		break; // BAD
		x++;
	} while(false);
	return x;
}

int test3(int x) {
	goto label; // GOOD
	label: x++;
	return x;
}

int test4(int x) {
	goto label; // GOOD
	do {
		label: x++;
	} while(false);
	return x;
}

int test5(int x, int y) {
	switch(y) {
	case 0:
		break; // GOOD
	case 1:
		goto label; // GOOD
		break;
	case 2:
		break; // BAD
		return x;
	case 3:
		return x;
		break; // GOOD
	case 4:
		goto label; // GOOD
	case 5:
		goto label;; // GOOD
	default:
		x++;
	}
	label:
	return x;
}

void test6(int x, int cond) {
	if (cond) {
		x++;
	} else goto end; // GOOD
	x++;
	end:
}

void test7(int x, int cond) {
	if (cond)
	{
		goto target;
	}
	goto somewhere_else; // GOOD
	while (x < 10) // not dead code
	{
	target:
		x++;
	}
	somewhere_else:
	switch (1)
	{
	  goto end;
	  while (x < 10) // not dead code
	  {
	case 1:
	    x++;
	  } break;
	}
	end:
}
