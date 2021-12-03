import java.io.IOException;
import java.io.Reader;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import flexjson.JSONDeserializer;
import flexjson.factories.ExistingObjectFactory;

import com.example.User;
import com.thirdparty.Person;

public class FlexjsonServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    // GOOD: a final class type is specified
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JSONDeserializer<User> deserializer = new JSONDeserializer<>();
        User user = deserializer.deserialize(req.getReader(), User.class);
    }

    @Override
    // GOOD: a non-null class type is specified which is not the generic `Object` type
    public void doHead(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JSONDeserializer<Person> deserializer = new JSONDeserializer<Person>();
        Person person = deserializer.deserialize(req.getReader(), Person.class);
    }

    @Override
    // BAD: allow class name to be controlled by remote source
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JSONDeserializer<User> deserializer = new JSONDeserializer<>();
        User user = (User) deserializer.deserialize(req.getReader()); // $unsafeDeserialization

    }

    @Override
    // BAD: allow class name to be controlled by remote source
    public void doTrace(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JSONDeserializer deserializer = new JSONDeserializer<>();
        User user = (User) deserializer.deserialize(req.getReader()); // $unsafeDeserialization

    }

    @Override
    // BAD: specify overly generic class type
    public void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        JSONDeserializer deserializer = new JSONDeserializer();
        User user = (User) deserializer.deserialize(req.getReader(), Object.class); // $unsafeDeserialization
    }

    private Person fromJsonToPerson(String json) {
        return new JSONDeserializer<Person>().use(null, Person.class).deserialize(json);
    }

    // GOOD: Specify the class to deserialize with `use`
    public void doPut2(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        Person person = fromJsonToPerson(json);
    }

    // BAD: Specify a concrete class type to `use` with `ObjectFactory`
    public void doPut3(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        Person person = new JSONDeserializer<Person>().use(Person.class, new ExistingObjectFactory(new Person())).deserialize(json); // $unsafeDeserialization
    }

    // GOOD: Specify a null path to `use` with a concrete class type
    public void doPut4(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        Person person = new JSONDeserializer<Person>().use(null, Person.class).deserialize(json);
    }

    // BAD: Specify a non-null json path to `use` with a concrete class type
    public void doPut5(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        Person person = new JSONDeserializer<Person>().use("abc", Person.class).deserialize(json); // $unsafeDeserialization
    }

    // GOOD: Specify a null json path to `use` with `ObjectFactory`
    public void doPut6(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        Person person = new JSONDeserializer<Person>().use(new ExistingObjectFactory(new Person()), "abc", null).deserialize(json);
    }

    // GOOD: Specify a concrete class type to deserialize with `ObjectFactory`
    public void doPut7(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        Person person = new JSONDeserializer<Person>().deserialize(json, new ExistingObjectFactory(new Person()));
    }

    // GOOD: Specify the class type to deserialize into
    public void doPut8(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        Person person = new JSONDeserializer<Person>().deserializeInto(json, new Person());
    }

    // GOOD: Specify a null json path to `use` with a concrete class type, interwoven with irrelevant use directives
    public void doPut9(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        Person person = new JSONDeserializer<Person>().use(Person.class, null).use(null, Person.class).use(String.class, null).deserialize(json);
    }

    // GOOD: Specify a null json path to `use` with a concrete class type, interwoven with irrelevant use directives, without using fluent method chaining
    public void doPut10(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        JSONDeserializer<Person> deserializer = new JSONDeserializer<Person>();
        deserializer.use(Person.class, null);
        deserializer.use(null, Person.class);
        deserializer.use(String.class, null);
        Person person = deserializer.deserialize(json);
    }

    // BAD: Specify a non-null json path to `use` with a concrete class type, interwoven with irrelevant use directives, without using fluent method chaining
    public void doPut11(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        JSONDeserializer<Person> deserializer = new JSONDeserializer<Person>();
        deserializer.use(Person.class, null);
        deserializer.use("someKey", Person.class);
        deserializer.use(String.class, null);
        Person person = deserializer.deserialize(json); // $unsafeDeserialization
    }
}
