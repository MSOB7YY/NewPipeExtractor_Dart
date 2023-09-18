import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/streamsParser.dart';

class TrendingExtractor {
  static TrendingExtractor get instance => _instance;
  static final TrendingExtractor _instance = TrendingExtractor._internal();
  TrendingExtractor._internal();

  /// Returns a list of StreamInfoItem containing Trending Videos
  Future<List<StreamInfoItem>> getTrendingVideos() async {
    final info = await NewPipeExtractorDart.safeExecute("getTrendingStreams");
    return StreamsParser.parseStreamListFromMap(info);
  }
}
