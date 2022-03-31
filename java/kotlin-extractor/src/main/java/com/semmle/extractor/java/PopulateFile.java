package com.semmle.extractor.java;

import java.io.File;
import java.util.HashMap;
import java.util.Map;

import com.github.codeql.Label;
import com.github.codeql.DbFile;
import com.github.codeql.TrapWriter;
import com.github.codeql.KotlinExtractorDbSchemeKt;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.files.FileUtil;
import com.semmle.util.trap.pathtransformers.PathTransformer;
import kotlin.Unit;

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
        return getFileLabel(absoluteFile, true);
    }

    public Label<DbFile> getFileLabel(File absoluteFile, boolean populateTables) {
        String databasePath = transformer.fileAsDatabaseString(absoluteFile);
        Label result = tw.<DbFile>getLabelFor("@\"" + escapeKey(databasePath) + ";sourcefile" + "\"", label -> {
            if(populateTables) {
                KotlinExtractorDbSchemeKt.writeFiles(tw, label, databasePath);
                populateParents(new File(databasePath), label);
            }
            return Unit.INSTANCE;
        });
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

    public Label relativeFileId(File jarFile, String pathWithinJar) {
        return getFileInJarLabel(jarFile, pathWithinJar, true);
    }

	public Label<DbFile> getFileInJarLabel(File jarFile, String pathWithinJar, boolean populateTables) {
		if (pathWithinJar.contains("\\"))
			throw new CatastrophicError("Invalid jar path: '" + pathWithinJar + "' should not contain '\\'.");

        String databasePath = transformer.fileAsDatabaseString(jarFile);
        if(!populateTables)
            return tw.getLabelFor("@\"" + databasePath + "/" + pathWithinJar + ";jarFile\"");

		Label jarFileId = this.populateFile(jarFile);
        Label jarFileLocation = tw.getLocation(jarFileId, 0, 0, 0, 0);
        KotlinExtractorDbSchemeKt.writeHasLocation(tw, jarFileId, jarFileLocation);

		StringBuilder fullName = new StringBuilder(databasePath);
		String[] split = pathWithinJar.split("/");
		Label current = jarFileId;
		for (int i = 0; i < split.length; i++) {
			String shortName = split[i];

			fullName.append("/");
			fullName.append(shortName);
			Label fileId = tw.getLabelFor("@\"" + fullName + ";jarFile" + "\"");

			boolean file = i == split.length - 1;
			if (file) {
				KotlinExtractorDbSchemeKt.writeFiles(tw, fileId, fullName.toString());
			} else {
				KotlinExtractorDbSchemeKt.writeFolders(tw, fileId, fullName.toString());
			}
			KotlinExtractorDbSchemeKt.writeContainerparent(tw, current, fileId);
			current = fileId;
		}

		return current;
	}

}
