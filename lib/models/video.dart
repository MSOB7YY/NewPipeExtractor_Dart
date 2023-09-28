import 'package:newpipeextractor_dart/exceptions/streamIsNull.dart';
import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';

class YoutubeVideo {
  /// Video Information
  final VideoInfo videoInfo;

  /// Video Only Streams
  final List<VideoOnlyStream>? videoOnlyStreams;

  /// Audio Only Streams
  final List<AudioOnlyStream>? audioOnlyStreams;

  /// Video Streams (Muxed, Video + Audio)
  final List<VideoStream>? videoStreams;

  // Video Segments
  final List<StreamSegment>? segments;

  const YoutubeVideo({
    required this.videoInfo,
    this.videoOnlyStreams,
    this.audioOnlyStreams,
    this.videoStreams,
    this.segments,
  });

  /// Transform this object into a StreamInfoItem which is smaller and
  /// allows saving or transporting it via Strings
  StreamInfoItem toStreamInfoItem() {
    return StreamInfoItem(
      url: videoInfo.url,
      id: videoInfo.id,
      name: videoInfo.name,
      uploaderName: videoInfo.uploaderName,
      uploaderUrl: videoInfo.uploaderUrl,
      uploaderAvatarUrl: videoInfo.uploaderAvatarUrl,
      date: videoInfo.date,
      isDateApproximation: videoInfo.isDateApproximation,
      viewCount: videoInfo.viewCount,
      isUploaderVerified: videoInfo.isUploaderVerified,
      duration: videoInfo.duration,
      shortDescription: videoInfo.description,
      isShortFormContent: videoInfo.isShortFormContent,
      textualUploadDate: videoInfo.textualUploadDate,
      thumbnailUrl: videoInfo.thumbnailUrl,
    );
  }

  /// If an instance of this object has no streams (Information only)
  /// then, this function will retrieve those streams and return a new
  /// [YoutubeVideo] object
  Future<YoutubeVideo> get getStreams async =>
      await NewPipeExtractorDart.videos.getStream(videoInfo.url);

  /// Gets the best quality video only stream
  /// (By resolution, fps is not taken in consideration)
  VideoOnlyStream? get videoOnlyWithHighestQuality {
    if (videoOnlyStreams == null) {
      throw const StreamIsNull("Tried to access a null VideoOnly stream");
    }
    VideoOnlyStream? video;
    for (int i = 0; i < videoOnlyStreams!.length; i++) {
      if (video == null) {
        video = videoOnlyStreams![i];
      } else {
        final int curRes = int.parse(video.resolution!.split("p").first);
        final int newRes =
            int.parse(videoOnlyStreams![i].resolution!.split("p").first);
        if (curRes < newRes) {
          video = videoOnlyStreams![i];
        }
      }
    }
    return video;
  }

  /// Gets the best quality video stream
  /// (By resolution, fps is not taken in consideration)
  VideoStream? get videoWithHighestQuality {
    if (videoStreams == null) {
      throw const StreamIsNull("Tried to access a null Video stream");
    }
    VideoStream? video;
    for (int i = 0; i < videoStreams!.length; i++) {
      if (video == null) {
        video = videoStreams![i];
      } else {
        final curRes = int.parse(video.resolution!.split("p").first);
        final newRes = int.parse(videoStreams![i].resolution!.split("p").first);
        if (curRes < newRes) {
          video = videoStreams![i];
        }
      }
    }
    return video;
  }

  /// Gets the best quality audio stream by Bitrate
  AudioOnlyStream? get audioWithHighestQuality {
    if (audioOnlyStreams == null) {
      throw const StreamIsNull("Tried to access a null Audio stream");
    }
    AudioOnlyStream? audio;
    for (int i = 0; i < audioOnlyStreams!.length; i++) {
      if (audio == null) {
        audio = audioOnlyStreams![i];
      } else {
        final curBitrate = audio.averageBitrate;
        final newBitrate = audioOnlyStreams![i].averageBitrate;
        if (curBitrate < newBitrate) {
          audio = audioOnlyStreams![i];
        }
      }
    }
    return audio;
  }

  /// Gets the best AAC format audio stream
  AudioOnlyStream? get audioWithBestAacQuality {
    if (audioOnlyStreams == null) {
      throw const StreamIsNull("Tried to access a null Audio stream");
    }
    final List<AudioOnlyStream> newList = [];
    for (final element in audioOnlyStreams!) {
      if (element.formatName == "m4a") {
        newList.add(element);
      }
    }
    if (newList.isEmpty) {
      return audioWithHighestQuality;
    }
    AudioOnlyStream? audio;
    for (int i = 0; i < newList.length; i++) {
      if (audio == null) {
        audio = newList[i];
      } else {
        final curBitrate = audio.averageBitrate;
        final newBitrate = newList[i].averageBitrate;
        if (curBitrate < newBitrate) {
          audio = newList[i];
        }
      }
    }
    return audio;
  }

  /// Gets the best OGG format audio stream
  AudioOnlyStream? get audioWithBestOggQuality {
    if (audioOnlyStreams == null) {
      throw const StreamIsNull("Tried to access a null Audio stream");
    }
    final List<AudioOnlyStream> newList = [];
    for (final element in audioOnlyStreams!) {
      if (element.formatName == "webm") {
        newList.add(element);
      }
    }
    if (newList.isEmpty) {
      return audioWithHighestQuality;
    }
    AudioOnlyStream? audio;
    for (int i = 0; i < newList.length; i++) {
      if (audio == null) {
        audio = newList[i];
      } else {
        final curBitrate = audio.averageBitrate;
        final newBitrate = newList[i].averageBitrate;
        if (curBitrate < newBitrate) {
          audio = newList[i];
        }
      }
    }
    return audio;
  }

  /// Get the best audio stream for the specified video stream
  /// taking in consideration the video stream format
  /// (MP4 supports AAC codec while WEBM supports OGG codec)
  AudioOnlyStream? getAudioStreamWithBestMatchForVideoStream(
      VideoOnlyStream stream) {
    if (stream.formatSuffix == "mp4") {
      return audioWithBestAacQuality;
    } else if (stream.formatSuffix == "webm") {
      return audioWithBestOggQuality;
    } else {
      return null;
    }
  }
}
