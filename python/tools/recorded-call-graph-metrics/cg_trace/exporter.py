import csv
import dataclasses

from lxml import etree


class Exporter:
    @staticmethod
    def export(recorded_calls, outfile_path):
        raise NotImplementedError()

    @staticmethod
    def dataclass_to_dict(obj):
        d = dataclasses.asdict(obj)
        prefix = obj.__class__.__name__.lower()
        return {f"{prefix}_{key}": val for (key, val) in d.items()}


class CSVExporter(Exporter):
    @staticmethod
    def export(recorded_calls, outfile_path):
        with open(outfile_path, "w", newline="") as csv_file:
            writer = None
            for (call, callee) in sorted(recorded_calls):
                data = {
                    **Exporter.dataclass_to_dict(call),
                    **Exporter.dataclass_to_dict(callee),
                }

                if writer is None:
                    writer = csv.DictWriter(csv_file, fieldnames=data.keys())
                    writer.writeheader()

                writer.writerow(data)

        print(f"output written to {outfile_path}")


class XMLExporter(Exporter):
    @staticmethod
    def export(recorded_calls, outfile_path):

        root = etree.Element("root")

        for (call, callee) in sorted(recorded_calls):
            data = {
                **Exporter.dataclass_to_dict(call),
                **Exporter.dataclass_to_dict(callee),
            }

            rc = etree.SubElement(root, "recorded_call")
            for k, v in data.items():
                # xml library only supports serializing attributes that have string values
                rc.set(k, str(v))

        tree = etree.ElementTree(root)
        tree.write(outfile_path, encoding="utf-8", pretty_print=True)
