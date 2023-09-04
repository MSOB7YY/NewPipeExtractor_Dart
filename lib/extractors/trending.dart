import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/streamsParser.dart';

class TrendingExtractor {
  /// Returns a list of StreamInfoItem containing Trending Videos
  static Future<List<StreamInfoItem>> getTrendingVideos() async {
    final info = await NewPipeExtractorDart.safeExecute("getTrendingStreams");
    return StreamsParser.parseStreamListFromMap(info);
  }
}
