#!/usr/bin/env python3

import sys
from pathlib import Path
import yaml

def find_and_load_models(basedir, globs):
    """Find and load all .yml files under the given directory."""
    models = {}
    for glob in globs:
        for file_path in Path(basedir).rglob(glob):
            with open(file_path, 'r') as f:
                data = yaml.safe_load(f)
                models[file_path] = data
    return models


def main():
    if len(sys.argv) < 2:
        print("Usage: compile-models.py <output.yml>", file=sys.stderr)
        sys.exit(1)
    
    # TODO: don't hard-code these
    basedir = 'java/ql/lib'
    globs = [
        'ext/*.model.yml',
        'ext/generated/**/*.model.yml',
        'ext/experimental/*.model.yml',
    ]
    models = find_and_load_models(basedir, globs)

    collected = {}
    
    print(f"Loaded {len(models)} .yml files")
    for (file_path, data) in models.items():
        for extension in data['extensions']:
            pack = extension['addsTo']['pack']
            extensible = extension['addsTo']['extensible']
            if (pack, extensible) not in collected:
                collected[(pack, extensible)] = []
            collected[(pack, extensible)].extend(extension['data'])

    print(f"Compiling")
    compiled_model = {}
    compiled_model['extensions'] = []
    for (pack, extensible), data in collected.items():
        extension = {
            'addsTo': {
                'pack': pack,
                'extensible': extensible
            },
            'data': sorted(data)
        }
        compiled_model['extensions'].append(extension)       

    output_file = sys.argv[1]
    print(f"Writing compiled model to {output_file}")
    with open(output_file, 'w') as f:
        yaml.dump(compiled_model, f, encoding='utf-8', width=10000, default_flow_style=None)

if __name__ == '__main__':
    main()
