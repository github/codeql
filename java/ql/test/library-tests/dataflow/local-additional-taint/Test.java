import org.apache.commons.codec.Encoder;
import org.apache.commons.codec.Decoder;
import org.apache.commons.codec.BinaryEncoder;
import org.apache.commons.codec.BinaryDecoder;
import org.apache.commons.codec.StringEncoder;
import org.apache.commons.codec.StringDecoder;
import java.util.Date;

class Test {
	public static void taintSteps(
                Date date,
		Decoder decoder,
		Encoder encoder,
		StringEncoder stringEncoder,
		StringDecoder stringDecoder,
		BinaryEncoder binEncoder,
		BinaryDecoder binDecoder) throws Exception {
		String string1 = "hello";
                String string2 = "world";

		byte [] bytes1 = new byte[0];
                byte [] bytes2 = new byte[0];

		Object obj1 = decoder.decode(string2);
                Object obj2 = encoder.encode(bytes2);

		string1 = stringDecoder.decode(string2);
		string1 = stringEncoder.encode(string2);

		bytes1 = binEncoder.encode(bytes2);
		bytes1 = binDecoder.decode(bytes2);

		Object clone = date.clone();
	}
}
