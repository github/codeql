# Unreleased lock

```
ID: java/unreleased-lock
Kind: problem
Severity: error
Precision: medium
Tags: reliability security external/cwe/cwe-764 external/cwe/cwe-833

```
[Click to see the query in the CodeQL repository](https://github.com/github/codeql/tree/main/java/ql/src/Likely%20Bugs/Concurrency/UnreleasedLock.ql)

When a thread acquires a lock it must make sure to unlock it again; failing to do so can lead to deadlocks. If a lock allows a thread to acquire it multiple times, for example `java.util.concurrent.locks.ReentrantLock`, then the number of locks must match the number of unlocks in order to fully release the lock.


## Recommendation
It is recommended practice always to immediately follow a call to `lock` with a `try` block and place the call to `unlock` inside the `finally` block. Beware of calls inside the `finally` block that could cause exceptions, as this may result in skipping the call to `unlock`.


## Example
The typical pattern for using locks safely looks like this:


```java
public void m() {
   lock.lock();
   // A
   try {
      // ... method body
   } finally {
      // B
      lock.unlock();
   }
}
```
If any code that can cause a premature method exit (for example by throwing an exception) is inserted at either point `A` or `B` then the method might not unlock, so this should be avoided.


## References
* Java API Documentation: [java.util.concurrent.locks.Lock](http://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/Lock.html), [java.util.concurrent.locks.ReentrantLock](http://docs.oracle.com/javase/8/docs/api/java/util/concurrent/locks/ReentrantLock.html).
* Common Weakness Enumeration: [CWE-764](https://cwe.mitre.org/data/definitions/764.html).
* Common Weakness Enumeration: [CWE-833](https://cwe.mitre.org/data/definitions/833.html).