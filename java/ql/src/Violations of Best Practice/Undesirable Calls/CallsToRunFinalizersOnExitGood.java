// Instead of using finalizers, define explicit termination methods 
// and call them in 'finally' blocks.
class LocalCache {
	private Collection<File> cacheFiles = ...;
	
	// Explicit method to close all cacheFiles
	public void dispose() {
		for (File cacheFile : cacheFiles) {
			disposeCacheFile(cacheFile);
		}
	}
}

void main() {
	LocalCache cache = new LocalCache();
	try {
		// Use the cache
	} finally {
		// Call the termination method in a 'finally' block, to ensure that
		// the cache's resources are freed. 
		cache.dispose();
	}
}