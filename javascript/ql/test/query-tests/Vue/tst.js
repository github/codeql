let Vue = require('vue');

new Vue( {
	created: () => this, // $ Alert
	computed: {
		x: () => this, // $ Alert
		y: { get: () => this }, // $ Alert
		z: { set: () => this } // $ Alert
	},
	methods: {
		arrow: () => this, // $ Alert
		nonArrow: function() { this; },
		arrowWithoutThis: () => 42,
		arrowWithNestedThis: () => (() => this)
	}
});
