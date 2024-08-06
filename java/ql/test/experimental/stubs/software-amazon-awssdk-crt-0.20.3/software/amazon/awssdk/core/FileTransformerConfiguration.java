// Generated automatically from software.amazon.awssdk.core.FileTransformerConfiguration for testing purposes

package software.amazon.awssdk.core;

import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class FileTransformerConfiguration implements ToCopyableBuilder<FileTransformerConfiguration.Builder, FileTransformerConfiguration>
{
    protected FileTransformerConfiguration() {}
    public FileTransformerConfiguration.Builder toBuilder(){ return null; }
    public FileTransformerConfiguration.FailureBehavior failureBehavior(){ return null; }
    public FileTransformerConfiguration.FileWriteOption fileWriteOption(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static FileTransformerConfiguration defaultCreateNew(){ return null; }
    public static FileTransformerConfiguration defaultCreateOrAppend(){ return null; }
    public static FileTransformerConfiguration defaultCreateOrReplaceExisting(){ return null; }
    public static FileTransformerConfiguration.Builder builder(){ return null; }
    static public enum FailureBehavior
    {
        DELETE, LEAVE;
        private FailureBehavior() {}
    }
    static public enum FileWriteOption
    {
        CREATE_NEW, CREATE_OR_APPEND_TO_EXISTING, CREATE_OR_REPLACE_EXISTING;
        private FileWriteOption() {}
    }
    static public interface Builder extends CopyableBuilder<FileTransformerConfiguration.Builder, FileTransformerConfiguration>
    {
        FileTransformerConfiguration.Builder failureBehavior(FileTransformerConfiguration.FailureBehavior p0);
        FileTransformerConfiguration.Builder fileWriteOption(FileTransformerConfiguration.FileWriteOption p0);
    }
}
