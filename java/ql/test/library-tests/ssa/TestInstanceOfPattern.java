class TestInstanceOfPattern {
	private String s = "field";
	void test(Object obj) {
		if (obj instanceof String s) {
			if (s.contains("abc")) {}
		} else {
			if (s.contains("def")) {}
		}
	}
	void test2(Object obj) {
		if (!(obj instanceof String s)) {
			if (s.contains("abc")) {}
		} else {
			if (s.contains("def")) {}
		}
	}
	void test3(Object obj) {
		if (obj instanceof String s && s.length() > 5) {
			if (s.contains("abc")) {}
		} else {
			if (s.contains("def")) {}
		}
	}
	void test4(Object obj) {
		if (obj instanceof String s || s.length() > 5) {
			if (s.contains("abc")) {}
		} else {
			if (s.contains("def")) {}
		}
	}
}
