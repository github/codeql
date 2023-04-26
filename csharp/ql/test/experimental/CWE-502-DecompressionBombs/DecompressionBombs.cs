using System.IO.Compression;
using Microsoft.AspNetCore.Mvc;

// For more information on enabling Web API for empty projects, visit https://go.microsoft.com/fwlink/?LinkID=397860

namespace MultipartFormWebAPITest.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ZipFile1Controller : ControllerBase
    {
        // POST api/<ImagesController>
        [HttpPost]
        public string Post(List<IFormFile> files)
        {
            if (!Request.ContentType!.StartsWith("multipart/form-data"))
                return "400";
            if (files.Count == 0)
                return "400";
            foreach (var formFile in files)
            {
                using var readStream = formFile.OpenReadStream();
                if (readStream.Length == 0) return "400";
                ZipHelpers.Bomb3(readStream);
                ZipHelpers.Bomb2(formFile.FileName);
                ZipHelpers.Bomb1(formFile.FileName);
            }
            var tmp = Request.Form["aa"];
            var tmp2 = Request.Form.Keys;
            // when we don't have only one file as body 
            ZipHelpers.Bomb3(Request.Body);
            ZipHelpers.Bomb2(Request.Query["param1"].ToString());
            var headers = Request.Headers;
            ZipHelpers.Bomb1(headers.ETag);
            return "200";
        }
    }
}

internal static class ZipHelpers
{
    public static void Bomb3(Stream compressedFileStream)
    {
        // using FileStream compressedFileStream = File.Open(CompressedFileName, FileMode.Open);
        // using FileStream outputFileStream = File.Create(DecompressedFileName);
        using var decompressor = new GZipStream(compressedFileStream, CompressionMode.Decompress);
        using var ms = new MemoryStream();
        decompressor.CopyTo(ms);
    }

    public static void Bomb2(string filename)
    {
        using var zipToOpen = new FileStream(filename, FileMode.Open);
        using var archive = new ZipArchive(zipToOpen, ZipArchiveMode.Read);
        foreach (var entry in archive.Entries) entry.ExtractToFile("./output.txt", true); // Sensitive
    }

    public static void Bomb1(string filename)
    {
        const long maxLength = 10 * 1024 * 1024; // 10MB
        // var filename = "/home/am/0_WorkDir/Payloads/Bombs/bombs-bones-codes-BH-2016/archives/evil-headers/10GB.zip";
        using var zipFile = ZipFile.OpenRead(filename);
        // Quickly check the value from the zip header
        var declaredSize = zipFile.Entries.Sum(entry => entry.Length);
        if (declaredSize > maxLength)
            throw new Exception("Archive is too big");
        foreach (var entry in zipFile.Entries)
        {
            using var entryStream = entry.Open();
            // Use MaxLengthStream to ensure we don't read more than the declared length
            using var maxLengthStream = new MaxLengthStream(entryStream, entry.Length);
            // Be sure to use the maxLengthSteam variable to read the content of the entry, not entryStream
            using var ms = new MemoryStream();
            maxLengthStream.CopyTo(ms);
        }
    }
}

internal sealed class MaxLengthStream : Stream
{
    private readonly Stream _stream;
    private long _length;

    public MaxLengthStream(Stream stream, long maxLength)
    {
        _stream = stream ?? throw new ArgumentNullException(nameof(stream));
        MaxLength = maxLength;
    }

    private long MaxLength { get; }

    public override bool CanRead => _stream.CanRead;
    public override bool CanSeek => false;
    public override bool CanWrite => false;
    public override long Length => _stream.Length;

    public override long Position
    {
        get => _stream.Position;
        set => throw new NotSupportedException();
    }

    public override int Read(byte[] buffer, int offset, int count)
    {
        var result = _stream.Read(buffer, offset, count);
        _length += result;
        if (_length > MaxLength)
            throw new Exception("Stream is larger than the maximum allowed size");

        return result;
    }

    // TODO ReadAsync

    public override void Flush()
    {
        throw new NotSupportedException();
    }

    public override long Seek(long offset, SeekOrigin origin)
    {
        throw new NotSupportedException();
    }

    public override void SetLength(long value)
    {
        throw new NotSupportedException();
    }

    public override void Write(byte[] buffer, int offset, int count)
    {
        throw new NotSupportedException();
    }

    protected override void Dispose(bool disposing)
    {
        _stream.Dispose();
        base.Dispose(disposing);
    }
}