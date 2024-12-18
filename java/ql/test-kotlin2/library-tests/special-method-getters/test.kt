fun test(cs: CharSequence, col: Collection<String>, map: Map<String, String>) = cs.length + col.size + map.size + map.keys.size + map.values.size + map.entries.size
