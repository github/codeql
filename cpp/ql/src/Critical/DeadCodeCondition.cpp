while(result) {
	if ( ... )
		...
	else if (result //wrong: this test is redundant
				&& result->flags != 0)
		...
	result = next(queue);
}


fp = fopen(log, "r");
if (fp) {
	/*
	 * large block of code
	 */
	if (!fp) { //wrong: always false
		...  /* dead code */
	}
}
