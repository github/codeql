package com.semmle.extractor.java;

import java.lang.reflect.*;
import java.io.File;
import java.io.IOException;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Objects;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import com.github.codeql.Logger;
import static com.github.codeql.ClassNamesKt.getIrDeclBinaryName;
import static com.github.codeql.ClassNamesKt.getIrClassVirtualFile;

import org.jetbrains.kotlin.ir.declarations.IrClass;

import com.intellij.openapi.vfs.VirtualFile;

import org.jetbrains.kotlin.ir.declarations.IrDeclaration;
import org.jetbrains.kotlin.ir.declarations.IrDeclarationWithName;
import org.jetbrains.org.objectweb.asm.ClassVisitor;
import org.jetbrains.org.objectweb.asm.ClassReader;
import org.jetbrains.org.objectweb.asm.Opcodes;

import com.semmle.util.concurrent.LockDirectory;
import com.semmle.util.concurrent.LockDirectory.LockingMode;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.NestedError;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.extraction.PopulationSpecFile;
import com.semmle.util.extraction.SpecFileEntry;
import com.semmle.util.files.FileUtil;
import com.semmle.util.io.WholeIO;
import com.semmle.util.process.Env;
import com.semmle.util.process.Env.Var;
import com.semmle.util.trap.dependencies.TrapDependencies;
import com.semmle.util.trap.dependencies.TrapSet;
import com.semmle.util.trap.pathtransformers.PathTransformer;

public class OdasaOutput {

	// either these are set ...
	private final File trapFolder;
	private final File sourceArchiveFolder;

	// ... or this one is set
	private final PopulationSpecFile specFile;

	private File currentSourceFile;
	private TrapSet trapsCreated;
	private TrapDependencies trapDependenciesForSource;

	private SpecFileEntry currentSpecFileEntry;

	// should origin tracking be used?
	private final boolean trackClassOrigins;

	private final Logger log;

	/** DEBUG only: just use the given file as the root for TRAP, source archive etc */
	OdasaOutput(File outputRoot, Logger log) {
		this.trapFolder = new File(outputRoot, "trap");
		this.sourceArchiveFolder = new File(outputRoot, "src_archive");
		this.specFile = null;
		this.trackClassOrigins = false;
		this.log = log;
	}

	public OdasaOutput(boolean trackClassOrigins, Logger log) {
		String trapFolderVar = Env.systemEnv().getFirstNonEmpty("CODEQL_EXTRACTOR_JAVA_TRAP_DIR", Var.TRAP_FOLDER.name());
		if (trapFolderVar != null) {
			String sourceArchiveVar = Env.systemEnv().getFirstNonEmpty("CODEQL_EXTRACTOR_JAVA_SOURCE_ARCHIVE_DIR", Var.SOURCE_ARCHIVE.name());
			if (sourceArchiveVar == null)
				throw new ResourceError(Var.TRAP_FOLDER + " was set to '" + trapFolderVar + "', but "
						+ Var.SOURCE_ARCHIVE + " was not set");
			this.trapFolder = new File(trapFolderVar);
			this.sourceArchiveFolder = new File(sourceArchiveVar);
			this.specFile = null;
		} else {
			this.trapFolder = null;
			this.sourceArchiveFolder = null;
			String specFileVar = Env.systemEnv().get(Var.ODASA_JAVA_LAYOUT);
			if (specFileVar == null)
				throw new ResourceError("Neither " + Var.TRAP_FOLDER + " nor " + Var.ODASA_JAVA_LAYOUT + " was set");
			this.specFile = new PopulationSpecFile(new File(specFileVar));
		}
		this.trackClassOrigins = trackClassOrigins;
		this.log = log;
	}

	public File getTrapFolder() {
		return trapFolder;
	}

	public boolean getTrackClassOrigins() {
		return trackClassOrigins;
	}

	/**
	 * Set the source file that is currently being processed. This may affect
	 * things like trap and source archive directories, and persists as a
	 * setting until this method is called again.
	 * @param f the current source file
	 */
	public void setCurrentSourceFile(File f) {
		currentSourceFile = f;
		currentSpecFileEntry = entryFor();
		trapsCreated = new TrapSet();
		trapsCreated.addSource(PathTransformer.std().fileAsDatabaseString(f));
		trapDependenciesForSource = null;
	}

	/** The output paths for that file, or null if it shouldn't be included */
	private SpecFileEntry entryFor() {
		if (specFile != null)
			return specFile.getEntryFor(currentSourceFile);
		else
			return new SpecFileEntry(trapFolder, sourceArchiveFolder,
					Arrays.asList(PathTransformer.std().fileAsDatabaseString(currentSourceFile)));
	}

	/*
	 * Trap sets and dependencies.
	 */

	public void writeTrapSet() {
		trapsCreated.save(trapSetFor(currentSourceFile).toPath());
	}

	private File trapSetFor(File file) {
		return FileUtil.appendAbsolutePath(
			currentSpecFileEntry.getTrapFolder(), PathTransformer.std().fileAsDatabaseString(file) + ".set");
	}

	public void addDependency(IrDeclaration sym, String signature) {
		String path = trapFilePathForDecl(sym, signature);
		trapDependenciesForSource.addDependency(path);
	}

	/*
	 * Source archive.
	 */

	/**
	 * Write the given source file to the right source archive, encoded in UTF-8,
	 * or do nothing if the file shouldn't be populated.
	 */
	public void writeCurrentSourceFileToSourceArchive(String contents) {
		if (currentSpecFileEntry != null && currentSpecFileEntry.getSourceArchivePath() != null) {
			File target = sourceArchiveFileFor(currentSourceFile);
			target.getParentFile().mkdirs();
			new WholeIO().write(target, contents);
		}
	}

	public void writeFileToSourceArchive(File srcFile) {
		File target = sourceArchiveFileFor(srcFile);
		target.getParentFile().mkdirs();
		String contents = new WholeIO().strictread(srcFile);
		new WholeIO().write(target, contents);
	}

	private File sourceArchiveFileFor(File file) {
		return FileUtil.appendAbsolutePath(currentSpecFileEntry.getSourceArchivePath(),
				PathTransformer.std().fileAsDatabaseString(file));
	}

	/*
	 * Trap file names and paths.
	 */

	private static final String CLASSES_DIR = "classes";
	private static final String JARS_DIR = "jars";
	private static final String MODULES_DIR = "modules";

	private File getTrapFileForCurrentSourceFile() {
		if (currentSpecFileEntry == null)
			return null;
		return trapFileFor(currentSourceFile);
	}

	private File getTrapFileForJarFile(File jarFile) {
		if (!jarFile.getAbsolutePath().endsWith(".jar"))
			return null;
		return FileUtil.appendAbsolutePath(
				currentSpecFileEntry.getTrapFolder(),
				JARS_DIR + "/" + PathTransformer.std().fileAsDatabaseString(jarFile) + ".trap.gz");
	}

	private File getTrapFileForModule(String moduleName) {
		return FileUtil.appendAbsolutePath(
				currentSpecFileEntry.getTrapFolder(),
				MODULES_DIR + "/" + moduleName + ".trap.gz");
	}

	private File trapFileFor(File file) {
		return FileUtil.appendAbsolutePath(currentSpecFileEntry.getTrapFolder(),
				PathTransformer.std().fileAsDatabaseString(file) + ".trap.gz");
	}

	private File getTrapFileForDecl(IrDeclaration sym, String signature) {
		if (currentSpecFileEntry == null)
			return null;
		return trapFileForDecl(sym, signature);
	}

	private File trapFileForDecl(IrDeclaration sym, String signature) {
		return FileUtil.fileRelativeTo(currentSpecFileEntry.getTrapFolder(),
				trapFilePathForDecl(sym, signature));
	}

	private final Map<String, String> memberTrapPaths = new LinkedHashMap<String, String>();
	private static final Pattern dots = Pattern.compile(".", Pattern.LITERAL);
	private String trapFilePathForDecl(IrDeclaration sym, String signature) {
		String binaryName = getIrDeclBinaryName(sym);
		String binaryNameWithSignature = binaryName + signature;
		// TODO: Reinstate this?
		//if (getTrackClassOrigins())
		//  classId += "-" + StringDigestor.digest(sym.getSourceFileId());
		String result = memberTrapPaths.get(binaryNameWithSignature);
		if (result == null) {
			result = CLASSES_DIR + "/" +
					dots.matcher(binaryName).replaceAll("/") +
					signature +
					".members" +
					".trap.gz";
			memberTrapPaths.put(binaryNameWithSignature, result);
		}
		return result;
	}

	/*
	 * Deletion of existing trap files.
	 */

	private void deleteTrapFileAndDependencies(IrDeclaration sym, String signature) {
		File trap = trapFileForDecl(sym, signature);
		if (trap.exists()) {
			trap.delete();
			File depFile = new File(trap.getParentFile(), trap.getName().replace(".trap.gz", ".dep"));
			if (depFile.exists())
				depFile.delete();
			File metadataFile = new File(trap.getParentFile(), trap.getName().replace(".trap.gz", ".metadata"));
			if (metadataFile.exists())
				metadataFile.delete();
		}
	}

	/*
	 * Trap writers.
	 */

	/**
	 * A {@link TrapFileManager} to output facts for the given source file,
	 * or <code>null</code> if the source file should not be populated.
	 */
	private TrapFileManager getTrapWriterForCurrentSourceFile() {
		File trapFile = getTrapFileForCurrentSourceFile();
		if (trapFile==null)
			return null;
		return trapWriter(trapFile, null, null);
	}

	/**
	 * Get a {@link TrapFileManager} to write members
	 * about a declaration, or <code>null</code> if the declaration shouldn't be populated.
	 *
	 * @param sym
	 * 		The declaration's symbol, including, in particular, its fully qualified
	 * 		binary class name.
	 * @param signature
	 * 		Any unique suffix needed to distinguish `sym` from other declarations with the same name.
	 * 		For functions for example, this means its parameter signature.
	 */
	private TrapFileManager getMembersWriterForDecl(IrDeclaration sym, String signature) {
		File trap = getTrapFileForDecl(sym, signature);
		if (trap==null)
			return null;
		TrapClassVersion currVersion = TrapClassVersion.fromSymbol(sym, log);
		String shortName = sym instanceof IrDeclarationWithName ? ((IrDeclarationWithName)sym).getName().asString() : "(name unknown)";
		if (trap.exists()) {
			// Only re-write an existing trap file if we encountered a newer version of the same class.
			TrapClassVersion trapVersion = readVersionInfo(trap);
			if (!currVersion.isValid()) {
				log.warn("Not rewriting trap file for: " + shortName + " " + trapVersion + " " + currVersion + " " + trap);
			} else if (currVersion.newerThan(trapVersion)) {
				log.trace("Rewriting trap file for: " + shortName + " " + trapVersion + " " + currVersion + " " + trap);
				deleteTrapFileAndDependencies(sym, signature);
			} else {
				return null;
			}
		} else {
			log.trace("Writing trap file for: " + shortName + " " + currVersion + " " + trap);
		}
		return trapWriter(trap, sym, signature);
	}

	private TrapFileManager trapWriter(File trapFile, IrDeclaration sym, String signature) {
		if (!trapFile.getName().endsWith(".trap.gz"))
			throw new CatastrophicError("OdasaOutput only supports writing to compressed trap files");
		String relative = FileUtil.relativePath(trapFile, currentSpecFileEntry.getTrapFolder());
		trapFile.getParentFile().mkdirs();
		trapsCreated.addTrap(relative);
		return concurrentWriter(trapFile, relative, log, sym, signature);
	}

	private TrapFileManager concurrentWriter(File trapFile, String relative, Logger log, IrDeclaration sym, String signature) {
		if (trapFile.exists())
			return null;
		return new TrapFileManager(trapFile, relative, true, log, sym, signature);
	}

	public class TrapFileManager implements AutoCloseable {

		private TrapDependencies trapDependenciesForClass;
		private File trapFile;
		private IrDeclaration sym;
		private String signature;
		private boolean hasError = false;

		private TrapFileManager(File trapFile, String relative, boolean concurrentCreation, Logger log, IrDeclaration sym, String signature) {
			trapDependenciesForClass = new TrapDependencies(relative);
			this.trapFile = trapFile;
			this.sym = sym;
			this.signature = signature;
		}

		public File getFile() {
			return trapFile;
		}

		public void addDependency(IrDeclaration dep, String signature) {
			trapDependenciesForClass.addDependency(trapFilePathForDecl(dep, signature));
		}

		public void addDependency(IrClass c) {
			addDependency(c, "");
		}

		public void close() {
			if (hasError) {
				return;
			}

			writeTrapDependencies(trapDependenciesForClass);
			// Record major/minor version information for extracted class files.
			// This is subsequently used to determine whether to re-extract (a newer version of) the same class.
			File metadataFile = new File(trapFile.getAbsolutePath().replace(".trap.gz", ".metadata"));
			try {
				Map<String, String> versionMap = new LinkedHashMap<>();
				TrapClassVersion tcv = TrapClassVersion.fromSymbol(sym, log);
				versionMap.put(MAJOR_VERSION, String.valueOf(tcv.getMajorVersion()));
				versionMap.put(MINOR_VERSION, String.valueOf(tcv.getMinorVersion()));
				versionMap.put(LAST_MODIFIED, String.valueOf(tcv.getLastModified()));
				versionMap.put(EXTRACTOR_NAME, tcv.getExtractorName());
				FileUtil.writePropertiesCSV(metadataFile, versionMap);
			} catch (IOException e) {
				log.warn("Could not save trap metadata file: " + metadataFile.getAbsolutePath(), e);
			}
		}
		private void writeTrapDependencies(TrapDependencies trapDependencies) {
			String dep = trapDependencies.trapFile().replace(".trap.gz", ".dep");
			trapDependencies.save(
					currentSpecFileEntry.getTrapFolder().toPath().resolve(dep));
		}

		public void setHasError() {
			hasError = true;
		}
	}

	/*
	 * Trap file locking.
	 */

	/**
	 * <b>CAUTION</b>: to avoid the potential for deadlock between multiple concurrent extractor processes,
	 * only one source file {@link TrapLocker} may be open at any time, and the lock must be obtained
	 * <b>before</b> any <b>class</b> file lock.
	 *
	 * Trap file extensions (and paths) ensure that source and class file locks are distinct.
	 *
	 * @return  a {@link TrapLocker} for the currently processed source file, which must have been
	 * previously set by a call to {@link OdasaOutput#setCurrentSourceFile(File)}.
	 */
	public TrapLocker getTrapLockerForCurrentSourceFile() {
		return new TrapLocker((IrClass)null, null);
	}

	/**
	 * <b>CAUTION</b>: to avoid the potential for deadlock between multiple concurrent extractor processes,
	 * only one jar file {@link TrapLocker} may be open at any time, and the lock must be obtained
	 * <b>after</b> any <b>source</b> file lock. Only one jar or class file lock may be open at any time.
	 *
	 * Trap file extensions (and paths) ensure that source and jar file locks are distinct.
	 *
	 * @return  a {@link TrapLocker} for the trap file corresponding to the given jar file.
	 */
	public TrapLocker getTrapLockerForJarFile(File jarFile) {
		return new TrapLocker(jarFile);
	}

	/**
	 * <b>CAUTION</b>: to avoid the potential for deadlock between multiple concurrent extractor processes,
	 * only one module {@link TrapLocker} may be open at any time, and the lock must be obtained
	 * <b>after</b> any <b>source</b> file lock. Only one jar or class file or module lock may be open at any time.
	 *
	 * Trap file extensions (and paths) ensure that source and module file locks are distinct.
	 *
	 * @return  a {@link TrapLocker} for the trap file corresponding to the given module.
	 */
	public TrapLocker getTrapLockerForModule(String moduleName) {
		return new TrapLocker(moduleName);
	}

	/**
	 * <b>CAUTION</b>: to avoid the potential for deadlock between multiple concurrent extractor processes,
	 * only one class file {@link TrapLocker} may be open at any time, and the lock must be obtained
	 * <b>after</b> any <b>source</b> file lock. Only one jar or class file lock may be open at any time.
	 *
	 * Trap file extensions (and paths) ensure that source and class file locks are distinct.
	 *
	 * @return  a {@link TrapLocker} for the trap file corresponding to the given class symbol.
	 */
	public TrapLocker getTrapLockerForDecl(IrDeclaration sym, String signature) {
		return new TrapLocker(sym, signature);
	}

	public class TrapLocker implements AutoCloseable {
		private final IrDeclaration sym;
		private final File trapFile;
		private final String signature;
		private final boolean isNonSourceTrapFile;
		private TrapLocker(IrDeclaration decl, String signature) {
			this.sym = decl;
			this.signature = signature;
			if (sym==null) {
				trapFile = getTrapFileForCurrentSourceFile();
			} else {
				trapFile = getTrapFileForDecl(sym, signature);
			}
			isNonSourceTrapFile = false;
		}
		private TrapLocker(File jarFile) {
			sym = null;
			signature = null;
			trapFile = getTrapFileForJarFile(jarFile);
			isNonSourceTrapFile = true;
		}
		private TrapLocker(String moduleName) {
			sym = null;
			signature = null;
			trapFile = getTrapFileForModule(moduleName);
			isNonSourceTrapFile = true;
		}
		public TrapFileManager getTrapFileManager() {
			if (trapFile!=null) {
				lockTrapFile(trapFile);
				return getMembersWriterForDecl(sym, signature);
			} else {
				return null;
			}
		}
		@Override
		public void close() {
			if (trapFile!=null) {
				try {
					unlockTrapFile(trapFile);
				} catch (NestedError e) {
					log.warn("Error unlocking trap file " + trapFile.getAbsolutePath(), e);
				}
			}
		}

		private LockDirectory getExtractorLockDir() {
			return LockDirectory.instance(currentSpecFileEntry.getTrapFolder(), log);
		}

		private void lockTrapFile(File trapFile) {
			getExtractorLockDir().blockingLock(LockingMode.Exclusive, trapFile, "Java extractor lock");
		}

		private void unlockTrapFile(File trapFile) {
			boolean success = getExtractorLockDir().maybeUnlock(LockingMode.Exclusive, trapFile);
			if (!success) {
				log.warn("Trap file was not locked: " + trapFile);
			}
		}
	}

	/*
	 * Class version tracking.
	 */

	private static final String MAJOR_VERSION = "majorVersion";
	private static final String MINOR_VERSION = "minorVersion";
	private static final String LAST_MODIFIED = "lastModified";
	private static final String EXTRACTOR_NAME = "extractorName";

	private static class TrapClassVersion {
		private int majorVersion;
		private int minorVersion;
		private long lastModified;
		private String extractorName; // May be null if not given

		public int getMajorVersion() {
			return majorVersion;
		}

		public int getMinorVersion() {
			return minorVersion;
		}

		public long getLastModified() {
			return lastModified;
		}

		public String getExtractorName() { return extractorName; }

		private TrapClassVersion(int majorVersion, int minorVersion, long lastModified, String extractorName) {
			this.majorVersion = majorVersion;
			this.minorVersion = minorVersion;
			this.lastModified = lastModified;
			this.extractorName = extractorName;
		}
		private boolean newerThan(TrapClassVersion tcv) {
			// Classes being compiled from source have major version 0 but should take precedence
			// over any classes with the same qualified name loaded from the classpath
			// in previous or subsequent extractor invocations.
			if (tcv.majorVersion==0)
				return false;
			else if (majorVersion==0)
				return true;
			// Always consider the Kotlin extractor superior to the Java extractor, because we may decode and extract
			// Kotlin metadata that the Java extractor can't understand:
			if(!Objects.equals(tcv.extractorName, extractorName)) {
				if (Objects.equals(tcv.extractorName, "kotlin"))
					return false;
				if (Objects.equals(extractorName, "kotlin"))
					return true;
			}
			// Otherwise, determine precedence in the following order:
			// majorVersion, minorVersion, lastModified.
			return tcv.majorVersion < majorVersion ||
					(tcv.majorVersion == majorVersion && tcv.minorVersion < minorVersion) ||
					(tcv.majorVersion == majorVersion && tcv.minorVersion == minorVersion &&
					tcv.lastModified < lastModified);
		}

        private static Map<String, Map<String, Long>> jarFileEntryTimeStamps = new HashMap<>();

        private static Map<String, Long> getZipFileEntryTimeStamps(String path, Logger log) {
            try {
                Map<String, Long> result = new HashMap<>();
                ZipFile zf = new ZipFile(path);
                Enumeration<? extends ZipEntry> entries = zf.entries();
                while (entries.hasMoreElements()) {
                    ZipEntry ze = entries.nextElement();
                    result.put(ze.getName(), ze.getLastModifiedTime().toMillis());
                }
                return result;
            } catch(IOException e) {
                log.warn("Failed to get entry timestamps from " + path, e);
                return null;
            }
        }

        private static long getVirtualFileTimeStamp(VirtualFile vf, Logger log) {
            if (vf.getFileSystem().getProtocol().equals("jar")) {
                String[] parts = vf.getPath().split("!/");
                if (parts.length == 2) {
                    String jarFilePath = parts[0];
                    String entryPath = parts[1];
                    if (!jarFileEntryTimeStamps.containsKey(jarFilePath)) {
                        jarFileEntryTimeStamps.put(jarFilePath, getZipFileEntryTimeStamps(jarFilePath, log));
                    }
                    Map<String, Long> entryTimeStamps = jarFileEntryTimeStamps.get(jarFilePath);
                    if (entryTimeStamps != null) {
                        Long entryTimeStamp = entryTimeStamps.get(entryPath);
                        if (entryTimeStamp != null)
                            return entryTimeStamp;
                        else
                            log.warn("Couldn't find timestamp for jar file " + jarFilePath + " entry " + entryPath);
                    }
                } else {
                    log.warn("Expected JAR-file path " + vf.getPath() + " to have exactly one '!/' separator");
                }
            }

            // For all files except for jar files, and a fallback in case of I/O problems reading a jar file:
            return vf.getTimeStamp();
        }

		private static TrapClassVersion fromSymbol(IrDeclaration sym, Logger log) {
			VirtualFile vf = sym instanceof IrClass ? getIrClassVirtualFile((IrClass)sym) :
					sym.getParent() instanceof IrClass ? getIrClassVirtualFile((IrClass)sym.getParent()) :
					null;
			if(vf == null)
				return new TrapClassVersion(-1, 0, 0, null);

			final int[] versionStore = new int[1];

			try {
				// Opcodes has fields called ASM4, ASM5, ...
				// We want to use the latest one that there is.
				Field asmField = null;
				int asmNum = -1;
				for(Field f : Opcodes.class.getDeclaredFields()) {
					String name = f.getName();
					if(name.startsWith("ASM")) {
						try {
							int i = Integer.parseInt(name.substring(3));
							if(i > asmNum) {
								asmNum = i;
								asmField = f;
							}
						} catch (NumberFormatException ex) {
							// Do nothing; this field doesn't have a name of the right format
						}
					}
				}
				int asm = asmField.getInt(null);
				ClassVisitor versionGetter = new ClassVisitor(asm) {
					public void visit(int version, int access, java.lang.String name, java.lang.String signature, java.lang.String superName, java.lang.String[] interfaces) {
						versionStore[0] = version;
					}
				};
				(new ClassReader(vf.contentsToByteArray())).accept(versionGetter, ClassReader.SKIP_CODE | ClassReader.SKIP_DEBUG | ClassReader.SKIP_FRAMES);

				return new TrapClassVersion(versionStore[0] & 0xffff, versionStore[0] >> 16, getVirtualFileTimeStamp(vf, log), "kotlin");
			}
			catch(IllegalAccessException e) {
				log.warn("Failed to read class file version information", e);
				return new TrapClassVersion(-1, 0, 0, null);
			}
			catch(IOException e) {
				log.warn("Failed to read class file version information", e);
				return new TrapClassVersion(-1, 0, 0, null);
			}
		}
		private boolean isValid() {
			return majorVersion>=0 && minorVersion>=0;
		}
		@Override
		public String toString() {
			return majorVersion + "." + minorVersion + "-" + lastModified + "-" + extractorName;
		}
	}

	private TrapClassVersion readVersionInfo(File trap) {
		int majorVersion = 0;
		int minorVersion = 0;
		long lastModified = 0;
		String extractorName = null;
		File metadataFile = new File(trap.getAbsolutePath().replace(".trap.gz", ".metadata"));
		if (metadataFile.exists()) {
			Map<String,String> metadataMap = FileUtil.readPropertiesCSV(metadataFile);
			try {
				majorVersion = Integer.parseInt(metadataMap.get(MAJOR_VERSION));
				minorVersion = Integer.parseInt(metadataMap.get(MINOR_VERSION));
				lastModified = Long.parseLong(metadataMap.get(LAST_MODIFIED));
				extractorName = metadataMap.get(EXTRACTOR_NAME);
			} catch (NumberFormatException e) {
				log.warn("Invalid class file version for " + trap.getAbsolutePath(), e);
			}
		} else {
			log.warn("Trap metadata file does not exist: " + metadataFile.getAbsolutePath());
		}
		return new TrapClassVersion(majorVersion, minorVersion, lastModified, extractorName);
	}

}
