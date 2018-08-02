void* f() {
	block = malloc(BLOCK_SIZE);
	if (block) { //correct: block is checked for nullness here
		block->id = NORMAL_BLOCK_ID;
	}
	//...
	/* make sure data-portion is null-terminated */
	block[BLOCK_SIZE - 1] = '\0'; //wrong: block not checked for nullness here
	return block;
}
