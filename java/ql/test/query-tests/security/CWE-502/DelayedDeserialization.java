import java.io.ByteArrayInputStream;
import java.io.DataInput;
import java.io.DataInputStream;
import java.io.ObjectInputStream;
import java.net.Socket;

public class DelayedDeserialization {

    public void test(Socket socket) throws Exception {
        DataInputStream in = new DataInputStream(socket.getInputStream());
        ObjectHolder holder = new ObjectHolder();
        holder.init(in);
        holder.getObject();
    }
}

class ObjectHolder {

    private final byte[] buffer = new byte[1024];

    public void init(DataInput input) throws Exception {
        input.readFully(buffer, 0, buffer.length);
    }

    public Object getObject() throws Exception {
        ByteArrayInputStream bais = new ByteArrayInputStream(buffer);
        ObjectInputStream ois = new ObjectInputStream(bais);
        return ois.readObject(); // $unsafeDeserialization
    }
}
