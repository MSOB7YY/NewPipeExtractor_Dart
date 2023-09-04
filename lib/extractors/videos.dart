import 'package:newpipeextractor_dart/models/videoInfo.dart';
import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/streamsParser.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';

class VideoExtractor {
  /// This functions retrieves a full [YoutubeVideo] object which
  /// has all the information from that video including all Video,
  /// Audio and Muxed Streams (Muxed = Video + Audio)
  static Future<YoutubeVideo> getStream(String? videoUrl) async {
    StringChecker.ensureGoodLink(videoUrl);

    final info = await NewPipeExtractorDart.execute(
        "getVideoInfoAndStreams", {"videoUrl": videoUrl});
    final informationMap = info[0];

    final List<AudioOnlyStream> audioOnlyStreams = [];
    info[1].forEach((key, map) {
      audioOnlyStreams.add(AudioOnlyStream.fromMap(map));
    });

    final List<VideoOnlyStream> videoOnlyStreams = [];
    info[2].forEach((key, map) {
      videoOnlyStreams.add(VideoOnlyStream.fromMap(map));
    });

    final List<VideoStream> videoStreams = [];
    info[3].forEach((key, map) {
      videoStreams.add(VideoStream.fromMap(map));
    });

    return YoutubeVideo(
        videoInfo: VideoInfo.fromMap(Map<String, dynamic>.from(informationMap)),
        videoOnlyStreams: videoOnlyStreams,
        audioOnlyStreams: audioOnlyStreams,
        videoStreams: videoStreams,
        segments: StreamsParser.parseStreamSegmentListFromMap(info[4]));
  }

  /// Retrieve only the Video Information
  static Future<VideoInfo?> getInfo(String videoUrl) async {
    StringChecker.ensureGoodLink(videoUrl);

    final informationMap = await NewPipeExtractorDart.safeExecute(
        "getVideoInformation", {"videoUrl": videoUrl});
    if (informationMap == null) return null;
    return VideoInfo.fromMap(Map<String, dynamic>.from(informationMap));
  }

  /// Retrieve all Streams into a dynamic List with the following order:
  ///
  /// [0] VideoOnlyStreams
  /// [1] AudioOnlyStreams
  /// [2] VideoStreams
  ///
  static Future<List<dynamic>?> getMediaStreams(String videoUrl) async {
    StringChecker.ensureGoodLink(videoUrl);

    final info = await NewPipeExtractorDart.safeExecute(
        "getAllVideoStreams", {"videoUrl": videoUrl});
    return info;
  }

  /// Retrieve Video Only Streams
  static Future<List<VideoOnlyStream>> getVideoOnlyStreams(
      String videoUrl) async {
    StringChecker.ensureGoodLink(videoUrl);

    final info = await NewPipeExtractorDart.safeExecute(
        "getVideoOnlyStreams", {"videoUrl": videoUrl});
    final videoOnlyStreams = <VideoOnlyStream>[];
    info.forEach((key, map) {
      videoOnlyStreams.add(VideoOnlyStream.fromMap(map));
    });
    return videoOnlyStreams;
  }

  /// Retrieve Audio Only Streams
  static Future<List<AudioOnlyStream>> getAudioOnlyStreams(
      String videoUrl) async {
    StringChecker.ensureGoodLink(videoUrl);

    final info = await NewPipeExtractorDart.safeExecute(
        "getAudioOnlyStreams", {"videoUrl": videoUrl});
    final List<AudioOnlyStream> audioOnlyStreams = [];
    info.forEach((key, map) {
      audioOnlyStreams.add(AudioOnlyStream.fromMap(map));
    });
    return audioOnlyStreams;
  }

  /// Retrieve Video Streams (Muxed = Video + Audio)
  static Future<List<VideoStream>> getVideoStreams(String videoUrl) async {
    StringChecker.ensureGoodLink(videoUrl);

    final info = await NewPipeExtractorDart.safeExecute(
        "getVideoStreams", {"videoUrl": videoUrl});
    final List<VideoStream> videoStreams = [];
    info.forEach((key, map) {
      videoStreams.add(VideoStream.fromMap(map));
    });
    return videoStreams;
  }

  /// Retrieve related videos by URL
  static Future<List<dynamic>> getRelatedStreams(String videoUrl) async {
    StringChecker.ensureGoodLink(videoUrl);

    final info = await NewPipeExtractorDart.safeExecute(
        "getRelatedStreams", {"videoUrl": videoUrl});
    return StreamsParser.parseInfoItemListFromMap(info, singleList: true);
  }

  /// Retrieves all stream segments from video URL
  static Future<List<StreamSegment>> getStreamSegments(String videoUrl) async {
    StringChecker.ensureGoodLink(videoUrl);

    final info = await NewPipeExtractorDart.safeExecute(
        "getVideoSegments", {"videoUrl": videoUrl});
    return StreamsParser.parseStreamSegmentListFromMap(info);
  }
}
