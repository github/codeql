using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// A package in a NuGet package repository.
    /// For example, the directory C:\Users\calum\.nuget\packages\microsoft.visualbasic.
    /// 
    /// Each package contains a number of subdirectories, organised by version.
    /// </summary>
    class Package
    {
        public readonly string directory;

        /// <summary>
        /// Constructs a package for the given directory.
        /// </summary>
        /// <param name="dir">The directory.</param>
        public Package(string dir)
        { 
            directory = dir;
        }

        /// <summary>
        /// The name of the package.
        /// </summary>
        public string Name => Path.GetDirectoryName(directory);

        /// <summary>
        /// The versions that exist within the package.
        /// </summary>
        public IEnumerable<PackageVersion> Versions => Directory.GetDirectories(directory).Select(dir => new PackageVersion(dir));

        public override string ToString() => Path.GetFileName(directory);

        public PackageVersion FindVersion(string version)
        {
            if (Directory.Exists(Path.Combine(directory, version)))
                return new PackageVersion(Path.Combine(directory, version));
            else
                return Versions.OrderByDescending(v => v.Version).First();
        }

        /// <summary>
        /// Locates the exact version of a particular package.
        /// </summary>
        /// <param name="version">The version to locate.</param>
        /// <returns>The specific version of the package.</returns>
        public PackageVersion FindExactVersion(string version)
        {
            if (Directory.Exists(Path.Combine(directory, version)))
                return new PackageVersion(Path.Combine(directory, version));
            else
                return null;
        }
    }

    /// <summary>
    /// A package in a NuGet package respository, including the specific version.
    /// For example, the directory C:\Users\calum\.nuget\packages\microsoft.visualbasic\10.0.1
    /// </summary>
    class PackageVersion
    {
        readonly string directory;

        /// <summary>
        /// The version of the package.
        /// </summary>
        public string Version => Path.GetFileName(directory);

        /// <summary>
        /// Constructs a package version from its directory.
        /// </summary>
        /// <param name="directory">The directory of this package.</param>
        public PackageVersion(string directory)
        {
            if (!Directory.Exists(directory))
                throw new DirectoryNotFoundException(directory);

            this.directory = directory;
        }

        public override string ToString() => Version;

        /// <summary>
        /// The frameworks within this package.
        /// Sometimes a directory references several frameworks, for example
        /// "net451+netstandard2.0". This are split into separate frameworks.
        /// </summary>
        IEnumerable<PackageFramework> UnorderedFrameworks
        {
            get
            {
                return UnorderedFrameworksInDirectory(Path.Combine(directory, "lib")).
                    Concat(UnorderedFrameworksInDirectory(Path.Combine(directory, "ref"))).
                    Concat(UnorderedFrameworksInDirectory(Path.Combine(directory, "build", "lib"))).
                    Concat(UnorderedFrameworksInDirectory(Path.Combine(directory, "build", "ref"))).
                    Concat(TryDirectory(Path.Combine(directory, "lib")));
            }
        }

        IEnumerable<PackageFramework> TryDirectory(string directory)
        {
            if (Directory.Exists(directory))
                yield return new PackageFramework(directory, "unknown");
        }

        IEnumerable<PackageFramework> UnorderedFrameworksInDirectory(string lib)
        {
            if (!Directory.Exists(lib))
                yield break;
            foreach (var p in System.IO.Directory.GetDirectories(lib))
            {
                var name = Path.GetFileName(p);
                if (name.Contains('+'))
                {
                    foreach (var p2 in name.Split('+'))
                        yield return new PackageFramework(p, p2);
                }
                else
                    yield return new PackageFramework(p, name);
            }
        }

        /// <summary>
        /// The frameworks in this package, in a consistent sequence, with the "best" frameworks
        /// appearing at the start of the list.
        /// 
        /// Priorities "netstandard" framework, followed by "netcoreapp", followed by everything else.
        /// Then, selects the highest version number.
        /// </summary>
        public IEnumerable<PackageFramework> Frameworks =>
            UnorderedFrameworks.
                    OrderBy(framework => framework.Framework.StartsWith("netstandard") ? 0 : framework.Framework.StartsWith("netcoreapp") ? 1 : 2).
                    ThenByDescending(framework => framework.Framework);

        /// <summary>
        /// Finds the best framework containing references.
        /// Returns null if no suitable framework was found.
        /// </summary>
        public PackageFramework? BestFramework => Frameworks.Where(f => f.References.Any()).FirstOrDefault();

        public bool ContainsLibraries
        {
            get
            {
                return Directory.Exists(Path.Combine(directory, "lib")) ||
                    Directory.Exists(Path.Combine(directory, "ref")) ||
                    Directory.Exists(Path.Combine(directory, "build", "lib")) ||
                    Directory.Exists(Path.Combine(directory, "build", "ref"));
            }
        }

        public bool ContainsDLLs
        {
            get
            {
                return Directory.GetFiles(directory, "*.dll", SearchOption.AllDirectories).Any();
            }
        }
    }

    /// <summary>
    /// A framework in a package.
    /// For example, C:\Users\calum\.nuget\packages\microsoft.testplatform.objectmodel\16.4.0\lib\netstandard2.0
    /// </summary>
    class PackageFramework
    {
        public string Directory { get; }

        /// <summary>
        /// The framework name.
        /// </summary>
        public string Framework { get; }

        /// <summary>
        /// Constructs a package framework from a directory.
        /// The framework is needed because the directory may specify more than one framework.
        /// </summary>
        /// <param name="dir">The directory path.</param>
        /// <param name="framework">The framework.</param>
        public PackageFramework(string dir, string framework)
        {
            if (!System.IO.Directory.Exists(dir))
                throw new FileNotFoundException(dir);
            Directory = dir;
            Framework = framework;
        }

        /// <summary>
        /// The reference DLLs contained within the directory.
        /// </summary>
        public IEnumerable<string> References
        {
            get
            {
                return new DirectoryInfo(Directory).GetFiles("*.dll").Select(fi => fi.FullName);
            }
        }

        public override string ToString() => Directory;
    }

    class TemporaryDirectory : IDisposable
    {
        readonly IProgressMonitor ProgressMonitor;

        public DirectoryInfo DirInfo { get; }

        public TemporaryDirectory(string name, IProgressMonitor pm)
        {
            ProgressMonitor = pm;
            DirInfo = new DirectoryInfo(name);
            DirInfo.Create();
        }

        /// <summary>
        /// Computes a unique temp directory for the packages associated
        /// with this source tree. Use a SHA1 of the directory name.
        /// </summary>
        /// <param name="srcDir"></param>
        /// <returns>The full path of the temp directory.</returns>
        public static string ComputeTempDirectory(string srcDir)
        {
            var bytes = Encoding.Unicode.GetBytes(srcDir);

            var sha1 = new SHA1CryptoServiceProvider();
            var sha = sha1.ComputeHash(bytes);
            var sb = new StringBuilder();
            foreach (var b in sha.Take(8))
                sb.AppendFormat("{0:x2}", b);

            return Path.Combine(Path.GetTempPath(), "GitHub", "packages", sb.ToString());
        }

        public static TemporaryDirectory CreateTempDirectory(string source, IProgressMonitor pm) => new TemporaryDirectory(ComputeTempDirectory(source), pm);

        public void Cleanup()
        {
            try
            {
                DirInfo.Delete(true);
            }
            catch (System.IO.IOException ex)
            {
                ProgressMonitor.Warning(string.Format("Couldn't delete package directory - it's probably held open by something else: {0}", ex.Message));
            }

        }

        public void Dispose()
        {
            Cleanup();
        }

        public override string ToString() => DirInfo.FullName.ToString();
    }

    /// <summary>
    /// The NuGet package repository.
    /// </summary>
    class NugetPackageRepository
    {
        // A list of package directories, in the order they should be searched.
        private readonly string[] packageDirs;

        public NugetPackageRepository(params string[] dirs)
        {
            packageDirs = dirs;
        }

        /// <summary>
        /// Constructs a NuGet package repository, using the default locations.
        /// For example,
        /// $HOME/.nuget/packages, /usr/share/dotnet/sdk/NuGetFallbackFolder
        /// </summary>
        public NugetPackageRepository(string sourceDir)
        {
            var homeFolder = Environment.GetFolderPath(Environment.SpecialFolder.UserProfile);
            var nugetPackages = Path.Combine(homeFolder, ".nuget", "packages");
            var nugetFallbackFolder = Environment.OSVersion.Platform == PlatformID.Win32NT ?
                @"C:\Program Files\dotnet\sdk\NuGetFallbackFolder" :
                "/usr/share/dotnet/sdk/NuGetFallbackFolder";

            packageDirs = new string[] { nugetPackages, nugetFallbackFolder };
        }

        /// <summary>
        /// Enumerate all available packages.
        /// </summary>
        public IEnumerable<Package> Packages
        {
            get
            {
                foreach (var d in packageDirs)
                    foreach (var p in Directory.GetDirectories(d))
                    {
                        var name = Path.GetFileName(p);
                        if (!name.StartsWith('.'))
                            yield return new Package(p);
                    }
            }
        }

        /// <summary>
        /// Tries to find a PackageFramework directory for a given package reference.
        /// </summary>
        /// <param name="reference">The package reference to search for.</param>
        /// <param name="package">The package that was found.</param>
        /// <returns>True if a package/version/framework was found.</returns>
        public bool TryFindLibs(PackageReference reference, out PackageFramework package, out ResolutionFailureReason reason)
        {
            var packages = packageDirs.
                Where(d => Directory.Exists(Path.Combine(d, reference.Include.ToLowerInvariant()))).
                Select(d => new Package(Path.Combine(d, reference.Include.ToLowerInvariant())));

            if(!packages.Any())
            {
                reason = ResolutionFailureReason.PackageNotFound;
                package = null;
                return false;
            }

            var version = packages.Select(p => p.FindVersion(reference.Version)).FirstOrDefault(v => !(v is null));

            if (version is null)
            {
                reason = ResolutionFailureReason.VersionNotFound;
                package = null;
                return false;
            }

            package = version.BestFramework;
            if(package is null)
            {
                reason = ResolutionFailureReason.LibsNotFound;
                return false;
            }

            reason = ResolutionFailureReason.Success;
            return true;
        }
    }

    enum ResolutionFailureReason
    {
        Success,
        PackageNotFound,
        VersionNotFound,
        LibsNotFound
    }
}
