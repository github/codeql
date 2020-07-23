import dataclasses
from typing import Dict

from lxml import etree


def dataclass_to_xml(obj, parent):
    obj_elem = etree.SubElement(parent, obj.__class__.__name__)
    for field in dataclasses.fields(obj):
        field_elem = etree.SubElement(obj_elem, field.name)
        value = getattr(obj, field.name)
        if isinstance(value, (str, int)) or value is None:
            field_elem.text = str(value)
        elif isinstance(value, list):
            for list_elem in value:
                assert dataclasses.is_dataclass(list_elem)
                dataclass_to_xml(list_elem, field_elem)
        elif dataclasses.is_dataclass(value):
            dataclass_to_xml(value, field_elem)
        else:
            raise ValueError(
                f"Can't export key {field.name!r} with value {value!r} (type {type(value)}"
            )


class XMLExporter:
    @staticmethod
    def export(outfile_path, recorded_calls, info: Dict[str, str]):

        root = etree.Element("root")

        info_elem = etree.SubElement(root, "info")
        for k, v in info.items():
            etree.SubElement(info_elem, k).text = v

        rcs = etree.SubElement(root, "recorded_calls")

        for (call, callee) in sorted(recorded_calls):
            rc = etree.SubElement(rcs, "recorded_call")
            dataclass_to_xml(call, rc)
            dataclass_to_xml(callee, rc)

        tree = etree.ElementTree(root)
        tree.write(outfile_path, encoding="utf-8", pretty_print=True)

        print(f"Wrote {len(recorded_calls)} recorded calls to {outfile_path}")
