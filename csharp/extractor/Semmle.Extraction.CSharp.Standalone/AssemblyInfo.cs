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
    sealed class AssemblyInfo
    {
        /// <summary>
        /// The file containing the assembly.
        /// </summary>
        public string Filename { get; private set; }

        /// <summary>
        /// Was the information correctly determined?
        /// </summary>
        public bool Valid { get; private set; }

        /// <summary>
        /// The short name of this assembly.
        /// </summary>
        public string Name { get; private set; }

        /// <summary>
        /// The version number of this assembly.
        /// </summary>
        public System.Version Version { get; private set; }

        /// <summary>
        /// The public key token of the assembly.
        /// </summary>
        public string PublicKeyToken { get; private set; }

        /// <summary>
        /// The culture.
        /// </summary>
        public string Culture { get; private set; }

        /// <summary>
        /// Get/parse a canonical ID of this assembly.
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

            private set
            {
                var sections = value.Split(new string[] { ", " }, StringSplitOptions.None);

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
                    if (Culture != null) yield return string.Format("{0}, Version={1}, Culture={2}", Name, Version, Culture);
                    yield return string.Format("{0}, Version={1}", Name, Version);
                }
                yield return Name;
                yield return Name.ToLowerInvariant();
            }
        }

        /// <summary>
        /// Get an invalid assembly info (Valid==false).
        /// </summary>
        public static AssemblyInfo Invalid { get; } = new AssemblyInfo();

        private AssemblyInfo() { }

        /// <summary>
        /// Get AssemblyInfo from a loaded Assembly.
        /// </summary>
        /// <param name="assembly">The assembly.</param>
        /// <returns>Info about the assembly.</returns>
        public static AssemblyInfo MakeFromAssembly(Assembly assembly) => new AssemblyInfo() { Valid = true, Filename = assembly.Location, Id = assembly.FullName };

        /// <summary>
        /// Parse an assembly name/Id into an AssemblyInfo,
        /// populating the available fields and leaving the others null.
        /// </summary>
        /// <param name="id">The assembly name/Id.</param>
        /// <returns>The deconstructed assembly info.</returns>
        public static AssemblyInfo MakeFromId(string id) => new AssemblyInfo() { Valid = true, Id = id };

        /// <summary>
        /// Reads the assembly info from a file.
        /// This uses System.Reflection.Metadata, which is a very performant and low-level
        /// library. This is very convenient when scanning hundreds of DLLs at a time.
        /// </summary>
        /// <param name="filename">The full filename of the assembly.</param>
        /// <returns>The information about the assembly.</returns>
        public static AssemblyInfo ReadFromFile(string filename)
        {
            var result = new AssemblyInfo() { Filename = filename };
            try
            {
                /*  This method is significantly faster and more lightweight than using
                 *  System.Reflection.Assembly.ReflectionOnlyLoadFrom. It also allows
                 *  loading the same assembly from different locations.
                 */
                using (var pereader = new System.Reflection.PortableExecutable.PEReader(new FileStream(filename, FileMode.Open, FileAccess.Read, FileShare.Read)))
                using (var sha1 = new SHA1CryptoServiceProvider())
                {
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

                        result.Name = reader.GetString(def.Name);
                        result.Version = def.Version;
                        result.Culture = def.Culture.IsNil ? "neutral" : reader.GetString(def.Culture);
                        result.PublicKeyToken = publicKeyString.ToString();
                        result.Valid = true;
                    }
                }
            }
            catch (BadImageFormatException)
            {
                // The DLL wasn't an assembly -> result.Valid = false.
            }
            catch (InvalidOperationException)
            {
                // Some other failure -> result.Valid = false.
            }

            return result;
        }
    }
}
