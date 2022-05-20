public static void main(String[] args) {
	// Only call the live method
	liveMethod();
}

/** This method is live because it is called by main(..) */
public static void liveMethod() {
	otherLiveMethod()
}

/** This method is live because it is called by a live method */
public static void otherLiveMethod() {
}


/** This method is dead because it is never called */
public static void deadMethod() {
	otherDeadMethod();
}

/** This method is dead because it is only called by dead methods */
public static void otherDeadMethod() {
}