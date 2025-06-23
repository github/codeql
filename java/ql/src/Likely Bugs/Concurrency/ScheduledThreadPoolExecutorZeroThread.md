## Overview

According the Java documentation on `ScheduledThreadPoolExecutor`, it is not a good idea to set `corePoolSize` to zero, since doing so indicates the executor to keep 0 threads in its pool and the executor will serve no purpose.

## Recommendation

Set the `ScheduledThreadPoolExecutor` to have 1 or more threads in its thread pool and use the class's other methods to create a thread execution schedule.

## Example

```java
public class Test {
    void f() {
        int i = 0;
        ScheduledThreadPoolExecutor s = new ScheduledThreadPoolExecutor(1); // COMPLIANT
        ScheduledThreadPoolExecutor s1 = new ScheduledThreadPoolExecutor(0); // NON_COMPLIANT
        s.setCorePoolSize(0); // NON_COMPLIANT
        s.setCorePoolSize(i); // NON_COMPLIANT
    }
}
```

## References
- [ScheduledThreadPoolExecutor](https://docs.oracle.com/en/java/javase/20/docs/api/java.base/java/util/concurrent/ScheduledThreadPoolExecutor.html)
