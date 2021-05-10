void test_issue_5850(unsigned char small, unsigned int large1) {
	for(; small < static_cast<unsigned char>(large1 - 1); small++) { } // GOOD [FALSE POSITIVE]
}