# PHP Language Support for CodeQL

This directory contains the PHP language support implementation for CodeQL, enabling comprehensive static code analysis for PHP applications.

## Overview

CodeQL PHP support provides:

- **Abstract Syntax Tree (AST)**: Full parsing and representation of PHP code constructs
- **Data Flow Analysis**: Taint tracking to detect security vulnerabilities
- **Control Flow Graph**: Program execution path modeling
- **Improved Type Inference**: Semantic type system with type narrowing, propagation, and union type support
- **Framework Models**: Built-in support for 10 major PHP frameworks (Laravel, Symfony, CodeIgniter, Yii, CakePHP, Zend/Laminas, WordPress, Drupal, Joomla, Magento)
- **Cross-File Analysis**: Program-wide data flow tracking across multiple files and functions
- **Security Queries**: Pre-built queries for detecting common vulnerabilities

## Directory Structure

```
php/
├── codeql-extractor.yml         # Extractor configuration
├── ql/
│   ├── lib/                     # Core QL libraries
│   │   ├── php.dbscheme         # Database schema
│   │   ├── php.qll              # Main library entry
│   │   ├── qlpack.yml           # Library pack config
│   │   ├── codeql/php/
│   │   │   ├── AST.qll          # AST type definitions
│   │   │   ├── DataFlow.qll     # Data flow analysis
│   │   │   ├── ControlFlow.qll  # Control flow modeling
│   │   │   ├── Concepts.qll     # Framework concepts
│   │   │   ├── Diagnostics.qll  # Error handling
│   │   │   ├── ast/             # AST modules
│   │   │   │   ├── Expr.qll     # Expressions
│   │   │   │   ├── Stmt.qll     # Statements
│   │   │   │   ├── Declaration.qll # Declarations
│   │   │   │   ├── Control.qll  # Control flow
│   │   │   │   ├── PHP8NamedArguments.qll   # PHP 8.0+ named arguments
│   │   │   │   ├── PHP8ConstructorPromotion.qll # PHP 8.0+ constructor promotion
│   │   │   │   ├── PHP8Examples.qll # PHP 8.x examples
│   │   │   │   └── internal/    # Implementation details
│   │   │   ├── frameworks/      # Framework models
│   │   │   │   ├── Core.qll     # PHP standard library
│   │   │   │   ├── Laravel.qll  # Laravel framework
│   │   │   │   ├── Symfony.qll  # Symfony framework
│   │   │   │   ├── CodeIgniter.qll # CodeIgniter framework
│   │   │   │   ├── Yii.qll      # Yii framework
│   │   │   │   ├── CakePHP.qll  # CakePHP framework
│   │   │   │   ├── ZendLaminas.qll # Zend/Laminas framework
│   │   │   │   ├── WordPress.qll    # WordPress framework
│   │   │   │   ├── Drupal.qll   # Drupal framework
│   │   │   │   ├── Joomla.qll   # Joomla framework
│   │   │   │   ├── Magento.qll  # Magento framework
│   │   │   │   └── AllFrameworks.qll # Unified framework detection
│   │   │   ├── types/           # Type inference system
│   │   │   │   ├── Type.qll     # Core type representation
│   │   │   │   ├── TypeNarrowing.qll # Type guards & narrowing
│   │   │   │   ├── TypePropagation.qll # Function type propagation
│   │   │   │   ├── UnionTypes.qll # Union & nullable types
│   │   │   │   ├── TypeInference.qll # Operator type inference
│   │   │   │   └── DataFlowIntegration.qll # Integration with data flow
│   │   │   ├── crossfile/       # Cross-file analysis
│   │   │   │   ├── CrossFileFlow.qll # Cross-file data flow
│   │   │   │   └── FunctionSummary.qll # Function summaries
│   │   │   ├── polymorphism/    # Polymorphism analysis (NEW)
│   │   │   │   ├── Polymorphism.qll # Integration module
│   │   │   │   ├── ClassResolver.qll # Class resolution
│   │   │   │   ├── MethodResolver.qll # Method resolution
│   │   │   │   ├── TraitComposition.qll # Trait analysis
│   │   │   │   ├── MagicMethods.qll # Magic method dispatch
│   │   │   │   ├── OverrideValidation.qll # Type safety
│   │   │   │   ├── VulnerabilityDetection.qll # Security vulnerabilities
│   │   │   │   ├── queries/ # Pre-built security queries (15 queries)
│   │   │   │   ├── README.md # Framework documentation
│   │   │   │   ├── QUICKSTART.md # 5-minute guide
│   │   │   │   ├── INTEGRATION_GUIDE.md # Integration instructions
│   │   │   │   └── USAGE_EXAMPLES.md # Practical examples
│   │   │   └── upgrades/            # Schema versions
│   ├── src/                     # Security queries
│   │   ├── qlpack.yml           # Query pack config
│   │   ├── queries/
│   │   │   ├── security/        # Security-focused queries
│   │   │   │   ├── cwe-89/      # SQL Injection
│   │   │   │   ├── cwe-78/      # Command Injection
│   │   │   │   ├── cwe-79/      # XSS
│   │   │   │   ├── cwe-90/      # LDAP Injection
│   │   │   │   ├── cwe-434/     # Path Traversal
│   │   │   │   ├── cwe-502/     # Insecure Deserialization
│   │   │   │   ├── cwe-611/     # XML External Entity (XXE)
│   │   │   │   └── cwe-918/     # Server-Side Request Forgery (SSRF)
│   │   │   ├── controlflow/     # Control flow analysis queries
│   │   │   └── filters/         # Result filters
│   └── test/                    # Test suite
│       ├── fixtures/            # Test input files
│       ├── library-tests/       # Unit tests
│       └── query-tests/         # Query validation
├── extractor/                   # Extractor implementation (Rust)
│   ├── src/
│   │   ├── main.rs              # CLI and entry point
│   │   ├── extractor.rs         # Tree-sitter AST extraction
│   │   ├── php8_features.rs     # PHP 8.x feature detection
│   │   ├── autobuilder.rs       # Auto-build support
│   │   └── lib.rs               # Library exports
│   ├── Cargo.toml               # Rust dependencies
│   └── target/                  # Build artifacts
└── downgrades/                  # Schema downgrade support

```

## Supported PHP Features

### Language Constructs

**Expressions:**
- Binary operations (+, -, *, /, %, **, &&, ||, &, |, ^, <<, >>, ==, ===, <, >, etc.)
- Unary operations (-, !, ~, ++, --)
- Variable references
- Function/method calls
- Array access and literals
- String literals and interpolation
- Ternary operators
- instanceof checks
- Type casts
- New object creation

**Statements:**
- Expression statements
- Block statements
- If/elseif/else conditionals
- While/do-while loops
- For and foreach loops
- Switch/case statements
- Try/catch/finally exception handling
- Return, break, continue statements
- Throw statements
- Echo and print statements
- Global and static declarations
- Unset statements

**Declarations:**
- Function declarations
- Class declarations
- Interface declarations
- Trait declarations
- Enum declarations (PHP 8.1+)
- Namespace declarations
- Use/import statements
- Constant declarations

### PHP 8.x Features (NEW)

**Named Arguments (PHP 8.0+):**
- Named argument detection in function/method calls
- Parameter name tracking and validation
- Example: `foo(name: "Alice", age: 30)`

**Constructor Property Promotion (PHP 8.0+):**
- Visibility modifier detection on constructor parameters
- Automatic property creation and initialization tracking
- Example: `public function __construct(private string $email) {}`

### PHP 8.2+ Features (NEW)

**Readonly Properties (PHP 8.2+):**
- Readonly keyword detection on class properties
- Initialization-once pattern validation
- Visibility and type tracking
- Immutability level analysis (strict, reference, shallow)
- Example: `public readonly string $id;`

**Disjunctive Normal Form (DNF) Types (PHP 8.2+):**
- Complex intersection and union type detection
- Supports PHP 8.0+ union types (`A|B`)
- Supports PHP 8.1+ intersection types (`A&B`)
- Full DNF type support: `(A&B)|(C&D)|E`
- Type complexity metrics and analysis
- Examples:
  - `function process((Countable&ArrayAccess)|DateTime $value): void`
  - `private (Iterator&Serializable)|stdClass $cache;`

### PHP 8.3+ Features (NEW)

**Attributes and Metadata (PHP 8.0+, enhanced in 8.3+):**
- Detection of class, method, property, and parameter attributes
- Built-in attribute support (`#[\Override]`, `#[\Deprecated]`)
- Framework attribute detection (Symfony, Laravel, Doctrine)
- Attribute configuration validation
- Security implications analysis
- Example: `#[Override] public function handle() { }`

**Readonly Classes (PHP 8.3+):**
- Detection of readonly class declarations
- Validation of public readonly property requirements
- Immutability verification (deep vs. shallow)
- Value object pattern recognition
- Inheritance and extension analysis
- Example: `readonly class Point { public function __construct(public int $x, public int $y) {} }`

### PHP 8.4+ Features (NEW)

**Property Hooks (PHP 8.4+):**
- Get and set hook detection on properties
- Computed property analysis
- Side effect detection in hooks
- Encapsulation pattern recognition
- Hook complexity analysis
- Example:
  ```php
  private string $value;

  public function __get(string $name): mixed {
    return match($name) {
      'upperValue' => strtoupper($this->value),
      default => $this->$name
    };
  }
  ```

**Asymmetric Visibility (PHP 8.4+):**
- Independent read/write visibility detection
- `public private(set)` syntax support
- Immutability enforcement through write restrictions
- Public read with private write pattern recognition
- Encapsulation level analysis
- Example: `public private(set) string $name;`

**DOM API Enhancement (PHP 8.4+):**
- Modern DOM API usage detection
- HTMLDocument and XMLDocument class tracking
- Living standard DOM compliance checking
- Security analysis for untrusted document parsing
- Example: `$doc = HTMLDocument::createFromString($html);`

**BCMath Object-Oriented Extension (PHP 8.4+):**
- Number class instantiation detection
- Arbitrary precision arithmetic analysis
- Legacy vs. modern API usage tracking
- Precision and rounding validation
- Financial calculation suitability analysis
- Example: `$result = (new Number("123.45"))->add(new Number("67.89"));`

**PDO Driver Subclasses (PHP 8.4+):**
- Modern driver subclass usage (SQLite, MySQL, PostgreSQL)
- Named argument configuration pattern detection
- Database-specific feature analysis
- Connection security validation
- Legacy string-based DSN vs. modern approach tracking
- Example: `$db = new PDO\MySQL(host: "localhost", database: "mydb");`

### PHP 8.5+ Features (NEW)

**Pipe Operator (PHP 8.5+):**
- Sequential function chaining with `|>` operator
- Pipe chain depth analysis
- Readability scoring (1-10 scale)
- Functional programming style detection
- Comparison with nested function calls
- Immutability pattern recognition
- Example:
  ```php
  $result = $data
    |> json_decode(...)
    |> array_filter(...)
    |> array_map(...);
  ```

**Clone With (PHP 8.5+):**
- Clone-with syntax detection (`clone $obj with { prop => val }`)
- Immutable copy creation pattern recognition
- Property update tracking
- Copy-constructor pattern validation
- Functional-style update analysis
- Example: `$updated = clone $config with { 'timeout' => 30 };`

**URI Extension (PHP 8.5+):**
- Uri namespace class detection
- RFC 3986 and WHATWG URL standard compliance
- URI parsing security analysis
- Potential SSRF vulnerability detection
- Component-based URI handling
- Example: `$uri = Uri\Uri::parse("https://example.com/path?query=value");`

**#[NoDiscard] Attribute (PHP 8.5+):**
- Attribute detection on functions, methods, constructors
- Return value usage tracking
- Violation detection (ignored return values)
- Custom message support for guidance
- Best practice validation
- Example: `#[NoDiscard("Store or use the query results")] public function query(): QueryResult`

### Supported Frameworks

**Laravel:**
- Request object input methods
- Query builder operations with safe parameterization
- Eloquent ORM models
- Blade template engine with auto-escaping
- Validation framework
- Middleware support

**Symfony:**
- Request parameter access
- Doctrine query builder
- Twig template engine with auto-escaping
- Form handling
- Security/authorization checks
- Dependency injection

**CodeIgniter:**
- Input class for request data
- Query builder with database methods
- Output class for rendering
- Active record pattern support
- Session handling

**Yii:**
- Request class input methods
- Database command builder
- View rendering
- Active record ORM
- Validators and filters

**CakePHP:**
- Request object data access
- Query builder and ORM
- View templates
- Security helpers
- Form builder

**Zend/Laminas:**
- HTTP Request object
- DB adapter and query builder
- Escaper utilities
- View helpers
- Form support

**WordPress:**
- Global WPDB object
- Query preparation with placeholders
- Nonce verification for CSRF protection
- Sanitization functions (esc_html, esc_attr)
- WordPress Hooks system

**Drupal:**
- Database query API
- CSRF token validation
- Render arrays and rendering
- Entity API
- Views integration

**Joomla:**
- Input class access
- Database query builder
- View rendering
- Token verification
- User access checks

**Magento:**
- Request object parameters
- Resource model queries
- Block and template rendering
- Form key validation
- Collection filtering

**PHP Core:**
- Dangerous functions (exec, eval, etc.)
- Database functions (mysql_*, mysqli_*, PDO)
- Output functions (echo, print, var_dump)
- File operations (file_get_contents, fopen, etc.)
- Serialization functions (unserialize, json_decode)
- Regular expressions
- Sanitization functions

## PHP Extractor Implementation

The PHP CodeQL extractor is implemented in Rust using **tree-sitter-php** for accurate Abstract Syntax Tree (AST) parsing.

### Architecture

**Parser:** tree-sitter-php (v0.23)
- Robust PEG-based PHP grammar
- Supports PHP 5.2 through PHP 8.1+
- Error recovery for incomplete code

**Extraction Pipeline:**
1. **File Discovery** - Recursive scanning for PHP files (.php, .php5, .php7, .php8, .phtml, .inc)
2. **Encoding Detection** - UTF-8 and fallback support
3. **Tree-Sitter Parsing** - Full AST generation with accurate location tracking
4. **TRAP Fact Generation** - Complete AST traversal generating CodeQL intermediate format
5. **PHP 8.x Feature Detection** - Named arguments and constructor promotion analysis
6. **Compression** - gzip or zstd output for efficient storage

### Supported AST Node Types

The extractor generates facts for 12+ major node types:

| Node Type | Description |
|-----------|-------------|
| `program` | Root AST node |
| `class_declaration` | Class definitions |
| `method_declaration` | Class methods |
| `function_declaration` | Function definitions |
| `assignment_expression` | Variable assignments |
| `function_call` | Function invocations |
| `method_call` | Method invocations |
| `if_statement` | If/elseif/else blocks |
| `while_statement` | While loops |
| `for_statement` | For loops |
| `foreach_statement` | Foreach loops |
| `switch_statement` | Switch/case blocks |
| `try_statement` | Try/catch/finally blocks |
| `interface_declaration` | Interface definitions |
| `trait_declaration` | Trait definitions |
| `namespace_declaration` | Namespace declarations |

### PHP 8.x Feature Detection

**Named Arguments Module** (`php8_features.rs`)
- AST-based detection using tree-sitter nodes
- Identifies `argument` nodes in function/method calls
- Generates `php_named_argument(id, param_name, value_id)` facts
- Detection: 118+ facts from test fixtures

**Constructor Promotion Module** (`php8_features.rs`)
- Scans for `__construct` methods with visibility modifiers
- Identifies `property_promotion_parameter` nodes
- Generates `php_promoted_parameter(id, visibility, property_name)` facts
- Detection: 81+ facts from test fixtures

### Fact Generation Metrics

Comprehensive extraction from test fixtures:
```
File Count:             2 files
Lines Processed:        684 lines
Total Facts Generated:  354 facts
├─ File declarations:   1
├─ AST nodes:          154 (from complete tree traversal)
├─ Named arguments:    118 (PHP 8.0+ feature)
└─ Promoted params:     81 (PHP 8.0+ feature)
```

### Building the Extractor

**Requirements:**
- Rust 1.70+
- tree-sitter-php 0.23
- Standard C compiler (for tree-sitter)

**Compilation:**
```bash
cd php/extractor
cargo build --release
```

**Output:**
- Binary: `target/release/codeql-extractor-php`
- Size: ~20 MB (optimized release build)

### Running the Extractor

**Basic Extraction:**
```bash
./target/release/codeql-extractor-php extract \
  --output <output_dir> \
  --source-root <php_source_dir> \
  --compression gzip
```

**Advanced Options:**
```bash
./target/release/codeql-extractor-php extract \
  --output /tmp/trap_files \
  --source-root /path/to/code \
  --compression gzip \
  --threads 16 \
  --max-file-size 52428800 \
  --exclude "**/vendor" \
  --exclude "**/.git" \
  --statistics
```

**Output Format:**
- TRAP files (one per input file)
- Gzip compressed by default
- Each file contains CodeQL facts (one per line)

## Built-in Security Queries

### SQL Injection (CWE-89)
Detects SQL queries concatenated with untrusted user input.

**Query ID:** `php/sql-injection`

**Example:**
```php
$id = $_GET['id'];
$query = "SELECT * FROM users WHERE id = " . $id;
mysqli_query($connection, $query); // Vulnerable
```

### Cross-Site Scripting (CWE-79)
Detects unescaped output of user-controlled data in HTML context.

**Query ID:** `php/xss`

**Example:**
```php
$name = $_GET['name'];
echo "Hello, $name"; // Vulnerable
```

### Command Injection (CWE-78)
Detects shell commands constructed with untrusted user input.

**Query ID:** `php/command-injection`

**Example:**
```php
$file = $_GET['file'];
exec("ls -la " . $file); // Vulnerable
```

### Path Traversal (CWE-434)
Detects file operations using untrusted path inputs.

**Query ID:** `php/path-traversal`

**Example:**
```php
$path = $_POST['path'];
$content = file_get_contents($path); // Vulnerable
```

### Insecure Deserialization (CWE-502)
Detects unsafe deserialization of untrusted data, which can lead to remote code execution through object injection.

**Query ID:** `php/insecure-deserialization`

**Example:**
```php
$data = $_POST['data'];
$object = unserialize($data); // Vulnerable - can execute arbitrary code
```

**Affected Functions:**
- `unserialize()` - Most dangerous, allows arbitrary code execution
- `json_decode()` - Can be dangerous with specific payload patterns
- `simplexml_load_string()` - XXE risk if not properly configured
- `yaml_parse()` - YAML deserialization RCE risk

### LDAP Injection (CWE-90)
Detects LDAP filter construction with untrusted input, allowing LDAP injection attacks.

**Query ID:** `php/ldap-injection`

**Example:**
```php
$username = $_GET['username'];
$filter = "(&(cn=$username)(objectClass=*))";
ldap_search($ldapconn, $basedn, $filter); // Vulnerable - LDAP injection
```

**Affected Functions:**
- `ldap_search()` - Search with user-controlled filter
- `ldap_read()`, `ldap_list()` - Directory operations
- `ldap_add()`, `ldap_modify()`, `ldap_delete()` - Modification operations
- `ldap_bind()`, `ldap_bind_ext()` - Authentication operations

### XML External Entity (XXE) Injection (CWE-611)
Detects XML parsing of untrusted data with external entity processing enabled, allowing information disclosure or DoS.

**Query ID:** `php/xxe-injection`

**Example:**
```php
$xml = $_POST['xml'];
$doc = new DOMDocument();
$doc->load($xml); // Vulnerable - XXE attack possible
```

**Affected Functions:**
- `simplexml_load_string()` - SimpleXML parsing
- `simplexml_load_file()` - File-based SimpleXML parsing
- `DOMDocument::load()`, `DOMDocument::loadXML()` - DOM parsing
- `XMLReader::open()`, `XMLReader::XML()` - XML reading
- `xml_parse()`, `xml_parser_create()` - Low-level XML parsing

### Server-Side Request Forgery (SSRF) (CWE-918)
Detects network requests using untrusted URLs or hosts, allowing attackers to make requests to internal resources.

**Query ID:** `php/ssrf`

**Example:**
```php
$url = $_GET['url'];
$content = file_get_contents($url); // Vulnerable - SSRF attack
```

**Affected Functions:**
- `curl_exec()`, `curl_multi_exec()` - cURL network requests
- `file_get_contents()` - URL/file reading
- `fopen()`, `fread()` - Stream operations
- `stream_context_create()` - Stream configuration
- `get_headers()` - Header fetching
- `fsockopen()`, `pfsockopen()` - Socket connections

### Use of Broken/Risky Cryptographic Algorithm (CWE-327)
Detects usage of weak cryptographic functions (MD5, SHA1, mcrypt) for security-critical operations.

**Query ID:** `php/weak-cryptography`

**Example:**
```php
$password = $_POST['password'];
$hash = md5($password); // Vulnerable - MD5 is cryptographically broken
```

**Weak Functions:**
- `md5()` - Cryptographically broken hash
- `sha1()` - Collision vulnerability
- `crypt()` - DES-based, weak
- `mcrypt_encrypt()` - Deprecated deprecated cipher

**Recommendation:** Use `password_hash()` with PASSWORD_ARGON2ID or `openssl_encrypt()` instead.

### Use of Hardcoded Credentials (CWE-798)
Detects hardcoded passwords, API keys, and secrets in source code.

**Query ID:** `php/hardcoded-credentials`

**Example:**
```php
$dbPassword = "admin123"; // Vulnerable
$apiKey = "sk_live_abc123xyz"; // Vulnerable
```

**Patterns Detected:**
- Database connection strings with embedded passwords
- API keys and tokens in code
- Common weak passwords
- Bearer tokens in plain text

**Recommendation:** Use environment variables or secure configuration management.

### Use of Insufficiently Random Values (CWE-760)
Detects weak password hashing algorithms (MD5, SHA1 without salt).

**Query ID:** `php/weak-password-hashing`

**Example:**
```php
$hash = md5($password); // Vulnerable
$hash = sha256($password); // Without salt, vulnerable
```

**Weak Patterns:**
- MD5/SHA1 for password hashing
- No salt usage
- Missing computational cost (bcrypt, Argon2)

**Recommendation:** Use `password_hash()` with PASSWORD_ARGON2ID.

### Improper Exception Handling (CWE-754)
Detects silent exception handling without logging or recovery.

**Query ID:** `php/improper-exception-handling`

**Example:**
```php
try {
  $result = riskyOperation();
} catch (Exception $e) {
  // Silent failure - vulnerability!
}
```

**Issues:**
- Empty catch blocks
- No logging or recovery
- No re-throw or error reporting

**Recommendation:** Log exceptions and either recover or re-throw.

## Data Flow Analysis

The PHP data flow framework models:

### Sources (Entry Points)
- Superglobal variables ($_GET, $_POST, $_REQUEST, $_SERVER, etc.)
- Framework request objects (Laravel Request, Symfony Request)
- Input stream reads (file_get_contents('php://input'))
- Database query results
- External API responses

### Sinks (Dangerous Operations)
- SQL query execution
- Command execution functions
- Unescaped HTML output
- File operations
- Code execution (eval, create_function)
- Serialization operations

### Sanitizers (Protection Functions)
- HTML escaping (htmlspecialchars, htmlentities)
- SQL escaping (mysqli_escape_string, prepared statements)
- Command escaping (escapeshellarg, escapeshellcmd)
- Input validation (is_numeric, in_array, etc.)

## Usage

### Running All Security Queries

```bash
codeql database create php_db --language=php --source-root=<path>
codeql query run php/ql/src/codeql-suites/php-security.yml -d php_db
```

### Running a Specific Query

```bash
codeql query run php/ql/src/queries/security/cwe-89/SqlInjection.ql -d php_db
```

### Querying a Database

```bash
codeql query run custom_query.ql -d php_db
```

## Enhanced Control Flow Analysis

PHP CodeQL now includes comprehensive control flow analysis for complex branching, loops, and exception handling.

### Capabilities

The enhanced control flow analysis provides:

**Complex Branching Analysis:**
- If/elseif/else chain analysis with branch counting
- Incomplete conditional detection (missing else branches)
- Branch coverage metrics
- Switch statement analysis with case counting

**Loop Analysis:**
- Loop type detection (while, do-while, for, foreach)
- Potentially infinite loop detection
- Loop control statement tracking (break, continue)
- Loop body analysis

**Exception Handling:**
- Try/catch/finally block analysis
- Exception coverage detection (catch-all checks)
- Multiple catch block handling

**Reachability Analysis:**
- Dead code detection
- Unreachable statement identification
- Control flow path enumeration
- Data-dependent branch analysis

**Complexity Metrics:**
- Branch complexity rating (1-10)
- Nested structure detection
- Maintainability indicators

### Example Queries

Find unreachable code:

```ql
import php
import codeql.php.EnhancedControlFlow

from UnreachableStmt unreachable
select unreachable.getAstNode(), "Dead code"
```

Detect incomplete conditionals:

```ql
from ConditionalChain cond
where cond.hasMissingBranch()
select cond, "Missing else branch for complete coverage"
```

Find potentially infinite loops:

```ql
from LoopNode loop
where loop.isPotentiallyInfinite()
select loop, "Potentially infinite loop detected"
```

Identify complex branching patterns:

```ql
from ComplexBranching branch
where branch.getComplexityRating() >= 7
select branch, "High complexity - consider refactoring"
```

### Pre-built Queries

Four pre-built queries leverage enhanced control flow:

1. **UnreachableCode.ql** - Detects dead code paths
2. **IncompleteConditionals.ql** - Flags missing else branches
3. **PotentiallyInfiniteLoop.ql** - Identifies infinite loops
4. **ComplexBranchingPatterns.ql** - Warns about hard-to-maintain code

Run them with:
```bash
codeql query run php/ql/src/queries/controlflow/ -d php_db
```

## Querying PHP 8.x Features

### Named Arguments Analysis

Query calls using named arguments:

```ql
import php
import codeql.php.ast.PHP8NamedArguments

from Call call
where call.hasNamedArguments()
select call, "Call uses named arguments"
```

Detect specific parameter names:

```ql
from Call call, string paramName
where call.getNamedParameterName() = paramName and
      paramName in ["query", "sql", "command"]
select call, "Potential taint flow through: " + paramName
```

### Constructor Promotion Analysis

Find classes with promoted properties:

```ql
import php
import codeql.php.ast.PHP8ConstructorPromotion

from PromotedConstructor constructor
select constructor, "Constructor with promoted properties"
```

Analyze promoted property visibility:

```ql
from PromotedProperty prop
where prop.isPublic()
select prop, "Public promoted property: " + prop.getName()
```

### Readonly Properties Analysis (PHP 8.2+)

Find all readonly properties:

```ql
import php
import codeql.php.ast.PHP8ReadonlyProperties

from ReadonlyProperty prop
where prop.getDeclaringClass().getName().matches("Config%")
select prop, "Readonly property in config class: " + prop.getName()
```

Check for uninitialized readonly properties:

```ql
from ClassWithReadonlyProperties class_, ReadonlyProperty prop
where prop.getDeclaringClass() = class_ and
      prop.requiresConstructorInitialization() and
      not prop.isInitializedInConstructor()
select class_, "Readonly property not initialized in constructor: " + prop.getName()
```

Analyze immutability patterns:

```ql
from ReadonlyPropertyImmutability immutability
where immutability.isTrulyImmutable()
select immutability.getProperty(),
       "Strictly immutable readonly property: " + immutability.getProperty().getName()
```

### DNF Type Analysis (PHP 8.2+)

Find all complex DNF types:

```ql
import php
import codeql.php.ast.PHP8DnfTypes

from DnfTypeParameter param
where param.hasComplexType()
select param.getFunction(),
       "Complex DNF parameter: " + param.getName() + " : " + param.getType()
```

Identify overly complex types:

```ql
from ComplexDnfType dnf
where dnf.isTooComplex()
select dnf.getTypeString(),
       "Overly complex DNF type (score: " + dnf.getComplexityScore() + ")"
```

Analyze return types with unions and intersections:

```ql
from DnfTypeReturnValue returnVal
where returnVal.hasComplexReturnType()
select returnVal.getFunction(),
       "Complex DNF return type: " + returnVal.getDnfType().getTypeString()
```

### Pre-built PHP 8.2+ Queries

Four pre-built queries for PHP 8.2 feature analysis:

1. **ReadonlyPropertyAnalysis.ql** - Detects all readonly properties and their characteristics
2. **ReadonlyPropertyMisuse.ql** - Warns about uninitialized or misused readonly properties
3. **DnfTypeAnalysis.ql** - Analyzes complex DNF types in function parameters
4. **ComplexDnfTypeUsage.ql** - Identifies overly complex types for maintainability improvement

Run them with:
```bash
codeql query run php/ql/src/queries/php8/ -d php_db
```

## Extension Points

### Adding New Framework Support

1. Create a new file in `php/ql/lib/codeql/php/frameworks/MyFramework.qll`
2. Define classes for framework-specific patterns:
   - Request object access
   - Query builders
   - Template rendering
   - ORM models

3. Import in main library if widely used

### Creating Custom Queries

```ql
import php
import codeql.php.DataFlow

class MySource extends DataFlowNode { ... }
class MySink extends DataFlowNode { ... }

module MyFlow = TaintTracking::Global<MySource, MySink>;

from MyFlow::PathNode source, MyFlow::PathNode sink
where MyFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Message", source.getNode(), "description"
```

## Testing

### Running Tests

```bash
codeql test run php/ql/test --
```

### Creating New Tests

1. Add test PHP file to `test/fixtures/`
2. Create corresponding test query in appropriate subdirectory
3. Verify expected results match actual results

## Cross-File Analysis

PHP CodeQL now supports cross-file data flow analysis, enabling detection of vulnerabilities that span multiple files:

### Features

- **Function Call Tracking**: Follows data flow through function calls and returns
- **Global Variable Propagation**: Tracks data movement through global scope
- **Include/Require Resolution**: Analyzes code loaded dynamically
- **Function Summaries**: Caches analysis results for frequently used functions
- **Call Graph Construction**: Builds complete program call graphs

### Example

```php
// file1.php
function getUserInput() {
    return $_GET['id'];
}

// file2.php
function processUser() {
    $id = getUserInput();
    $query = "SELECT * FROM users WHERE id = " . $id; // Detected as SQLi
    return query($query);
}
```

## Improved Type Inference System

PHP CodeQL now features an enhanced type inference system that significantly improves vulnerability detection accuracy:

### Type System Architecture

The improved type inference system consists of five integrated components:

**1. Core Type Representation** (`types/Type.qll`)
- Semantic type hierarchy: `BuiltinType`, `ClassType`, `UnionType`, `NullableType`, `GenericType`
- Type operations: `isSubtypeOf()`, `unify()`, `isCompatible()`
- Supports PHP 8.0+ union types and nullable types
- Type casting and instance checks

**2. Type Narrowing** (`types/TypeNarrowing.qll`)
- Type guards from validation functions: `is_string()`, `is_int()`, `is_array()`
- instanceof checks for class type refinement
- isset() and null checks for nullable type narrowing
- Type narrowing through control flow branches

**3. Type Propagation** (`types/TypePropagation.qll`)
- Function return type tracking across call sites
- Parameter type validation and propagation
- Method call type inference
- Inter-procedural type flow analysis
- Array and string operation type inference

**4. Union and Nullable Types** (`types/UnionTypes.qll`)
- Full support for PHP 8.0 union types (string|int)
- Nullable type representation (?T) and equivalence to T|null
- Union type normalization and compatibility checking
- Type intersection and narrowing for unions

**5. Operator Type Inference** (`types/TypeInference.qll`)
- Binary operator type inference (arithmetic, string, comparison, logical)
- Unary operator type inference (negation, bitwise, increment)
- Assignment type inference and propagation
- Array and string function return types
- Type casting effect on data flow

### Key Features

- **Reduces False Positives**: Type information eliminates impossible vulnerabilities
  - Example: `(int)$input` breaks string-based injection
  - Type casts to int/float stop SQL and XSS taint

- **Improves Detection Accuracy**: Type propagation catches more real vulnerabilities
  - Example: `is_string()` guard narrows type before sink
  - Framework type validation recognized as effective barrier

- **Respects PHP Type System**: Handles PHP 8.0+ type declarations
  - Declared parameter and return types
  - Union types and nullable types
  - Class type hierarchies and interfaces

### Type System Benefits

| Feature | Benefit | Example |
|---------|---------|---------|
| Type Narrowing | Eliminates false positives | `if (is_int($x)) { query($x); }` → Not flagged |
| Type Propagation | Catches cross-file bugs | Function return type tracked to sink |
| Union Types | Modern PHP support | `string\|int` properly represented |
| Class Types | Framework validation | `instanceof` checks trusted results |
| Cast Detection | Type-based sanitization | `(int)$input` breaks injection taint |

## Polymorphism Analysis Framework

PHP CodeQL now includes a comprehensive polymorphism analysis framework with 19 specialized modules for analyzing object-oriented polymorphism patterns.

### Capabilities

**Method Resolution:**
- Complete method resolution through inheritance hierarchies
- Trait composition with method precedence rules
- Magic method dispatch (__call, __get, __invoke, __toString, etc.)
- Static context handling (self::, parent::, static::, late static binding)

**Type Safety:**
- Method override validation with signature checking
- Covariance/contravariance validation
- Liskov substitution principle enforcement
- Interface implementation validation

**Security Analysis:**
- Type confusion vulnerability detection
- Unsafe method override detection
- Magic method exploitation patterns
- Visibility bypass attacks
- Deserialization gadget chains
- Trait composition vulnerabilities
- Duck typing missing method detection
- Taint flow through polymorphic dispatch

**Performance Analysis:**
- Polymorphic method statistics
- Hot method detection (optimization candidates)
- Inheritance depth analysis
- Method resolution complexity assessment

### Pre-built Security Queries

9 security-focused queries detect:
- `PolymorphismVulnerabilities.ql` - Type confusion
- `UnsafeMethodOverrides.ql` - Incompatible method signatures
- `MagicMethodVulnerabilities.ql` - Dangerous magic methods
- `TypeSafetyViolations.ql` - Variance violations
- `VisibilityBypassVulnerabilities.ql` - Access control bypass
- `TraitVulnerabilities.ql` - Unsafe trait composition
- `DeserializationGadgets.ql` - RCE gadget chains
- `DuckTypingMissingMethods.ql` - Runtime method errors
- `PolymorphicDataFlowAnalysis.ql` - Injection through dispatch

### Usage

```ql
import codeql.php.polymorphism.Polymorphism

// Resolve method calls through inheritance
from MethodCall call
where exists(Method m | m = resolveMethodCall(call))
select call, m.getDeclaringClass()

// Detect unsafe overrides
from Method overriding, Method overridden
where overriding.getName() = overridden.getName() and
      not hasCompletelyCompatibleSignature(overriding, overridden)
select overriding, "Unsafe override"
```

### Running Polymorphism Queries

```bash
# All polymorphism queries
codeql query run lib/codeql/php/polymorphism/queries/ \
  --database php-db

# Specific query
codeql query run lib/codeql/php/polymorphism/queries/UnsafeMethodOverrides.ql \
  --database php-db

# Complete suite
codeql query run lib/codeql/php/polymorphism/queries/Polymorphism.qls \
  --database php-db
```

### Documentation

- **Quick Start**: `lib/codeql/php/polymorphism/QUICKSTART.md` (5-minute setup)
- **Framework Overview**: `lib/codeql/php/polymorphism/README.md`
- **Integration Guide**: `lib/codeql/php/polymorphism/INTEGRATION_GUIDE.md`
- **Usage Examples**: `lib/codeql/php/polymorphism/USAGE_EXAMPLES.md`

---

## Known Limitations

1. **Dynamic Calls**: Difficult to analyze `call_user_func` with arbitrary function names
2. **Magic Methods**: Limited support for `__get`, `__set`, `__call` behavior (enhanced with polymorphism framework)
3. **Goto Statements**: Minimal control flow analysis for goto
4. **Variable Functions**: Cannot fully analyze indirect function calls via variables
5. **Reflection**: Cannot analyze reflection-based code with full accuracy (polymorphism framework has partial support)
6. **Autoloading**: Dynamic class autoloading patterns may not be fully resolved
7. **Advanced Generic Types**: Generic type parameter inference limited (PHP doesn't have true generics)

## Future Enhancements

- [x] Extended framework support (10 frameworks: Laravel, Symfony, CodeIgniter, Yii, CakePHP, Zend/Laminas, WordPress, Drupal, Joomla, Magento)
- [x] Cross-file analysis support (Function tracking, global variables, includes/requires)
- [x] Improved type inference system (Type narrowing, propagation, union types, operator inference)
- [x] Advanced polymorphism analysis (19 QL modules, 15 pre-built queries, 550+ test scenarios)
- [x] Support for newer PHP 8.x features (named arguments, constructor promotion)
  - Tree-sitter-php AST-based detection
  - 118+ named argument facts
  - 81+ constructor promotion facts
- [x] Comprehensive tree-sitter-based extractor
  - 154+ AST node facts
  - Accurate location information
  - Full PHP 5.2-8.1+ support
- [x] Enhanced control flow analysis for complex branching
  - If/elseif/else chain analysis
  - Loop and exception handling analysis
  - Dead code and unreachable statement detection
  - Complexity metrics and branch coverage analysis
  - 4 pre-built control flow queries
- [x] Additional security queries (insecure deserialization, LDAP injection, XXE, SSRF)
  - CWE-502: Insecure Deserialization (unserialize, json_decode, etc.)
  - CWE-90: LDAP Injection (ldap_search, ldap_add, etc.)
  - CWE-611: XML External Entity (XXE) attacks (simplexml_load_string, DOMDocument, etc.)
  - CWE-918: Server-Side Request Forgery (SSRF) via curl, file_get_contents, etc.
  - 4 new security queries with data flow analysis
- [x] Support for PHP 8.2+ features (readonly properties, disjunctive normal form types)
  - PHP 8.2 readonly properties with immutability analysis
  - Disjunctive Normal Form (DNF) types: unions and intersections
  - Type complexity metrics and analysis
  - 4 pre-built PHP 8.2+ analysis queries
  - Full tree-sitter-php integration for feature detection
- [x] Support for PHP 8.3+ features (attributes, readonly classes)
  - Attribute detection and validation (#[Override], #[Deprecated], framework attributes)
  - Readonly class enforcement and immutability verification
  - Value object pattern recognition
  - Attribute security implications analysis
- [x] Additional security queries (weak crypto, hardcoded credentials, weak hashing, exception handling)
  - CWE-327: Weak cryptography detection (MD5, SHA1, mcrypt)
  - CWE-798: Hardcoded credentials (passwords, API keys, secrets)
  - CWE-760: Weak password hashing (MD5/SHA1 without salt)
  - CWE-754: Improper exception handling (silent failures, no logging)
  - 4 new security queries with comprehensive pattern detection
- [x] Enhanced reflection analysis for polymorphism framework
  - ReflectionClass and ReflectionMethod usage detection
  - Unsafe dynamic instantiation detection
  - Magic method exploitation pattern detection
  - Secure reflection validation
- [x] Support for PHP 8.4+ features (property hooks, asymmetric visibility, DOM API, BCMath, PDO)
  - Property hook detection and analysis
  - Asymmetric visibility enforcement (public private(set))
  - Modern DOM API (HTMLDocument, XMLDocument) usage tracking
  - BCMath object-oriented extension with precision analysis
  - PDO driver subclass usage (SQLite, MySQL, PostgreSQL)
  - 5 new QL modules with comprehensive analysis
- [x] Support for PHP 8.5+ features (pipe operator, clone with, URI, #[NoDiscard])
  - Pipe operator (`|>`) detection with readability scoring
  - Clone-with syntax for immutable object updates
  - URI extension with RFC 3986 and WHATWG compliance
  - #[NoDiscard] attribute for return value tracking
  - Security analysis for SSRF, XXE, and unused return values
  - 4 new QL modules + attribute integration
  - 5 pre-built example queries for PHP 8.4/8.5 features
- [x] Updated extractor for PHP 8.4/8.5 feature detection
  - 6 new feature detection methods in Rust extractor
  - TRAP fact generation for property hooks, asymmetric visibility, pipe operator, clone-with, URI, NoDiscard
  - Full tree-sitter-php support for all new features
- [ ] Machine learning-based vulnerability detection
- [ ] Performance optimization for large codebases
- [ ] Dynamic class name resolution improvements

## Contributing

To contribute improvements:

1. Update the appropriate module in `php/ql/lib/codeql/php/`
2. Add/update security queries in `php/ql/src/queries/`
3. Add test cases in `php/ql/test/`
4. Ensure all tests pass
5. Submit PR with description of changes

## References

- [CodeQL Documentation](https://codeql.github.com/docs/)
- [PHP Official Manual](https://www.php.net/manual/)
- [OWASP Top 10 PHP Vulnerabilities](https://owasp.org/www-project-top-ten/)
- [CWE/SANS Top 25](https://cwe.mitre.org/top25/)

## License

This PHP language support is part of CodeQL and follows the same licensing terms.
