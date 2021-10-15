

def original(the_ast):
    def walk(node, in_function, in_name_main):
        def flags():
            return in_function * 2 + in_name_main
        if isinstance(node, ast.Module):
            for import_node in walk(node.body, in_function, in_name_main):
                yield import_node
        elif isinstance(node, ast.ImportFrom):
            aliases = [ Alias(a.name, a.asname) for a in node.names]
            yield FromImport(node.level, node.module, aliases, flags())
        elif isinstance(node, ast.Import):
            aliases = [ Alias(a.name, a.asname) for a in node.names]
            yield Import(aliases, flags())
        elif isinstance(node, ast.FunctionDef):
            for _, child in ast.iter_fields(node):
                for import_node in walk(child, True, in_name_main):
                    yield import_node
        elif isinstance(node, list):
            for n in node:
                for import_node in walk(n, in_function, in_name_main):
                    yield import_node
    return list(walk(the_ast, False, False))

def similar_1(the_ast):
    def walk(node, in_function, in_name_main):
        def flags():
            return in_function * 2 + in_name_main
        if isinstance(node, ast.Module):
            for import_node in walk(node.body, in_function, in_name_main):
                yield import_node
        elif isinstance(node, ast.ImportFrom):
            aliases = [ Alias(a.name, a.asname) for a in node.names]
            yield FromImport(node.level, node.module, aliases, flags())
        elif isinstance(node, ast.Import):
            aliases = [ Alias(a.name, a.asname) for a in node.names]
            yield Import(aliases, flags())
        elif isinstance(node, ast.FunctionDef):
            for _, child in ast.iter_fields(node):
                for import_node in walk(child, True, in_name_main):
                    yield import_node
    return list(walk(the_ast, False, False))

def similar_2(the_ast):
    def walk(node, in_function, in_name_main):
        def flags():
            return in_function * 2 + in_name_main
        if isinstance(node, ast.Module):
            for import_node in walk(node.body, in_function, in_name_main):
                yield import_node
        elif isinstance(node, ast.Import):
            aliases = [ Alias(a.name, a.asname) for a in node.names]
            yield Import(aliases, flags())
        elif isinstance(node, ast.FunctionDef):
            for _, child in ast.iter_fields(node):
                for import_node in walk(child, True, in_name_main):
                    yield import_node
        elif isinstance(node, list):
            for n in node:
                for import_node in walk(n, in_function, in_name_main):
                    yield import_node
    return list(walk(the_ast, False, False))
