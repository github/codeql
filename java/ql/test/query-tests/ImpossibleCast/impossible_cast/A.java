package impossible_cast;

import java.io.Serializable;

public class A {
	{ String[] s = (String[])new Object[] { "Hello, world!" }; } // $ Alert
	{ Serializable[] ss = (Object[][])new Serializable[] {}; } // $ Alert
}
