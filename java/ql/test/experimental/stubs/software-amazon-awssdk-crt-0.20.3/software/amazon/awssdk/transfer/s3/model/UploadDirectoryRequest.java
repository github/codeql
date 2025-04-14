// Generated automatically from software.amazon.awssdk.transfer.s3.model.UploadDirectoryRequest for
// testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.nio.file.Path;
import java.util.Optional;
import java.util.OptionalInt;
import java.util.function.Consumer;
import software.amazon.awssdk.transfer.s3.model.TransferDirectoryRequest;
import software.amazon.awssdk.transfer.s3.model.UploadFileRequest;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class UploadDirectoryRequest
    implements ToCopyableBuilder<UploadDirectoryRequest.Builder, UploadDirectoryRequest>,
        TransferDirectoryRequest {
  protected UploadDirectoryRequest() {}

  public Optional<Boolean> followSymbolicLinks() {
    return null;
  }

  public Optional<String> s3Delimiter() {
    return null;
  }

  public Optional<String> s3Prefix() {
    return null;
  }

  public OptionalInt maxDepth() {
    return null;
  }

  public Path source() {
    return null;
  }

  public String bucket() {
    return null;
  }

  public String toString() {
    return null;
  }

  public UploadDirectoryRequest(UploadDirectoryRequest.DefaultBuilder p0) {}

  public UploadDirectoryRequest.Builder toBuilder() {
    return null;
  }

  public boolean equals(Object p0) {
    return false;
  }

  public int hashCode() {
    return 0;
  }

  public java.util.function.Consumer<UploadFileRequest.Builder> uploadFileRequestTransformer() {
    return null;
  }

  public static UploadDirectoryRequest.Builder builder() {
    return null;
  }

  public static java.lang.Class<? extends UploadDirectoryRequest.Builder>
      serializableBuilderClass() {
    return null;
  }

  public static interface Builder
      extends CopyableBuilder<UploadDirectoryRequest.Builder, UploadDirectoryRequest> {
    UploadDirectoryRequest build();

    UploadDirectoryRequest.Builder bucket(String p0);

    UploadDirectoryRequest.Builder followSymbolicLinks(Boolean p0);

    UploadDirectoryRequest.Builder maxDepth(Integer p0);

    UploadDirectoryRequest.Builder s3Delimiter(String p0);

    UploadDirectoryRequest.Builder s3Prefix(String p0);

    UploadDirectoryRequest.Builder source(Path p0);

    UploadDirectoryRequest.Builder uploadFileRequestTransformer(
        java.util.function.Consumer<UploadFileRequest.Builder> p0);
  }

  public static class DefaultBuilder {}
}
