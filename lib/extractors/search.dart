import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/streamsParser.dart';

class SearchExtractor {
  static SearchExtractor get instance => _instance;
  static final SearchExtractor _instance = SearchExtractor._internal();
  SearchExtractor._internal();

  /// Search on Youtube for the provided Query, this will return
  /// a YoutubeSearch object which will contain all StreamInfoItem,
  /// PlaylistInfoItem and ChannelInfoItem found, you can then query
  /// for more results running that object [getNextPage()] function
  Future<YoutubeSearch> searchYoutube(
      String query, List<String> filters) async {
    final info = await NewPipeExtractorDart.safeExecute(
        "searchYoutube", {"query": query, "filters": filters});
    final parsedList = _parseSearchResults(info);
    return YoutubeSearch(
        query: query,
        searchVideos: parsedList[0],
        searchPlaylists: parsedList[1],
        searchChannels: parsedList[2]);
  }

  /// Gets the next page of the current YoutubeSearch Query
  Future<List<dynamic>> getNextPage() async {
    final info = await NewPipeExtractorDart.safeExecute("getNextPage");
    return _parseSearchResults(info);
  }

  /// Search on YoutubeMusic for the provided Query, this will return
  /// a YoutubeSearch object which will contain all StreamInfoItem,
  /// PlaylistInfoItem and ChannelInfoItem found, you can then query
  /// for more results running that object [getNextPage()] function
  Future<YoutubeMusicSearch> searchYoutubeMusic(
      String query, List<String> filters) async {
    final info = await NewPipeExtractorDart.safeExecute(
        "searchYoutubeMusic", {"query": query, "filters": filters});
    final parsedList = _parseSearchResults(info);
    return YoutubeMusicSearch(
        query: query,
        searchVideos: parsedList[0],
        searchPlaylists: parsedList[1],
        searchChannels: parsedList[2]);
  }

  /// Gets the next page of the current YoutubeMusicSearch Query
  Future<List<dynamic>> getNextMusicPage() async {
    final info = await NewPipeExtractorDart.safeExecute("getNextMusicPage");
    return _parseSearchResults(info);
  }

  List<dynamic> _parseSearchResults(info) {
    return StreamsParser.parseInfoItemListFromMap(info, singleList: false);
  }
}
