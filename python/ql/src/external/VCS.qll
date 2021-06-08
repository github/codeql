import python

class Commit extends @svnentry {
  Commit() {
    svnaffectedfiles(this, _, _) and
    exists(date svnDate, date snapshotDate |
      svnentries(this, _, _, svnDate, _) and
      snapshotDate(snapshotDate) and
      svnDate <= snapshotDate
    )
  }

  /** Gets a textual representation of this element. */
  string toString() { result = this.getRevisionName() }

  string getRevisionName() { svnentries(this, result, _, _, _) }

  string getAuthor() { svnentries(this, _, result, _, _) }

  date getDate() { svnentries(this, _, _, result, _) }

  int getChangeSize() { svnentries(this, _, _, _, result) }

  string getMessage() { svnentrymsg(this, result) }

  string getAnAffectedFilePath(string action) {
    exists(File rawFile | svnaffectedfiles(this, rawFile, action) |
      result = rawFile.getAbsolutePath()
    )
  }

  string getAnAffectedFilePath() { result = getAnAffectedFilePath(_) }

  File getAnAffectedFile(string action) { svnaffectedfiles(this, result, action) }

  File getAnAffectedFile() { exists(string action | result = this.getAnAffectedFile(action)) }

  predicate isRecent() { recentCommit(this) }

  int daysToNow() {
    exists(date now | snapshotDate(now) | result = getDate().daysTo(now) and result >= 0)
  }

  int getRecentAdditionsForFile(File f) { svnchurn(this, f, result, _) }

  int getRecentDeletionsForFile(File f) { svnchurn(this, f, _, result) }

  int getRecentChurnForFile(File f) {
    result = getRecentAdditionsForFile(f) + getRecentDeletionsForFile(f)
  }
}

class Author extends string {
  Author() { exists(Commit e | this = e.getAuthor()) }

  Commit getACommit() { result.getAuthor() = this }

  File getAnEditedFile() { result = this.getACommit().getAnAffectedFile() }
}

predicate recentCommit(Commit e) {
  exists(date snapshotDate, date commitDate, int days |
    snapshotDate(snapshotDate) and
    e.getDate() = commitDate and
    days = commitDate.daysTo(snapshotDate) and
    days >= 0 and
    days <= 60
  )
}

date firstChange(File f) {
  result = min(Commit e, date toMin | f = e.getAnAffectedFile() and toMin = e.getDate() | toMin)
}

predicate firstCommit(Commit e) {
  not exists(File f | f = e.getAnAffectedFile() | firstChange(f) < e.getDate())
}

predicate artificialChange(Commit e) { firstCommit(e) or e.getChangeSize() >= 50000 }
