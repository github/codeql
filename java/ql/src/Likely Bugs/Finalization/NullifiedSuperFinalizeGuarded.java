class GuardedLocalCache {
	private Collection<NativeResource> localResources;
	// A finalizer guardian, which performs the finalize actions for 'GuardedLocalCache'
	// even if a subclass does not call 'super.finalize' in its 'finalize' method
	private Object finalizerGuardian = new Object() {
		protected void finalize() throws Throwable {
			for (NativeResource r : localResources) {
				r.dispose();
			}
		};
	};
}