using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;

namespace Semmle.BuildAnalyser
{
    /// <summary>
    /// Stores information about an assembly file (DLL).
    /// </summary>
    internal sealed class AssemblyInfo
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
                if (Version != null)
                    result = string.Format("{0}, Version={1}", result, Version);
                if (Culture != null)
                    result = string.Format("{0}, Culture={1}", result, Culture);
                if (PublicKeyToken != null)
                    result = string.Format("{0}, PublicKeyToken={1}", result, PublicKeyToken);
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
                if (Version != null)
                {
                    if (Culture != null)
                        yield return string.Format("{0}, Version={1}, Culture={2}", Name, Version, Culture);
                    yield return string.Format("{0}, Version={1}", Name, Version);
                }
                yield return Name;
                yield return Name.ToLowerInvariant();
            }
        }

        private AssemblyInfo(string id, string filename)
        {
            var sections = id.Split(new string[] { ", " }, StringSplitOptions.None);

            Name = sections.First();

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

        private AssemblyInfo(string filename, string name, Version version, string culture, string publicKeyToken)
        {
            Filename = filename;
            Name = name;
            Version = version;
            Culture = culture;
            PublicKeyToken = publicKeyToken;
        }

        /// <summary>
        /// Get AssemblyInfo from a loaded Assembly.
        /// </summary>
        /// <param name="assembly">The assembly.</param>
        /// <returns>Info about the assembly.</returns>
        public static AssemblyInfo MakeFromAssembly(Assembly assembly)
        {
            if (assembly.FullName is null)
            {
                throw new InvalidOperationException("Assembly with empty full name is not expected.");
            }

            return new AssemblyInfo(assembly.FullName, assembly.Location);
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
                using var sha1 = new SHA1CryptoServiceProvider();
                var metadata = pereader.GetMetadata();
                unsafe
                {
                    var reader = new System.Reflection.Metadata.MetadataReader(metadata.Pointer, metadata.Length);
                    var def = reader.GetAssemblyDefinition();

                    // This is how you compute the public key token from the full public key.
                    // The last 8 bytes of the SHA1 of the public key.
                    var publicKey = reader.GetBlobBytes(def.PublicKey);
                    var publicKeyToken = sha1.ComputeHash(publicKey);
                    var publicKeyString = new StringBuilder();
                    foreach (var b in publicKeyToken.Skip(12).Reverse())
                        publicKeyString.AppendFormat("{0:x2}", b);

                    var culture = def.Culture.IsNil ? "neutral" : reader.GetString(def.Culture);
                    return new AssemblyInfo(filename, reader.GetString(def.Name), def.Version, culture, publicKeyString.ToString());
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
    }
}
