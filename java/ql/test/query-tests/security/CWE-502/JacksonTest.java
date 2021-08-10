import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.databind.jsontype.BasicPolymorphicTypeValidator;
import com.fasterxml.jackson.databind.jsontype.PolymorphicTypeValidator;
import java.io.IOException;
import java.io.Serializable;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.List;

public class JacksonTest {

    public static void withSocket(Action<String> action) throws Exception {
        try (ServerSocket serverSocket = new ServerSocket(0)) {
            try (Socket socket = serverSocket.accept()) {
                byte[] bytes = new byte[1024];
                int n = socket.getInputStream().read(bytes);
                String jexlExpr = new String(bytes, 0, n);
                action.run(jexlExpr);
            }
        }
    }
}

interface Action<T> {
    void run(T object) throws Exception;
}

abstract class PhoneNumber implements Serializable {
    public int areaCode;
    public int local;
}

class DomesticNumber extends PhoneNumber {
}

class InternationalNumber extends PhoneNumber {
    public int countryCode;
}

class Employee extends Person {
}

class Person {
    public String name;
    public int age;

    // this annotation enables polymorphic type handling
    @JsonTypeInfo(use = JsonTypeInfo.Id.CLASS)
    public Object phone;
}

class Task {
    public Person assignee;
}

class Tag implements Serializable {
    public String title;
}

class Cat {
    public String name;
    public Serializable tag;
}

class UnsafePersonDeserialization {

    // BAD: Person has a field with an annotation that enables polymorphic type
    //      handling
    private static void testUnsafeDeserialization() throws Exception {
        JacksonTest.withSocket(string -> {
            ObjectMapper mapper = new ObjectMapper();
            mapper.readValue(string, Person.class); // $unsafeDeserialization
        });
    }

    // BAD: Employee extends Person that has a field with an annotation that enables
    //      polymorphic type handling
    private static void testUnsafeDeserializationWithExtendedClass() throws Exception {
        JacksonTest.withSocket(string -> {
            ObjectMapper mapper = new ObjectMapper();
            mapper.readValue(string, Employee.class); // $unsafeDeserialization
        });
    }

    // BAD: Task has a Person field that has a field with an annotation that enables
    //      polymorphic type handling
    private static void testUnsafeDeserializationWithWrapper() throws Exception {
        JacksonTest.withSocket(string -> {
            ObjectMapper mapper = new ObjectMapper();
            mapper.readValue(string, Task.class); // $unsafeDeserialization
        });
    }
}

class SaferPersonDeserialization {

    // GOOD: Despite enabled polymorphic type handling, this is safe because ObjectMapper
    //       has a validator
    private static void testSafeDeserializationWithValidator() throws Exception {
        JacksonTest.withSocket(string -> {
            PolymorphicTypeValidator ptv = 
                    BasicPolymorphicTypeValidator.builder()
                            .allowIfSubType("only.allowed.package")
                            .build();

            ObjectMapper mapper = new ObjectMapper();
            mapper.setPolymorphicTypeValidator(ptv);

            mapper.readValue(string, Person.class);
        });
    }

    // GOOD: Despite enabled polymorphic type handling, this is safe because ObjectMapper
    //       has a validator
    private static void testSafeDeserializationWithValidatorAndBuilder() throws Exception {
        JacksonTest.withSocket(string -> {
            PolymorphicTypeValidator ptv = 
                    BasicPolymorphicTypeValidator.builder()
                            .allowIfSubType("only.allowed.package")
                            .build();

            ObjectMapper mapper = JsonMapper.builder()
                    .polymorphicTypeValidator(ptv)
                    .build();

            mapper.readValue(string, Person.class);
        });
    }
}

class UnsafeCatDeserialization {

    // BAD: deserializing untrusted input while polymorphic type handling is on
    private static void testUnsafeDeserialization() throws Exception {
        JacksonTest.withSocket(string -> {
            ObjectMapper mapper = new ObjectMapper();
            mapper.enableDefaultTyping();   // this enables polymorphic type handling
            mapper.readValue(string, Cat.class); // $unsafeDeserialization
        });
    }

    // BAD: deserializing untrusted input while polymorphic type handling is on
    private static void testUnsafeDeserializationWithObjectMapperReadValues() throws Exception {
        JacksonTest.withSocket(string -> {
            ObjectMapper mapper = new ObjectMapper();
            mapper.enableDefaultTyping();
            mapper.readValues(new JsonFactory().createParser(string), Cat.class).readAll(); // $unsafeDeserialization
        });
    }

    // BAD: deserializing untrusted input while polymorphic type handling is on
    private static void testUnsafeDeserializationWithObjectMapperTreeToValue() throws Exception {
        JacksonTest.withSocket(string -> {
            ObjectMapper mapper = new ObjectMapper();
            mapper.enableDefaultTyping();
            mapper.treeToValue(mapper.readTree(string), Cat.class); // $unsafeDeserialization
        });
    }

    // BAD: an attacker can control both data and type of deserialized object
    private static void testUnsafeDeserializationWithUnsafeClass() throws Exception {
        JacksonTest.withSocket(input -> {
            String[] parts = input.split(";");
            String data = parts[0];
            String type = parts[1];
            Class clazz = Class.forName(type);
            ObjectMapper mapper = new ObjectMapper();
            mapper.readValue(data, clazz); // $unsafeDeserialization
        });
    }

    // BAD: an attacker can control both data and type of deserialized object
    private static void testUnsafeDeserializationWithUnsafeClassAndCustomTypeResolver() throws Exception {
        JacksonTest.withSocket(input -> {
            String[] parts = input.split(";");
            String data = parts[0];
            String type = parts[1];
            ObjectMapper mapper = new ObjectMapper();
            mapper.readValue(data, resolveImpl(type, mapper)); // $unsafeDeserialization
        });
    }

    private static JavaType resolveImpl(String type, ObjectMapper mapper) throws Exception {
        return mapper.constructType(Class.forName(type));
    }
}

class SaferCatDeserialization {

    // GOOD: Despite enabled polymorphic type handling, this is safe because ObjectMapper
    //       has a validator
    private static void testUnsafeDeserialization() throws Exception {
        JacksonTest.withSocket(string -> {
            PolymorphicTypeValidator ptv = 
                BasicPolymorphicTypeValidator.builder()
                        .allowIfSubType("only.allowed.pachage")
                        .build();
        
            ObjectMapper mapper = JsonMapper.builder().polymorphicTypeValidator(ptv).build();
            mapper.enableDefaultTyping(); // this enables polymorphic type handling

            mapper.readValue(string, Cat.class);
        });
    }
}