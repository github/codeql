package java.io;

public class File {
    public int compareTo( // $ negativeSinkExample=compareTo(File):Argument[this] negativeSourceExample=compareTo(File):Parameter[this] // modeled as neutral
        File pathname // $ negativeSinkExample=compareTo(File):Argument[0] negativeSourceExample=compareTo(File):Parameter[0] // modeled as neutral
    ) {
        return 0;
    }

    public boolean setLastModified(long time) { // $ sinkModel=setLastModified(long):Argument[this] sourceModel=setLastModified(long):Parameter[this] // time is not a candidate (primitive type)
        return false;
    } // return value is not a source candidate because it's a primitive
}
