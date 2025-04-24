import "@/both" // $ importTarget=Fallback/lib1/both.ts
import "@/only1" // $ importTarget=Fallback/lib1/only1.ts
import "@/only2" // $ importTarget=Fallback/lib2/only2.ts
import "@/differentExtension" // $ importTarget=Fallback/lib2/differentExtension.ts
import "@/differentExtension.js" // $ importTarget=Fallback/lib2/differentExtension.ts

import "@/subdir" // $ importTarget=Fallback/lib1/subdir/index.ts
import "@/subdir/both" // $ importTarget=Fallback/lib1/subdir/both.ts
import "@/subdir/only1" // $ importTarget=Fallback/lib1/subdir/only1.ts
import "@/subdir/only2" // $ importTarget=Fallback/lib2/subdir/only2.ts
