import java.io.*;
import java.lang.ClassNotFoundException;
import java.net.Socket;
import java.util.ArrayList;

class Test {

    class A implements Serializable{
        transient Object[] data;

        private void writeObject(java.io.ObjectOutputStream out) throws IOException {
            out.writeInt(data.length);

            for (int i = 0; i < data.length; i++) {
                out.writeObject(data[i]);
            }
        }

        private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
            int length = in.readInt();

            // BAD: An array is allocated whose size could be controlled by an attacker.
            data = new Object[length];

            for (int i = 0; i < length; i++) {
                data[i] = in.readObject();
            }
        }
    }

    class B implements Serializable{
        transient Object[] data;

        private void writeObject(java.io.ObjectOutputStream out) throws IOException {
            out.writeInt(data.length);

            for (int i = 0; i < data.length; i++) {
                out.writeObject(data[i]);
            }
        }

        private void readObject(java.io.ObjectInputStream in) throws IOException, ClassNotFoundException {
            int length = in.readInt();

            // GOOD: An ArrayList is used, which dynamically allocates memory as needed.
            ArrayList<Object> dataList = new ArrayList<>();

            for (int i = 0; i < length; i++) {
                dataList.add(in.readObject());
            }

            data = dataList.toArray();
        }
    }


    public void processData1(Socket sock) throws IOException {
        ObjectInputStream stream = new ObjectInputStream(sock.getInputStream());

        int size = stream.readInt();
        // BAD: A user-controlled amount of memory is allocated
        byte[] buffer = new byte[size];

        // ...
    }

    public void processData2(Socket sock) throws IOException {
        ObjectInputStream stream = new ObjectInputStream(sock.getInputStream());

        int size = stream.readInt();

        if (size > 4096) {
            throw new IOException("Size too large");
        }

        // GOOD: There is an upper bound on memory consumption.
        byte[] buffer = new byte[size];

        // ...
    }
}
