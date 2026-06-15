import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.net.Socket;

public class DelayedUnsafeDeserialization {

    public void testWithInputStream(Socket socket) throws Exception {
        ObjectHolder holder = new ObjectHolder();
        holder.init(socket.getInputStream());
        holder.getObject();
    }

    public void testWithByteArray(Socket socket) throws Exception {
        ObjectHolder holder = new ObjectHolder();
        byte[] input = new byte[1024];
        socket.getInputStream().read(input, 0, input.length);
        holder.init(input);
        holder.getObject();
    }
}

class ObjectHolder {

    private byte[] buffer = new byte[1024];

    public void init(InputStream input) throws Exception {
        input.read(buffer, 0, buffer.length);
    }

    public void init(byte[] input) throws Exception {
        buffer = input;
    }

    public Object getObject() throws Exception {
        ByteArrayInputStream bais = new ByteArrayInputStream(buffer);
        ObjectInputStream ois = new ObjectInputStream(bais);
        return ois.readObject();
    }
}
