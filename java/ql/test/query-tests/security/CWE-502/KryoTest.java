
import java.io.*;
import java.net.Socket;
import com.esotericsoftware.kryo.Kryo;
import com.esotericsoftware.kryo.pool.KryoPool;
import com.esotericsoftware.kryo.io.Input;

public class KryoTest {

    private Kryo getSafeKryo() {
        Kryo kryo = new Kryo();
        kryo.setRegistrationRequired(true);
        // ... kryo.register(A.class) ...
        return kryo;
    }

    public void kryoDeserialize(Socket sock) throws java.io.IOException {
        KryoPool kryoPool = new KryoPool.Builder(this::getSafeKryo).softReferences().build();
        Input input = new Input(sock.getInputStream());
        Object o = kryoPool.run(kryo -> kryo.readClassAndObject(input)); // OK
    }

    public void kryoDeserialize2(Socket sock) throws java.io.IOException {
        KryoPool kryoPool = new KryoPool.Builder(this::getSafeKryo).softReferences().build();
        Input input = new Input(sock.getInputStream());
        Kryo k = kryoPool.borrow();
        try {
            Object o = k.readClassAndObject(input); // OK
        } finally {
            kryoPool.release(k);
        }
    }

}
