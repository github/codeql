using System.Collections.Generic;
using Microsoft.CodeAnalysis.Text;
using Semmle.Extraction.PowerShell.Entities;
using Location = Microsoft.CodeAnalysis.Location;
using GeneratedLocation = Semmle.Extraction.Entities.GeneratedLocation;
using System.Management.Automation.Language;

namespace Semmle.Extraction.PowerShell
{
    /// <summary>
    /// Extraction context for CIL extraction.
    /// Adds additional context that is specific for CIL extraction.
    /// One context = one DLL/EXE.
    /// </summary>
    public class PowerShellContext : Extraction.Context
    {
        public CompiledScript Compilation { get; }

        private HashSet<int> populatedIds = new HashSet<int>();
        
        public PowerShellContext(Extraction.Extractor e, CompiledScript c, TrapWriter trapWriter, bool addAssemblyTrapPrefix)
            : base(e, trapWriter, addAssemblyTrapPrefix)
        {
            Compilation = c;
            folders = new CachedFunction<PathTransformer.ITransformedPath, Folder>(path => new Folder(this, path));
        }

        internal void Extract(IExtractedEntity entity)
        {
            foreach (var content in entity.Contents)
            {
                content.Extract(this);
            }
        }

        public override Extraction.Entities.Location CreateLocation()
        {
            return GeneratedLocation.Create(this);
        }

        public override Extraction.Entities.Location CreateLocation(Location? location)
        {
            return SourceCodeLocation.Create(this, location);
        }

        public Location ExtentToAnalysisLocation(IScriptExtent extent){
            return Location.Create(Compilation.Location,
                new TextSpan(extent.StartOffset, extent.EndOffset - extent.StartOffset),
                new LinePositionSpan(new LinePosition(extent.StartLineNumber, extent.StartColumnNumber),
                    new LinePosition(extent.EndLineNumber, extent.EndColumnNumber)));
        }

        public Location CreateAnalysisLocation(Ast token)
        {
            return ExtentToAnalysisLocation(token.Extent);
        }

        private readonly CachedFunction<PathTransformer.ITransformedPath, Folder> folders;

        /// <summary>
        /// Creates a folder entity with the given path.
        /// </summary>
        /// <param name="path">The path of the folder.</param>
        /// <returns>A folder entity.</returns>
        internal Folder CreateFolder(PathTransformer.ITransformedPath path) => folders[path];

        private readonly Dictionary<object, Label> ids = new Dictionary<object, Label>();

        internal T PopulateCachedEntity<T>(T e) where T : CachedEntity
        {
            if (!populatedIds.Contains(e.Label.Value))
            {
                PopulateLater(() => { e.Populate(TrapWriter.Writer);});
                populatedIds.Add(e.Label.Value);
            }
            
            return e;
        }
        
        internal T Populate<T>(T e) where T : IExtractedEntity
        {
            if (e.Label.Valid)
            {
                return e;   // Already populated
            }

            if (ids.TryGetValue(e, out var existing))
            {
                // It exists already
                e.Label = existing;
            }
            else
            {
                e.Label = GetNewLabel();
                DefineLabel(e);
                ids.Add(e, e.Label);
                PopulateLater(() =>
                {
                    foreach (var c in e.Contents)
                        c.Extract(this);
                });
#if DEBUG_LABELS
                using var writer = new EscapingTextWriter();
                e.WriteId(writer);
                var id = writer.ToString();

                if (debugLabels.TryGetValue(id, out var previousEntity))
                {
                    Extractor.Message(new Message("Duplicate trap ID", id, null, severity: Util.Logging.Severity.Warning));
                }
                else
                {
                    debugLabels.Add(id, e);
                }
#endif
            }
            return e;
        }

#if DEBUG_LABELS
        private readonly Dictionary<string, IExtractedEntity> debugLabels = new Dictionary<string, IExtractedEntity>();
#endif
    }
}
