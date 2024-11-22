using Semmle.Util;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace Semmle.Extraction.PowerShell.Entities
{
    internal class File : Extraction.Entities.File
    {
        public PowerShellContext PowerShellContext => (PowerShellContext)base.Context;

        protected File(PowerShellContext cx, string path)
            : base(cx, path)
        {
        }

        private static string[] GetPSModulePaths()
        {
            return Environment.GetEnvironmentVariable("PSModulePath")?.Split(Path.PathSeparator)
                ?? Array.Empty<string>();
        }

        private bool PathIsInPSModulePath()
        {
            // Check if f's path is inside one of the paths in $Env:PSModulePath
            return GetPSModulePaths().Any(originalPath.StartsWith);
        }

        public override void Populate(TextWriter trapFile)
        {
            trapFile.files(this, TransformedPath.Value);

            if (TransformedPath.ParentDirectory is PathTransformer.ITransformedPath dir)
            {
                trapFile.containerparent(Extraction.Entities.Folder.Create(PowerShellContext, dir), this);
            }

            if(PathIsInPSModulePath())
            {
                trapFile.is_in_psmodule_path(this);
            }

            try
            {
                System.Text.Encoding encoding;
                var lineCount = 0;
                using (var sr = new StreamReader(originalPath, detectEncodingFromByteOrderMarks: true))
                {
                    while (sr.ReadLine() is not null)
                    {
                        lineCount++;
                    }
                    encoding = sr.CurrentEncoding;
                }

                trapFile.numlines(this, lineCount, 0, 0);
                PowerShellContext.TrapWriter.Archive(originalPath, TransformedPath, encoding ?? System.Text.Encoding.Default);
            }
            catch (Exception exc)
            {
                PowerShellContext.ExtractionError($"Couldn't read file: {originalPath}. {exc.Message}", null, null, exc.StackTrace);
            }
        }

        private bool IsPossiblyTextFile()
        {
            var extension = TransformedPath.Extension.ToLowerInvariant();
            return !extension.Equals("dll") && !extension.Equals("exe");
        }

        public static File Create(PowerShellContext cx, string path) => FileFactory.Instance.CreateEntity(cx, (typeof(File), path), path);

        private class FileFactory : CachedEntityFactory<string, File>
        {
            public static FileFactory Instance { get; } = new FileFactory();

            public override File Create(PowerShellContext cx, string init) => new File(cx, init);
        }
    }
}
