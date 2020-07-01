void main(int argc, char **argv) {
	uint32_t big_num = INT32_MAX;
	char buf[big_num];
	int16_t bytes_received = 0;
	int max_get = INT16_MAX + 1;

	// BAD: 'bytes_received' is compared with a value of a wider type.
	// 'bytes_received' overflows before  reaching 'max_get',
	// causing an infinite loop
	while (bytes_received < max_get)
		bytes_received += get_from_input(buf, bytes_received);
	}

	uint32_t bytes_received = 0;

	// GOOD: 'bytes_received2' has a type  at least as wide as 'max_get'
	while (bytes_received < max_get) {
		bytes_received += get_from_input(buf, bytes_received);
	}

}


int getFromInput(char *buf, short pos) {
	// write to buf
	// ...
	return 1;
}
