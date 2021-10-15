let Vue = require('vue');

new Vue( {
	created: () => this, // NOT OK
	computed: {
		x: () => this, // NOT OK
		y: { get: () => this }, // NOT OK
		z: { set: () => this } // NOT OK
	},
	methods: {
		arrow: () => this, // NOT OK
		nonArrow: function() { this; }, // OK
		arrowWithoutThis: () => 42, // OK
		arrowWithNestedThis: () => (() => this) // OK
	}
});
