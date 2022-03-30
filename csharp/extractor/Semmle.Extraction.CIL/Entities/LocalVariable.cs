﻿using System.Collections.Generic;
using System.IO;

namespace Semmle.Extraction.CIL.Entities
{
    internal class LocalVariable : LabelledEntity
    {
        private readonly MethodImplementation method;
        private readonly int index;
        private readonly Type type;

        public LocalVariable(Context cx, MethodImplementation m, int i, Type t) : base(cx)
        {
            method = m;
            index = i;
            type = t;
        }

        public override void WriteId(EscapingTextWriter trapFile)
        {
            trapFile.WriteSubId(method);
            trapFile.Write('_');
            trapFile.Write(index);
            trapFile.Write(";cil-local");
        }

        public override IEnumerable<IExtractionProduct> Contents
        {
            get
            {
                yield return type;
                yield return Tuples.cil_local_variable(this, method, index, type);
            }
        }
    }
}
