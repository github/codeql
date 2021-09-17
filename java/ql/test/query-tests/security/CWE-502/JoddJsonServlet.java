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
    // GOOD: class type specified (despite a dangerous configuration)
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        JsonParser parser = new JsonParser();
        parser.setClassMetadataName("class");
        Person person = parser.parse(json, Person.class);
    }

    @Override
    // BAD: dangerously configured parser with no class restriction passed to `parse`,
    // using a few different possible call sequences.
    public void doHead(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");
        int callOrder;
        try {
            callOrder = Integer.parseInt(req.getParameter("callOrder"));
        }
        catch(NumberFormatException e) {
            throw new RuntimeException(e);
        }

        JsonParser parser = new JsonParser();
        if(callOrder == 0) {
            parser.setClassMetadataName("class");
            User obj = parser.parse(json, null); // $unsafeDeserialization
        } else if(callOrder == 1) {
            parser.setClassMetadataName("class").parse(json, null); // $unsafeDeserialization
        } else if(callOrder == 2) {
            parser.setClassMetadataName("class").lazy(true).parse(json, null); // $unsafeDeserialization
        } else if(callOrder == 3) {
            parser.withClassMetadata(true).lazy(true).parse(json, null); // $unsafeDeserialization
        }
    }

    @Override
    // BAD: allow class name to be controlled by remote source
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        try {
            JsonParser parser = new JsonParser();
            Object obj = parser.parse(json, Class.forName(clazz)); // $unsafeDeserialization
        } catch (ClassNotFoundException cne) {
            throw new IOException(cne.getMessage());
        }
    }

    @Override
    // GOOD: dangerously configured parser is ameliorated by setting a list of allowed classes, using various call orders,
    // or by explicitly disabling the class metadata option.
    public void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");
        int callOrder;
        try {
            callOrder = Integer.parseInt(req.getParameter("callOrder"));
        }
        catch(NumberFormatException e) {
            throw new RuntimeException(e);
        }

        JsonParser parser = new JsonParser();
        if(callOrder == 0) {
            parser.setClassMetadataName("class");
            parser.allowClass("example.Class");
            User obj = parser.parse(json, null);
        } else if(callOrder == 1) {
            parser.allowClass("example.Class");
            parser.setClassMetadataName("class");
            User obj = parser.parse(json, null);
        } else if(callOrder == 2) {
            parser.setClassMetadataName("class").allowClass("example.Class").parse(json, null);
        } else if(callOrder == 3) {
            parser.allowClass("example.Class").setClassMetadataName("class").parse(json, null);
        } else if(callOrder == 4) {
            parser.setClassMetadataName("class").withClassMetadata(false).parse(json, null);
        } else if(callOrder == 5) {
            parser.withClassMetadata(true).setClassMetadataName(null).parse(json, null);
        }
    }
}