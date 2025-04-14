import sys, os
from collections import deque, defaultdict
import time
import multiprocessing as mp
import json

from queue import Empty as _Empty
from queue import Full as _Full

from semmle.extractors import SuperExtractor, ModulePrinter, SkippedBuiltin
from semmle.profiling import get_profiler
from semmle.path_rename import renamer_from_options_and_env
from semmle.logging import WARN, recursion_error_message, internal_error_message, Logger

class ExtractorFailure(Exception):
    'Generic exception representing the failure of an extractor.'
    pass


class ModuleImportGraph(object):

    def __init__(self, max_depth):
        self.modules = {}
        self.succ = defaultdict(set)
        self.todo = set()
        self.done = set()
        self.max_depth = max_depth

    def add_root(self, mod):
        self.modules[mod] = 0
        if mod not in self.done:
            self.todo.add(mod)

    def add_import(self, mod, imported):
        assert mod in self.modules
        self.succ[mod].add(imported)
        if imported in self.modules:
            if self.modules[imported] > self.modules[mod] + 1:
                self._reduce_depth(imported, self.modules[mod] + 1)
        else:
            if self.modules[mod] < self.max_depth and imported not in self.done:
                self.todo.add(imported)
            self.modules[imported] = self.modules[mod] + 1

    def _reduce_depth(self, mod, depth):
        if self.modules[mod] <= depth:
            return
        if depth > self.max_depth:
            return
        if mod not in self.done:
            self.todo.add(mod)
        self.modules[mod] = depth
        for imp in self.succ[mod]:
            self._reduce_depth(imp, depth+1)

    def get(self):
        mod = self.todo.pop()
        assert not mod in self.done and self.modules[mod] <= self.max_depth
        self.done.add(mod)
        return mod

    def push_back(self, mod):
        self.done.remove(mod)
        self.todo.add(mod)

    def empty(self):
        return not self.todo

class ExtractorPool(object):
    '''Pool of worker processes running extractors'''

    def __init__(self, outdir, archive, proc_count, options, logger: Logger):
        if proc_count < 1:
            raise ValueError("Number of processes must be at least one.")
        self.verbose = options.verbose
        self.outdir = outdir
        self.max_import_depth = options.max_import_depth
        # macOS does not support `fork` properly, so we must use `spawn` instead.
        method = 'spawn' if sys.platform == "darwin" else None
        try:
            ctx = mp.get_context(method)
        except AttributeError:
            # `get_context` doesn't exist -- we must be running an old version of Python.
            ctx = mp
        #Keep queue short to minimise delay when stopping
        self.module_queue = ctx.Queue(proc_count*2)
        self.reply_queue = ctx.Queue(proc_count*20)
        self.archive = archive
        self.local_queue = deque()
        self.enqueued = set()
        self.done = set()
        self.requirements = {}
        self.import_graph = ModuleImportGraph(options.max_import_depth)
        logger.debug("Source archive: %s", archive)
        self.logger = logger
        DiagnosticsWriter.create_output_dir()
        args = (self.module_queue, outdir, archive, options, self.reply_queue, logger)
        self.procs = [
            ctx.Process(target=_extract_loop, args=(n+1,) + args + (n == 0,)) for n in range(proc_count)
        ]
        for p in self.procs:
            p.start()
        self.start_time = time.time()

    def extract(self, the_traverser):
        '''Extract all the files from the given traverser,
        and all the imported files up to the depth specified
        by the options.
        '''
        self.logger.trace("Starting traversal")
        for mod in the_traverser:
            self.import_graph.add_root(mod)
            self.try_to_send()
            self.receive(False)
        #Prime the queue
        while self.try_to_send():
            pass
        while self.enqueued or not self.import_graph.empty():
            self.try_to_send()
            self.receive(True)

    def try_to_send(self):
        if self.import_graph.empty():
            return False
        module = self.import_graph.get()
        try:
            self.module_queue.put(module, False)
            self.enqueued.add(module)
            self.logger.debug("Enqueued %s", module)
            return True
        except _Full:
            self.import_graph.push_back(module)
            return False

    def receive(self, block=False):
        try:
            what, mod, imp = self.reply_queue.get(block)
            if what == "INTERRUPT":
                self.logger.debug("Main process received interrupt")
                raise KeyboardInterrupt
            elif what == "UNRECOVERABLE_FAILURE":
                raise ExtractorFailure(str(mod))
            elif what == "FAILURE":
                self.enqueued.remove(mod)
            elif what == "SUCCESS":
                self.enqueued.remove(mod)
            else:
                assert what == "IMPORT"
                assert mod is not None
                if imp is None:
                    self.logger.warning("Unexpected None as import.")
                else:
                    self.import_graph.add_import(mod, imp)
        except _Empty:
            #Nothing in reply queue.
            pass

    def close(self):
        self.logger.debug("Closing down workers")
        assert not self.enqueued
        for p in self.procs:
            self.module_queue.put(None)
        for p in self.procs:
            p.join()
        self.logger.info("Processed %d modules in %0.2fs", len(self.import_graph.done), time.time() - self.start_time)

    def stop(self, timeout=2.0):
        '''Stop the worker pool, reasonably promptly and as cleanly as possible.'''
        try:
            _drain_queue(self.module_queue)
            for p in self.procs:
                self.module_queue.put(None)
            _drain_queue(self.reply_queue)
            end = time.time() + timeout
            running = set(self.procs)
            while running and time.time() < end:
                time.sleep(0.1)
                _drain_queue(self.reply_queue)
                running = {p for p in running if p.is_alive()}
            if running:
                for index, proc in enumerate(self.procs, 1):
                    if proc.is_alive():
                        self.logger.error("Process %d timed out", index)
        except Exception as ex:
            self.logger.error("Unexpected error when stopping %s", ex)

    @staticmethod
    def from_options(options, trap_dir, archive, logger: Logger):
        '''Convenience method to create extractor pool from options.'''
        cpus = mp.cpu_count()
        procs = options.max_procs
        if procs == 'all':
            procs = cpus
        elif procs is None or procs == 'half':
            procs = (cpus+1)//2
        else:
            procs = int(procs)
        return ExtractorPool(trap_dir, archive, procs, options, logger)

def _drain_queue(queue):
    try:
        while True:
            queue.get(False)
    except _Empty:
        #Emptied queue as best we can.
        pass

class DiagnosticsWriter(object):
    def __init__(self, proc_id):
        self.proc_id = proc_id

    def write(self, message):
        dir = os.environ.get("CODEQL_EXTRACTOR_PYTHON_DIAGNOSTIC_DIR")
        if dir:
            with open(os.path.join(dir, "worker-%d.jsonl" % self.proc_id), "a") as output_file:
                output_file.write(json.dumps(message.to_dict()) + "\n")

    @staticmethod
    def create_output_dir():
        dir = os.environ.get("CODEQL_EXTRACTOR_PYTHON_DIAGNOSTIC_DIR")
        if dir:
            os.makedirs(os.environ["CODEQL_EXTRACTOR_PYTHON_DIAGNOSTIC_DIR"], exist_ok=True)



# Function run by worker processes
def _extract_loop(proc_id, queue, trap_dir, archive, options, reply_queue, logger: Logger, write_global_data):
    diagnostics_writer = DiagnosticsWriter(proc_id)
    send_time = 0
    recv_time = 0
    extraction_time = 0

    # use utf-8 as the character encoding for stdout/stderr to be able to properly
    # log/print things on systems that use bad default encodings (windows).
    sys.stdout.reconfigure(encoding='utf-8')
    sys.stderr.reconfigure(encoding='utf-8')

    try:
        renamer = renamer_from_options_and_env(options, logger)
    except Exception as ex:
        logger.error("Exception: %s", ex)
        reply_queue.put(("INTERRUPT", None, None))
        sys.exit(2)
    logger.set_process_id(proc_id)
    try:
        if options.trace_only:
            extractor = ModulePrinter(options, trap_dir, archive, renamer, logger)
        else:
            extractor = SuperExtractor(options, trap_dir, archive, renamer, logger, diagnostics_writer)
        profiler = get_profiler(options, id, logger)
        with profiler:
            while True:
                start_recv = time.time()
                unit = queue.get()
                recv_time += time.time() - start_recv
                if unit is None:
                    if write_global_data:
                        extractor.write_global_data()
                    extractor.close()
                    return
                try:
                    start = time.time()
                    imports = extractor.process(unit)
                    end_time = time.time()
                    extraction_time += end_time - start
                    if imports is SkippedBuiltin:
                        logger.info("Skipped built-in %s", unit)
                    else:
                        for imp in imports:
                            reply_queue.put(("IMPORT", unit, imp))
                        send_time += time.time() - end_time
                        logger.info("Extracted %s in %0.0fms", unit, (end_time-start)*1000)
                except SyntaxError as ex:
                    # Syntax errors have already been handled in extractor.py
                    reply_queue.put(("FAILURE", unit, None))
                except RecursionError as ex:
                    logger.error("Failed to extract %s: %s", unit, ex)
                    logger.traceback(WARN)
                    try:
                        error = recursion_error_message(ex, unit)
                        diagnostics_writer.write(error)
                    except Exception as ex:
                        logger.warning("Failed to write diagnostics: %s", ex)
                        logger.traceback(WARN)
                    reply_queue.put(("FAILURE", unit, None))
                except Exception as ex:
                    logger.error("Failed to extract %s: %s", unit, ex)
                    logger.traceback(WARN)
                    try:
                        error = internal_error_message(ex, unit)
                        diagnostics_writer.write(error)
                    except Exception as ex:
                        logger.warning("Failed to write diagnostics: %s", ex)
                        logger.traceback(WARN)
                    reply_queue.put(("FAILURE", unit, None))
                else:
                    reply_queue.put(("SUCCESS", unit, None))
    except KeyboardInterrupt:
        logger.debug("Worker process received interrupt")
        reply_queue.put(("INTERRUPT", None, None))
    except Exception as ex:
        logger.error("Exception: %s", ex)
        reply_queue.put(("INTERRUPT", None, None))
    # Avoid deadlock and speed up termination by clearing queue.
    try:
        while True:
            msg = queue.get(False)
            if msg is None:
                break
    except _Empty:
        #Cleared queue enough to avoid deadlock.
        pass
    sys.exit(2)
