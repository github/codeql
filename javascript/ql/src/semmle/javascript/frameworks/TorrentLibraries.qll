/**
 * Provides classes for modelling Torrent libraries.
 */

import javascript

/**
 * Provides classes for working with [parse-torrent](https://github.com/webtorrent/parse-torrent) code.
 */
module ParseTorrent {
  private DataFlow::SourceNode mod() { result = DataFlow::moduleImport("parse-torrent") }

  /**
   * A torrent that has been parsed into a JavaScript object.
   */
  class ParsedTorrent extends DataFlow::SourceNode {
    ParsedTorrent() {
      this = mod().getACall() or
      this = mod().getAMemberCall("remote").getCallback(1).getParameter(1)
    }
  }

  private DataFlow::SourceNode parsedTorrentRef(DataFlow::TypeTracker t) {
    t.start() and
    result instanceof ParsedTorrent
    or
    exists(DataFlow::TypeTracker t2 | result = parsedTorrentRef(t2).track(t2, t))
  }

  /** Gets a data flow node referring to a parsed torrent. */
  DataFlow::SourceNode parsedTorrentRef() {
    result = parsedTorrentRef(DataFlow::TypeTracker::end())
  }

  /**
   * An access to user-controlled torrent information.
   */
  class UserControlledTorrentInfo extends RemoteFlowSource {
    UserControlledTorrentInfo() {
      exists(DataFlow::SourceNode ref, DataFlow::PropRead read |
        ref = parsedTorrentRef() and
        read = ref.getAPropertyRead() and
        this = read
      |
        exists(string prop |
          not (
            prop = "private" or
            prop = "infoHash" or
            prop = "length"
            // "pieceLength" and "lastPieceLength" are not guaranteed to be numbers as of commit ae3ad15d
          ) and
          read.getPropertyName() = prop
        )
        or
        not exists(read.getPropertyName())
      )
    }

    override string getSourceType() { result = "torrent information" }
  }
}
