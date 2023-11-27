import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/streamsParser.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';

class PlaylistExtractor {
  static PlaylistExtractor get instance => _instance;
  static final PlaylistExtractor _instance = PlaylistExtractor._internal();
  PlaylistExtractor._internal();

  /// Extract all the details of the given Playlist URL into a YoutubePlaylist object
  Future<YoutubePlaylist?> getPlaylistDetails(String? playlistUrl) async {
    StringChecker.ensureGoodLink(playlistUrl);

    final info = await NewPipeExtractorDart.safeExecute("getPlaylistDetails", {"playlistUrl": playlistUrl});
    if (info == null) return null;
    final map = (info as Map<Object?, Object?>).cast<String, dynamic>();
    return YoutubePlaylist.fromMap(map);
  }

  /// Extract all the Streams from the given Playlist URL
  /// as a list of StreamInfoItem
  Future<List<StreamInfoItem>> getPlaylistStreams(String? playlistUrl) async {
    StringChecker.ensureGoodLink(playlistUrl);

    final info = await NewPipeExtractorDart.safeExecute("getPlaylistStreams", {"playlistUrl": playlistUrl});
    return StreamsParser.parseStreamListFromMap(info);
  }

  Future<List<StreamInfoItem>> getPlaylistStreamsNextPage(String? playlistUrl) async {
    StringChecker.ensureGoodLink(playlistUrl);

    final info = await NewPipeExtractorDart.safeExecute("getPlaylistStreamsNextPage", {"playlistUrl": playlistUrl});
    return StreamsParser.parseStreamListFromMap(info);
  }
}
