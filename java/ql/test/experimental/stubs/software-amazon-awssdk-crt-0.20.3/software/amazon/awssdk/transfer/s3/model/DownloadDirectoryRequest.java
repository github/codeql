// Generated automatically from software.amazon.awssdk.transfer.s3.model.DownloadDirectoryRequest
// for testing purposes

package software.amazon.awssdk.transfer.s3.model;

import java.nio.file.Path;
import java.util.function.Consumer;
import software.amazon.awssdk.services.s3.model.ListObjectsV2Request;
import software.amazon.awssdk.transfer.s3.config.DownloadFilter;
import software.amazon.awssdk.transfer.s3.model.DownloadFileRequest;
import software.amazon.awssdk.transfer.s3.model.TransferDirectoryRequest;
import software.amazon.awssdk.utils.builder.CopyableBuilder;
import software.amazon.awssdk.utils.builder.ToCopyableBuilder;

public class DownloadDirectoryRequest
    implements ToCopyableBuilder<DownloadDirectoryRequest.Builder, DownloadDirectoryRequest>,
        TransferDirectoryRequest {
  protected DownloadDirectoryRequest() {}

  public DownloadDirectoryRequest(DownloadDirectoryRequest.DefaultBuilder p0) {}

  public DownloadDirectoryRequest.Builder toBuilder() {
    return null;
  }

  public DownloadFilter filter() {
    return null;
  }

  public Path destination() {
    return null;
  }

  public String bucket() {
    return null;
  }

  public String toString() {
    return null;
  }

  public boolean equals(Object p0) {
    return false;
  }

  public int hashCode() {
    return 0;
  }

  public java.util.function.Consumer<DownloadFileRequest.Builder> downloadFileRequestTransformer() {
    return null;
  }

  public java.util.function.Consumer<ListObjectsV2Request.Builder> listObjectsRequestTransformer() {
    return null;
  }

  public static DownloadDirectoryRequest.Builder builder() {
    return null;
  }

  public static java.lang.Class<? extends DownloadDirectoryRequest.Builder>
      serializableBuilderClass() {
    return null;
  }

  public static interface Builder
      extends CopyableBuilder<DownloadDirectoryRequest.Builder, DownloadDirectoryRequest> {
    DownloadDirectoryRequest.Builder bucket(String p0);

    DownloadDirectoryRequest.Builder destination(Path p0);

    DownloadDirectoryRequest.Builder downloadFileRequestTransformer(
        java.util.function.Consumer<DownloadFileRequest.Builder> p0);

    DownloadDirectoryRequest.Builder filter(DownloadFilter p0);

    DownloadDirectoryRequest.Builder listObjectsV2RequestTransformer(
        java.util.function.Consumer<ListObjectsV2Request.Builder> p0);
  }

  public static class DefaultBuilder {}
}
