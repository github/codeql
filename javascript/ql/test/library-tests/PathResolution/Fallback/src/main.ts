import "@/both" // $ MISSING: importTarget=Fallback/lib1/both.ts
import "@/only1" // $ MISSING: importTarget=Fallback/lib1/only1.ts
import "@/only2" // $ MISSING: importTarget=Fallback/lib2/only2.ts
import "@/differentExtension" // $ MISSING: importTarget=Fallback/lib2/differentExtension.ts
import "@/differentExtension.js" // $ MISSING: importTarget=Fallback/lib2/differentExtension.ts

import "@/subdir" // $ MISSING: importTarget=Fallback/lib1/subdir/index.ts
import "@/subdir/both" // $ MISSING: importTarget=Fallback/lib1/subdir/both.ts
import "@/subdir/only1" // $ MISSING: importTarget=Fallback/lib1/subdir/only1.ts
import "@/subdir/only2" // $ MISSING: importTarget=Fallback/lib2/subdir/only2.ts
