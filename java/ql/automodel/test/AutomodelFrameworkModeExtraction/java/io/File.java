package java.io;

public class File {
    public int compareTo( // $ negativeSinkExample=compareTo(File):Argument[this] sourceModelCandidate=compareTo(File):Parameter[this] // modeled as neutral for sinks
        File pathname // $ negativeSinkExample=compareTo(File):Argument[0] sourceModelCandidate=compareTo(File):Parameter[0] // modeled as neutral for sinks
    ) {
        return 0;
    }

    public boolean setLastModified(long time) { // $ sinkModelCandidate=setLastModified(long):Argument[this] sourceModelCandidate=setLastModified(long):Parameter[this] // time is not a candidate (primitive type)
        return false;
    } // return value is not a source candidate because it's a primitive
}
