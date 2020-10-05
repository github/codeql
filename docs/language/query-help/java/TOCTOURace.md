# Time-of-check time-of-use race condition

```
ID: java/toctou-race-condition
Kind: problem
Severity: warning
Precision: medium
Tags: security external/cwe/cwe-367

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Security/CWE/CWE-367/TOCTOURace.ql)

Often it is necessary to check the state of a resource before using it. If the resource is accessed concurrently, then the check and the use need to be performed atomically, otherwise the state of the resource may change between the check and the use. This can lead to a "time-of-check/time-of-use" (TOCTOU) race condition.

In Java, classes may present state inspection methods and operation methods which are synchronized. This prevents multiple threads from executing those methods simultaneously, but it does not prevent a state change in between separate method invocations.


## Recommendation
When calling a series of methods which require a consistent view of an object, make sure to synchronize on a monitor that will prevent any other access to the object during your operations.

If the class that you are using has a well-designed interface, then synchronizing on the object itself will prevent its state being changed inappropriately.


## Example
The following example shows a resource which has a readiness state, and an action that is only valid if the resource is ready.

In the bad case, the caller checks the readiness state and then acts, but does not synchronize around the two calls, so the readiness state may be changed by another thread.

In the good case, the caller jointly synchronizes the check and the use on the resource, so no other thread can modify the state before the use.


```java
class Resource {
	public synchronized boolean isReady() { ... }

	public synchronized void setReady(boolean ready) { ... }
	
	public synchronized void act() { 
		if (!isReady())
			throw new IllegalStateException();
		...
	}
}
	
public synchronized void bad(Resource r) {
	if (r.isReady()) {
		// r might no longer be ready, another thread might
		// have called setReady(false)
		r.act();
	}
}

public synchronized void good(Resource r) {
	synchronized(r) {
		if (r.isReady()) {
			r.act();
		}
	}
}
```

## References
* Common Weakness Enumeration: [CWE-367](https://cwe.mitre.org/data/definitions/367.html).