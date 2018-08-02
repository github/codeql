Record* fixRecord(Record* r) {
	Record myRecord = *r;
	delete r;

	myRecord.fix();
	return &myRecord; //returns reference to myRecord, which is a stack-allocated object
}
