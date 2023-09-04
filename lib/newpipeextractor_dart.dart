import 'package:flutter/services.dart';
import 'package:newpipeextractor_dart/utils/reCaptcha.dart';

// Models
export 'models/channel.dart';
export 'models/comment.dart';
export 'models/filters.dart';
export 'models/playlist.dart';
export 'models/search.dart';
export 'models/video.dart';
export 'models/streamSegment.dart';

// InfoItems
export 'models/infoItems/video.dart';

// Streams
export 'models/streams.dart';

class NewPipeExtractorDart {
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
