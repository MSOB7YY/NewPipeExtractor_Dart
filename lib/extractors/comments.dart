import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';

class CommentsExtractor {
  static Future<List<YoutubeComment>> getComments(String? videoUrl) async {
    StringChecker.ensureGoodLink(videoUrl);

    final info = await NewPipeExtractorDart.safeExecute(
        'getComments', {"videoUrl": videoUrl});

    return _parseCommentsResponse(info);
  }

  static Future<List<YoutubeComment>> getNextComments() async {
    final info = await NewPipeExtractorDart.safeExecute('getCommentsNextPage');

    return _parseCommentsResponse(info);
  }

  static List<YoutubeComment> _parseCommentsResponse(dynamic info) {
    final comments = <YoutubeComment>[];
    info?.forEach((key, map) {
      comments.add(YoutubeComment.fromMap(map));
    });
    return comments;
  }
}
