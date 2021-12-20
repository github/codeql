using Microsoft.CodeAnalysis;
using Semmle.Extraction.Entities;
using Semmle.Util.Logging;
using System;
using System.Collections.Generic;
using System.Collections.Concurrent;
using System.Diagnostics.CodeAnalysis;
using System.IO;
using System.Linq;

namespace Semmle.Extraction
{
    /// <summary>
    /// State that needs to be available throughout the extraction process.
    /// There is one `ContextShared` object per compilation, which allows
    /// for entities to be written to a shared TRAP file.
    ///
    /// Unlike the TRAP file associated with a `Context` object, the shared
    /// TRAP file will be accessed concurrently by multiple threads, so
    /// appropriate locking is required.
    /// </summary>
    public class ContextShared : IDisposable
    {
        public readonly Dictionary<object, CachedEntity> ObjectEntityCacheShared = new();

        public readonly Dictionary<ISymbol, CachedEntity> SymbolEntityCacheShared = new(SymbolEqualityComparer.Default);

        private bool writingLabel = false;

        private readonly TrapWriter sharedTrapWriter;

        private ContextShared(TrapWriter trapWriter)
        {
            this.sharedTrapWriter = trapWriter;
        }

        public static ContextShared Create(ILogger logger, Layout layout, TrapWriter.CompressionMode trapCompression)
        {
            var transformedPath = PathTransformer.CreateFake("shared");
            var projectLayout = layout.LookupProjectOrDefault(transformedPath);
            return new ContextShared(projectLayout.CreateTrapWriter(logger, transformedPath, trapCompression, discardDuplicates: false));
        }

        [ThreadStatic] private static Context? currentContext;

        /// <summary>
        /// Registers the context object used by the current thread.
        /// </summary>
        public static void RegisterContext(Context context)
        {
            currentContext = context;
        }

        public Label GetLabelForWriter(CachedEntity entity, TextWriter trapFile)
        {
            Label label;
            bool isSharedTrapFile;

            lock (sharedTrapWriter)
            {
                if (entity.LabelMap is null)
                    entity.LabelMap = new();

                if (entity.LabelMap.TryGetValue(trapFile, out var cached))
                    return cached;

                isSharedTrapFile = trapFile == sharedTrapWriter.Writer;

                var trapWriter = isSharedTrapFile ? sharedTrapWriter : currentContext!.TrapWriter;

                label = new Label(trapWriter.IdCounter++);

                entity.LabelMap[trapFile] = label;
            };

            if (isSharedTrapFile)
            {
                // shared or non-shared entity referenced from shared TRAP file
                currentContext!.PopulateQueue.AddFirst(() =>
                    WithWriter(trapFile => entity.DefineLabel(trapFile, entity.Context.Extractor), true));
            }
            else
            {
                // shared entity referenced from non-shared TRAP file
                currentContext!.PopulateQueue.AddFirst(() => currentContext!.DefineLabel(entity));
            }
            return label;
        }

        private void WithWriter(Action<TextWriter> a, bool writeLabel)
        {
            lock (sharedTrapWriter)
            {
                if (writingLabel)
                {
                    currentContext!.PopulateQueue.AddFirst(() => WithWriter(a, writeLabel));
                    return;
                }

                writingLabel = writeLabel;
                try
                {
                    a(sharedTrapWriter.Writer);
                }
                finally
                {
                    writingLabel = false;
                }
            }
        }

        /// <summary>
        /// Access the shared TRAP file in a thread-safe manner.
        /// </summary>
        public void WithWriter(Action<TextWriter> a) => WithWriter(a, false);

        void IDisposable.Dispose()
        {
            sharedTrapWriter.Dispose();
        }
    }
}
