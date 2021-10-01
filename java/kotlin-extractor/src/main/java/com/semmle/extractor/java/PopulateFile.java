package com.semmle.extractor.java;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import com.github.codeql.Label;
import com.github.codeql.TrapWriter;
import com.github.codeql.KotlinExtractorDbSchemeKt;
import com.semmle.util.trap.pathtransformers.PathTransformer;
import com.semmle.util.files.FileUtil;

public class PopulateFile {

  private TrapWriter tw;
  private PathTransformer transformer;
  public PopulateFile(TrapWriter tw) {
    this.tw = tw;
    this.transformer = PathTransformer.std();
  }

	private static final String[] keyReplacementMap = new String[127];
	static {
		keyReplacementMap['&'] = "&amp;";
		keyReplacementMap['{'] = "&lbrace;";
		keyReplacementMap['}'] = "&rbrace;";
		keyReplacementMap['"'] = "&quot;";
		keyReplacementMap['@'] = "&commat;";
		keyReplacementMap['#'] = "&num;";
	}

	/**
	 * Escape a string for use in a TRAP key, by replacing special characters with HTML entities.
	 * <p>
	 * The given string cannot contain any sub-keys, as the delimiters <code>{</code> and <code>}</code>
	 * are escaped.
	 * <p>
	 * To construct a key containing both sub-keys and arbitrary input data, escape the individual parts of
	 * the key rather than the key as a whole, for example:
	 * <pre>
	 * "foo;{" + label.toString() + "};" + escapeKey(data)
	 * </pre>
	 */
	public static String escapeKey(String s) {
		StringBuilder sb = null;
		int lastIndex = 0;
		for (int i = 0; i < s.length(); ++i) {
			char ch = s.charAt(i);
			switch (ch) {
			case '&':
			case '{':
			case '}':
			case '"':
			case '@':
			case '#':
				if (sb == null) {
					sb = new StringBuilder();
				}
				sb.append(s, lastIndex, i);
				sb.append(keyReplacementMap[ch]);
				lastIndex = i + 1;
				break;
			}
		}
		if (sb != null) {
			sb.append(s, lastIndex, s.length());
			return sb.toString();
		} else {
			return s;
		}
	}

  public Label populateFile(File absoluteFile) {
    String databasePath = transformer.fileAsDatabaseString(absoluteFile);
    // Ensure the rewritten path is used from now on.
    File normalisedFile = new File(databasePath);
    Label result = tw.getLabelFor("@\"" + escapeKey(databasePath) + ";sourcefile" + "\"");
    KotlinExtractorDbSchemeKt.writeFiles(tw, result, databasePath);
    populateParents(normalisedFile, result);
    return result;
  }

	private Label addFolderTuple(String databasePath) {
		Label result = tw.getLabelFor("@\"" + escapeKey(databasePath) + ";folder" + "\"");
		KotlinExtractorDbSchemeKt.writeFolders(tw, result, databasePath);
		return result;
	}

	/**
	 * Populate the parents of an already-normalised file. The path transformers
	 * and canonicalisation of {@link PathTransformer#fileAsDatabaseString(File)} will not be
	 * re-applied to this, so it should only be called after proper normalisation
	 * has happened. It will fill in all parent folders in the current TRAP file.
	 */
	private void populateParents(File normalisedFile, Label label) {
		File parent = normalisedFile.getParentFile();
		if (parent == null) return;

    Label parentLabel = addFolderTuple(FileUtil.normalisePath(parent.getPath()));
    populateParents(parent, parentLabel);
		KotlinExtractorDbSchemeKt.writeContainerparent(tw, parentLabel, label);
	}

}