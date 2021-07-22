import csv


class PackagePart:
    """
    Represents a single package part with its count returned from the QL query, such as:
    "android.util",1,"remote","source",16
    """

    def __init__(self, package, kind, part, count):
        self.package = package
        # "summary", "sink", or "source"
        self.part = part
        # "source:remote", "sink:create-file", ...
        self.kind = part + ":" + kind
        self.count = int(count)


class Package:
    """
    Represents an entire package with multiple parts returned from the QL query.
    """

    def __init__(self, name, package_count):
        self.parts: list[PackagePart] = []

        self.name = name
        self.package_count = int(package_count)

    def add_part(self, part: PackagePart):
        self.parts.append(part)

    def get_part_count(self, p):
        count = 0
        for part in self.parts:
            if part.part == p:
                count += part.count
        return count

    def get_kind_count(self, k):
        count = 0
        for part in self.parts:
            if part.kind == k:
                count += part.count
        return count


class PackageCollection:
    """
    A (sorted) list of packages. Packages are returned by the QL query in the form:
    "android.util",1,"remote","source",16

    And then the denormalized rows are aggregated by packages.
    """

    def __init__(self, ql_output_path):
        self.packages: list[Package] = []
        self.package_names = set()

        # Read the generated CSV file, and collect package statistics.
        with open(ql_output_path) as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                # row: "android.util",1,"remote","source",16

                package = self.__get_or_create_package(row[0], row[1])

                packagePart = PackagePart(
                    package, row[2], row[3], row[4])

                package.add_part(packagePart)
        self.__sort()

    def __sort(self):
        self.packages.sort(key=lambda f: f.name)

    def get_packages(self):
        return self.packages

    def __get_or_create_package(self, package_name, package_count):
        if package_name not in self.package_names:
            self.package_names.add(package_name)
            package = Package(package_name, package_count)
            self.packages.append(package)
            return package
        else:
            for package in self.packages:
                if package.name == package_name:
                    return package
            return None

    def get_parts(self):
        parts = set()
        for package in self.packages:
            for part in package.parts:
                parts.add(part.part)
        return sorted(parts)

    def get_kinds(self):
        kinds = set()
        for package in self.packages:
            for part in package.parts:
                kinds.add(part.kind)
        return sorted(kinds)

    def get_part_count(self, p):
        count = 0
        for package in self.packages:
            count += package.get_part_count(p)
        return count
