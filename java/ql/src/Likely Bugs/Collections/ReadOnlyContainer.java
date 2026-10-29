boolean containsDuplicates(Object[] array) {
	java.util.Set<Object> seen = new java.util.HashSet<Object>();
	for (Object o : array) {
		if (seen.contains(o))
			return true;
	}
	return false;
}