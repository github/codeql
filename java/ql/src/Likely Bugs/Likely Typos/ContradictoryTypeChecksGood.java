String getKind(Animal a) {
	if (a instanceof Tiger) {
		return "Tiger!";
	} else if (a instanceof Mammal) {
		return "Mammal";
	} else {
		return "unknown";
	}
}