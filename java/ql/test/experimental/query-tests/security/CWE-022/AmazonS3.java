import software.amazon.awssdk.transfer.s3.S3TransferManager;
import software.amazon.awssdk.transfer.s3.model.UploadFileRequest;
import software.amazon.awssdk.transfer.s3.model.FileUpload;
import software.amazon.awssdk.transfer.s3.model.FileDownload;
import software.amazon.awssdk.transfer.s3.model.DirectoryUpload;
import software.amazon.awssdk.transfer.s3.model.CompletedDirectoryUpload;
import software.amazon.awssdk.transfer.s3.model.DirectoryDownload;
import software.amazon.awssdk.transfer.s3.model.CompletedDirectoryDownload;
import software.amazon.awssdk.transfer.s3.model.DownloadDirectoryRequest;
import software.amazon.awssdk.transfer.s3.model.DownloadFileRequest;
import software.amazon.awssdk.transfer.s3.model.ResumableFileUpload;
import software.amazon.awssdk.transfer.s3.model.UploadDirectoryRequest;
import software.amazon.awssdk.transfer.s3.model.ResumableFileDownload;
import software.amazon.awssdk.transfer.s3.model.CompletedFileUpload;
import software.amazon.awssdk.transfer.s3.model.CompletedFileDownload;
import software.amazon.awssdk.transfer.s3.progress.LoggingTransferListener;

import java.net.URI;
import java.nio.file.Paths;

public class AmazonS3 {
  S3TransferManager transferManager = S3TransferManager.create();
  String bucketName = "bucketTest";
  String key = "keyTest";

  public String uploadFile(URI filePathURI) {
    UploadFileRequest uploadFileRequest =
        UploadFileRequest.builder()
            .putObjectRequest(b -> b.bucket(this.bucketName).key(this.key))
            .addTransferListener(LoggingTransferListener.create())
            .source(Paths.get(filePathURI)) // $ hasTaintFlow="get(...)"
            .build();

    FileUpload fileUpload = this.transferManager.uploadFile(uploadFileRequest);

    CompletedFileUpload uploadResult = fileUpload.completionFuture().join();
    return uploadResult.response().eTag();
  }

  public String uploadFileResumable(URI filePathURI) {
    UploadFileRequest uploadFileRequest =
        UploadFileRequest.builder()
            .putObjectRequest(b -> b.bucket(this.bucketName).key(this.key))
            .addTransferListener(LoggingTransferListener.create())
            .source(Paths.get(filePathURI)) // $ hasTaintFlow="get(...)"
            .build();

    // Initiate the transfer
    FileUpload upload = this.transferManager.uploadFile(uploadFileRequest);
    // Pause the upload
    ResumableFileUpload resumableFileUpload = upload.pause();
    // Optionally, persist the resumableFileUpload
    resumableFileUpload.serializeToFile(Paths.get(filePathURI)); // $ hasTaintFlow="get(...)"
    // Retrieve the resumableFileUpload from the file
    ResumableFileUpload persistedResumableFileUpload =
        ResumableFileUpload.fromFile(Paths.get(filePathURI)); // $ hasTaintFlow="get(...)"
    // Resume the upload
    FileUpload resumedUpload = this.transferManager.resumeUploadFile(persistedResumableFileUpload);
    // Wait for the transfer to complete
    resumedUpload.completionFuture().join();
    FileUpload fileUpload = this.transferManager.uploadFile(uploadFileRequest);
    CompletedFileUpload uploadResult = fileUpload.completionFuture().join();
    return uploadResult.response().eTag();
  }

  public String downloadFileResumable(URI downloadedFileWithPath) {
    DownloadFileRequest downloadFileRequest =
        DownloadFileRequest.builder()
            .getObjectRequest(b -> b.bucket(this.bucketName).key(this.key))
            .addTransferListener(LoggingTransferListener.create())
            .destination(Paths.get(downloadedFileWithPath)) // $ hasTaintFlow="get(...)"
            .build();

    // Initiate the transfer
    FileDownload download = this.transferManager.downloadFile(downloadFileRequest);
    // Pause the download
    ResumableFileDownload resumableFileDownload = download.pause();
    // Optionally, persist the resumableFileDownload
    resumableFileDownload.serializeToFile(Paths.get(downloadedFileWithPath)); // $ hasTaintFlow="get(...)"
    // Retrieve the resumableFileDownload from the file
    ResumableFileDownload persistedResumableFileDownload =
        ResumableFileDownload.fromFile(Paths.get(downloadedFileWithPath)); // $ hasTaintFlow="get(...)"
    // Resume the download
    FileDownload resumedDownload =
        this.transferManager.resumeDownloadFile(persistedResumableFileDownload);
    // Wait for the transfer to complete
    resumedDownload.completionFuture().join();
    FileDownload filedownload = this.transferManager.downloadFile(downloadFileRequest);
    CompletedFileDownload downloadResult = filedownload.completionFuture().join();
    return downloadResult.response().eTag();
  }

  public Integer uploadDirectory(URI sourceDirectory) {
    DirectoryUpload directoryUpload =
        this.transferManager.uploadDirectory(
            UploadDirectoryRequest.builder()
                .source(Paths.get(sourceDirectory)) // $ hasTaintFlow="get(...)"
                .bucket(this.bucketName)
                .build());

    CompletedDirectoryUpload completedDirectoryUpload = directoryUpload.completionFuture().join();
    return completedDirectoryUpload.failedTransfers().size();
  }

  public Long downloadFile(String downloadedFileWithPath) {
    DownloadFileRequest downloadFileRequest =
        DownloadFileRequest.builder()
            .getObjectRequest(b -> b.bucket(this.bucketName).key(this.key))
            .addTransferListener(LoggingTransferListener.create())
            .destination(Paths.get(downloadedFileWithPath)) // $ hasTaintFlow="get(...)"
            .build();

    FileDownload downloadFile = this.transferManager.downloadFile(downloadFileRequest);

    CompletedFileDownload downloadResult = downloadFile.completionFuture().join();
    return downloadResult.response().contentLength();
  }

  public Integer downloadObjectsToDirectory(URI destinationPathURI) {
    DirectoryDownload directoryDownload =
        this.transferManager.downloadDirectory(
            DownloadDirectoryRequest.builder()
                .destination(Paths.get(destinationPathURI)) // $ hasTaintFlow="get(...)"
                .bucket(this.bucketName)
                .build());
    CompletedDirectoryDownload completedDirectoryDownload =
        directoryDownload.completionFuture().join();

    return completedDirectoryDownload.failedTransfers().size();
  }
}
