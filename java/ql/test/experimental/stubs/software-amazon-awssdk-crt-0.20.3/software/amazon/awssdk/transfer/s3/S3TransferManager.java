// Generated automatically from software.amazon.awssdk.transfer.s3.S3TransferManager for testing purposes

package software.amazon.awssdk.transfer.s3;

import java.util.concurrent.Executor;
import java.util.function.Consumer;
import software.amazon.awssdk.services.s3.S3AsyncClient;
import software.amazon.awssdk.transfer.s3.model.Copy;
import software.amazon.awssdk.transfer.s3.model.CopyRequest;
import software.amazon.awssdk.transfer.s3.model.DirectoryDownload;
import software.amazon.awssdk.transfer.s3.model.DirectoryUpload;
import software.amazon.awssdk.transfer.s3.model.Download;
import software.amazon.awssdk.transfer.s3.model.DownloadDirectoryRequest;
import software.amazon.awssdk.transfer.s3.model.DownloadFileRequest;
import software.amazon.awssdk.transfer.s3.model.DownloadRequest;
import software.amazon.awssdk.transfer.s3.model.FileDownload;
import software.amazon.awssdk.transfer.s3.model.FileUpload;
import software.amazon.awssdk.transfer.s3.model.ResumableFileDownload;
import software.amazon.awssdk.transfer.s3.model.ResumableFileUpload;
import software.amazon.awssdk.transfer.s3.model.Upload;
import software.amazon.awssdk.transfer.s3.model.UploadDirectoryRequest;
import software.amazon.awssdk.transfer.s3.model.UploadFileRequest;
import software.amazon.awssdk.transfer.s3.model.UploadRequest;
import software.amazon.awssdk.utils.SdkAutoCloseable;

public interface S3TransferManager extends SdkAutoCloseable
{
    default <ResultT> Download<ResultT> download(DownloadRequest<ResultT> p0){ return null; }
    default Copy copy(CopyRequest p0){ return null; }
    default Copy copy(java.util.function.Consumer<CopyRequest.Builder> p0){ return null; }
    default DirectoryDownload downloadDirectory(DownloadDirectoryRequest p0){ return null; }
    default DirectoryDownload downloadDirectory(java.util.function.Consumer<DownloadDirectoryRequest.Builder> p0){ return null; }
    default DirectoryUpload uploadDirectory(UploadDirectoryRequest p0){ return null; }
    default DirectoryUpload uploadDirectory(java.util.function.Consumer<UploadDirectoryRequest.Builder> p0){ return null; }
    default FileDownload downloadFile(DownloadFileRequest p0){ return null; }
    default FileDownload downloadFile(java.util.function.Consumer<DownloadFileRequest.Builder> p0){ return null; }
    default FileDownload resumeDownloadFile(ResumableFileDownload p0){ return null; }
    default FileDownload resumeDownloadFile(java.util.function.Consumer<ResumableFileDownload.Builder> p0){ return null; }
    default FileUpload resumeUploadFile(ResumableFileUpload p0){ return null; }
    default FileUpload resumeUploadFile(java.util.function.Consumer<ResumableFileUpload.Builder> p0){ return null; }
    default FileUpload uploadFile(UploadFileRequest p0){ return null; }
    default FileUpload uploadFile(java.util.function.Consumer<UploadFileRequest.Builder> p0){ return null; }
    default Upload upload(UploadRequest p0){ return null; }
    default Upload upload(java.util.function.Consumer<UploadRequest.Builder> p0){ return null; }
    static S3TransferManager create(){ return null; }
    static S3TransferManager.Builder builder(){ return null; }
    static public interface Builder
    {
        S3TransferManager build();
        S3TransferManager.Builder executor(Executor p0);
        S3TransferManager.Builder s3Client(S3AsyncClient p0);
        S3TransferManager.Builder uploadDirectoryFollowSymbolicLinks(Boolean p0);
        S3TransferManager.Builder uploadDirectoryMaxDepth(Integer p0);
    }
}
