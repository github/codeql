// Relative import
import "../base/lib/file"; // $ importTarget=BaseUrl/base/lib/file.ts
import "../base/lib/file.ts"; // $ importTarget=BaseUrl/base/lib/file.ts
import "../base/lib/file.js"; // $ importTarget=BaseUrl/base/lib/file.ts
import "../base/lib"; // $ importTarget=BaseUrl/base/lib/index.ts
import "../base/lib/index"; // $ importTarget=BaseUrl/base/lib/index.ts
import "../base/lib/index.ts"; // $ importTarget=BaseUrl/base/lib/index.ts
import "../base/lib/index.js"; // $ importTarget=BaseUrl/base/lib/index.ts

// Import relative to baseUrl
import "lib/file"; // $ importTarget=BaseUrl/base/lib/file.ts
import "lib/file.ts"; // $ importTarget=BaseUrl/base/lib/file.ts
import "lib/file.js"; // $ importTarget=BaseUrl/base/lib/file.ts
import "lib"; // $ importTarget=BaseUrl/base/lib/index.ts
import "lib/index"; // $ importTarget=BaseUrl/base/lib/index.ts
import "lib/index.ts"; // $ importTarget=BaseUrl/base/lib/index.ts
import "lib/index.js"; // $ importTarget=BaseUrl/base/lib/index.ts

// Import matching "@/*" path mapping
import "@/file"; // $ importTarget=BaseUrl/base/lib/file.ts
import "@/file.ts"; // $ importTarget=BaseUrl/base/lib/file.ts
import "@/file.js"; // $ importTarget=BaseUrl/base/lib/file.ts
import "@"; // $ importTarget=BaseUrl/base/lib/nostar.ts
import "@/index"; // $ importTarget=BaseUrl/base/lib/index.ts
import "@/index.ts"; // $ importTarget=BaseUrl/base/lib/index.ts
import "@/index.js"; // $ importTarget=BaseUrl/base/lib/index.ts

// Import matching "#/*" path mapping
import "#/file"; // $ importTarget=BaseUrl/base/lib/file.ts
import "#/file.ts"; // $ importTarget=BaseUrl/base/lib/file.ts
import "#/file.js"; // $ importTarget=BaseUrl/base/lib/file.ts
import "#/index"; // $ importTarget=BaseUrl/base/lib/index.ts
import "#/index.ts"; // $ importTarget=BaseUrl/base/lib/index.ts
import "#/index.js"; // $ importTarget=BaseUrl/base/lib/index.ts

// Import matching "^lib*" path mapping
import "^lib/file"; // $ importTarget=BaseUrl/base/lib/file.ts
import "^lib2/file"; // $ importTarget=BaseUrl/base/lib2/file.ts

// Import matching "@/*.xyz" path mapping. Note that this is not actually supported by TypeScript.
import "@/file.xyz";
import "@/file.ts.xyz";
import "@/file.js.xyz";
import "@.xyz";
import "@/index.xyz";
import "@/index.ts.xyz";
import "@/index.js.xyz";
