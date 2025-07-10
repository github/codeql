import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
import org.jabsorb.JSONSerializer;
import org.jabsorb.serializer.SerializerState;
import org.jabsorb.serializer.ObjectMatch;

import com.example.User;
import com.thirdparty.Person;

public class JabsorbServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    // GOOD: final class type specified
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        try {
            Object jsonObject = new JSONObject(json);

            JSONSerializer serializer = new JSONSerializer();
            serializer.registerDefaultSerializers();

            serializer.setMarshallClassHints(true);
            serializer.setMarshallNullAttributes(true);

            SerializerState state = new SerializerState();
            User user = (User) serializer.unmarshall(state, User.class, jsonObject);
        } catch (Exception e) {
            throw new IOException(e.getMessage());
        }
    }

    // GOOD: concrete class type specified even if it has vulnerable subclasses
    public void doHead(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        try {
            Object jsonObject = new JSONObject(json);

            JSONSerializer serializer = new JSONSerializer();
            serializer.registerDefaultSerializers();

            serializer.setMarshallClassHints(true);
            serializer.setMarshallNullAttributes(true);

            SerializerState state = new SerializerState();
            Person person = (Person) serializer.unmarshall(state, Person.class, jsonObject);
        } catch (Exception e) {
            throw new IOException(e.getMessage());
        }
    }

    @Override
    // GOOD: try unmarshall but doesn't actually marshall the object
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        try {
            Object jsonObject = new JSONObject(json);

            JSONSerializer serializer = new JSONSerializer();
            serializer.registerDefaultSerializers();

            serializer.setMarshallClassHints(true);
            serializer.setMarshallNullAttributes(true);

            SerializerState state = new SerializerState();
            ObjectMatch objMatch = serializer.tryUnmarshall(state, Class.forName(clazz), jsonObject);
            User obj = new User();
            boolean result = objMatch.equals(obj);
        } catch (Exception e) {
            throw new IOException(e.getMessage());
        }
    }

    @Override
    // BAD: allow class name to be controlled by remote source
    public void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        try {
            Object jsonObject = new JSONObject(json);

            JSONSerializer serializer = new JSONSerializer();
            serializer.registerDefaultSerializers();

            serializer.setMarshallClassHints(true);
            serializer.setMarshallNullAttributes(true);

            SerializerState state = new SerializerState();
            User user = (User) serializer.unmarshall(state, Class.forName(clazz), jsonObject); // $unsafeDeserialization
        } catch (Exception e) {
            throw new IOException(e.getMessage());
        }
    }

    // BAD: allow explicit class type controlled by remote source in the format of "json={\"javaClass\":\"com.thirdparty.Attacker\", ...}"
    public void doPut2(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");

        try {
            JSONSerializer serializer = new JSONSerializer();
            serializer.registerDefaultSerializers();

            User user = (User) serializer.fromJSON(json); // $unsafeDeserialization
        } catch (Exception e) {
            throw new IOException(e.getMessage());
        }
    }
}