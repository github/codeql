#
# This is a port of com.semmle.extractor.projectstructure.ProjectLayoutTests
# and must be kept in sync
#

from semmle.projectlayout import ProjectLayout
import unittest

PROJECT_LAYOUT = ProjectLayout(u"""
@Example

/this/path/will/remain
-this/path/will/not
/and/look//this/path/is/ok

#Source
/src//
-/src/tests

#Tests
/src/tests//

#Generated
/gen
/gen2//gen

#Misc
misc//
othermisc
//thirdmisc

#ExecutionOrder
ex/order
-ex/order/tests/a
ex/order/tests
/src/tests//testA.c
#Patterns
**/*.included
**/inc
-**/exc
my
-my/excluded/**/files
my/**//files/**/a
//**/weird""".split('\n'))

MINIMAL_LAYOUT = ProjectLayout(u"""
/included/path
- excluded/path""".split('\n'))

CS_LAYOUT = ProjectLayout(u"""
#Production code
/
-**/src.test

#Testing code
**/src.test""".split('\n'))

def map(path):
    return PROJECT_LAYOUT.artificial_path(path)

class ProjectLayoutTests(unittest.TestCase):
    def test_advanced_patterns(self):
        self.assertEqual(u"/Patterns/firstPattern.included", map(u"/firstPattern.included"))
        self.assertEqual(u"/Patterns/P1/P2/a.included", map(u"/P1/P2/a.included"))
        self.assertEqual(u"/Patterns/P3/P4/inc", map(u"/P3/P4/inc"))
        self.assertEqual(u"/Patterns/P4/P5/inc/a.c", map(u"/P4/P5/inc/a.c"))
        assert map(u"/P3/P4/inc/exc") is None
        assert map(u"/P3/P4/inc/exc/a/b.c") is None
        self.assertEqual(u"/Patterns/my/code", map(u"/my/code"))
        assert map("u/my/excluded/but/very/interesting/files/a.c") is None
        self.assertEqual(u"/Patterns/files/a/b.c", map(u"/my/excluded/but/very/interesting/files/a/b.c"))
        self.assertEqual(u"/Patterns/P5/P6/weird", map(u"/P5/P6/weird"))

    def test_non_virtual_path(self):
        self.assertEqual(u"/this/path/will/remain/the-same.c", map(u"/this/path/will/remain/the-same.c"))
        assert map(u"/this/path/will/not/be/included.c") is None
        self.assertEqual(u"/this/path/is/ok/to-use.c", map(u"/and/look/this/path/is/ok/to-use.c"))

    def test_ignore_unmentioned_paths(self):
        assert map(u"/lib/foo.c") is None

    def test_do_not_match_partial_names(self):
        assert map(u"/gen2/foo.c") is None
        assert map(u"/src2/foo.c") is None

    def test_simple_mapping(self):
        self.assertEqual(u"/Source/foo.c", map(u"/src/foo.c"))

    def test_match_in_sequence(self):
        self.assertEqual(u"/ExecutionOrder/ex/order/tests/a", map("/ex/order/tests/a"))
        self.assertEqual(u"/Tests/testA.c", map(u"/src/tests/testA.c"))

    def test_excluded_and_included(self):
        self.assertEqual(u"/Tests/test.c", map("/src/tests/test.c"))

    def test_without_double_slashes(self):
        self.assertEqual(u"/Generated/gen/gen.c", map("/gen/gen.c"))

    def test_middle_double_slash(self):
        self.assertEqual(u"/Generated/gen/gen.c", map("/gen2/gen/gen.c"))

    def test_initial_double_slash(self):
        self.assertEqual(u"/Misc/thirdmisc/misc.c", map("/thirdmisc/misc.c"))

    def test_map_directories(self):
        self.assertEqual(u"/Generated/gen", map("/gen"))
        self.assertEqual(u"/Generated/gen/", map("/gen/"))
        self.assertEqual(u"/Source", map("/src"))
        self.assertEqual(u"/Misc/thirdmisc", map("/thirdmisc"))

    def test_missing_initial_slash(self):
        self.assertEqual(u"/Misc", map("/misc"))
        self.assertEqual(u"/Misc/othermisc", map("/othermisc"))

    def test_minimal_layout(self):
        self.assertEqual(u"/included/path/foo.c", MINIMAL_LAYOUT.artificial_path("/included/path/foo.c"))
        assert MINIMAL_LAYOUT.artificial_path(u"/excluded/path/name") is None

    def test_project_names(self):
        self.assertEqual(u"Example", PROJECT_LAYOUT.project_name())
        self.assertEqual(u"Example", PROJECT_LAYOUT.project_name("Something else"))
        self.assertRaises(Exception, lambda: MINIMAL_LAYOUT.project_name())
        self.assertEqual(u"My project", MINIMAL_LAYOUT.project_name("My project"))

    def test_cs(self):
        self.assertEqual(u"/Production code", CS_LAYOUT.artificial_path(u""))
        self.assertEqual(u"/Production code/", CS_LAYOUT.artificial_path(u"/"));
        self.assertEqual(u"/Production code/AppAuth/ear/App/src", CS_LAYOUT.artificial_path(u"/AppAuth/ear/App/src"));
        self.assertEqual(u"/Testing code/BUILD/bun/BUILD/src.test", CS_LAYOUT.artificial_path(u"/BUILD/bun/BUILD/src.test"));


if __name__ == "__main__":
    unittest.main()
