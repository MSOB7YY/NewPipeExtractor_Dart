import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/streamsParser.dart';

class SearchExtractor {
  /// Search on Youtube for the provided Query, this will return
  /// a YoutubeSearch object which will contain all StreamInfoItem,
  /// PlaylistInfoItem and ChannelInfoItem found, you can then query
  /// for more results running that object [getNextPage()] function
  static Future<YoutubeSearch> searchYoutube(
      String query, List<String> filters) async {
    final info = await NewPipeExtractorDart.safeExecute(
        "searchYoutube", {"query": query, "filters": filters});
    var parsedList = _parseSearchResults(info);
    return YoutubeSearch(
        query: query,
        searchVideos: parsedList[0],
        searchPlaylists: parsedList[1],
        searchChannels: parsedList[2]);
  }

  /// Gets the next page of the current YoutubeSearch Query
  static Future<List<dynamic>> getNextPage() async {
    final info = await NewPipeExtractorDart.safeExecute("getNextPage");
    return _parseSearchResults(info);
  }

  /// Search on YoutubeMusic for the provided Query, this will return
  /// a YoutubeSearch object which will contain all StreamInfoItem,
  /// PlaylistInfoItem and ChannelInfoItem found, you can then query
  /// for more results running that object [getNextPage()] function
  static Future<YoutubeMusicSearch> searchYoutubeMusic(
      String query, List<String> filters) async {
    final info = await NewPipeExtractorDart.safeExecute(
        "searchYoutubeMusic", {"query": query, "filters": filters});
    var parsedList = _parseSearchResults(info);
    return YoutubeMusicSearch(
        query: query,
        searchVideos: parsedList[0],
        searchPlaylists: parsedList[1],
        searchChannels: parsedList[2]);
  }

  /// Gets the next page of the current YoutubeMusicSearch Query
  static Future<List<dynamic>> getNextMusicPage() async {
    final info = await NewPipeExtractorDart.safeExecute("getNextMusicPage");
    return _parseSearchResults(info);
  }

  static List<dynamic> _parseSearchResults(info) {
    return StreamsParser.parseInfoItemListFromMap(info, singleList: false);
  }
}
