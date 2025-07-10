# Change Note Validation Test Script

This directory contains a comprehensive test script to validate CodeQL change note file formats and understand the exact requirements for CodeQL pack release validation.

## Quick Start

```bash
# Run the validation test
python3 test-change-notes-validation.py
```

## What This Test Does

The test script helps debug and understand:

1. **File naming patterns** - What formats are accepted
2. **YAML frontmatter requirements** - What fields are required
3. **Content format validation** - What content structures work
4. **Category validation** - Different categories for library vs query packs
5. **Specific issue debugging** - Why certain files fail validation

## Test Coverage

The script creates and validates 15 different test files covering:

- ✅ Valid change notes with proper YAML frontmatter
- ✅ Valid change notes with different categories
- ✅ Valid change notes with proper date formats
- ❌ Invalid change notes without frontmatter
- ❌ Invalid change notes with malformed YAML
- ❌ Invalid change notes with wrong categories
- ❌ Invalid change notes with empty content
- ❌ Invalid change notes with wrong filename formats
- ❌ Invalid change notes with invalid dates

## Sample Valid Change Note

```markdown
---
category: minorAnalysis
---
* Added taint flow model for new function to improve security analysis.
```

## Common Issues and Solutions

### Issue: Wrong Filename Format
**Problem:** `2025-07-08.md` (missing description)
**Solution:** `2025-07-08-description.md`

### Issue: Missing YAML Frontmatter
**Problem:** File starts with content directly
**Solution:** Add YAML frontmatter with `---` delimiters

### Issue: Invalid Category
**Problem:** Using wrong category for pack type
**Solution:** Use valid categories (see documentation)

### Issue: Empty Content
**Problem:** No content after YAML frontmatter
**Solution:** Add descriptive content with bullet points

## Files Created

- `test-change-notes-validation.py` - Main test script
- `CHANGE_NOTE_VALIDATION_RESULTS.md` - Detailed documentation
- `actions/ql/lib/change-notes/2025-07-08-test-validation.md` - Sample valid file

## Usage Examples

```bash
# Run full validation test
python3 test-change-notes-validation.py

# Test a specific file
python3 -c "
from test-change-notes-validation import ChangeNoteValidator
validator = ChangeNoteValidator()
errors = validator.validate_file('path/to/your/file.md', 'library_pack')
print('✅ Valid' if not errors else '❌ Invalid: ' + ', '.join(errors))
"
```

## Understanding the Output

The script provides clear validation results:
- ✅ **VALIDATION PASSED** - File follows all requirements
- ❌ **VALIDATION FAILED** - Lists specific issues to fix

## Pack Types

The script validates for both pack types:
- **Library packs** - Use categories: breaking, deprecated, feature, majorAnalysis, minorAnalysis, fix
- **Query packs** - Use categories: breaking, deprecated, newQuery, queryMetadata, majorAnalysis, minorAnalysis, fix

## Next Steps

1. Run the test to understand current validation state
2. Fix any failing change notes based on the error messages
3. Use the sample files as templates for new change notes
4. Run `codeql pack release --dry-run` to validate with actual CodeQL CLI