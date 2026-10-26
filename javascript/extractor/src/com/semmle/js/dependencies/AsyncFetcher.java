package com.semmle.js.dependencies;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.CompletionException;
import java.util.concurrent.ExecutorService;
import java.util.function.Consumer;
import java.util.function.Supplier;

import com.semmle.js.dependencies.packument.Packument;

/**
 * Asynchronous I/O operations needed for dependency installation.
 * <p>
 * The methods in this class are non-blocking, that is, they return more or less immediately, always scheduling the work
 * in the provided executor service. Requests are cached where it makes sense.
 */
public class AsyncFetcher {
    private Fetcher fetcher = new Fetcher();
    private ExecutorService executor;
    private Consumer<CompletionException> errorReporter;

    /**
     * @param executor thread pool to perform I/O tasks
     * @param errorReporter called once for each error from the underlying I/O tasks
     */
    public AsyncFetcher(ExecutorService executor, Consumer<CompletionException> errorReporter) {
        this.executor = executor;
        this.errorReporter = errorReporter;
    }

    private CompletionException makeError(String message, Exception cause) {
        CompletionException ex = new CompletionException(message, cause);
        errorReporter.accept(ex); // Handle here to ensure each exception is logged at most once, not once per consumer
        throw ex;
    }

    private class CachedOperation<K, V> {
        private Map<K, CompletableFuture<V>> cache = new LinkedHashMap<>();

        public synchronized CompletableFuture<V> get(K key, Supplier<V> builder) {
            CompletableFuture<V> future = cache.get(key);
            if (future == null) {
                future = CompletableFuture.supplyAsync(() -> builder.get(), executor);
                cache.put(key, future);
            }
            return future;
        }
    }

    private CachedOperation<String, Packument> packuments = new CachedOperation<>();

    /**
     * Returns a future that completes with the packument for the given package.
     * <p>
     * At most one fetch will be performed.
     */
    public CompletableFuture<Packument> getPackument(String packageName) {
        return packuments.get(packageName, () -> {
            try {
                return fetcher.getPackument(packageName);
            } catch (IOException e) {
                throw makeError("Could not fetch packument for " + packageName, e);
            }
        });
    }

    /** Result of a tarball extraction */
    private static class ExtractionResult {
        /** The directory into which the tarball was extracted. */
        Path destDir;

        /** Files created by the extraction, relative to <code>destDir</code>. */
        List<Path> relativePaths;

        ExtractionResult(Path destDir, List<Path> relativePaths) {
            this.destDir = destDir;
            this.relativePaths = relativePaths;
        }
    }

    private CachedOperation<String, ExtractionResult> tarballExtractions = new CachedOperation<>();

    /**
     * Extracts the relevant contents of the given tarball URL in the given folder;
     * the returned future completes when done.
     *
     * If the same tarball has already been extracted elsewhere, then symbolic links are added to `destDir` linking to the already extracted tarball. 
     */
    public CompletableFuture<Void> installFromTarballUrl(String tarballUrl, Path destDir) {
        return tarballExtractions.get(tarballUrl, () -> {
            try {
                List<Path> relativePaths = fetcher.extractFromTarballUrl(tarballUrl, destDir);
                return new ExtractionResult(destDir, relativePaths);
            } catch (IOException e) {
                throw makeError("Could not install package from " + tarballUrl, e);
            }
        }).thenAccept(extractionResult -> {
            if (!extractionResult.destDir.equals(destDir)) {
                // We've been asked to extract the same tarball into multiple directories (due to multiple package.json files).
                // Symlink files from the original directory instead of extracting again.
                // In principle we could symlink the whole directory, but directory symlinks are hard to create in a portable way.
                System.out.println("Creating symlink farm from " + destDir + " to " + extractionResult.destDir);
                for (Path relativePath : extractionResult.relativePaths) {
                    Path originalFile = extractionResult.destDir.resolve(relativePath);
                    Path newFile = destDir.resolve(relativePath);
                    try {
                        fetcher.mkdirp(newFile.getParent());
                        Files.createSymbolicLink(newFile, originalFile);
                    } catch (IOException e) {
                        throw makeError("Failed to create symlink " + newFile + " -> " + originalFile, e);
                    }
                }
            }
        });
    }
}
