
class SmallSet(list):

    __slots__ = []

    def update(self, other):
        filtered = [x for x in other if x not in self]
        self.extend(filtered)

    def add(self, item):
        if item not in self:
            self.append(item)

class DiGraph(object):
    '''A simple directed graph class (not necessarily a DAG).
    Nodes must be hashable'''

    def __init__(self, name = ""):
        self.name = name
        self.pred = {}
        self.succ = {}
        self.all_nodes = []
        self.node_annotations = {}
        self.edge_annotations = {}

    def add_node(self, n):
        'Add a node to the graph'
        if n not in self.succ:
            self.pred[n] = SmallSet()
            self.succ[n] = SmallSet()
            self.all_nodes.append(n)

    def add_edge(self, x, y):
        '''Add an edge (x -> y) to the graph. Return true if x, y was
        previously in graph'''
        if x in self.succ:
            if y in self.succ[x]:
                return True
        else:
            self.add_node(x)
        self.add_node(y)
        self.pred[y].add(x)
        self.succ[x].add(y)
        return False

    def remove_node(self, x):
        if x not in self.succ:
            raise ValueError("Node %s does not exist." % x)
        preds = self.pred[x]
        succs = self.succ[x]
        for p in preds:
            self.succ[p].remove(x)
        for s in succs:
            self.pred[s].remove(x)
        del self.succ[x]
        del self.pred[x]

    def remove_edge(self, x, y):
        self.pred[y].remove(x)
        self.succ[x].remove(y)

    def annotate_edge(self, x, y, note):
        '''Set the annotation on the edge (x -> y) to note.
        '''
        if x not in self.succ or y not in self.succ[x]:
            raise ValueError("Edge %s -> %s does not exist." % (x, y))
        self.edge_annotations[(x,y)] = note

    def annotate_node(self, x, note):
        '''Set the annotation on the node x to note.
        '''
        if x not in self.succ:
            raise ValueError("Node %s does not exist." % x)
        self.node_annotations[x] = note

    def nodes(self):
        '''Return an iterator for all nodes, in the form (node, note) pairs.
           Do not modify the graph while using this iterator'''
        for node in self.all_nodes:
            yield node, self.node_annotations.get(node)

    def edges(self):
        '''Return an iterator for all edges, in the form of (pred, succ, note) triple.
           Do not modify the graph while using this iterator'''
        index = dict((n, i) for i, n in enumerate(self.all_nodes))
        for n in self.all_nodes:
            n_succs = self.succ[n]
            for succ in sorted(n_succs, key = lambda n : index[n]):
                yield n, succ, self.edge_annotations.get((n,succ))

    def sources(self):
        '''Return an iterator for all nodes with no predecessors.
           Do not modify the graph while using this iterator'''
        for n, p in self.pred.items():
            if not p:
                yield n

    def __contains__(self, node):
        return node in self.succ


class FlowGraph(DiGraph):
    '''A DiGraph that supports the concept of definitions and variables.
    Used to compute dominance and SSA form.
    For more explanation of the algorithms used see
    'Modern Compiler Implementation by Andrew W. Appel.
    '''

    def __init__(self, root, name = ""):
        DiGraph.__init__(self, name)
        self.definitions = {}
        self.deletions = {}
        self.uses = {}
        self.use_all_nodes = set()
        self.root = root

    def clear_computed(self):
        to_be_deleted = [attr for attr in self.__dict__ if attr[0] == '_']
        for attr in to_be_deleted:
            delattr(self, attr)

    def _require(self, what):
        '''Ensures that 'what' has been computed (computing if needed).'''
        if hasattr(self, "_" + what):
            return
        setattr(self, "_" + what, getattr(self, "_compute_" + what)())

    def add_deletion(self, node, var):
        assert node in self.succ
        self.deletions[node] = var

    def add_definition(self, node, var):
        assert node in self.succ
        self.definitions[node] = var

    def add_use(self, node, var):
        assert node in self.succ, node
        self.uses[node] = var

    def use_all_defined_variables(self, node):
        assert node in self.succ
        self.use_all_nodes.add(node)

    def _compute_depth_first_pre_order(self):
        self._require("depth_first_pre_order_labels")
        reachable = [ f for f in self.all_nodes if f in self._depth_first_pre_order_labels ]
        return sorted(reachable, key = lambda f : -self._depth_first_pre_order_labels[f])

    def _compute_reachable(self):
        self._require("depth_first_pre_order")
        return frozenset(self._depth_first_pre_order)

    def reachable_nodes(self):
        self._require("reachable")
        return self._reachable

    def _compute_reversed_depth_first_pre_order(self):
        self._require("depth_first_pre_order")
        return reversed(self._depth_first_pre_order)

    def _compute_bb_depth_first_pre_order(self):
        self._require('depth_first_pre_order')
        self._require('bb_heads')
        bbs = []
        for n in self._depth_first_pre_order:
            if n in self._bb_heads:
                bbs.append(n)
        return bbs

    def _compute_bb_reversed_depth_first_pre_order(self):
        self._require("bb_depth_first_pre_order")
        return reversed(self._bb_depth_first_pre_order)

    def _compute_depth_first_pre_order_labels(self):
        'Compute order with depth first search.'
        orders = {}
        order = 0
        nodes_to_visit = [ self.root ]
        while nodes_to_visit:
            node = nodes_to_visit[-1]
            orders[node] = 0
            if node in self.succ:
                for succ in self.succ[node]:
                    if succ not in orders:
                        nodes_to_visit.append(succ)
                    else:
                        order += 1
                        orders[node] = order
            if node is nodes_to_visit[-1]:
                nodes_to_visit.pop()
                order += 1
                orders[node] = order
        return orders

    def _compute_idoms(self):
        self._require("depth_first_pre_order")
        idoms = {}

        def idom_intersection(n1, n2):
            'Determine the last common idom of n1, n2'
            orders = self._depth_first_pre_order_labels
            while n1 is not n2:
                while orders[n1] < orders[n2]:
                    n1 = idoms[n1]
                while orders[n2] < orders[n1]:
                    n2 = idoms[n2]
            return n1

        for node in self._depth_first_pre_order:
            if len(self.pred[node]) == 1:
                idoms[node] = next(iter(self.pred[node]))
            else:
                idom = None
                for p in self.pred[node]:
                    if p == self.root:
                        idom = p
                    elif p in idoms:
                        if idom is None:
                            idom = p
                        else:
                            idom = idom_intersection(idom, p)
                if idom is not None:
                    idoms[node] = idom
        return idoms

    def idoms(self):
        '''Returns an iterable of node pairs: node, idom(node)'''
        self._require('idoms')
        idoms = self._idoms
        for n in self.all_nodes:
            if n in idoms:
                yield n, idoms[n]


    def _compute_dominance_frontier(self):
        '''Compute the dominance frontier:
        DF[n] = DF_local[n] Union over C in children DF_up[c]'''

        def dominates(dom, node):
            while node in idoms:
                next_node = idoms[node]
                if dom == next_node:
                    return True
                node = next_node
            return False

        self._require('idoms')
        idoms = self._idoms
        dominance_frontier = {}
        df_up = {}
        dom_tree = _reverse_map(idoms)
        self._require('reversed_depth_first_pre_order')
        for node in self._reversed_depth_first_pre_order:
            df_local_n = set(n for n in self.succ[node] if node != idoms[n])
            dfn = df_local_n
            if node in dom_tree:
                for child in dom_tree[node]:
                    dfn.update(df_up[child])
            dominance_frontier[node] = dfn
            if node in idoms:
                imm_dom = idoms[node]
                df_up[node] = set(n for n in dfn if not dominates(imm_dom, n))
            else:
                df_up[node] = dfn
        return dominance_frontier

    def _compute_phi_nodes(self):
        '''Compute the phi nodes for this graph.
        A minimal set of phi-nodes are computed;
        No phi-nodes are added unless the variable is live.
        '''
        self._require('dominance_frontier')
        self._require('liveness')
        dominance_frontier = self._dominance_frontier
        definitions = dict(self.definitions)
        # We must count deletions as definitions here. Otherwise, we can have
        # uses of a deleted variable whose SSA definition is an actual definition,
        # rather than a deletion.
        definitions.update(self.deletions)
        phi_nodes = {}
        defsites = {}
        for a in definitions.values():
            defsites[a] = set()
        for n in definitions:
            a = definitions[n]
            defsites[a].add(n)
        for a in defsites:
            W = set(defsites[a])
            while W:
                n = W.pop()
                if n not in dominance_frontier:
                    continue
                for y in dominance_frontier[n]:
                    if y not in phi_nodes:
                        phi_nodes[y] = set()
                    if a not in phi_nodes[y]:
                        phi_nodes[y].add(a)
                        if y not in definitions or a != definitions[y]:
                            W.add(y)
        trimmed = {}
        for node in phi_nodes:
            assert node in self._bb_heads
            if node not in self._liveness:
                continue
            new_phi_vars = set()
            phi_vars = phi_nodes[node]
            for v in phi_vars:
                if v in self._liveness[node]:
                    new_phi_vars.add(v)
            if new_phi_vars:
                trimmed[node] = new_phi_vars
        return trimmed

    def _compute_ssa_data(self):
        ''' Compute the SSA variables, definitions, uses and phi-inputs.
        '''
        self._require('basic_blocks')
        self._require('phi_nodes')
        self._require('bb_depth_first_pre_order')
        self._require('use_all')
        phi_nodes = self._phi_nodes
        reaching_ssa_vars = {}
        work_set = set()
        work_set.add(self.root)
        ssa_defns = {}
        ssa_uses = {}
        ssa_phis = {}
        ssa_vars = set()
        ssa_var_cache = {}

        def make_ssa_var(variable, node):
            '''Ensure that there is no more than one SSA variable for each (variable, node) pair.'''
            uid = (variable, node)
            if uid in ssa_var_cache:
                return ssa_var_cache[uid]
            var = SSA_Var(variable, node)
            ssa_var_cache[uid] = var
            return var

        for bb in self._bb_depth_first_pre_order:
            #Track SSA variables in each BB.
            reaching_ssa_vars[bb] = {}
        for bb in self._bb_depth_first_pre_order:
            live_vars = reaching_ssa_vars[bb].copy()
            #Add an SSA definition for each phi-node.
            if bb in phi_nodes:
                variables = phi_nodes[bb]
                for v in variables:
                    var = make_ssa_var(v, bb)
                    ssa_defns[var] = bb
                    live_vars[v] = var
            for node in self.nodes_in_bb(bb):
                #Add an SSA use for each use.
                if node in self.uses:
                    a = self.uses[node]
                    if a not in live_vars:
                        #Treat a use as adding a reaching variable,
                        #since a second use, if it can be reached,
                        #will always find the variable defined.
                        var = make_ssa_var(a, node)
                        live_vars[a] = var
                    else:
                        var = live_vars[a]
                    ssa_vars.add(var)
                    ssa_uses[node] = [ var ]
                #Add an SSA use for all live SSA variables for
                #each use_all (end of module/class scope).
                if node in self._use_all:
                    all_live = [ var for var in live_vars.values() if var.variable in self._use_all[node]]
                    ssa_uses[node] = all_live
                    ssa_vars.update(all_live)
                #Add an SSA definition for each definition.
                if node in self.definitions:
                    a = self.definitions[node]
                    var = make_ssa_var(a, node)
                    ssa_defns[var] = node
                    live_vars[a] = var
                #Although deletions are not definitions, we treat them as such.
                #SSA form has no concept of deletion, so we have to treat `del x`
                #as `x = Undefined`.
                if node in self.deletions:
                    a = self.deletions[node]
                    if a in live_vars:
                        var = live_vars[a]
                        ssa_vars.add(var)
                        ssa_uses[node] = [ var ]
                    else:
                        #If no var is defined here we don't need to create one
                        #as a new one will be immediately be defined by the deletion.
                        pass
                    var = make_ssa_var(a, node)
                    ssa_defns[var] = node
                    live_vars[a] = var
            #Propagate set of reaching variables to
            #successor blocks.
            for n in self.succ[node]:
                reaching_ssa_vars[n].update(live_vars)
                if n in phi_nodes:
                    for v in phi_nodes[n]:
                        if v in live_vars:
                            var = make_ssa_var(v, n)
                            if var not in ssa_phis:
                                ssa_phis[var] = set()
                            ssa_vars.add(live_vars[v])
                            ssa_phis[var].add(live_vars[v])
        #Prune unused definitions.
        used_ssa_defns = {}
        for var in ssa_defns:
            if var in ssa_vars:
                used_ssa_defns[var] = ssa_defns[var]
        ssa_defns = used_ssa_defns
        sorted_vars = list(self._sort_ssa_variables(ssa_vars))
        assert set(sorted_vars) == ssa_vars
        assert len(sorted_vars) == len(ssa_vars)
        ssa_vars = sorted_vars
        return ssa_vars, ssa_defns, ssa_uses, ssa_phis


    def ssa_variables(self):
        '''Returns all the SSA variables for this graph'''
        self._require('ssa_data')
        return self._ssa_data[0]

    def _sort_ssa_variables(self, ssa_vars):
        node_to_var = {}
        for v in ssa_vars:
            node = v.node
            if node in node_to_var:
                vset = node_to_var[node]
            else:
                vset = set()
                node_to_var[node] = vset
            vset.add(v)
        for n in self.all_nodes:
            if n in node_to_var:
                variables = node_to_var[n]
                for v in sorted(variables, key=lambda v:v.variable.id):
                    yield v

    def ssa_definitions(self):
        '''Returns all the SSA definition as an iterator of (node, variable) pairs.'''
        self._require('ssa_data')
        ssa_defns = self._ssa_data[1]
        reversed_defns = _reverse_map(ssa_defns)
        for n in self.all_nodes:
            if n in reversed_defns:
                variables = reversed_defns[n]
                for v in sorted(variables, key=lambda v:v.variable.id):
                    yield n, v

    def get_ssa_definition(self, var):
        '''Returns the definition node of var. Returns None if there is no definition.'''
        self._require('ssa_data')
        ssa_defns = self._ssa_data[1]
        return ssa_defns.get(var)

    def ssa_uses(self):
        '''Returns all the SSA uses as an iterator of (node, variable) pairs.'''
        self._require('ssa_data')
        ssa_uses = self._ssa_data[2]
        for n in self.all_nodes:
            if n in ssa_uses:
                variables = ssa_uses[n]
                for v in sorted(variables, key=lambda v:v.variable.id):
                    yield n, v

    def get_ssa_variables_used(self, node):
        '''Returns all the SSA variables used at this node'''
        self._require('ssa_data')
        ssa_uses = self._ssa_data[2]
        return ssa_uses.get(node, ())

    def ssa_phis(self):
        '''Return all SSA phi inputs as an iterator of (variable, input-variable) pairs.'''
        self._require('ssa_data')
        ssa_phis = self._ssa_data[3]
        ssa_vars = self._ssa_data[0]
        indexed = dict((v, index) for index, v in enumerate(ssa_vars))
        for v in ssa_vars:
            if v not in ssa_phis:
                continue
            phis = ssa_phis[v]
            for phi in sorted(phis, key=lambda v:indexed[v]):
                yield v, phi

    def _compute_bb_heads(self):
        '''Compute all flow nodes that are the first node in a basic block.'''
        bb_heads = set()
        for node in self.all_nodes:
            preds = self.pred[node]
            if len(preds) != 1 or len(self.succ[preds[0]]) != 1:
                bb_heads.add(node)
        return bb_heads

    def _compute_basic_blocks(self):
        '''Compute Basic blocks membership'''
        self._require('bb_heads')
        basic_blocks = {}
        bb_tails = {}
        for bb in self._bb_heads:
            for index, node in enumerate(self.nodes_in_bb(bb)):
                basic_blocks[node] = bb, index
            bb_tails[bb] = node
        self._bb_tails = bb_tails
        return basic_blocks

    def get_basic_blocks(self):
        self._require('basic_blocks')
        return self._basic_blocks

    def _compute_bb_succ(self):
        self._require('basic_blocks')
        bb_succs = {}
        for bb in self._bb_heads:
            bb_succs[bb] = self.succ[self._bb_tails[bb]]
        return bb_succs

    def _compute_bb_pred(self):
        self._require('basic_blocks')
        bb_preds = {}
        for bb in self._bb_heads:
            preds_of_bb = self.pred[bb]
            bb_preds[bb] = SmallSet(self._basic_blocks[p][0] for p in preds_of_bb)
        return bb_preds

    def nodes_in_bb(self, bb):
        '''Return an iterator over all node in basic block 'bb.'''
        node = bb
        while True:
            yield node
            succs = self.succ[node]
            if not succs:
                return
            node = succs[0]
            if node in self._bb_heads:
                return


    def _compute_use_all(self):
        '''Compute which variables have been defined.
           A variable is defined at node n, if there is a path to n which
           passes through a definition, but not through a subsequent deletion.
        '''

        self._require('bb_heads')
        self._require('bb_succ')
        self._require('bb_pred')
        use_all = {}

        def defined_in_block(bb):
            defined = defined_at_start[bb].copy()
            for node in self.nodes_in_bb(bb):
                if node in self.definitions:
                    var = self.definitions[node]
                    defined.add(var)
                if node in self.deletions:
                    var = self.deletions[node]
                    defined.discard(var)
                if node in self.use_all_nodes:
                    use_all[node] = frozenset(defined)
            return defined

        defined_at_start = {}
        work_set = set()
        for bb in self._bb_heads:
            if not self._bb_pred[bb]:
                work_set.add(bb)
                defined_at_start[bb] = set()
        work_list = list(work_set)
        while work_list:
            bb = work_list.pop()
            work_set.remove(bb)
            defined_at_bb_end = defined_in_block(bb)
            for succ in self._bb_succ[bb]:
                if succ not in defined_at_start:
                    defined_at_start[succ] = set()
                elif defined_at_start[succ] >= defined_at_bb_end:
                    continue
                defined_at_start[succ].update(defined_at_bb_end)
                if succ not in work_set:
                    work_list.append(succ)
                    work_set.add(succ)
        return use_all

    def _compute_liveness(self):
        '''Compute liveness of all variables in this flow-graph.
        Return a mapping of basic blocks to the set of variables
        that are live at the start of that basic block.
        See http://en.wikipedia.org/wiki/Live_variable_analysis.'''

        self._require('bb_pred')
        self._require('use_all')

        def gen_and_kill_for_block(bb):
            gen = set()
            kill = set()
            for node in reversed(list(self.nodes_in_bb(bb))):
                if node in self.uses:
                    var = self.uses[node]
                    gen.add(var)
                    kill.discard(var)
                if node in self.deletions:
                    var = self.deletions[node]
                    gen.add(var)
                    kill.discard(var)
                if node in self.definitions:
                    var = self.definitions[node]
                    gen.discard(var)
                    kill.add(var)
                if node in self._use_all:
                    for var in self._use_all[node]:
                        gen.add(var)
                        kill.discard(var)
            return gen, kill

        def liveness_for_block(bb, live_out):
            return gens[bb].union(live_out.difference(kills[bb]))

        live_at_end = {}
        live_at_start = {}
        gens = {}
        kills = {}
        work_set = set()
        #Initialise
        for bb in self._bb_heads:
            gens[bb], kills[bb] = gen_and_kill_for_block(bb)
            live_at_end[bb] = set()
            live_at_start[bb] = set()
            work_set.add(bb)
        #Find fixed point
        while work_set:
            bb = work_set.pop()
            live_in = liveness_for_block(bb, live_at_end[bb])
            if live_in != live_at_start[bb]:
                assert len(live_in) > len(live_at_start[bb])
                live_at_start[bb] = live_in
                for pred in self._bb_pred[bb]:
                    work_set.add(pred)
                    live_at_end[pred] = live_at_end[pred].union(live_in)
        return live_at_start


    def delete_unreachable_nodes(self):
        self._require("reachable")
        unreachable = [u for u in self.all_nodes if u not in self._reachable]
        if not unreachable:
            return
        for mapping in (self.definitions, self.deletions, self.uses):
            for u in unreachable:
                if u in mapping:
                    del mapping[u]
        for u in unreachable:
            self.use_all_nodes.discard(u)
            self.remove_node(u)
        #Make sure we retain the order of all_nodes.
        self.all_nodes = [r for r  in self.all_nodes if r in self._reachable]
        self.clear_computed()

    def dominated_by(self, node):
        self._require('idoms')
        assert node in self, str(node) + " is not in graph"
        dominated = set([node])
        todo = set(self.succ[node])
        while todo:
            n = todo.pop()
            if n in dominated:
                continue
            #Unreachable nodes will not be in self._idoms
            if n in self._idoms and self._idoms[n] in dominated:
                dominated.add(n)
                todo.update(self.succ[n])
        return dominated

    def strictly_dominates(self, pre, post):
        self._require('idoms')
        while post in self._idoms:
            post = self._idoms[post]
            if pre == post:
                return True
        return False

    def reaches_while_dominated(self, pre, post, control):
        ''' Holds if `pre` reaches `post` while remaining in the
            region dominated by `control`.'''
        self._require('dominance_frontier')
        dominance_frontier = self._dominance_frontier[control]
        todo = { pre }
        reached = set()
        while todo:
            node = todo.pop()
            if node in dominance_frontier:
                continue
            if node == post:
                return True
            if node in reached:
                continue
            reached.add(node)
            todo.update(self.succ[node])
        return False

    def split(self, splits):
        #We expect the following to be true (we assert it later):
        #top dominates heads for all splits.
        # Key class for (partially) ordering node by inverse dominance
        class DominanceKey(object):
            def __init__(this, node):
                this.node = node
            def __lt__(this, other):
                return self.strictly_dominates(other.node, this.node)
        splits.sort(key=lambda arg: DominanceKey(arg[0]))
        for top, heads in splits:
            self.single_split(top, heads)

    def single_split(self, top, heads):
        '''Splits the flow-graph from the branches. All code that succeeds each head
        becomes unique to that head, limited to those nodes that are strictly dominated by top,
        excluding exit nodes.
        '''
        assert top in self, "top " + str(top) + " is not in graph"
        strictly_dominated_by_top = self.dominated_by(top)
        strictly_dominated_by_top.remove(top)
        for head in heads:
            assert head in self, "head " + str(head) + " is not in graph"
            assert head in strictly_dominated_by_top, str(head) + " is not dominated by " + str(top)

        def successors_within_region(start, region):
            #Find all nodes in region, that are reached from start (without leaving region)
            nodes = set([start])
            todo = set(self.succ[start])
            while todo:
                s = todo.pop()
                if s not in nodes and s in region:
                    nodes.add(s)
                    todo.update(self.succ[s])
            return nodes

        subgraphs = [ (head, successors_within_region(head, strictly_dominated_by_top)) for head in heads ]

        #Copy the two subgraphs
        head_copies = []
        branch_copies = []
        for head, branch in subgraphs:
            head_copy, branch_copy = self._copy_subgraph(head, branch, True)
            head_copies.append(head_copy)
            branch_copies.append(branch_copy)
        #The original will be deleted by `delete_unreachable_nodes()`

        #Make sure we retain the order of all_nodes.
        self.all_nodes = [n for n  in self.all_nodes if n in self.succ]
        #All computed values are now invalid.
        self.clear_computed()
        self.delete_unreachable_nodes()
        return head_copies, branch_copies

    def _copy_subgraph(self, entry, to_copy, remove_links):
        copies = {}
        assert entry in to_copy, repr(entry) + " is not in sub-graph " + str(to_copy)
        for node in to_copy:
            copy = node.copy()
            copies[node] = copy
            self.add_node(copy)
            ann = self.node_annotations.get(node)
            self.annotate_node(copy, ann)
            if node == entry:
                res = copy
            for mapping in (self.definitions, self.deletions, self.uses):
                if node in mapping:
                    mapping[copy] = mapping[node]
            if node in self.use_all_nodes:
                self.use_all_nodes.add(copy)

        for node in to_copy:
            for s in self.succ[node]:
                ann = self.edge_annotations.get((node,s))
                if s in to_copy:
                    self.add_edge(copies[node], copies[s])
                    self.annotate_edge(copies[node], copies[s], ann)
                else:
                    self.add_edge(copies[node], s)
                    self.annotate_edge(copies[node], s, ann)
        if remove_links:
            predecessors_to_remove = set()
            for p in self.pred[entry]:
                ann = self.edge_annotations.get((p, entry))
                if p not in to_copy:
                    self.add_edge(p, copies[entry])
                    self.annotate_edge(p, copies[entry], ann)
                    predecessors_to_remove.add(p)
            for p in predecessors_to_remove:
                self.remove_edge(p, entry)
        return res, set(copies.values())

    def unroll(self, head, bodystart):
        body = self.dominated_by(bodystart)
        entries = [p for p in self.pred[head] if p not in body]
        bodystart2, _ = self._copy_subgraph(bodystart, body, False)
        prehead = head.copy()
        self.add_node(prehead)
        ann = self.node_annotations.get(head)
        self.annotate_node(prehead, ann)
        for s in self.succ[head]:
            if s is not bodystart:
                self.add_edge(prehead, s)
                ann = self.edge_annotations.get((head, s))
                self.annotate_edge(prehead, s, ann)
        self.add_edge(prehead, bodystart2)
        ann = self.edge_annotations.get((head, bodystart))
        self.annotate_edge(prehead, bodystart2, ann)
        for p in entries:
            ann = self.edge_annotations.get((p, head))
            self.remove_edge(p, head)
            self.add_edge(p, prehead)
            self.annotate_edge(p, prehead, ann)
        self.clear_computed()
        self.delete_unreachable_nodes()

class SSA_Var(object):
    'A single static assignment variable'

    __slots__ = [ 'variable', 'node' ]

    def __init__(self, variable, node):
        self.variable = variable
        self.node = node

    def __repr__(self):
        return 'SSA_Var(%r, %r)' % (self.variable.id, self.node)


def _reverse_map(mapping):
    'Reverse a mapping of keys -> values to value->set(keys)'
    inv_map = {}
    for k, v in mapping.items():
        if v not in inv_map:
            inv_map[v] = SmallSet()
        inv_map[v].add(k)
    return inv_map
