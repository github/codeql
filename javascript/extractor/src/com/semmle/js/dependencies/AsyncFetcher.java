package com.semmle.js.dependencies;

import java.io.IOException;
import java.nio.file.Path;
import java.util.LinkedHashMap;
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

    class CachedOperation<K, V> {
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

    /**
     * Extracts the relevant contents of the given tarball URL in the given folder;
     * the returned future completes when done.
     */
    public CompletableFuture<Void> installFromTarballUrl(String tarballUrl, Path destDir) {
        return CompletableFuture.runAsync(() -> {
            try {
                fetcher.extractFromTarballUrl(tarballUrl, destDir);
            } catch (IOException e) {
                throw makeError("Could not install package from " + tarballUrl, e);
            }
        }, executor);
    }
}
