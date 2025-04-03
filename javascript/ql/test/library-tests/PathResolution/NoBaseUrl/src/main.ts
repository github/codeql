// Relative import
import "../lib/file"; // $ importTarget=NoBaseUrl/lib/file.ts
import "../lib/file.ts"; // $ importTarget=NoBaseUrl/lib/file.ts
import "../lib/file.js"; // $ importTarget=NoBaseUrl/lib/file.ts
import "../lib"; // $ importTarget=NoBaseUrl/lib/index.ts
import "../lib/index"; // $ importTarget=NoBaseUrl/lib/index.ts
import "../lib/index.ts"; // $ importTarget=NoBaseUrl/lib/index.ts
import "../lib/index.js"; // $ importTarget=NoBaseUrl/lib/index.ts

// Import unresolvable due to missing baseUrl
import "lib/file";
import "lib/file.ts";
import "lib/file.js";
import "lib";
import "lib/index";
import "lib/index.ts";
import "lib/index.js";

// Import matching "@/*" path mapping
import "@/file"; // $ importTarget=NoBaseUrl/lib/file.ts
import "@/file.ts"; // $ importTarget=NoBaseUrl/lib/file.ts
import "@/file.js"; // $ importTarget=NoBaseUrl/lib/file.ts
import "@"; // $ MISSING: importTarget=NoBaseUrl/lib/nostar.ts
import "@/index"; // $ importTarget=NoBaseUrl/lib/index.ts
import "@/index.ts"; // $ importTarget=NoBaseUrl/lib/index.ts
import "@/index.js"; // $ importTarget=NoBaseUrl/lib/index.ts

// Import matching "@/*.xyz" path mapping. Note that this is not actually supported by TypeScript.
import "@/file.xyz";
import "@/file.ts.xyz";
import "@/file.js.xyz";
import "@.xyz";
import "@/index.xyz";
import "@/index.ts.xyz";
import "@/index.js.xyz";
