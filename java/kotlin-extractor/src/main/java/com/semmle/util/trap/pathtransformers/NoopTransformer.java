package com.semmle.util.trap.pathtransformers;

public class NoopTransformer extends PathTransformer {
	@Override
	public String transform(String input) {
		return input;
	}
}