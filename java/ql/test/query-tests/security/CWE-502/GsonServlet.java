import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.typeadapters.RuntimeTypeAdapterFactory;

import com.example.User;
import com.thirdparty.Person;

public class GsonServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    // GOOD: concrete class type specified
    public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");

        Gson gson = new Gson();
        Object obj = gson.fromJson(json, User.class);
    }

    @Override
    // GOOD: concrete class type specified
    public void doPut(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");

        Gson gson = new Gson();
        Object obj = gson.fromJson(json, Person.class);
    }

    @Override
    // BAD: allow class name to be controlled by remote source
    public void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        try {
            Gson gson = new Gson();
            Object obj = gson.fromJson(json, Class.forName(clazz)); // $unsafeDeserialization
        } catch (ClassNotFoundException cne) {
            throw new IOException(cne.getMessage());
        }
    }

    @Override
    // BAD: allow class name to be controlled by remote source even with a type adapter factory
    public void doHead(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        try {
            RuntimeTypeAdapterFactory<User> runtimeTypeAdapterFactory = RuntimeTypeAdapterFactory
            .of(User.class, "type");
            Gson gson = new GsonBuilder().registerTypeAdapterFactory(runtimeTypeAdapterFactory).create();
            Object obj = gson.fromJson(json, Class.forName(clazz)); // $unsafeDeserialization
        } catch (ClassNotFoundException cne) {
            throw new IOException(cne.getMessage());
        }
    }

    @Override
    // GOOD: specify allowed class types without explicitly configured vulnerable subclass types
    public void doTrace(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String json = req.getParameter("json");
        String clazz = req.getParameter("class");

        RuntimeTypeAdapterFactory<Person> runtimeTypeAdapterFactory = RuntimeTypeAdapterFactory
            .of(Person.class, "type");
        Gson gson = new GsonBuilder().registerTypeAdapterFactory(runtimeTypeAdapterFactory).create();
        Person obj = gson.fromJson(json, Person.class);
    }
}