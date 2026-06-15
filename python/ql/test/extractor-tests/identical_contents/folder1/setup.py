#Contents don't matter but must be the same for both files.

class ExtractorTest(unittest.TestCase):
    
    def __init__(self, name):
        unittest.TestCase.__init__(self, name)
        self.here = os.path.dirname(__file__)
        self.module_path = os.path.abspath(os.path.join(self.here, "data"))
        self.trap_path = os.path.abspath(os.path.join(self.here, "traps"))

    def setUp(self):
        try:
            os.makedirs(self.trap_path)
        except:
            if os.path.exists(self.trap_path):
                return
            raise

    def tearDown(self):
        shutil.rmtree(self.trap_path, ignore_errors=True)

    def check_exists_only_and_clear(self, *module_names):
        for name in module_names:
            path = os.path.join(self.trap_path, name.replace('.', os.sep) + ".trap.gz")
            self.assertTrue(os.path.exists(path), "No trap file for " + name + " at " + path)
            os.remove(path)
        for _, _, filenames in os.walk(self.trap_path):
            filenames = [ name for name in filenames if not name.startswith("$") and name != "__builtin__.trap.gz"]
            self.assertFalse(filenames, "Some trap files remain: " + ", ".join(filenames))
            
    def run_extractor(self, *args):
        argv = sys.argv
        sys.argv = [ "python_extractor" ] + ["-p", self.module_path, "-o", self.trap_path, "--omit-hash"] + list(args)
        semmle.populator.main()
        sys.argv = sys
