import java.util.StringJoiner;

public class StringJoinerTests {

	Object taint() {
		return null;
	}

	void sink(Object o) {}

	public void test() throws Exception {
		{
			// "java.util;StringJoiner;false;StringJoiner;(CharSequence);;Argument[0];Argument[-1];taint;manual"
			StringJoiner out = null;
			CharSequence in = (CharSequence) taint();
			out = new StringJoiner(in);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;StringJoiner;(CharSequence,CharSequence,CharSequence);;Argument[0];Argument[-1];taint;manual"
			StringJoiner out = null;
			CharSequence in = (CharSequence) taint();
			out = new StringJoiner(in, null, null);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;StringJoiner;(CharSequence,CharSequence,CharSequence);;Argument[1];Argument[-1];taint;manual"
			StringJoiner out = null;
			CharSequence in = (CharSequence) taint();
			out = new StringJoiner(null, in, null);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;StringJoiner;(CharSequence,CharSequence,CharSequence);;Argument[2];Argument[-1];taint;manual"
			StringJoiner out = null;
			CharSequence in = (CharSequence) taint();
			out = new StringJoiner(null, null, in);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;add;;;Argument[-1];ReturnValue;value;manual"
			StringJoiner out = null;
			StringJoiner in = (StringJoiner) taint();
			out = in.add(null);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;add;;;Argument[0];Argument[-1];taint;manual"
			StringJoiner out = null;
			CharSequence in = (CharSequence) taint();
			out.add(in);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;merge;;;Argument[-1];ReturnValue;value;manual"
			StringJoiner out = null;
			StringJoiner in = (StringJoiner) taint();
			out = in.merge(null);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;merge;;;Argument[0];Argument[-1];taint;manual"
			StringJoiner out = null;
			StringJoiner in = (StringJoiner) taint();
			out.merge(in);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;setEmptyValue;;;Argument[-1];ReturnValue;taint;manual"
			StringJoiner out = null;
			StringJoiner in = (StringJoiner) taint();
			out = in.setEmptyValue(null);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;setEmptyValue;;;Argument[0];Argument[-1];taint;manual"
			StringJoiner out = null;
			CharSequence in = (CharSequence) taint();
			out.setEmptyValue(in);
			sink(out);
		}
		{
			// "java.util;StringJoiner;false;toString;;;Argument[-1];ReturnValue;taint;manual"
			String out = null;
			StringJoiner in = (StringJoiner) taint();
			out = in.toString();
			sink(out);
		}

	}

}
