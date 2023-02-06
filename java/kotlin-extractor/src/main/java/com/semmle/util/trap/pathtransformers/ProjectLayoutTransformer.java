package com.semmle.util.trap.pathtransformers;

import java.io.File;

import com.semmle.util.projectstructure.ProjectLayout;

public class ProjectLayoutTransformer extends PathTransformer {
	private final ProjectLayout layout;
	
	public ProjectLayoutTransformer(File file) {
		layout = new ProjectLayout(file);
	}
	
	@Override
	public String transform(String input) {
		if (isWindowsPath(input, 0)) {
			String result = layout.artificialPath('/' + input);
			if (result == null) {
				return input;
			} else if (isWindowsPath(result, 1) && result.charAt(0) == '/') {
				return result.substring(1);
			} else {
				return result;
			}
		} else {
			String result = layout.artificialPath(input);
			return result != null ? result : input;
		}
	}
	
	private static boolean isWindowsPath(String s, int startAt) {
		return s.length() >= (3 + startAt) &&
				s.charAt(startAt) != '/' &&
				s.charAt(startAt + 1) == ':' &&
				s.charAt(startAt + 2) == '/';
	}
}