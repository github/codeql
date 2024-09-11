using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Reflection.Metadata;
using System.Text.RegularExpressions;

namespace Semmle.Extraction.CSharp.DependencyFetching
{
    /// <summary>
    /// Stores information about an assembly file (DLL).
    /// </summary>
    internal sealed partial class AssemblyInfo
    {
        /// <summary>
        /// The file containing the assembly.
        /// </summary>
        public string Filename { get; }

        /// <summary>
        /// The short name of this assembly.
        /// </summary>
        public string Name { get; }

        /// <summary>
        /// The version number of this assembly.
        /// </summary>
        public System.Version? Version { get; }

        /// <summary>
        /// The version number of the .NET Core framework that this assembly targets.
        ///
        /// This is extracted from the `TargetFrameworkAttribute` of the assembly, e.g.
        /// ```
        /// [assembly:TargetFramework(".NETCoreApp,Version=v7.0")]
        /// ```
        /// yields version 7.0.
        /// </summary>
        public Version? NetCoreVersion { get; }

        /// <summary>
        /// The public key token of the assembly.
        /// </summary>
        public string? PublicKeyToken { get; }

        /// <summary>
        /// The culture.
        /// </summary>
        public string? Culture { get; }

        /// <summary>
        /// Gets the canonical ID of this assembly.
        /// </summary>
        public string Id
        {
            get
            {
                var result = Name;
                if (Version is not null)
                    result = $"{result}, Version={Version}";
                if (Culture is not null)
                    result = $"{result}, Culture={Culture}";
                if (PublicKeyToken is not null)
                    result = $"{result}, PublicKeyToken={PublicKeyToken}";
                return result;
            }
        }

        public override string ToString() => Id;

        /// <summary>
        /// Gets a list of canonical search strings for this assembly.
        /// </summary>
        public IEnumerable<string> IndexStrings
        {
            get
            {
                yield return Id;
                if (Version is not null)
                {
                    if (Culture is not null)
                        yield return $"{Name}, Version={Version}, Culture={Culture}";
                    yield return $"{Name}, Version={Version}";
                }
                yield return Name;
                yield return Name.ToLowerInvariant();
            }
        }

        private AssemblyInfo(string id, string filename)
        {
            var sections = id.Split(new string[] { ", " }, StringSplitOptions.None);

            Name = sections[0];

            foreach (var section in sections.Skip(1))
            {
                if (section.StartsWith("Version="))
                    Version = new Version(section.Substring(8));
                else if (section.StartsWith("Culture="))
                    Culture = section.Substring(8);
                else if (section.StartsWith("PublicKeyToken="))
                    PublicKeyToken = section.Substring(15);
                // else: Some other field like processorArchitecture - ignore.
            }

            Filename = filename;
        }

        private AssemblyInfo(string filename, string name, Version version, string culture, string publicKeyToken, Version? netCoreVersion)
        {
            Filename = filename;
            Name = name;
            Version = version;
            Culture = culture;
            PublicKeyToken = publicKeyToken;
            NetCoreVersion = netCoreVersion;
        }

        /// <summary>
        /// Returns the id and name of the assembly that would be created from the received id.
        /// </summary>
        public static (string id, string name) ComputeSanitizedAssemblyInfo(string id)
        {
            var assembly = new AssemblyInfo(id, string.Empty);
            return (assembly.Id, assembly.Name);
        }

        /// <summary>
        /// Reads the assembly info from a file.
        /// This uses System.Reflection.Metadata, which is a very performant and low-level
        /// library. This is very convenient when scanning hundreds of DLLs at a time.
        /// </summary>
        /// <param name="filename">The full filename of the assembly.</param>
        /// <returns>The information about the assembly.</returns>
        public static AssemblyInfo ReadFromFile(string filename)
        {
            try
            {
                /*  This method is significantly faster and more lightweight than using
                 *  System.Reflection.Assembly.ReflectionOnlyLoadFrom. It also allows
                 *  loading the same assembly from different locations.
                 */
                using var pereader = new System.Reflection.PortableExecutable.PEReader(new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read));
                if (!pereader.HasMetadata)
                {
                    throw new AssemblyLoadException();
                }

                using var sha1 = SHA1.Create();
                var metadata = pereader.GetMetadata();

                unsafe
                {
                    var reader = new MetadataReader(metadata.Pointer, metadata.Length);
                    if (!reader.IsAssembly)
                    {
                        throw new AssemblyLoadException();
                    }

                    var def = reader.GetAssemblyDefinition();

                    // This is how you compute the public key token from the full public key.
                    // The last 8 bytes of the SHA1 of the public key.
                    var publicKey = reader.GetBlobBytes(def.PublicKey);
                    var publicKeyToken = sha1.ComputeHash(publicKey);
                    var publicKeyString = new StringBuilder();
                    foreach (var b in publicKeyToken.Skip(12).Reverse())
                        publicKeyString.AppendFormat("{0:x2}", b);

                    var culture = def.Culture.IsNil ? "neutral" : reader.GetString(def.Culture);
                    Version? netCoreVersion = null;

                    foreach (var attrHandle in def.GetCustomAttributes().Select(reader.GetCustomAttribute))
                    {
                        var ctorHandle = attrHandle.Constructor;
                        if (ctorHandle.Kind != HandleKind.MemberReference)
                        {
                            continue;
                        }

                        var mHandle = reader.GetMemberReference((MemberReferenceHandle)ctorHandle).Parent;
                        if (mHandle.Kind != HandleKind.TypeReference)
                        {
                            continue;
                        }

                        var name = reader.GetString(reader.GetTypeReference((TypeReferenceHandle)mHandle).Name);

                        if (name is "TargetFrameworkAttribute")
                        {
                            var decoded = attrHandle.DecodeValue(new DummyAttributeDecoder());
                            if (
                                decoded.FixedArguments.Length > 0 &&
                                decoded.FixedArguments[0].Value is string value &&
                                NetCoreAppRegex().Match(value).Groups.TryGetValue("version", out var match))
                            {
                                netCoreVersion = new Version(match.Value);
                            }
                            break;
                        }
                    }

                    return new AssemblyInfo(filename, reader.GetString(def.Name), def.Version, culture, publicKeyString.ToString(), netCoreVersion);
                }
            }
            catch (BadImageFormatException)
            {
                // The DLL wasn't an assembly
            }
            catch (InvalidOperationException)
            {
                // Some other failure
            }

            throw new AssemblyLoadException();
        }

        [GeneratedRegex(@"^\.NETCoreApp,Version=v(?<version>\d+\.\d+)$", RegexOptions.IgnoreCase | RegexOptions.Compiled | RegexOptions.Singleline)]
        private static partial Regex NetCoreAppRegex();

        private class DummyAttributeDecoder : ICustomAttributeTypeProvider<int>
        {
            public int GetPrimitiveType(PrimitiveTypeCode typeCode) => 0;

            public int GetSystemType() => throw new NotImplementedException();

            public int GetSZArrayType(int elementType) =>
                throw new NotImplementedException();

            public int GetTypeFromDefinition(MetadataReader reader, TypeDefinitionHandle handle, byte rawTypeKind) =>
                throw new NotImplementedException();

            public int GetTypeFromReference(MetadataReader reader, TypeReferenceHandle handle, byte rawTypeKind) =>
                throw new NotImplementedException();

            public int GetTypeFromSerializedName(string name) =>
                throw new NotImplementedException();

            public PrimitiveTypeCode GetUnderlyingEnumType(int type) =>
                throw new NotImplementedException();

            public bool IsSystemType(int type) => throw new NotImplementedException();

        }
    }
}
