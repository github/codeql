import org.springframework.context.support.StaticMessageSource;
import java.util.Locale;

public class Test {

	public static String code = "mycode";
	public static Locale locale = Locale.US;

	String taint() { return "tainted"; }

	void sink(Object o) {}

	public void test() {
		StaticMessageSource sms = new StaticMessageSource();
		sms.addMessage(code, locale, "hello {0}");
		sink(sms.getMessage(code, new String[]{ taint() }, locale)); // $hasTaintFlow
		sink(sms.getMessage(code, new String[]{ taint() }, "", locale)); // $hasTaintFlow
		sink(sms.getMessage(code, null, taint(), locale)); // $hasTaintFlow
	}
}
