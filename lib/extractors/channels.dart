import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/httpClient.dart';
import 'package:newpipeextractor_dart/utils/streamsParser.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';
import 'package:html/parser.dart' as parser;
import 'package:http/http.dart' as http;

class ChannelExtractor {
  /// Retrieve all ChannelInfo and
  /// build it into our own Model
  static Future<YoutubeChannel> channelInfo(String? url) async {
    StringChecker.ensureGoodLink(url);

    final channel = await NewPipeExtractorDart.safeExecute(
        'getChannel', {"channelUrl": url});
    return YoutubeChannel.fromMap(channel);
  }

  /// Retrieve uploads from a Channel URL
  static Future<List<StreamInfoItem>> getChannelUploads(String url) async {
    StringChecker.ensureGoodLink(url);

    final info = NewPipeExtractorDart.safeExecute(
        'getChannelUploads', {"channelUrl": url});
    return StreamsParser.parseStreamListFromMap(info);
  }

  /// Retrieve next page from channel uploads
  static Future<List<StreamInfoItem>> getChannelNextUploads() async {
    final info = await NewPipeExtractorDart.safeExecute('getChannelNextPage');
    return StreamsParser.parseStreamListFromMap(info);
  }

  /// Retrieve high quality Channel Avatar URL
  static Future<String?> getAvatarUrl(String channelId) async {
    var url = 'https://www.youtube.com/channel/$channelId?hl=en';
    var client = http.Client();
    var response = await client.get(Uri.parse(url),
        headers: ExtractorHttpClient.defaultHeaders);
    var raw = response.body;
    return parser
        .parse(raw)
        .querySelector('meta[property="og:image"]')
        ?.attributes['content'];
  }
}
