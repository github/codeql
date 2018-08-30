public class Test {
	// OK: may be assigned by init() below
	private int foo;

	public Test() {
		init();
	}

	private native void init();

	public int getFoo() {
		return foo;
	}
}

class GsonTest {
	@com.google.gson.annotations.Expose private String s; // OK
	public String getS() { return s; }
}

class JacksonTest {
	@com.fasterxml.jackson.annotation.JsonIgnore
	private int i; // not OK; field is ignored for Jackson JSON deserialization
	public int getI() { return i; }
	{
		new com.fasterxml.jackson.databind.ObjectMapper().readValue("...", JacksonTest.class);
	}
}

class JacksonTest3 {
	private int i; // not OK; field is never deserialized
	public int getI() { return i; }
}

@com.fasterxml.jackson.annotation.JsonAutoDetect
@com.fasterxml.jackson.annotation.JsonIgnoreProperties
class JacksonTest2 {
	private int i; // OK
	public int getI() { return i; }
	{
		new com.fasterxml.jackson.databind.ObjectMapper().readValue("...", JacksonTest2.class);
	}
}

class JacksonTest4 {
	private int i; // OK
	public int getI() { return i; }
	{
		Class<?> clazz = JacksonTest4.class;
		readvalue(clazz);
	}
	public void readvalue(Class<?> clazz) {
		new com.fasterxml.jackson.databind.ObjectMapper().readValue("...", clazz);
	}
}
