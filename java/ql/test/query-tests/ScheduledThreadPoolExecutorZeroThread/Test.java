import java.util.concurrent.ScheduledThreadPoolExecutor;

public class Test {
    void f() {
        int i = 0;
        ScheduledThreadPoolExecutor s = new ScheduledThreadPoolExecutor(1); // Compliant
        ScheduledThreadPoolExecutor s1 = new ScheduledThreadPoolExecutor(0); // $ Alert
        s.setCorePoolSize(0); // $ Alert
        s.setCorePoolSize(i); // $ Alert
    }
}
