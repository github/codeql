import * as namespace from "namespace-import";
import { Name1, Name2 } from "named-import";
import DefaultImport from "default-import";
import asn = require("import-assign");

function foo(
    x1: Name1,
    x2: Name2,
    x3: namespace.Foo,
    x5: asn.Foo,
    x6: DefaultImport,
    x7: UnresolvedName,
    x8: Name1<number>
) {}

export class ExportedClass {};
