void* f() {
	block = (MyBlock *)malloc(sizeof(MyBlock));
	if (block) { //correct: block is checked for nullness here
		block->id = NORMAL_BLOCK_ID;
	}
	//...
	/* make sure data-portion is null-terminated */
	block->data[BLOCK_SIZE - 1] = '\0'; //wrong: block not checked for nullness here
	return block;
}
