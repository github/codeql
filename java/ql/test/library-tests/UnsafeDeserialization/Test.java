import java.io.IOException;
import java.io.ObjectInputStream;
import org.apache.commons.io.serialization.ValidatingObjectInputStream;

class Test {
	public void test() throws IOException, ClassNotFoundException {
		ObjectInputStream objectStream = new ObjectInputStream(null);
		ObjectInputStream validating = new ValidatingObjectInputStream(null);
		objectStream.readObject();
		validating.readObject();
	}
}
