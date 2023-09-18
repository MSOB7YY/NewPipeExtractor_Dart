import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';

class YoutubeIDUtils {
  static YoutubeIDUtils get instance => _instance;
  static final YoutubeIDUtils _instance = YoutubeIDUtils._internal();
  YoutubeIDUtils._internal();

  /// Get ID from any Stream URL, return [null] on failure
  Future<String?> getIdFromStreamUrl(String? url) async {
    StringChecker.ensureGoodLink(url);

    final id = await NewPipeExtractorDart.execute(
        'getIdFromStreamUrl', {"streamUrl": url});
    return id['id'] == "" ? null : id['id'];
  }

  /// Get ID from any Playlist URL, return [null] on failure
  Future<String?> getIdFromPlaylistUrl(String? url) async {
    StringChecker.ensureGoodLink(url);

    final id = await NewPipeExtractorDart.execute(
        'getIdFromPlaylistUrl', {"playlistUrl": url});
    return id['id'] == "" ? null : id['id'];
  }

  /// Get ID from any Channel URL, return [null] on failure
  Future<String?> getIdFromChannelUrl(String? url) async {
    StringChecker.ensureGoodLink(url);

    final id = await NewPipeExtractorDart.execute(
        'getIdFromChannelUrl', {"channelUrl": url});
    return id['id'] == "" ? null : id['id'];
  }
}
