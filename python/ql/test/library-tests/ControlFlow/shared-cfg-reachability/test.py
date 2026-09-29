def same_block_forward():
    reachability_same_block_forward_source = 1
    reachability_same_block_forward_destination = (  # $ reaches=same_block_forward
        reachability_same_block_forward_source + 1
    )
    return reachability_same_block_forward_destination


def same_block_reverse():
    reachability_same_block_reverse_destination = 1  # $ not-reaches=same_block_reverse
    reachability_same_block_reverse_source = reachability_same_block_reverse_destination + 1
    return reachability_same_block_reverse_source


def branch_left_to_join(condition):
    if condition:
        reachability_branch_left_to_join_source = 1
    else:
        fallback = 2
    reachability_branch_left_to_join_destination = fallback  # $ reaches=branch_left_to_join
    return reachability_branch_left_to_join_destination


def branch_right_to_join(condition):
    if condition:
        fallback = 1
    else:
        reachability_branch_right_to_join_source = 2
    reachability_branch_right_to_join_destination = fallback  # $ reaches=branch_right_to_join
    return reachability_branch_right_to_join_destination


def branch_siblings(condition):
    if condition:
        reachability_branch_siblings_source = 1
    else:
        reachability_branch_siblings_destination = 2  # $ not-reaches=branch_siblings


def loop_backedge(condition):
    while condition:
        reachability_loop_backedge_destination = 1  # $ reaches=loop_backedge
        reachability_loop_backedge_source = reachability_loop_backedge_destination + 1


def loop_exit(condition):
    while condition:
        reachability_loop_exit_source = 1
    reachability_loop_exit_destination = 2  # $ reaches=loop_exit
    return reachability_loop_exit_destination


def distinct_scope_source():
    reachability_distinct_scopes_source = 1
    return reachability_distinct_scopes_source


def distinct_scope_destination():
    reachability_distinct_scopes_destination = 2  # $ not-reaches=distinct_scopes
    return reachability_distinct_scopes_destination
