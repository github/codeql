int write_default_config_bad() {
	// BAD - this is world-writable so any user can overwrite the config
	FILE* out = creat(OUTFILE, 0666);
	fprintf(out, DEFAULT_CONFIG);
}

int write_default_config_good() {
	// GOOD - this allows only the current user to modify the file
	FILE* out = creat(OUTFILE, S_IWUSR | S_IRUSR);
	fprintf(out, DEFAULT_CONFIG);
}
