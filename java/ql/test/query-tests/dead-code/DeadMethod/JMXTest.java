import java.lang.management.ManagementFactory;

import javax.management.ObjectName;

public class JMXTest {

	public static interface FooMBean {
		public String sometimesLiveMethod(String arg);
		public String liveMethod2(String arg);
	}

	public static class FooIntermediate implements FooMBean {
		// This method is dead, because it is overridden in FooImpl, which is the registered MBean.
		public String sometimesLiveMethod(String arg) { return "foo"; }
		// This method is live, because it is the most specific method for FooImpl
		public String liveMethod2(String arg) { return "foo"; }
	}

	// MBean registered class
	public static class FooImpl extends FooIntermediate {
		// This method is live, because it is declared in FooMBean.
		public String sometimesLiveMethod(String arg) { return "foo"; }
	}

	public static void register(Object o) throws Exception {
		ManagementFactory.getPlatformMBeanServer().registerMBean(o, new ObjectName("foo"));
	}

	public static void main(String[] args) throws Exception {
		register(new FooImpl());
	}
}
