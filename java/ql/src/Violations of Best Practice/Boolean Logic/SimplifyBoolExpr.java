boolean f1(List<Boolean> l) {
	for(Boolean x : l) {
		if (x == true) return true;
	}
	return false;
}

boolean f2(List<Boolean> l) {
	for(Boolean x : l) {
		if (x) return true;
	}
	return false;
}

void g1(List<Boolean> l1) {
	List<Boolean> l2 = new ArrayList<Boolean>();
	for(Boolean x : l1) {
		l2.add(x == true);
	}
}

void g2(List<Boolean> l1) {
	List<Boolean> l2 = new ArrayList<Boolean>();
	for(Boolean x : l1) {
		if (x == null) {
			// handle null case
		}
		l2.add(x);
	}
}
