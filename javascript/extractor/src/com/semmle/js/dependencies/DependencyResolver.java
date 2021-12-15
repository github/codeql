package com.semmle.js.dependencies;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.google.gson.Gson;
import com.semmle.js.dependencies.packument.PackageJson;
import com.semmle.util.data.Pair;

public class DependencyResolver {
    private AsyncFetcher fetcher;
    private List<Constraint> constraints = new ArrayList<>();

    /** Packages we don't try to install because it is part of the same monorepo. */
    private Set<String> packagesInRepo;

    private static class Constraint {
        final PackageJson targetPackage;
        final SemVer targetPackageVersion;
        final PackageJson demandingPackage;
        final int depth;

        Constraint(PackageJson targetPackage, SemVer targetPackageVersion, PackageJson demandingPackage, int depth) {
            this.targetPackage = targetPackage;
            this.targetPackageVersion = targetPackageVersion;
            this.demandingPackage = demandingPackage;
            this.depth = depth;
        }

        String getTargetPackageName() {
            return targetPackage.getName(); // Must exist as you can't depend on a package without a name
        }
    }

    public DependencyResolver(AsyncFetcher fetcher, Set<String> packagesInRepo) {
        this.fetcher = fetcher;
        this.packagesInRepo = packagesInRepo;
    }

    private void addConstraint(Constraint constraint) {
        synchronized(constraints) {
            constraints.add(constraint);
        }
    }

    // Matches either a version ("2.1.x" / "3.0", etc..), or a version constraint operator ("<", "||", "~", etc...). 
    private static final Pattern semVerToken = Pattern.compile("\\d+(?:\\.[\\dx]+)+(?:-[\\w.-]*)?|[~^<>=|&-]+");

    /**
     * Returns the first version number mentioned in the given constraints, excluding upper bounds such as `&lt; 2.0.0`,
     * or `null` if no such version number was found.
     * <p>
     * To help ensure deterministic version resolution, we prefer the version mentioned in the constraint, rather than
     * the latest version satisfying the constraint (as the latter can change in time).
     */
    public static SemVer getPreferredVersionFromVersionSpec(String versionSpec) {
        versionSpec = versionSpec.trim();
        boolean isFirst = true;
        Matcher m = semVerToken.matcher(versionSpec);
        while (m.find()) {
            if (isFirst && m.start() != 0) {
                return null; // Not a version range
            }
            isFirst = false;
            String text = m.group();
            if (text.equals("<")) {
                // Skip next token to ignore upper bound constraints like `< 2.0.0`.
                if (!m.find()) break;
            }
            if (text.charAt(0) >= '0' && text.charAt(0) <= '9') {
                SemVer semVer = SemVer.tryParse(text.replace("x", "0"));
                if (semVer != null) {
                    return semVer;
                }
            }
        }
        return null;
    }

    /**
     * Given a set of available versions, pick the oldest version no older than <code>preferredVersion</code>.
     */
    private Pair<SemVer, PackageJson> getTargetVersion(Map<String, PackageJson> versions, SemVer preferredVersion) {
        PackageJson result = versions.get(preferredVersion.toString());
        if (result != null) return Pair.make(preferredVersion, result);
        SemVer bestVersion = null;
        for (Map.Entry<String, PackageJson> entry : versions.entrySet()) {
            SemVer version = SemVer.tryParse(entry.getKey());
            if (version == null) continue; // Could not parse version
            if (version.compareTo(preferredVersion) < 0) continue; // Version is older than preferred version, ignore
            if (bestVersion != null && bestVersion.compareTo(version) < 0) continue; // We already found an older version
            bestVersion = version;
            result = entry.getValue();
        }
        return Pair.make(bestVersion, result);
    }

    /**
     * Fetches all packages and builds up the constraint system needed for resolving.
     */
    private CompletableFuture<Void> fetchRelevantPackages(PackageJson pack, int depth) {
        List<CompletableFuture<Void>> futures = new ArrayList<>();
        List<Map<String, String>> dependencyMaps = depth == 0
            ? Arrays.asList(pack.getDependencies(), pack.getPeerDependencies(), pack.getDevDependencies())
            : Arrays.asList(pack.getDependencies()); // for transitive dependencies, only follow explicit dependencies
        for (Map<String, String> dependencies : dependencyMaps) {
            if (dependencies == null) continue;
            dependencies.forEach((targetName, targetVersions) -> {
                if (packagesInRepo.contains(targetName)) {
                    return;
                }
                SemVer preferredVersion = getPreferredVersionFromVersionSpec(targetVersions);
                System.out.println("Prefer " + preferredVersion + " from " + targetVersions);
                if (preferredVersion == null) return;
                futures.add(fetcher.getPackument(targetName).exceptionally(ex -> null).thenCompose(targetPackument -> {
                    if (targetPackument == null) {
                        return CompletableFuture.completedFuture(null);
                    }
                    Map<String, PackageJson> versions = targetPackument.getVersions();
                    if (versions == null) return CompletableFuture.completedFuture(null);

                    // Pick the matching version
                    Pair<SemVer, PackageJson> targetVersionAndPackage = getTargetVersion(versions, preferredVersion);
                    SemVer targetVersion = targetVersionAndPackage.fst();
                    PackageJson targetPackage = targetVersionAndPackage.snd();
                    if (targetPackage == null) return CompletableFuture.completedFuture(null);

                    if (targetName.startsWith("@types/")) {
                        // Deeply install dependencies in `@types`
                        addConstraint(new Constraint(targetPackage, targetVersion, pack, depth));
                        return fetchRelevantPackages(targetPackage, depth + 1);
                    } else if (dependencies != pack.getDevDependencies() && (targetPackage.getTypes() != null || targetPackage.getTypings() != null)) {
                        // If a non-dev dependency contains its own typings, do a shallow install of that package
                        addConstraint(new Constraint(targetPackage, targetVersion, pack, depth));
                    }
                    return CompletableFuture.completedFuture(null);
                }));
            });
        }
        return CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));
    }

    /**
     * Resolves the dependencies of the given package in a deterministic way.
     */
    private CompletableFuture<Map<String, PackageJson>> resolvePackages(PackageJson rootPackage) {
        return fetchRelevantPackages(rootPackage, 0).thenApply(void_ -> {
            // Compute the minimum depth from which each dependency is requested.
            Map<String, Integer> packageDepth = new LinkedHashMap<>();
            for (Constraint constraint : constraints) {
                Integer currentDepth = packageDepth.get(constraint.getTargetPackageName());
                if (currentDepth == null || currentDepth > constraint.depth) {
                    packageDepth.put(constraint.getTargetPackageName(), constraint.depth);
                }
            }

            // We use a greedy solver: sort the constraints and then satisfy them eagerly in that order.
            constraints.sort((c1, c2) -> {
                int cmp;

                cmp = Integer.compare(packageDepth.get(c1.getTargetPackageName()), packageDepth.get(c2.getTargetPackageName()));
                if (cmp != 0) return cmp;

                cmp = c1.getTargetPackageName().compareTo(c2.getTargetPackageName());
                if (cmp != 0) return cmp;

                // Pick the most recent version, so reverse-sort by package version.
                cmp = -c1.targetPackageVersion.compareTo(c2.targetPackageVersion);
                if (cmp != 0) return cmp;

                return 0;
            });

            Map<String, PackageJson> selectedPackages = new LinkedHashMap<>();
            for (Constraint constraint : constraints) {
                if (selectedPackages.containsKey(constraint.getTargetPackageName())) {
                    // Too bad, we already picked a version for this package. Ignore the constraint.
                    continue;
                }
                if (constraint.demandingPackage != rootPackage) {
                    PackageJson selectedDemander = selectedPackages.get(constraint.demandingPackage.getName());
                    if (selectedDemander != null && selectedDemander != constraint.demandingPackage) {
                        // The constraint comes from a package version we already decided not to install (a different version was picked).
                        // There is no need to try to satisfy this constraint, so ignore it.
                        continue;
                    }
                }
                System.out.println("Picked " + constraint.getTargetPackageName() + "@" + constraint.targetPackageVersion);
                selectedPackages.put(constraint.getTargetPackageName(), constraint.targetPackage);
            }

            return selectedPackages;
        });
    }

    public CompletableFuture<Void> installDependencies(PackageJson rootPackage, Path nodeModulesDir) {
        return resolvePackages(rootPackage).thenCompose(resolvedPackages -> {
            List<CompletableFuture<Void>> futures = new ArrayList<>();
            resolvedPackages.forEach((name, targetPackage) -> {
                Path destinationDir = nodeModulesDir.resolve(Fetcher.toSafePath(name));
                futures.add(fetcher.installFromTarballUrl(targetPackage.getDist().getTarball(), destinationDir));
            });
            return CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]));
        });
    }

    /** Entry point which installs dependencies from a given `package.json`, used for testing and benchmarking. */
    public static void main(String[] args) throws IOException {
        ExecutorService executors = Executors.newFixedThreadPool(50);
        try {
            DependencyResolver resolver = new DependencyResolver(new AsyncFetcher(executors, err -> { System.err.println(err); }), Collections.emptySet());
            for (String packageJsonPath : args) {
                Path path = Paths.get(packageJsonPath).toAbsolutePath();
                PackageJson packageJson = new Gson().fromJson(Files.newBufferedReader(path), PackageJson.class);
                resolver.installDependencies(packageJson, path.getParent().resolve("node_modules")).join();
            }
            System.out.println("Done");
        } finally {
            executors.shutdown();
        }
    }
}
