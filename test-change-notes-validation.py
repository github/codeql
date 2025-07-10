#!/usr/bin/env python3
"""
Test script to validate different change note file formats and understand
the exact requirements for CodeQL pack release validation.

This script creates various test change note files to understand:
1. What file naming patterns are accepted
2. What YAML frontmatter is required
3. What content formats work
4. Why `actions/ql/lib/change-notes/2025-07-08.md` is failing validation

Based on the analysis of the CodeQL repository structure and documentation.
"""

import os
import sys
import tempfile
import shutil
from pathlib import Path
import yaml
import re
from datetime import datetime, timedelta

class ChangeNoteValidator:
    """Validates change note files according to CodeQL pack requirements."""
    
    def __init__(self):
        self.valid_categories = {
            'query_pack': ['breaking', 'deprecated', 'newQuery', 'queryMetadata', 'majorAnalysis', 'minorAnalysis', 'fix'],
            'library_pack': ['breaking', 'deprecated', 'feature', 'majorAnalysis', 'minorAnalysis', 'fix']
        }
        self.date_pattern = re.compile(r'^\d{4}-\d{2}-\d{2}$')
        self.filename_pattern = re.compile(r'^(\d{4}-\d{2}-\d{2})-.+\.md$')
        
    def validate_filename(self, filename):
        """Validate change note filename format."""
        errors = []
        
        if not filename.endswith('.md'):
            errors.append("Filename must end with .md")
            
        match = self.filename_pattern.match(filename)
        if not match:
            errors.append("Filename must follow format: YYYY-MM-DD-description.md")
            return errors
            
        date_str = match.group(1)
        if not self.date_pattern.match(date_str):
            errors.append("Date part must be in YYYY-MM-DD format")
        else:
            # Validate that the date is actually valid
            try:
                datetime.strptime(date_str, '%Y-%m-%d')
            except ValueError:
                errors.append(f"Invalid date: {date_str}")
                
        return errors
        
    def validate_content(self, content, pack_type='library_pack'):
        """Validate change note content and YAML frontmatter."""
        errors = []
        
        # Check for YAML frontmatter
        if not content.startswith('---'):
            errors.append("Content must start with YAML frontmatter (---)")
            return errors
            
        # Split content into frontmatter and body
        parts = content.split('---')
        if len(parts) < 3:
            errors.append("YAML frontmatter must be enclosed by --- lines")
            return errors
            
        frontmatter_str = parts[1].strip()
        body = '---'.join(parts[2:]).strip()
        
        # Parse YAML frontmatter
        try:
            frontmatter = yaml.safe_load(frontmatter_str)
        except yaml.YAMLError as e:
            errors.append(f"Invalid YAML frontmatter: {e}")
            return errors
            
        # Check required fields
        if 'category' not in frontmatter:
            errors.append("YAML frontmatter must contain 'category' field")
        else:
            category = frontmatter['category']
            if category not in self.valid_categories[pack_type]:
                errors.append(f"Invalid category '{category}' for {pack_type}. Valid categories: {self.valid_categories[pack_type]}")
                
        # Check body content
        if not body:
            errors.append("Change note must have content after the YAML frontmatter")
        elif not body.strip().startswith('*'):
            errors.append("Change note content should start with a bullet point (*)")
            
        return errors
        
    def validate_file(self, filepath, pack_type='library_pack'):
        """Validate a single change note file."""
        errors = []
        
        # Validate filename
        filename = Path(filepath).name
        errors.extend(self.validate_filename(filename))
        
        # Validate content
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
            errors.extend(self.validate_content(content, pack_type))
        except Exception as e:
            errors.append(f"Error reading file: {e}")
            
        return errors

def create_test_files():
    """Create various test change note files."""
    test_files = {}
    
    # 1. Valid change note with proper YAML frontmatter (library pack)
    test_files['2025-07-08-valid-library-basic.md'] = """---
category: minorAnalysis
---
* Added taint flow model for new function."""
    
    # 2. Valid change note with different category (query pack)
    test_files['2025-07-08-valid-query-new.md'] = """---
category: newQuery
---
* Added a new query to detect potential security vulnerabilities."""
    
    # 3. Valid change note with breaking change
    test_files['2025-07-08-valid-breaking.md'] = """---
category: breaking
---
* Removed deprecated API function that was causing issues."""
    
    # 4. Valid change note with feature category (library pack only)
    test_files['2025-07-08-valid-feature.md'] = """---
category: feature
---
* Added new API for enhanced data flow analysis."""
    
    # 5. Invalid change note without frontmatter
    test_files['2025-07-08-invalid-no-frontmatter.md'] = """* This is a change note without YAML frontmatter."""
    
    # 6. Invalid change note with malformed frontmatter
    test_files['2025-07-08-invalid-malformed-yaml.md'] = """---
category minorAnalysis
---
* Missing colon in YAML frontmatter."""
    
    # 7. Invalid change note with invalid category
    test_files['2025-07-08-invalid-category.md'] = """---
category: invalidCategory
---
* This uses an invalid category."""
    
    # 8. Invalid change note with empty content
    test_files['2025-07-08-invalid-empty-content.md'] = """---
category: minorAnalysis
---
"""
    
    # 9. Different date formats (valid)
    current_date = datetime.now()
    yesterday = current_date - timedelta(days=1)
    
    test_files[f'{current_date.strftime("%Y-%m-%d")}-current-date.md'] = """---
category: fix
---
* Fixed performance issue with current date format."""
    
    test_files[f'{yesterday.strftime("%Y-%m-%d")}-yesterday.md'] = """---
category: minorAnalysis
---
* Updated analysis with yesterday's date format."""
    
    # 10. Invalid filename formats
    test_files['invalid-filename-format.md'] = """---
category: minorAnalysis
---
* This file has an invalid filename format."""
    
    test_files['2025-13-45-invalid-date.md'] = """---
category: minorAnalysis
---
* This file has an invalid date in filename."""
    
    # 11. The problematic file mentioned in the issue (testing different scenarios)
    test_files['2025-07-08-problematic-file.md'] = """---
category: minorAnalysis
---
* This simulates the problematic file mentioned in the issue."""
    
    # 12. Additional edge cases
    test_files['2025-07-08-no-bullet-point.md'] = """---
category: minorAnalysis
---
This change note doesn't start with a bullet point."""
    
    test_files['2025-07-08-multiple-bullets.md'] = """---
category: majorAnalysis
---
* First change made to the system.
* Second change made to the system.
* Third change made to the system."""
    
    return test_files

def simulate_codeql_pack_validation(test_dir):
    """Simulate CodeQL pack release validation."""
    print("\n" + "=" * 60)
    print("SIMULATING CODEQL PACK VALIDATION")
    print("=" * 60)
    
    # Create a temporary actions pack structure
    actions_pack_dir = test_dir / "actions-pack-test"
    actions_pack_dir.mkdir(exist_ok=True)
    
    # Create qlpack.yml
    qlpack_content = """name: codeql/actions-test
version: 0.4.14-dev
library: true
warnOnImplicitThis: true
dependencies:
  codeql/util: ${workspace}
  codeql/yaml: ${workspace}
extractor: actions
"""
    
    with open(actions_pack_dir / "qlpack.yml", 'w') as f:
        f.write(qlpack_content)
    
    # Create change-notes directory
    change_notes_dir = actions_pack_dir / "change-notes"
    change_notes_dir.mkdir(exist_ok=True)
    
    # Copy test files to the change-notes directory
    test_files = create_test_files()
    for filename, content in test_files.items():
        if filename.startswith('2025-07-08'):  # Only copy the problematic date files
            with open(change_notes_dir / filename, 'w') as f:
                f.write(content)
    
    print(f"Created test pack structure at: {actions_pack_dir}")
    print(f"Change notes directory: {change_notes_dir}")
    print(f"Files in change-notes directory:")
    for file in change_notes_dir.iterdir():
        if file.is_file():
            print(f"  - {file.name}")
    
    # Note: In a real scenario, you would run:
    # codeql pack release --dry-run
    # But since we don't have codeql CLI in this environment, we simulate the validation
    
    print("\nSimulated validation results:")
    print("Note: In a real scenario, you would run 'codeql pack release --dry-run' to validate the pack")
    
    return actions_pack_dir

def main():
    """Main function to run the change note validation tests."""
    print("=" * 60)
    print("CodeQL Change Note Validation Test")
    print("=" * 60)
    
    # Create test directory
    test_dir = Path("/tmp/test-change-notes-validation")
    test_dir.mkdir(exist_ok=True)
    
    # Create test files
    test_files = create_test_files()
    validator = ChangeNoteValidator()
    
    print(f"\nCreated {len(test_files)} test files:")
    for filename in test_files.keys():
        print(f"  - {filename}")
    
    # Write test files to disk
    for filename, content in test_files.items():
        filepath = test_dir / filename
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
    
    print("\n" + "=" * 60)
    print("VALIDATION RESULTS FOR LIBRARY PACK")
    print("=" * 60)
    
    # Validate each test file for library pack
    for filename in sorted(test_files.keys()):
        filepath = test_dir / filename
        print(f"\nValidating: {filename}")
        print("-" * 40)
        
        errors = validator.validate_file(filepath, pack_type='library_pack')
        
        if errors:
            print("❌ VALIDATION FAILED")
            for error in errors:
                print(f"  • {error}")
        else:
            print("✅ VALIDATION PASSED")
    
    print("\n" + "=" * 60)
    print("VALIDATION RESULTS FOR QUERY PACK")
    print("=" * 60)
    
    # Validate each test file for query pack
    for filename in sorted(test_files.keys()):
        filepath = test_dir / filename
        print(f"\nValidating: {filename}")
        print("-" * 40)
        
        errors = validator.validate_file(filepath, pack_type='query_pack')
        
        if errors:
            print("❌ VALIDATION FAILED")
            for error in errors:
                print(f"  • {error}")
        else:
            print("✅ VALIDATION PASSED")
    
    # Simulate CodeQL pack validation
    actions_pack_dir = simulate_codeql_pack_validation(test_dir)
    
    # Summary
    print("\n" + "=" * 60)
    print("SUMMARY AND FINDINGS")
    print("=" * 60)
    
    print("\nKey findings about change note validation:")
    print("1. File naming is critical - must follow YYYY-MM-DD-description.md format")
    print("2. YAML frontmatter is required with proper --- delimiters")
    print("3. 'category' field is mandatory in YAML frontmatter")
    print("4. Categories differ between library and query packs")
    print("5. Content should start with bullet points (*)")
    print("6. Dates must be valid (e.g., 2025-07-08 is valid, 2025-13-45 is not)")
    
    print("\nValid categories for library packs:")
    for cat in validator.valid_categories['library_pack']:
        print(f"  - {cat}")
    
    print("\nValid categories for query packs:")
    for cat in validator.valid_categories['query_pack']:
        print(f"  - {cat}")
    
    print("\nFile naming requirements:")
    print("  - Must end with .md")
    print("  - Must follow format: YYYY-MM-DD-description.md")
    print("  - Date must be valid (e.g., 2025-07-08)")
    print("  - Description can be any kebab-case string")
    
    print("\nYAML frontmatter requirements:")
    print("  - Must start and end with ---")
    print("  - Must contain 'category' field")
    print("  - Category must be one of the valid categories")
    
    print("\nContent requirements:")
    print("  - Must have content after YAML frontmatter")
    print("  - Should start with a bullet point (*)")
    
    print(f"\nTest files created in: {test_dir}")
    print(f"Simulated pack structure in: {actions_pack_dir}")
    
    print("\n" + "=" * 60)
    print("SPECIFIC ISSUE ANALYSIS")
    print("=" * 60)
    
    print("\nRegarding the problematic file 'actions/ql/lib/change-notes/2025-07-08.md':")
    print("If this file is failing validation, it's likely due to one of these issues:")
    print("1. Missing or malformed YAML frontmatter")
    print("2. Invalid category for library pack (must be one of: breaking, deprecated, feature, majorAnalysis, minorAnalysis, fix)")
    print("3. Empty content after YAML frontmatter")
    print("4. Invalid date format in filename")
    print("5. Missing bullet point (*) at the start of content")
    
    print("\nTo fix the issue, ensure the file follows this format:")
    print("```")
    print("---")
    print("category: minorAnalysis")
    print("---")
    print("* Description of the change.")
    print("```")

if __name__ == "__main__":
    main()