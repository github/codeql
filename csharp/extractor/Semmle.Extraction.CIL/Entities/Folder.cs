using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    interface IFolder : IFileOrFolder
    {
    }

    public class Folder : LabelledEntity, IFolder
    {
        readonly string path;

        public Folder(Context cx, string path) : base(cx)
        {
            this.path = path;
            ShortId = new StringId(path.Replace("\\", "/").Replace(":", "_"));
        }

        static readonly Id suffix = new StringId(";folder");

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                // On Posix, we could get a Windows directory of the form "C:"
                bool windowsDriveLetter = path.Length == 2 && char.IsLetter(path[0]) && path[1] == ':';

                var parent = Path.GetDirectoryName(path);
                if (parent != null && !windowsDriveLetter)
                {
                    var parentFolder = cx.CreateFolder(parent);
                    yield return parentFolder;
                    yield return Tuples.containerparent(parentFolder, this);
                }
                yield return Tuples.folders(this, path, Path.GetFileName(path));
            }
        }

        public override Id IdSuffix => suffix;
    }
}
