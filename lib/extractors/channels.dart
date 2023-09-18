import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/httpClient.dart';
import 'package:newpipeextractor_dart/utils/streamsParser.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class ChannelExtractor {
  static ChannelExtractor get instance => _instance;
  static final ChannelExtractor _instance = ChannelExtractor._internal();
  ChannelExtractor._internal();

  /// Retrieve all ChannelInfo and
  /// build it into our own Model
  Future<YoutubeChannel> channelInfo(String? url) async {
    StringChecker.ensureGoodLink(url);

    final channel = await NewPipeExtractorDart.safeExecute(
        'getChannel', {"channelUrl": url});
    return YoutubeChannel.fromMap(channel);
  }

  /// Retrieve uploads from a Channel URL
  Future<List<StreamInfoItem>> getChannelUploads(String url) async {
    StringChecker.ensureGoodLink(url);

    final info = NewPipeExtractorDart.safeExecute(
        'getChannelUploads', {"channelUrl": url});
    return StreamsParser.parseStreamListFromMap(info);
  }

  /// Retrieve next page from channel uploads
  Future<List<StreamInfoItem>> getChannelNextUploads() async {
    final info = await NewPipeExtractorDart.safeExecute('getChannelNextPage');
    return StreamsParser.parseStreamListFromMap(info);
  }

  /// Retrieve high quality Channel Avatar URL
  Future<String?> getAvatarUrl(String channelId) async {
    final url = 'https://www.youtube.com/channel/$channelId?hl=en';
    final client = http.Client();
    final response = await client.get(Uri.parse(url),
        headers: ExtractorHttpClient.defaultHeaders);
    final raw = response.body;
    return parser
        .parse(raw)
        .querySelector('meta[property="og:image"]')
        ?.attributes['content'];
  }
}
