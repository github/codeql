import java.io.File;

class ContainerSizeCmpZero
{
    private static File MakeFile(String filename) {
    if(filename != null && filename.length() >= 0) {
        return new File(filename);
    }
    return new File("default.name");
    }
}
