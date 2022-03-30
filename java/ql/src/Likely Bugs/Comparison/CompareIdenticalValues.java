class Customer {
	...
	public boolean equals(Object o) {
		if (o == null) return false;
		if (Customer.class != o.getClass()) return false;
		Customer other = (Customer)o;
		if (!name.equals(o.name)) return false;
		if (id != id) return false;  // Comparison of identical values
		return true;
	}
}

class Customer {
	...
	public boolean equals(Object o) {
		if (o == null) return false;
		if (Customer.class != o.getClass()) return false;
		Customer other = (Customer)o;
		if (!name.equals(o.name)) return false;
		if (id != o.id) return false;  // Comparison corrected
		return true;
	}
}