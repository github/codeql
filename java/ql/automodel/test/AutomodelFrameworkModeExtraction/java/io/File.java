package java.io;

public class File {
    public int compareTo( // `this` is a negative example - this is modeled as a neutral model
        File pathname // negative example - this is modeled as a neutral model
    ) {
        return 0;
    }

    public boolean setLastModified(long time) { // time is a sink and source candidate, even though it's a primitive
        return false;
    } // return value is not a source candidate because it's a primitive
}
