// Relative import
import "../lib/file"; // $ importTarget=Extended/lib/file.ts
import "../lib/file.ts"; // $ importTarget=Extended/lib/file.ts
import "../lib/file.js"; // $ importTarget=Extended/lib/file.ts
import "../lib"; // $ importTarget=Extended/lib/index.ts
import "../lib/index"; // $ importTarget=Extended/lib/index.ts
import "../lib/index.ts"; // $ importTarget=Extended/lib/index.ts
import "../lib/index.js"; // $ importTarget=Extended/lib/index.ts

// Import relative to baseUrl
import "lib/file"; // $ MISSING: importTarget=Extended/lib/file.ts
import "lib/file.ts"; // $ MISSING: importTarget=Extended/lib/file.ts
import "lib/file.js"; // $ MISSING: importTarget=Extended/lib/file.ts
import "lib"; // $ MISSING: importTarget=Extended/lib/index.ts
import "lib/index"; // $ MISSING: importTarget=Extended/lib/index.ts
import "lib/index.ts"; // $ MISSING: importTarget=Extended/lib/index.ts
import "lib/index.js"; // $ MISSING: importTarget=Extended/lib/index.ts

// Import matching "@/*" path mapping
import "@/file"; // $ MISSING: importTarget=Extended/lib/file.ts
import "@/file.ts"; // $ MISSING: importTarget=Extended/lib/file.ts
import "@/file.js"; // $ MISSING: importTarget=Extended/lib/file.ts
import "@"; // $ MISSING: importTarget=Extended/lib/nostar.ts
import "@/index"; // $ MISSING: importTarget=Extended/lib/index.ts
import "@/index.ts"; // $ MISSING: importTarget=Extended/lib/index.ts
import "@/index.js"; // $ MISSING: importTarget=Extended/lib/index.ts

// Import matching "@/*.xyz" path mapping. Note that this is not actually supported by TypeScript.
import "@/file.xyz";
import "@/file.ts.xyz";
import "@/file.js.xyz";
import "@.xyz";
import "@/index.xyz";
import "@/index.ts.xyz";
import "@/index.js.xyz";
