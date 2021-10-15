package impossible_cast;

import java.io.Serializable;

public class A {
	{ String[] s = (String[])new Object[] { "Hello, world!" }; }
	{ Serializable[] ss = (Object[][])new Serializable[] {}; }
}
