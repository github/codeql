package flexjson;

import java.io.Reader;

public class JSONDeserializer<T> {

    public JSONDeserializer() {
    }

    /**
     * Deserialize the given json formatted input into a Java object.
     *
     * @param input a json formatted string.
     * @return an Java instance deserialized from the json input.
     */
    public T deserialize( String input ) {
        return null;
    }

    /**
     * Same as {@link #deserialize(String)}, but uses an instance of
     * java.io.Reader as json input.
     *
     * @param input the stream where the json input is coming from.
     * @return an Java instance deserialized from the java.io.Reader's input.
     */
    public T deserialize( Reader input ) {
        return null;
    }

    /**
     * Deserialize the given json input, and use the given Class as
     * the type of the initial object to deserialize into.  This object
     * must implement a no-arg constructor.
     *
     * @param input a json formatted string.
     * @param root a Class used to create the initial object.
     * @return the object created from the given json input.
     */
    public T deserialize( String input, Class root ) {
        return null;
    }

    /**
     * Same as {@link #deserialize(java.io.Reader, Class)}, but uses an instance of
     * java.io.Reader as json input.
     *
     * @param input the stream where the json input is coming from.
     * @param root a Class used to create the initial object.
     * @return an Java instance deserialized from the java.io.Reader's input.
     */
    public T deserialize( Reader input, Class root ) {
        return null;
    }

    /**
     * Deserialize the given json input, and use the given ObjectFactory to
     * create the initial object to deserialize into.
     *
     * @param input a json formatted string.
     * @param factory an ObjectFactory used to create the initial object.
     * @return the object created from the given json input.
     */
    public T deserialize( String input, ObjectFactory factory ) {
        return null;
    }

    /**
     * Same as {@link #deserialize(String, ObjectFactory)}, but uses an instance of
     * java.io.Reader as json input.
     *
     * @param input the stream where the json input is coming from.
     * @param factory an ObjectFactory used to create the initial object.
     * @return an Java instance deserialized from the java.io.Reader's input.
     */
    public T deserialize( Reader input, ObjectFactory factory ) {
        return null;
    }

    /**
     * Deserialize the given input into the existing object target.
     * Values in the json input will overwrite values in the
     * target object.  This means if a value is included in json
     * a new object will be created and set into the existing object. 
     *
     * @param input a json formatted string.
     * @param target an instance to set values into from the json string.
     * @return will return a reference to target.
     */
    public T deserializeInto( String input, T target ) {
        return null;
    }

    /**
     * Same as {@link #deserializeInto(String, Object)}, but uses an instance of
     * java.io.Reader as json input.
     *
     * @param input the stream where the json input is coming from.
     * @param target an instance to set values into from the json string.
     * @return will return a reference to target.
     */
    public T deserializeInto( Reader input, T target ) {
        return null;
    }

    public JSONDeserializer<T> use( String path, Class clazz ) {
        return null;
    }

    public JSONDeserializer<T> use( Class clazz, ObjectFactory factory ) {
        return null;
    }

    public JSONDeserializer<T> use( String path, ObjectFactory factory ) {
        return null;
    }

    public JSONDeserializer<T> use(ObjectFactory factory, String... paths) {
        return null;
    }
}
