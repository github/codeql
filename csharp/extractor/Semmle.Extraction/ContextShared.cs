using Microsoft.CodeAnalysis;
using Semmle.Util.Logging;
using System;
using System.Collections.Generic;
using System.IO;

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

        private readonly Queue<CachedEntity> labelQueue = new();

        private bool writingLabel = false;

        private readonly TrapWriter trapWriterShared;

        private ContextShared(TrapWriter trapWriter)
        {
            trapWriterShared = trapWriter;
        }

        public static ContextShared Create(ILogger logger, Layout layout, TrapWriter.CompressionMode trapCompression)
        {
            var transformedPath = PathTransformer.CreateFake("shared");
            var projectLayout = layout.LookupProjectOrDefault(transformedPath);
            return new ContextShared(projectLayout.CreateTrapWriter(logger, transformedPath, trapCompression, discardDuplicates: false));
        }

        [ThreadStatic] private static Context? currentThreadContext;

        /// <summary>
        /// Registers the context object used by the current thread.
        /// </summary>
        public static void RegisterContext(Context context)
        {
            currentThreadContext = context;
        }

        public void DefineLabel(CachedEntity entity) =>
            GetLabelForWriter(entity, trapWriterShared.Writer);

        public Label GetLabelForWriter(CachedEntity entity, TextWriter trapFile)
        {
            var isSharedTrapFile = trapFile == trapWriterShared.Writer;

            // non-shared entity referenced in its own TRAP file
            if (entity.Label.Valid && !isSharedTrapFile)
                return entity.Label;

            Label label;

            lock (trapWriterShared)
            {
                if (entity.LabelMap is null)
                    entity.LabelMap = new();

                if (entity.LabelMap.TryGetValue(trapFile, out var cached))
                    return cached;

                var trapWriter = isSharedTrapFile ? trapWriterShared : currentThreadContext!.TrapWriter;

                label = new Label(trapWriter.IdCounter++);

                entity.LabelMap[trapFile] = label;
            };

            if (isSharedTrapFile)
            {
                // shared or non-shared entity referenced from shared TRAP file
                WriteSharedLabel(entity);
            }
            else
            {
                // shared entity referenced from non-shared TRAP file
                currentThreadContext!.LabelQueue.Enqueue(entity);
            }
            return label;
        }

        /// <summary>
        /// Writes the label for a shared entity to the shared TRAP file.
        /// </summary>
        private void WriteSharedLabel(CachedEntity entity)
        {
            lock (trapWriterShared)
            {
                if (writingLabel)
                {
                    labelQueue.Enqueue(entity);
                    return;
                }

                writingLabel = true;
                try
                {
                    entity.DefineLabel(trapWriterShared.Writer, entity.Context.Extractor);
                }
                finally
                {
                    writingLabel = false;
                    if (labelQueue.TryDequeue(out var next))
                        WriteSharedLabel(next);
                }
            }
        }

        /// <summary>
        /// Access the shared TRAP file in a thread-safe manner.
        /// </summary>
        public void WithWriter(Action<TextWriter> a)
        {
            lock (trapWriterShared)
            {
                if (writingLabel)
                {
                    currentThreadContext!.PopulateQueue.Enqueue(() => WithWriter(a));
                    return;
                }

                a(trapWriterShared.Writer);
            }
        }

        void IDisposable.Dispose()
        {
            trapWriterShared.Dispose();
        }
    }
}
