package com.semmle.js.dependencies;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PushbackInputStream;
import java.io.Reader;
import java.net.URL;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

import com.google.gson.Gson;
import com.google.gson.JsonParseException;

import com.semmle.js.dependencies.packument.Packument;

import org.apache.commons.compress.archivers.tar.TarArchiveEntry;
import org.apache.commons.compress.archivers.tar.TarArchiveInputStream;
import org.apache.commons.compress.compressors.gzip.GzipCompressorInputStream;
import org.apache.commons.compress.utils.IOUtils;

/**
 * Synchronous I/O operations needed for dependency installation.
 * <p>
 * By design, the methods in this class are thread-safe, synchronous (blocking), and do not cache anything.
 * <p>
 * Should only be used through the {@link AsyncFetcher} class, which wraps this class with scheduling and caching.
 */
public class Fetcher {
    private Object mkdirpLock = new Object();

    /** Creates the given directory and its parent directories. Only one thread is allowed to create directories at once. */
    public void mkdirp(Path dir) throws IOException {
        synchronized (mkdirpLock) {
            Files.createDirectories(dir);
        }
    }

    private static final Pattern validPackageName = Pattern.compile("(?:@[\\w.-]+\\/)?\\w[\\w.-]*");

    private boolean isValidPackageName(String name) {
        return validPackageName.matcher(name).matches();
    }

    public static Path toSafePath(String string) {
        if (string == null) return null;
        Path path = Paths.get(string).normalize();
        if (path.startsWith("..") || path.isAbsolute()) {
            return null;
        }
        return path;
    }

    /**
     * Submits a GET request to the given URL and returns an input with the response.
     */
    private InputStream fetch(String url) throws IOException {
        URLConnection connection = new URL(url).openConnection();
        connection.setRequestProperty("Accept-Encoding", "gzip, identity, *");
        connection.setDoInput(true);
        connection.connect();
        InputStream input = connection.getInputStream();
        String encoding = connection.getContentEncoding();
        if ("gzip".equals(encoding)) {
            return new GzipCompressorInputStream(new BufferedInputStream(input));
        } else {
            return input;
        }
    }

    /**
     * Fetches the packument for the given package (containing all versions of the package.json).
     */
    public Packument getPackument(String packageName) throws IOException {
        if (!isValidPackageName(packageName)) {
            throw new IOException("Package name contains unexpected characters:" + packageName);
        }
        System.out.println("Fetching package metadata for " + packageName);
        try (Reader reader = new BufferedReader(new InputStreamReader(fetch("https://registry.npmjs.org/" + packageName)))) {
            Packument packument = new Gson().fromJson(reader, Packument.class);
            if (packument == null) {
                throw new IOException("Malformed packument for " + packageName);
            }
            return packument;
        } catch (JsonParseException ex) {
            throw new IOException("Malformed packument for " + packageName, ex);
        }
    }

    /**
     * Extracts the package at the given tarball URL into the given directory.
     * <p>
     * Only `package.json` and `.d.ts` files are extracted.
     *
     * @return paths of the files created by this call, relative to <code>destDir</code>
     */
    public List<Path> extractFromTarballUrl(String tarballUrl, Path destDir) throws IOException {
        if  (!tarballUrl.startsWith("https://registry.npmjs.org/") || !tarballUrl.endsWith(".tgz")) { // Paranoid check
            throw new IOException("Tarball URL has unexpected format: " + tarballUrl);
        }
        System.out.println("Unpacking " + tarballUrl + " to " + destDir);
        List<Path> relativePaths = new ArrayList<>();
        try (InputStream rawStream = new URL(tarballUrl).openStream()) {
            // Despite having the .tgz extension, the file is not always gzipped, sometimes it's just a raw tar archive,
            // regardless of what Accept-Encoding header we send.
            // Sniff the header to detect which is the case.
            // Note that the compression format has nothing to do with the Accept-Encoding/Content-Encoding headers,
            // so we can't reuse the code from fetch().
            PushbackInputStream pushback = new PushbackInputStream(rawStream, 2);
            int byte1 = pushback.read();
            int byte2 = pushback.read();
            pushback.unread(byte2);
            pushback.unread(byte1);
            InputStream decompressedStream = (byte1 == 31 && byte2 == 139)
                ? new GzipCompressorInputStream(new BufferedInputStream(pushback))
                : pushback;
            TarArchiveInputStream stream = new TarArchiveInputStream(new BufferedInputStream(decompressedStream));
            TarArchiveEntry tarEntry;
            while ((tarEntry = stream.getNextTarEntry()) != null) {
                if (!stream.canReadEntryData(tarEntry)) {
                    continue;
                }
                if (tarEntry.isDirectory()) {
                    continue; // We create directories on demand.
                }
                Path entryPath = toSafePath(tarEntry.getName());
                if (entryPath == null) continue;

                // Strip off the leading folder name.
                // The entire package is inside a folder, but the name of that folder is unspecified and its name varies.
                if (entryPath.getNameCount() < 2) continue;
                entryPath = entryPath.subpath(1, entryPath.getNameCount());

                String filename = entryPath.getFileName().toString();
                if (!filename.endsWith(".d.ts") && !filename.equals("package.json")) {
                    continue; // Only extract .d.ts files and package.json
                }
                relativePaths.add(entryPath);
                Path outputFile = destDir.resolve(entryPath);
                mkdirp(outputFile.getParent());
                try (OutputStream output = new BufferedOutputStream(Files.newOutputStream(outputFile))) {
                    IOUtils.copy(stream, output);
                }
            }
        }
        return relativePaths;
    }
}
