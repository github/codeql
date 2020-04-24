import java.io.IOException;
import java.io.ObjectInput;
import java.io.ObjectInputStream;

class Test {
	public void test() throws IOException, ClassNotFoundException {
		ObjectInputStream objectStream = new ObjectInputStream(null);
		ObjectInput objectInput = new ObjectInputStream(null);
		objectStream.readObject();
		objectInput.readObject();
	}
}
