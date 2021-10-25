
class InFinally {
	void returnVoidInFinally() {
		try {
		} finally {
			return;
		}
	}

	int returnIntInFinally(boolean b1, boolean b2) {
		try {
			if (b1) {
				return 4;
			}
		} finally {
			if (b2) {
				return 5;
			}
		}
		return 3;
	}

	int throwInFinally(boolean b1, boolean b2) {
		try {
			if (b1) {
				throw new RuntimeException("Foo 1");
			}
		} finally {
			if (b2) {
				throw new RuntimeException("Foo 2");
			}
		}
		throw new RuntimeException("Foo 3");
	}

	void breakInFinally(boolean b) {
		for (int i = 0; i < 10; i++) {
			if(b) {
				break;
			}
		}
		try {
			for (int i = 0; i < 10; i++) {
				if(b) {
					break;
				}
			}
		} finally {
			for (int i = 0; i < 10; i++) {
				if(b) {
					break;
				}
			}
		}

		for (int i = 0; i < 10; i++) {
			try {
				if(b) {
					break;
				}
			} finally {
				if(b) {
					break;
				}
			}
		}

		try {
		} finally {
			for (int i = 0; i < 10; i++) {
				try {
					if(b) {
						break;
					}
				} finally {
					if(b) {
						break;
					}
				}
			}
		}
	}

	void continueInFinally(boolean b) {
		for (int i = 0; i < 10; i++) {
			if(b) {
				continue;
			}
		}
		try {
			for (int i = 0; i < 10; i++) {
				if(b) {
					continue;
				}
			}
		} finally {
			for (int i = 0; i < 10; i++) {
				if(b) {
					continue;
				}
			}
		}

		for (int i = 0; i < 10; i++) {
			try {
				if(b) {
					continue;
				}
			} finally {
				if(b) {
					continue;
				}
			}
		}

		try {
		} finally {
			for (int i = 0; i < 10; i++) {
				try {
					if(b) {
						continue;
					}
				} finally {
					if(b) {
						continue;
					}
				}
			}
		}
	}
}

