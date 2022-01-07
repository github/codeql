import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.io.StringWriter;
import java.io.Writer;
import java.util.Iterator;
import java.util.HashMap;
import java.util.Map;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonGenerator;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectWriter;
import com.fasterxml.jackson.databind.ObjectReader;

class Test {
	public static class Potato {
		private String name;

		private String getName() {
			return name;
		}
	}

	public static String taint() {
		return "tainted";
	}

	public static void sink(Object any) {}

	public static void jacksonObjectMapper() throws Exception {
		String s = taint();
		ObjectMapper om = new ObjectMapper();
		File file = new File("testFile");
		om.writeValue(file, s);
		sink(file); //$hasTaintFlow
		OutputStream out = new FileOutputStream(file);
		om.writeValue(out, s);
		sink(file); //$hasTaintFlow
		Writer writer = new StringWriter();
		om.writeValue(writer, s);
		sink(writer); //$hasTaintFlow
		JsonGenerator generator = new JsonFactory().createGenerator(new StringWriter());
		om.writeValue(generator, s);
		sink(generator); //$hasTaintFlow
		String t = om.writeValueAsString(s);
		sink(t); //$hasTaintFlow
		byte[] bs = om.writeValueAsBytes(s);
		String reconstructed = new String(bs, "utf-8");
		sink(bs); //$hasTaintFlow
		sink(reconstructed); //$hasTaintFlow
	}

	public static void jacksonObjectWriter() throws Exception {
		String s = taint();
		ObjectWriter ow = new ObjectWriter();
		File file = new File("testFile");
		ow.writeValue(file, s);
		sink(file); //$hasTaintFlow
		OutputStream out = new FileOutputStream(file);
		ow.writeValue(out, s);
		sink(out); //$hasTaintFlow
		Writer writer = new StringWriter();
		ow.writeValue(writer, s);
		sink(writer); //$hasTaintFlow
		JsonGenerator generator = new JsonFactory().createGenerator(new StringWriter());
		ow.writeValue(generator, s);
		sink(generator); //$hasTaintFlow
		String t = ow.writeValueAsString(s);
		sink(t); //$hasTaintFlow
		byte[] bs = ow.writeValueAsBytes(s);
		String reconstructed = new String(bs, "utf-8");
		sink(bs); //$hasTaintFlow
		sink(reconstructed); //$hasTaintFlow
	}

	public static void jacksonObjectReader() throws java.io.IOException {
		String s = taint();
		ObjectMapper om = new ObjectMapper();
		ObjectReader reader = om.readerFor(Potato.class);
		sink(reader.readValue(s));  //$hasTaintFlow
		sink(reader.readValue(s, Potato.class).name);  //$hasTaintFlow
		sink(reader.readValue(s, Potato.class).getName());  //$hasTaintFlow
	}

	public static void jacksonObjectReaderIterable() throws java.io.IOException {
		String s = taint();
		ObjectMapper om = new ObjectMapper();
		ObjectReader reader = om.readerFor(Potato.class);
		sink(reader.readValues(s));  //$hasTaintFlow
		Iterator<Potato> pIterator = reader.readValues(s);
		while(pIterator.hasNext()) {
			Potato p = pIterator.next();
			sink(p); //$hasTaintFlow
			sink(p.name); //$hasTaintFlow
			sink(p.getName()); //$hasTaintFlow
		}
	}

	public static void jacksonTwoStepDeserialization() throws java.io.IOException {
		String s = taint();
		Map<String, Object> taintedParams = new HashMap<>();
		taintedParams.put("name", s);
		ObjectMapper om = new ObjectMapper();
		JsonNode jn = om.valueToTree(taintedParams);
		sink(jn); //$hasTaintFlow
		Potato p = om.convertValue(jn, Potato.class);
		sink(p); //$hasTaintFlow
		sink(p.getName()); //$hasTaintFlow
	}
}
