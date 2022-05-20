class State {
	// The 'transient' modifier has no effect here because
	// the 'State' class does not implement 'Serializable'.
	private transient int[] stateData;
}

class PersistentState implements Serializable {
	private int[] stateData;
	// The 'transient' modifier indicates that this field is not part of
	// the persistent state and should therefore not be serialized.
	private transient int[] cachedComputedData;
}