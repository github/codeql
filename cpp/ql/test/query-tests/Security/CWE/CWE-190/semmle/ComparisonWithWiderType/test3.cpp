void test_issue_5850(unsigned char small, unsigned int large1) {
	for(; small < static_cast<unsigned char>(large1 - 1); small++) { } // GOOD
}

void test_widening(unsigned char small, char large) {
	for(; small < static_cast<unsigned int>(static_cast<short>(large) - 1); small++) { } // GOOD
}
