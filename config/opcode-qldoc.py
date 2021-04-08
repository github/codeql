#!/usr/bin/env python3

import os
import re
path = os.path

needs_an_re = re.compile(r'^(?!Unary)[AEIOU]')  # Name requiring "an" instead of "a".
start_qldoc_re = re.compile(r'^\s*/\*\*')  # Start of a QLDoc comment
end_qldoc_re = re.compile(r'\*/\s*$')  # End of a QLDoc comment
blank_qldoc_line_re = re.compile(r'^\s*\*\s*$')  # A line in a QLDoc comment with only the '*'
instruction_class_re = re.compile(r'^class (?P<name>[A-aa-z0-9]+)Instruction\s')  # Declaration of an `Instruction` class
opcode_base_class_re = re.compile(r'^abstract class (?P<name>[A-aa-z0-9]+)Opcode\s')  # Declaration of an `Opcode` base class
opcode_class_re = re.compile(r'^  class (?P<name>[A-aa-z0-9]+)\s')  # Declaration of an `Opcode` class

script_dir = path.realpath(path.dirname(__file__))
instruction_path = path.realpath(path.join(script_dir, '../cpp/ql/src/semmle/code/cpp/ir/implementation/raw/Instruction.qll'))
opcode_path = path.realpath(path.join(script_dir, '../cpp/ql/src/semmle/code/cpp/ir/implementation/Opcode.qll'))

# Scan `Instruction.qll`, keeping track of the QLDoc comment attached to each declaration of a class
# whose name ends with `Instruction`.
instruction_comments = {}
in_qldoc = False
saw_blank_line_in_qldoc = False
qldoc_lines = []
with open(instruction_path, 'r', encoding='utf-8') as instr:
    for line in instr:
        if in_qldoc:
            if end_qldoc_re.search(line):
                qldoc_lines.append(line)
                in_qldoc = False
            elif blank_qldoc_line_re.search(line):
                # We're going to skip any lines after the first blank line, to avoid duplicating all
                # of the verbose description.
                saw_blank_line_in_qldoc = True
            elif not saw_blank_line_in_qldoc:
                qldoc_lines.append(line)
        else:
            if start_qldoc_re.search(line):
                # Starting a new QLDoc comment.
                saw_blank_line_in_qldoc = False
                qldoc_lines.append(line)
                if not end_qldoc_re.search(line):
                    in_qldoc = True
            else:
                instruction_match = instruction_class_re.search(line)
                if instruction_match:
                    # Found the declaration of an `Instruction` class. Record the QLDoc comments.
                    instruction_comments[instruction_match.group('name')] = qldoc_lines
                qldoc_lines = []

# Scan `Opcode.qll`. Whenever we see the declaration of an `Opcode` class for which we have a
# corresponding `Instruction` class, we'll attach a copy of the `Instruction`'s QLDoc comment.
in_qldoc = False
qldoc_lines = []
output_lines = []
with open(opcode_path, 'r', encoding='utf-8') as opcode:
    for line in opcode:
        if in_qldoc:
            qldoc_lines.append(line)
            if end_qldoc_re.search(line):
                in_qldoc = False
        else:
            if start_qldoc_re.search(line):
                qldoc_lines.append(line)
                if not end_qldoc_re.search(line):
                    in_qldoc = True
            else:
                name_without_suffix = None
                name = None
                indent = ''
                opcode_base_match = opcode_base_class_re.search(line)
                if opcode_base_match:
                    name_without_suffix = opcode_base_match.group('name')
                    name = name_without_suffix + 'Opcode'
                else:
                    opcode_match = opcode_class_re.search(line)
                    if opcode_match:
                        name_without_suffix = opcode_match.group('name')
                        name = name_without_suffix
                        # Indent by two additional spaces, since opcodes are declared in the
                        # `Opcode` module.
                        indent = '  '
                
                if name_without_suffix:
                    # Found an `Opcode` that matches a known `Instruction`. Replace the QLDoc with
                    # a copy of the one from the `Instruction`.
                    if instruction_comments.get(name_without_suffix):
                        article = 'an' if needs_an_re.search(name_without_suffix) else 'a'
                        qldoc_lines = [
                            indent + '/**\n',
                            indent + ' * The `Opcode` for ' + article + ' `' + name_without_suffix + 'Instruction`.\n',
                            indent + ' *\n',
                            indent + ' * See the `' + name_without_suffix + 'Instruction` documentation for more details.\n',
                            indent + ' */\n'
                        ]
                output_lines.extend(qldoc_lines)
                qldoc_lines = []
                output_lines.append(line)

# Write out the updated `Opcode.qll`
with open(opcode_path, 'w', encoding='utf-8') as opcode:
    opcode.writelines(output_lines)
