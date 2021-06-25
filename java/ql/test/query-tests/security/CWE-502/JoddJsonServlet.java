import java.io.IOException;
import java.io.Reader;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import jodd.json.JsonParser;

import com.example.User;
import com.thirdparty.Person;

public class JoddJsonServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    // GOOD: class type specified without whitelisted class types
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        JsonParser parser = new JsonParser();
        Person person = parser.parse(json, Person.class);
    }
 
    @Override
    // GOOD: specify a designated final class type
    public void doHead(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        JsonParser parser = new JsonParser();
        parser.allowClass("com.example.*");
        parser.setClassMetadataName("class");
        User obj = parser.parse(json, User.class);
    }

    @Override
    // BAD: allow class name to be controlled by remote source 
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        try {
            JsonParser parser = new JsonParser();
            Object obj = parser.parse(json, Class.forName(clazz));
        } catch (ClassNotFoundException cne) {
            throw new IOException(cne.getMessage());
        }
    }

    @Override
    // BAD: enable user controlled class types and allow overly generic class types
    public void doTrace(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        JsonParser parser = new JsonParser();
        parser.allowClass("com.thirdparty.*");
        parser.withClassMetadata(true);
        Person obj = parser.parse(json, Person.class);

    }

    @Override
    // BAD: enable user controlled class types and allow overly generic class types
    public void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        JsonParser parser = new JsonParser();
        parser.allowClass("com.thirdparty.*");
        parser.setClassMetadataName("class");
        Person obj = parser.parse(json, Person.class);
    }
}