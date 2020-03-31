import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.io.Writer;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;

class Test {
	public static String taint() {
		return "tainted";
	}

	public static void jacksonObjectMapper() {
		String s = taint();
		ObjectMapper om = new ObjectMapper();
		File file = new File("testFile");
		om.writeValue(file, s);
		OutputStream out = new FileOutputStream(file);
		om.writeValue(out, s);
		Writer writer = new StringWriter();
		om.writeValue(writer, s);
		JsonGenerator generator = new JsonFactory().createGenerator(new StringWriter());
		om.writeValue(generator, s);
		String t = om.writeValueAsString(s);
		System.out.println(t);
		byte[] bs = om.writeValueAsBytes(s);
		String reconstructed = new String(bs, "utf-8");
		System.out.println(reconstructed);
	}

	public static void jacksonObjectWriter() {
		String s = taint();
		ObjectWriter ow = new ObjectWriter();
		File file = new File("testFile");
		ow.writeValue(file, s);
		OutputStream out = new FileOutputStream(file);
		ow.writeValue(out, s);
		Writer writer = new StringWriter();
		ow.writeValue(writer, s);
		JsonGenerator generator = new JsonFactory().createGenerator(new StringWriter());
		ow.writeValue(generator, s);
		String t = ow.writeValueAsString(s);
		System.out.println(t);
		byte[] bs = ow.writeValueAsBytes(s);
		String reconstructed = new String(bs, "utf-8");
		System.out.println(reconstructed);
	}
}
