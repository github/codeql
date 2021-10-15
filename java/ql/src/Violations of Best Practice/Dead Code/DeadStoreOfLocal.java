Person find(String name) {
	Person result;
	for (Person p : people.values())
		if (p.getName().equals(name))
			result = p;  // Redundant assignment
	result = people.get(name);
	return result;