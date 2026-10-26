Record* fixRecord(Record* r) {
	Record myRecord = *r;
	delete r;

	myRecord.fix();
	return &myRecord; //returns pointer to myRecord, which is a stack-allocated object
}
