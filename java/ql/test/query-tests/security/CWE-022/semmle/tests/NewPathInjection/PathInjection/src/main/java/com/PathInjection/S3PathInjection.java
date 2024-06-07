package com.PathInjection;

import software.amazon.awssdk.transfer.s3.S3TransferManager;
import software.amazon.awssdk.transfer.s3.model.*;
import software.amazon.awssdk.transfer.s3.progress.LoggingTransferListener;

import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.Paths;

public class S3PathInjection {
  S3TransferManager transferManager = S3TransferManager.create();
  String bucketName = "bucketTest";
  String key = "keyTest";

  public String uploadFile(URI filePathURI) {
    UploadFileRequest uploadFileRequest =
        UploadFileRequest.builder()
            .putObjectRequest(b -> b.bucket(this.bucketName).key(this.key))
            .addTransferListener(LoggingTransferListener.create())
            .source(Paths.get(filePathURI)) // $ PathInjection
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
            .source(Paths.get(filePathURI)) // $ PathInjection
            .build();

    // Initiate the transfer
    FileUpload upload = this.transferManager.uploadFile(uploadFileRequest);
    // Pause the upload
    ResumableFileUpload resumableFileUpload = upload.pause();
    // Optionally, persist the resumableFileUpload
    resumableFileUpload.serializeToFile(Paths.get(filePathURI)); // $ PathInjection
    // Retrieve the resumableFileUpload from the file
    ResumableFileUpload persistedResumableFileUpload =
        ResumableFileUpload.fromFile(Paths.get(filePathURI)); // $ PathInjection
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
            .destination(Paths.get(downloadedFileWithPath)) // $ PathInjection
            .build();

    // Initiate the transfer
    FileDownload download = this.transferManager.downloadFile(downloadFileRequest);
    // Pause the download
    ResumableFileDownload resumableFileDownload = download.pause();
    // Optionally, persist the resumableFileDownload
    resumableFileDownload.serializeToFile(Paths.get(downloadedFileWithPath)); // $ PathInjection
    // Retrieve the resumableFileDownload from the file
    ResumableFileDownload persistedResumableFileDownload =
        ResumableFileDownload.fromFile(Paths.get(downloadedFileWithPath)); // $ PathInjection
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
                .source(Paths.get(sourceDirectory)) // $ PathInjection
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
            .destination(Paths.get(downloadedFileWithPath)) // $ PathInjection
            .build();

    FileDownload downloadFile = this.transferManager.downloadFile(downloadFileRequest);

    CompletedFileDownload downloadResult = downloadFile.completionFuture().join();
    return downloadResult.response().contentLength();
  }

  public Integer downloadObjectsToDirectory(URI destinationPathURI) {
    DirectoryDownload directoryDownload =
        this.transferManager.downloadDirectory(
            DownloadDirectoryRequest.builder()
                .destination(Paths.get(destinationPathURI)) // $ PathInjection
                .bucket(this.bucketName)
                .build());
    CompletedDirectoryDownload completedDirectoryDownload =
        directoryDownload.completionFuture().join();

    return completedDirectoryDownload.failedTransfers().size();
  }
}
