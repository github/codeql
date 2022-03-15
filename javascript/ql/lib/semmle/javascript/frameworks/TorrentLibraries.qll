/**
 * Provides classes for modeling Torrent libraries.
 */

import javascript

/**
 * Provides classes for working with [parse-torrent](https://github.com/webtorrent/parse-torrent) code.
 */
module ParseTorrent {
  private API::Node mod() { result = API::moduleImport("parse-torrent") }

  /**
   * A torrent that has been parsed into a JavaScript object.
   */
  class ParsedTorrent extends DataFlow::SourceNode {
    API::Node node;

    ParsedTorrent() {
      (
        node = mod().getReturn() or
        node = mod().getMember("remote").getParameter(1).getParameter(1)
      ) and
      this = node.getAnImmediateUse()
    }

    /** Gets the API node for this torrent object. */
    API::Node asApiNode() { result = node }
  }

  /** Gets a data flow node referring to a parsed torrent. */
  DataFlow::SourceNode parsedTorrentRef() { result = any(ParsedTorrent t).asApiNode().getAUse() }

  /**
   * An access to user-controlled torrent information.
   */
  class UserControlledTorrentInfo extends RemoteFlowSource instanceof DataFlow::PropRead {
    UserControlledTorrentInfo() {
      exists(API::Node read |
        read = any(ParsedTorrent t).asApiNode().getAMember() and
        this = read.getAnImmediateUse()
      |
        exists(string prop |
          not (
            prop = "private" or
            prop = "infoHash" or
            prop = "length"
            // "pieceLength" and "lastPieceLength" are not guaranteed to be numbers as of commit ae3ad15d
          ) and
          super.getPropertyName() = prop
        )
        or
        not exists(super.getPropertyName())
      )
    }

    override string getSourceType() { result = "torrent information" }
  }
}
