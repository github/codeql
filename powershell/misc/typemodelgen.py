import xml.etree.ElementTree as ET
from pathlib import Path
import sys
import os
import re
from collections import defaultdict


def fixup(t):
    """Sometimes the docs specify a type that doesn't align with what
    PowerShell reports. This function fixes up those types so that it aligns with PowerShell.
    """
    if t.startswith("system.readonlyspan<"):
        return "system.string"
    # A regular expression that matches strings like a.b.c<T, U, W>
    # and replacee it with a.b.c
    return re.sub(r"<.*>", "", t)

def skipQualifier(name):
    """Removes the qualifier from the name."""
    # A regular expression that matches strings like a.b.c and returns c
    # and replaces it with c
    return re.sub(r".*\.", "", name)


def isStatic(member):
    """Returns True if the member is static, False otherwise."""
    for child in member:
        if child.tag == "MemberSignature" and "static" in child.attrib["Value"]:
            return True
    return False


def isA(member, x):
    """Returns True if member is an `x`."""
    for child in member:
        if child.tag == "MemberType" and child.text == x:
            return True
    return False


def isMethod(member):
    """Returns True if the member is a method, False otherwise."""
    return isA(member, "Method")


def isField(member):
    """Returns True if the member is a field, False otherwise."""
    return isA(member, "Field")


def isProperty(member):
    """Returns True if the member is a property, False otherwise."""
    return isA(member, "Property")


def isEvent(member):
    """Returns True if the member is an event, False otherwise."""
    return isA(member, "Event")


def isAttachedProperty(member):
    """Returns True if the member is an attached property, False otherwise."""
    return isA(member, "AttachedProperty")


def isAttachedEvent(member):
    """Returns True if the member is an attached event, False otherwise."""
    return isA(member, "AttachedEvent")


def isConstructor(member):
    """Returns True if the member is a constructor, False otherwise."""
    return isA(member, "Constructor")


# A map from filenames to a set of type models to be stored in the file
summaries = defaultdict(set)


def generateTypeModels(arg):
    """Generates type models for the given XML file."""
    folder_path = Path(arg)

    for file_path in folder_path.rglob("*"):
        try:
            if not file_path.name.endswith(".xml"):
                continue
            
            if not file_path.is_file():
                continue
            
            tree = ET.parse(str(file_path))
            root = tree.getroot()
            if not root.tag == "Type":
                continue

            thisType = root.attrib["FullName"]

            parentName = file_path.parent.name
            # Remove `and + in parentName
            parentName = parentName.replace("`", "").replace("+", "")

            # Remove ` in file_path.stem
            # and + in file_path.stem
            if thisType == "":
                print("Error: Empty type name")
                continue

            folderName = "generated/" + parentName
            filename = folderName + ".typemodel.yml"
            s = set()
            for elem in root.findall(".//Members/Member"):
                name = elem.attrib["MemberName"]
                if name == ".ctor":
                    continue

                staticMarker = ""
                if isStatic(elem):
                    staticMarker = "!"

                startSelectorMarker = ""
                endSelectorMarker = ""
                if isField(elem):
                    startSelectorMarker = "Member"
                    endSelectorMarker = ""
                if isProperty(elem):
                    startSelectorMarker = "Member"
                    endSelectorMarker = ""
                if isMethod(elem):
                    startSelectorMarker = "Method"
                    endSelectorMarker = ".ReturnValue"

                if isEvent(elem):
                    continue  # What are these?
                if isAttachedProperty(elem):
                    continue  # What are these?
                if isAttachedEvent(elem):
                    continue  # What are these?
                if isConstructor(elem):
                    continue  # No need to model the type information for constructors
                if startSelectorMarker == "":
                    print(f"Error: Unknown type for {thisType}.{name}")
                    continue

                if elem.find(".//ReturnValue/ReturnType") is None:
                    print(f"Error: {name} has no return type!")
                    continue

                returnType = elem.find(".//ReturnValue/ReturnType").text
                if returnType == "System.Void":
                    continue  # Don't generate type summaries for void methods

                s.add(
                    f'    - ["{fixup(returnType.lower())}", "{fixup(thisType.lower()) + staticMarker}", "{startSelectorMarker}[{skipQualifier(fixup(name.lower()))}]{endSelectorMarker}"]\n'
                )

            summaries[filename].update(s)

        except ET.ParseError as e:
            print(f"Error parsing XML: {e}")
        except Exception as e:
            print(f"An error occurred: {repr(e)}")


def writeModels():
    """Writes the type models to disk."""
    for filename, s in summaries.items():
        if len(s) == 0:
            continue
        os.makedirs(os.path.dirname(filename), exist_ok=True)
        with open(filename, "w") as file:
            file.write("# THIS FILE IS AN AUTO-GENERATED MODELS AS DATA FILE. DO NOT EDIT.\n")
            file.write("extensions:\n")
            file.write("  - addsTo:\n")
            file.write("      pack: microsoft/powershell-all\n")
            file.write("      extensible: typeModel\n")
            file.write("    data:\n")
            for summary in s:
                for x in summary:
                    file.write(x)


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python parse_xml.py <xml_file1> <xml_file2> ... <xml_fileN>")
        sys.exit(1)

    for arg in sys.argv[1:]:
        print(f"Processing {arg}...")
        generateTypeModels(arg)

    print("Writing models...")
    writeModels()
