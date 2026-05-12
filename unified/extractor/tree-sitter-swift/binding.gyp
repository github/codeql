{
  "targets": [
    {
      "target_name": "tree_sitter_swift_binding",
      "dependencies": [
        "<!(node -p \"require('node-addon-api').targets\"):node_addon_api_except",
      ],
      "include_dirs": [
        "src",
      ],
      "sources": [
        "bindings/node/binding.cc",
        "src/parser.c",
        # NOTE: if your language has an external scanner, add it here.
        "src/scanner.c",
      ],
      "cflags_c": [
        "-std=c11",
      ],
      "actions": [
          {
	      "action_name": "wait_for_tree_sitter",
	      "action": ["node", "scripts/wait-for-tree-sitter.js"],
	      "inputs": [],
	      "outputs": ["node_modules/tree-sitter-cli"]
	  },
          {
	      "action_name": "generate_header_files",
	      "inputs": [
	          "grammar.js",
		  "node_modules/tree-sitter-cli"
	      ],
	      "outputs": [
	          "src/grammar.json",
		  "src/node-types.json",
		  "src/parser.c",
		  "src/tree_sitter",
	      ],
	      "action": ["tree-sitter", "generate", "--no-bindings"],
	  }
      ]
    }
  ]
}
