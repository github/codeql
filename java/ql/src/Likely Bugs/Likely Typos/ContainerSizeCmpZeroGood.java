import java.io.File;

class ContainerSizeCmpZero
{
    private static File MakeFile(String filename) {
    if(filename != null && !filename.isEmpty()) {
        return new File(filename);
    }
    return new File("default.name");
    }
}
