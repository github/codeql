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
    // GOOD: class type specified
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        JsonParser parser = new JsonParser();
        Person person = parser.parse(json, Person.class);
    }
 
    @Override
    // BAD: specify a null class type
    public void doHead(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        JsonParser parser = new JsonParser();
        parser.allowClass("com.example.*");
        parser.setClassMetadataName("class");
        User obj = parser.parse(json, null);
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
}