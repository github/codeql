import csv
import sys
import packages


class Framework:
    """
    Frameworks are the aggregation units in the RST and timeseries report. These are read from the frameworks.csv file.
    """

    def __init__(self, name, url, package_pattern):
        self.name = name
        self.url = url
        self.package_pattern = package_pattern


class FrameworkCollection:
    """
    A (sorted) list of frameworks.
    """

    def __init__(self, path):
        self.frameworks: list[Framework] = []
        self.package_patterns = set()

        with open(path) as csvfile:
            reader = csv.reader(csvfile)
            next(reader)
            for row in reader:
                # row: Hibernate,https://hibernate.org/,org.hibernate
                self.__add(Framework(row[0], row[1], row[2]))
        self.__sort()

    def __add(self, framework: Framework):
        if framework.package_pattern not in self.package_patterns:
            self.package_patterns.add(framework.package_pattern)
            self.frameworks.append(framework)
        else:
            print("Package pattern already exists: " +
                  framework.package_pattern, file=sys.stderr)

    def __sort(self):
        self.frameworks.sort(key=lambda f: f.name)

    def get(self, framework_name):
        for framework in self.frameworks:
            if framework.name == framework_name:
                return framework
        return None

    def get_frameworks(self):
        return self.frameworks

    def __package_match_single(self, package: packages.Package, pattern):
        return (pattern.endswith("*") and package.name.startswith(pattern[:-1])) or (not pattern.endswith("*") and pattern == package.name)

    def __package_match(self, package: packages.Package, pattern):
        patterns = pattern.split(" ")
        return any(self.__package_match_single(package, pattern) for pattern in patterns)

    def get_package_filter(self, framework: Framework):
        """
        Returns a lambda filter that holds for packages that match the current framework.

        The pattern is either full name, such as "org.hibernate", or a prefix, such as "java.*".
        Patterns can also contain a space separated list of patterns, such as "java.sql javax.swing".

        Package patterns might overlap, in case of 'org.apache.commons.io' and 'org.apache.*', the statistics for
        the latter will not include the statistics for the former.
        """
        return lambda p: \
            self.__package_match(p, framework.package_pattern) and \
            all(
                len(framework.package_pattern) >= len(pattern) or
                not self.__package_match(p, pattern) for pattern in self.package_patterns)
