String getKind(Animal a) {
	if (a instanceof Mammal) {
		return "Mammal";
	} else if (a instanceof Tiger) {
		return "Tiger!";
	} else {
		return "unknown";
	}
}