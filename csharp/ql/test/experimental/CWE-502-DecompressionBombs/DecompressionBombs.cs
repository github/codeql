using System.IO.Compression;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;

namespace MultipartFormWebAPITest.Controllers;

[Route("api/[controller]")]
[ApiController]
public class ZipFile1Controller : ControllerBase
{
    [HttpPost]
    public IActionResult Post(List<IFormFile> files)
    {
        foreach (var formFile in files)
        {
            ZipHelpers.Bomb2(formFile.FileName);
            ZipHelpers.BombSafe(formFile.FileName);
            ZipHelpers.Bomb3(formFile.OpenReadStream());
        }


        StringValues file1;
        StringValues header1;
        Request.Form.TryGetValue("file", out file1);
        Request.Headers.TryGetValue("Header1", out header1);
        Request.Query.TryGetValue("queryParam1", out var qParam);

        var a = Request.Headers["a"];
        var b = Request.Headers.ContentType;

        var d = Array.Empty<KeyValuePair<string, StringValues>>();
        Request.Headers.CopyTo(d, 0);

        ZipHelpers.Bomb2(file1!);
        ZipHelpers.Bomb2(header1!);
        ZipHelpers.Bomb2(qParam!);

        return Accepted();
    }
}

internal static class ZipHelpers
{
    public static void Bomb3(Stream compressedFileStream)
    {
        using var decompressor = new GZipStream(compressedFileStream, CompressionMode.Decompress);
        using var ms = new MemoryStream();
        decompressor.CopyTo(ms);
        using var decompressor2 = new BrotliStream(compressedFileStream, CompressionMode.Decompress);
        using var ms2 = new MemoryStream();
        decompressor2.CopyTo(ms2);
        using var decompressor3 = new DeflateStream(compressedFileStream, CompressionMode.Decompress);
        using var ms3 = new MemoryStream();
        decompressor3.CopyTo(ms3);
    }

    public static void Bomb2(string filename)
    {
        using var zipToOpen = new FileStream(filename, FileMode.Open);
        using var archive = new ZipArchive(zipToOpen, ZipArchiveMode.Read);
        archive.ExtractToDirectory("./tmp/", true);
        (archive.GetEntry("aaa") ?? throw new InvalidOperationException()).ExtractToFile("/tmp/tmp");
        foreach (var entry in archive.Entries) entry.ExtractToFile("./output.txt", true); // Sensitive
    }

    public static void BombSafe(string filename)
    {
        const long maxLength = 10 * 1024 * 1024; // 10MB
        using var zipFile = ZipFile.Open(filename, ZipArchiveMode.Read);
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

        const string zipPath = @"c:\users\exampleuser\start.zip";
        const string extractPath = @"c:\users\exampleuser\extract";
        using var archive = ZipFile.Open(zipPath, ZipArchiveMode.Update);
        archive.ExtractToDirectory(extractPath);
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