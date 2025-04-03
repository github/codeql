// Relative import
import "../lib/file"; // $ importTarget=BaseUrl/lib/file.ts
import "../lib/file.ts"; // $ importTarget=BaseUrl/lib/file.ts
import "../lib/file.js"; // $ importTarget=BaseUrl/lib/file.ts
import "../lib"; // $ importTarget=BaseUrl/lib/index.ts
import "../lib/index"; // $ importTarget=BaseUrl/lib/index.ts
import "../lib/index.ts"; // $ importTarget=BaseUrl/lib/index.ts
import "../lib/index.js"; // $ importTarget=BaseUrl/lib/index.ts

// Import relative to baseUrl
import "lib/file"; // $ importTarget=BaseUrl/lib/file.ts
import "lib/file.ts"; // $ importTarget=BaseUrl/lib/file.ts
import "lib/file.js"; // $ importTarget=BaseUrl/lib/file.ts
import "lib"; // $ importTarget=BaseUrl/lib/index.ts
import "lib/index"; // $ importTarget=BaseUrl/lib/index.ts
import "lib/index.ts"; // $ importTarget=BaseUrl/lib/index.ts
import "lib/index.js"; // $ importTarget=BaseUrl/lib/index.ts

// Import matching "@/*" path mapping
import "@/file"; // $ importTarget=BaseUrl/lib/file.ts
import "@/file.ts"; // $ importTarget=BaseUrl/lib/file.ts
import "@/file.js"; // $ importTarget=BaseUrl/lib/file.ts
import "@"; // $ MISSING: importTarget=BaseUrl/lib/nostar.ts
import "@/index"; // $ importTarget=BaseUrl/lib/index.ts
import "@/index.ts"; // $ importTarget=BaseUrl/lib/index.ts
import "@/index.js"; // $ importTarget=BaseUrl/lib/index.ts

// Import matching "@/*.xyz" path mapping. Note that this is not actually supported by TypeScript.
import "@/file.xyz";
import "@/file.ts.xyz";
import "@/file.js.xyz";
import "@.xyz";
import "@/index.xyz";
import "@/index.ts.xyz";
import "@/index.js.xyz";
