library newpipeextractor_dart;

import 'package:flutter/services.dart';

import 'package:newpipeextractor_dart/extractors/channels.dart';
import 'package:newpipeextractor_dart/extractors/comments.dart';
import 'package:newpipeextractor_dart/extractors/playlist.dart';
import 'package:newpipeextractor_dart/extractors/search.dart';
import 'package:newpipeextractor_dart/extractors/trending.dart';
import 'package:newpipeextractor_dart/extractors/videos.dart';
import 'package:newpipeextractor_dart/utils/httpClient.dart';
import 'package:newpipeextractor_dart/utils/reCaptcha.dart';
import 'package:newpipeextractor_dart/utils/url.dart';

// Models
export 'models/channel.dart';
export 'models/comment.dart';
export 'models/filters.dart';
export 'models/playlist.dart';
export 'models/search.dart';
export 'models/video.dart';
export 'models/streamSegment.dart';
export 'models/enums.dart';
export 'models/streams.dart';
export 'models/videoInfo.dart';
export 'models/thumbnails.dart';

// InfoItems
export 'models/stream_info_item.dart';
export 'models/yt_feed.dart';

class NewPipeExtractorDart {
  static VideoExtractor get videos => VideoExtractor.instance;
  static ChannelExtractor get channels => ChannelExtractor.instance;
  static TrendingExtractor get trending => TrendingExtractor.instance;
  static PlaylistExtractor get playlists => PlaylistExtractor.instance;
  static SearchExtractor get search => SearchExtractor.instance;
  static CommentsExtractor get comments => CommentsExtractor.instance;
  static ExtractorHttpClient get httpClient => ExtractorHttpClient.instance;
  static YoutubeIDUtils get idUtils => YoutubeIDUtils.instance;

  static const MethodChannel _extractorChannel =
      MethodChannel('newpipeextractor_dart');

  static Future<dynamic> execute(String method, [dynamic arguments]) async {
    return await _extractorChannel.invokeMethod(method, arguments);
  }

  static Future<dynamic> safeExecute(String method, [dynamic arguments]) async {
    Future<T?> task<T>() => _extractorChannel.invokeMethod(method, arguments);
    var info = await task();
    // Check if we got reCaptcha needed response
    info = await ReCaptchaPage.checkInfo(info, task);
    return info;
  }
}
