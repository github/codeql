// AVOID: Iterate the map using the key set.
class AddressBook {
	private Map<String, Person> people = ...;
	public String findId(String first, String last) {
		for (String id : people.keySet()) {
			Person p = people.get(id);
			if (first.equals(p.firstName()) && last.equals(p.lastName()))
				return id;
		}
		return null;
	}
}

// GOOD: Iterate the map using the entry set.
class AddressBook {
	private Map<String, Person> people = ...;
	public String findId(String first, String last) {
		for (Entry<String, Person> entry: people.entrySet()) {
			Person p = entry.getValue();
			if (first.equals(p.firstName()) && last.equals(p.lastName()))
				return entry.getKey();
		}
		return null;
	}
}