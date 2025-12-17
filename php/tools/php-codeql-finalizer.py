#!/usr/bin/env python3
"""
Production-Ready PHP CodeQL TRAP Finalizer

This tool finalizes PHP CodeQL databases by converting TRAP fact files
into CodeQL's binary dataset format. It uses CodeQL's native 'codeql dataset import'
command to properly compile TRAP to binary relations.

IMPORTANT LIMITATIONS:
- CodeQL's query engine requires .stats files that contain detailed column statistics
- These .stats files are generated only by CodeQL's internal C++ finalizer
- CodeQL's public version only has built-in support for: Python, JavaScript, Go, Java,
  C++, C#, Ruby, Swift, Kotlin, and others - but NOT custom extractors
- Full PHP query support requires either:
  1. Contributing PHP support to the official CodeQL project
  2. Building CodeQL from source and adding PHP finalization handlers
  3. Using alternative analysis methods on the extracted TRAP data

WHAT THIS TOOL PROVIDES:
- Proper TRAP-to-binary conversion using CodeQL's dataset import
- Correct database structure for CodeQL tools
- A solid foundation for PHP analysis
- Clear path forward for full integration

USAGE:
  python3 php-codeql-finalizer.py <database_path> [--codeql-path <path>]

Example:
  python3 php-codeql-finalizer.py /tmp/my-php-db
  python3 php-codeql-finalizer.py ~/databases/php-db --codeql-path ~/codeql/codeql
"""

import os
import sys
import subprocess
from pathlib import Path


class CodeQLDatabaseFinalizer:
    """Finalize CodeQL database with PHP TRAP facts using native CodeQL commands"""

    def __init__(self, db_path, codeql_path=None):
        self.db_path = Path(db_path).resolve()
        self.trap_dir = self.db_path / "trap" / "php"
        # CodeQL expects dataset at db-<language>/ directory
        self.dataset_dir = self.db_path / "db-php"
        self.db_yml = self.db_path / "codeql-database.yml"

        # Find CodeQL installation
        if codeql_path:
            self.codeql = codeql_path
        else:
            # Try to find codeql in PATH
            result = subprocess.run(['which', 'codeql'], capture_output=True, text=True)
            if result.returncode == 0:
                self.codeql = result.stdout.strip()
            else:
                # Try common installation paths
                for path in [
                    os.path.expanduser("~/Tools/codeql/codeql"),
                    "/opt/codeql/codeql",
                    "/usr/local/bin/codeql"
                ]:
                    if Path(path).exists():
                        self.codeql = path
                        break
                else:
                    raise FileNotFoundError("CodeQL not found. Please set CODEQL_PATH or ensure codeql is in PATH")

        # Find dbscheme - try multiple locations
        self.dbscheme = self._find_dbscheme()
        if not self.dbscheme:
            raise FileNotFoundError("PHP dbscheme not found")

    def _find_dbscheme(self):
        """Find the PHP dbscheme file"""
        paths = [
            Path(self.codeql).parent / "php" / "php.dbscheme",
            Path(self.codeql).parent.parent / "php" / "php.dbscheme",
            Path("/home/pveres/Tools/codeql/php/php.dbscheme"),
            Path.cwd() / "php.dbscheme"
        ]

        for path in paths:
            if path.exists():
                return str(path)

        return None

    def finalize(self):
        """Execute complete finalization process using CodeQL native commands"""
        print(f"PHP CodeQL Database Finalization")
        print(f"{'='*60}")
        print(f"Database:   {self.db_path}")
        print(f"TRAP dir:   {self.trap_dir}")
        print(f"DBSchema:   {self.dbscheme}")
        print(f"CodeQL:     {self.codeql}\n")

        # Validate prerequisites
        if not self.trap_dir.exists():
            raise FileNotFoundError(f"TRAP directory not found: {self.trap_dir}")

        trap_files = list(self.trap_dir.glob("*.trap*"))
        if not trap_files:
            raise FileNotFoundError(f"No TRAP files found in {self.trap_dir}")

        print(f"Found {len(trap_files)} TRAP file(s)")
        for trap_file in trap_files:
            print(f"  • {trap_file.name}")
        print()

        # Step 1: Create dataset directory
        print("Step 1: Preparing dataset directory...")
        self.dataset_dir.mkdir(parents=True, exist_ok=True)
        print(f"  ✓ Dataset directory ready: {self.dataset_dir}\n")

        # Step 2: Import TRAP files using CodeQL's native dataset import
        print("Step 2: Importing TRAP files with CodeQL dataset import...")
        self._import_trap_with_codeql()
        print()

        # Step 3: Update database.yml to mark as finalized
        print("Step 3: Marking database as finalized...")
        self._mark_finalized()
        print()

        # Step 4: Verify finalization
        print("Step 4: Verifying finalization...")
        self._verify()
        print()

        print(f"{'='*60}")
        print(f"✓ Finalization complete!")
        print(f"\nDatabase location: {self.db_path}")
        print(f"\nNOTE: Full CodeQL query support is limited by architecture.")
        print(f"See documentation for analysis alternatives and integration paths.")

    def _import_trap_with_codeql(self):
        """Import TRAP files using CodeQL's native dataset import command"""
        cmd = [
            self.codeql,
            'dataset',
            'import',
            '--dbscheme', self.dbscheme,
            '--threads=0',  # Use all available cores
            '--',
            str(self.dataset_dir),
            str(self.trap_dir)
        ]

        print(f"  Running: {' '.join(cmd[:6])} ...")

        try:
            result = subprocess.run(cmd, capture_output=True, text=True, timeout=300)

            if result.returncode != 0:
                print(f"\n  ✗ CodeQL dataset import failed!")
                print(f"\nSTDOUT:\n{result.stdout}")
                print(f"\nSTDERR:\n{result.stderr}")
                raise RuntimeError(f"CodeQL dataset import failed with code {result.returncode}")

            # Show progress output
            if result.stdout:
                lines = result.stdout.strip().split('\n')
                for line in lines[-5:]:  # Show last 5 lines of output
                    print(f"  {line}")

            print(f"  ✓ TRAP files imported successfully")

        except subprocess.TimeoutExpired:
            raise RuntimeError("CodeQL dataset import timed out (>5 minutes)")
        except Exception as e:
            raise RuntimeError(f"Failed to run CodeQL dataset import: {e}")

    def _mark_finalized(self):
        """Update database.yml to mark as finalized"""
        if not self.db_yml.exists():
            raise FileNotFoundError(f"Database metadata not found: {self.db_yml}")

        with open(self.db_yml, 'r') as f:
            content = f.read()

        # Replace finalised flag
        if 'finalised: false' in content:
            content = content.replace('finalised: false', 'finalised: true')
        elif 'finalised: true' not in content:
            # Add the flag if it doesn't exist
            content = content.rstrip() + '\nfinalised: true\n'

        with open(self.db_yml, 'w') as f:
            f.write(content)

        print(f"  ✓ Updated {self.db_yml}")

    def _verify(self):
        """Verify finalization was successful"""
        # Check dataset directory structure
        if self.dataset_dir.exists():
            print(f"  ✓ Dataset directory: {self.dataset_dir}")
            items = list(self.dataset_dir.iterdir())
            print(f"    Contains {len(items)} item(s)")

            # Check for binary dataset structure
            default_dir = self.dataset_dir / "default"
            if default_dir.exists():
                print(f"    ✓ Binary dataset created at {default_dir}")

        # Check finalized flag
        with open(self.db_yml) as f:
            content = f.read()
            if 'finalised: true' in content:
                print(f"  ✓ Database marked as finalized")
            else:
                print(f"  ✗ WARNING: Database not marked as finalized!")


def main():
    import argparse

    parser = argparse.ArgumentParser(
        description='Finalize PHP CodeQL database with extracted TRAP facts'
    )
    parser.add_argument(
        'database_path',
        help='Path to CodeQL database directory'
    )
    parser.add_argument(
        '--codeql-path',
        help='Path to CodeQL executable (optional, will search PATH)'
    )

    args = parser.parse_args()

    try:
        finalizer = CodeQLDatabaseFinalizer(args.database_path, args.codeql_path)
        finalizer.finalize()
        sys.exit(0)
    except Exception as e:
        print(f"\n✗ ERROR: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
