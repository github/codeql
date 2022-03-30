int i = 0;
for (i = 0; i < NUM_RECORDS; i++) {
	int j = 0;
	//This loop should have a more descriptive iteration variable
	for (j = 0; j < NUM_FIELDS; j++) {
		process(record[i]->field[j]);
	}
	
	int field_idx = 0;
	//Better: the inner loop has a descriptive name
	for (field_idx = 0; field_idx < NUM_FIELDS; field_idx++) {
		save(record[i]->field[field_idx]);
	}
}