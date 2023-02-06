package com.semmle.util.concurrent;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.util.LinkedHashMap;
import java.util.Map;

import com.semmle.util.data.StringDigestor;
import com.semmle.util.exception.CatastrophicError;
import com.semmle.util.exception.ResourceError;
import com.semmle.util.files.FileUtil;
import com.semmle.util.io.WholeIO;

import com.github.codeql.Logger;
import com.github.codeql.Severity;

/**
 * Helper class to simplify handling of file-system-based inter-process
 * locking and mutual exclusion.
 *
 * Both files and directories can be locked; locks are provided in the
 * usual flavours of "shared" and "exclusive", plus a no-op variety to
 * help unify code -- see the {@link LockingMode} enum.
 *
 * Note that each locked file requires one file descriptor to be held open.
 * It is vital for clients to avoid creating too many locks, and to release
 * locks when possible.
 *
 * The locks obtained by this class are VM-wide, and cannot be used to
 * ensure mutual exclusion between threads of the same VM. Rather, they
 * can enforce mutual exclusion between separate VMs trying to acquire
 * locks for the same paths.
 */
public class LockDirectory {
	private final Logger logger;

	private final File lockDir;

	/**
	 * An enum describing the possible locking modes.
	 */
	public enum LockingMode {
		/**
		 * Shared mode: A shared lock can be taken any number of times, but only
		 * if no exclusive lock is in place.
		 */
		Shared(true),
		/**
		 * An exclusive lock can only be taken if no other lock is in place; it
		 * prevents all other locks.
		 */
		Exclusive(false),
		/**
		 * A dummy mode: Lock and unlock operations are no-ops.
		 */
		None(true),
		;

		private boolean shared;

		private LockingMode(boolean shared) {
			this.shared = shared;
		}

		public boolean isShared() { return shared; }
	}

	/**
	 * An internal representation of a locked path. Contains some immutable state: The canonical
	 * path being locked, and the (derived) lock and status files. When the {@link #lock(LockDirectory.LockingMode, String)}
	 * method is called, a file descriptor to the lock file is opened; {@link #unlock(LockDirectory.LockingMode)} must be
	 * called to release it when the lock is no longer required.
	 *
	 * This class is not thread-safe, but it is expected that its clients ({@link LockDirectory})
	 * enforce thread-safe access to instances.
	 */
	private class LockFile {
		private final String lockedPath;
		private final File lockFile;
		private final File statusFile;

		private LockingMode mode = null;
		private RandomAccessFile lockStream = null;
		private FileChannel lockChannel = null;
		private FileLock lock = null;

		public LockFile(File f) {
			try {
				lockedPath = f.getCanonicalPath();
			} catch (IOException e) {
				throw new ResourceError("Failed to canonicalise path for locking: " + f, e);
			}
			String sha = StringDigestor.digest(lockedPath);
			lockFile = new File(lockDir, sha);
			statusFile = new File(lockDir, sha + ".log");
		}

		/**
		 * Get the (canonical) path associated with this lock file -- this is the
		 * path that is being locked.
		 */
		public String getLockedPath() {
			return lockedPath;
		}

		/**
		 * Acquire a lock with the given mode. If this method returns normally,
		 * the lock has been acquired -- an exception is thrown otherwise. This
		 * method does not block.
		 *
		 * If no exception is thrown, a file descriptor is kept open until
		 * {@link #unlock(LockDirectory.LockingMode)} is called.
		 * @param mode The desired locking mode. If {@link LockingMode#None}, this
		 * 	operation is a no-op (and does not in fact open a file descriptor).
		 * @param message A message to be recorded alongside the lock file. This
		 * is included in the exception message of other processes using this
		 * 	infrastructure when the lock acquisition fails.
		 * @throws CatastrophicError if a lock has already been obtained and not released.
		 * @throws ResourceError if an exception occurs while obtaining the lock, including
		 * 	if it cannot be acquired because another process holds it.
		 */
		public void lock(LockingMode mode, String message) {
			if (mode == LockingMode.None) return;
			if (lock != null)
				throw new CatastrophicError("Trying to re-lock existing lock for " + lockedPath);
			this.mode = mode;
			try {
				lockStream = new RandomAccessFile(lockFile, "rw");
				lockChannel = lockStream.getChannel();
				tryLock(mode);
				new WholeIO().strictwrite(statusFile, mode + " lock acquired for " + lockedPath + ": " + message);
			} catch (IOException e) {
				throw new ResourceError("Failed to obtain lock for " + lockedPath + " at " + lockFile, e);
			}
		}

		/**
		 * Acquire a lock with the given mode. If this method returns normally,
		 * the lock has been acquired -- an exception is thrown otherwise. This
		 * method blocks indefinitely while waiting to acquire the lock.
		 *
		 * If no exception is thrown, a file descriptor is kept open until
		 * {@link #unlock(LockDirectory.LockingMode)} is called.
		 * @param mode The desired locking mode. If {@link LockingMode#None}, this
		 * 	operation is a no-op (and does not in fact open a file descriptor).
		 * @param message A message to be recorded alongside the lock file. This
		 * is included in the exception message of other processes using this
		 * 	infrastructure when the lock acquisition fails.
		 * @throws ResourceError if an exception occurs while obtaining the lock,.
		 */
		public void blockingLock(LockingMode mode, String message) {
			if (mode == LockingMode.None) return;
			if (lock != null)
				throw new CatastrophicError("Trying to re-lock existing lock for " + lockedPath);
			this.mode = mode;
			try {
				lockStream = new RandomAccessFile(lockFile, "rw");
				lockChannel = lockStream.getChannel();
				lock = lockChannel.tryLock(0, Long.MAX_VALUE, mode.isShared());
				while (lock == null) {
					ThreadUtil.sleep(500, true);
					lock = lockChannel.tryLock(0, Long.MAX_VALUE, mode.isShared());
				}
				new WholeIO().strictwrite(statusFile, mode + " lock acquired for " + lockedPath + ": " + message);
			} catch (IOException e) {
				throw new ResourceError("Failed to obtain lock for " + lockedPath + " at " + lockFile, e);
			}
		}

		/**
		 * Internal helper method: Try to acquire a particular kind of lock, assuming the
		 * {@link #lockChannel} has been set up. Throws if acquisition fails, rather than
		 * blocking.
		 * @param mode The desired lock mode -- exclusive or shared.
		 * @throws IOException if acquisition of the lock fails for reasons other than
		 * 	an incompatible lock already being held by another process.
		 * @throws ResourceError if the lock is already held by another process. The exception
		 * 	message includes the status string, if it can be determined.
		 */
		private void tryLock(LockingMode mode) throws IOException {
			lock = lockChannel.tryLock(0, Long.MAX_VALUE, mode.isShared());
			if (lock == null) {
				String status = new WholeIO().read(statusFile);
				throw new ResourceError("Failed to acquire " + mode + " lock for " + lockedPath + "." +
						(status == null ? "" : "\nExisting lock message: " + status));
			}
		}

		/**
		 * Release this lock. This will close the file descriptor opened by {@link #lock(LockDirectory.LockingMode, String)}.
		 * @param mode A mode, which must match the mode passed into {@link #lock(LockDirectory.LockingMode, String)}
		 * 	(unless it is {@link LockingMode#None}, in which case the method is a no-op).
		 * @throws CatastrophicError if the passed mode does not match the one used for locking.
		 * @throws ResourceError if releasing the lock or clearing up temporary files fails.
		 */
		public void unlock(LockingMode mode) {
			if (mode == LockingMode.None)
				return;
			if (mode != this.mode)
				throw new CatastrophicError("Attempting to unlock " + lockedPath + " with incompatible mode: " +
						this.mode + " lock was obtained, but " + mode + " lock is being released.");
			release(mode);
		}

		private void release(LockingMode mode) {
			try {
				if (lock != null)
					try {
						// On Windows, the lockChannel/lockStream prevents the lockFile from being
						// deleted. The statusFile should only be written after the lock is held,
						// so deleting it before releasing the lock is not expected to fail if the
						// lock is exclusive.
						// Deleting the lock file may fail, if another process just acquires it
						// after we release it.
						try {
							if (statusFile.exists() && !statusFile.delete()) {
									if (!mode.isShared()) throw new ResourceError("Could not clear status file " + statusFile);
							}
						} finally {
							lock.release();
							FileUtil.close(lockStream);
							FileUtil.close(lockChannel);
							if (!lockFile.delete())
								logger.error("Could not clear lock file " + lockFile + " (it might have been locked by another process).");
						}
					} catch (IOException e) {
						throw new ResourceError("Couldn't release lock for " + lockedPath, e);
					}
			} finally {
				mode = null;
				lockStream = null;
				lockChannel = null;
				lock = null;
			}
		}
	}

	private static final Map<File, LockDirectory> instances = new LinkedHashMap<File, LockDirectory>();

	/**
	 * Obtain the {@link LockDirectory} instance for a given lock directory. The directory
	 * in question will be created if it doesn't exist.
	 * @param lockDir A directory -- must be writable, and will be created if it doesn't
	 * 	already exist.
	 * @return The {@link LockDirectory} instance responsible for the specified lock directory.
	 * @throws ResourceError if the directory cannot be created, exists as a non-directory
	 * 	or cannot be canonicalised.
	 */
	public static synchronized LockDirectory instance(File lockDir) {
		return instance(lockDir, null);
	}

	/**
	 * See {@link #instance(File)}.
	 * Use this method only if log output should be directed to a custom {@link Logger}.
	 */
	public static synchronized LockDirectory instance(File lockDir, Logger logger) {
		// First try to create the directory -- canonicalisation will fail if it doesn't exist.
		try {
			FileUtil.mkdirs(lockDir);
		} catch(ResourceError e) {
			throw new ResourceError("Couldn't ensure lock directory " + lockDir + " exists.", e);
		}

		// Canonicalise.
		try {
			lockDir = lockDir.getCanonicalFile();
		} catch (IOException e) {
			throw new ResourceError("Couldn't canonicalise requested lock directory " + lockDir, e);
		}

		// Find and return the right instance.
		LockDirectory instance = instances.get(lockDir);
		if (instance == null) {
			instance = new LockDirectory(lockDir, logger);
			instances.put(lockDir, instance);
		}
		return instance;
	}

	/**
	 * A map from canonical locked paths to the associated {@link LockFile} instances.
	 */
	private final Map<String, LockFile> locks = new LinkedHashMap<String, LockFile>();

	/**
	 * Create a new instance of {@link LockDirectory}, holding all locks in the
	 * specified log directory.
	 * @param lockDir A writable directory in which locks will be stored.
	 * @param logger The {@link Logger} to use, if non-null.
	 */
	private LockDirectory(File lockDir, Logger logger) {
		this.lockDir = lockDir;
		this.logger = logger;
	}

	/**
	 * Acquire a lock of the specified kind for the path represented by the given file.
	 * The file should exist, and its path should be canonicalisable.
	 *
	 * Calling this method keeps one file descriptor open
	 * @param mode The desired locking mode. If {@link LockingMode#None} is passed, this is a no-op,
	 * 	otherwise it determines whether a shared or exclusive lock is acquired.
	 * @param f The path that should be locked -- does not need to be writable, and will not
	 * 	be opened.
	 * @param message A message describing the purpose of the lock acquisition. This is
	 * 	potentially displayed when other processes fail to acquire the lock for the given
	 * 	path.
	 * @throws CatastrophicError if an attempt is made to lock an already locked path.
	 */
	public synchronized void lock(LockingMode mode, File f, String message) {
		if (mode == LockingMode.None) return;
		LockFile lock = new LockFile(f);
		if (locks.containsKey(lock.getLockedPath()))
				throw new CatastrophicError("Trying to lock already locked path " + lock.getLockedPath() + ".");
		lock.lock(mode, message);
		locks.put(lock.getLockedPath(), lock);
	}

	/**
	 * Acquire a lock of the specified kind for the path represented by the given file.
	 * The file should exist, and its path should be canonicalisable. This method waits
	 * indefinitely for the lock to become available. There is no ordering on processes
	 * that are waiting to acquire the lock in this manner.
	 *
	 * Calling this method keeps one file descriptor open
	 * @param mode The desired locking mode. If {@link LockingMode#None} is passed, this is a no-op,
	 * 	otherwise it determines whether a shared or exclusive lock is acquired.
	 * @param f The path that should be locked -- does not need to be writable, and will not
	 * 	be opened.
	 * @param message A message describing the purpose of the lock acquisition. This is
	 * 	potentially displayed when other processes fail to acquire the lock for the given
	 * 	path.
	 */
	public synchronized void blockingLock(LockingMode mode, File f, String message) {
		if (mode == LockingMode.None) return;
		LockFile lock = new LockFile(f);
		if (locks.containsKey(lock.getLockedPath()))
			throw new CatastrophicError("Trying to lock already locked path " + lock.getLockedPath() + ".");
		lock.blockingLock(mode, message);
		locks.put(lock.getLockedPath(), lock);
	}

	/**
	 * Release a lock held on a particular path.
	 *
	 * This method closes the file descriptor associated with the lock, freeing related
	 * resources.
	 * @param mode the mode of the lock. If it equals {@link LockingMode#None}, this is a no-op; otherwise
	 * 	it is expected to match the mode passed to the corresponding {@link #lock(LockingMode, File, String)}
	 * 	call.
	 * @param f The path which should be unlocked. As with {@link #lock(LockingMode, File, String)}, it is
	 *	expected to exist and be canonicalisable. It also must be currently locked.
	 * @throws CatastrophicError on API contract violation: The path isn't currently locked, or the
	 * 	mode doesn't correspond to the mode specified when it was locked.
	 * @throws ResourceError if something goes wrong while releasing resources.
	 */
	public synchronized void unlock(LockingMode mode, File f) {
		if (!maybeUnlock(mode, f))
			throw new CatastrophicError("Trying to unlock " + new LockFile(f).getLockedPath() + ", but it is not locked.");
	}

	/**
	 * Release a lock that may be held on a particular path.
	 *
	 * This method closes the file descriptor associated with the lock, freeing related
	 * resources. Unlike {@link #unlock(LockingMode, File)}, this method will not throw
	 * if the specified {@link File} is not locked, making it more suitable for post-exception
	 * cleanup -- <code>false</code> will be returned in that case.
	 * @param mode the mode of the lock. If it equals {@link LockingMode#None}, this is a no-op; otherwise
	 * 	it is expected to match the mode passed to the corresponding {@link #lock(LockingMode, File, String)}
	 * 	call.
	 * @param f The path which should be unlocked. As with {@link #lock(LockingMode, File, String)}, it is
	 *	expected to exist and be canonicalisable.
	 * @return <code>true</code> if <code>mode == LockingMode.None</code>, or the unlock operation completed
	 * 		successfully; <code>false</code> if the path <code>f</code> isn't currently locked.
	 * @throws ResourceError if something goes wrong while releasing resources.
	 */
	public synchronized boolean maybeUnlock(LockingMode mode, File f) {
		if (mode == LockingMode.None) return true;
		// New instance constructed just to share the logic of computing the canonical path.
		LockFile key = new LockFile(f);
		LockFile existing = locks.get(key.getLockedPath());
		if (existing == null)
			return false;
		locks.remove(key.getLockedPath());
		existing.unlock(mode);
		return true;
	}

	public File getDir(){ return lockDir; }
}
