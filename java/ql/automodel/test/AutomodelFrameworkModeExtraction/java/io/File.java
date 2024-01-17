package java.io;

public class File {
    public int compareTo( // $ negativeExample=compareTo(File):Argument[this] negativeExample=compareTo(File):Parameter[this] // modeled as neutral
        File pathname // $ negativeExample=compareTo(File):Argument[0] negativeExample=compareTo(File):Parameter[0] // modeled as neutral
    ) {
        return 0;
    }

    public boolean setLastModified(long time) { // $ sinkModel=setLastModified(long):Argument[this] sourceModel=setLastModified(long):Parameter[this] // time is not a candidate (primitive type)
        return false;
    } // return value is not a source candidate because it's a primitive
}
