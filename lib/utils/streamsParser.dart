import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';

class StreamsParser {
  /// Retrieves a list of different types of InfoItems from the method channel response map
  static List<dynamic> parseInfoItemListFromMap(info,
      {required bool singleList}) {
    if (info == null) return [];
    if ((info as Map).containsKey("error")) {
      print(info["error"]);
      return [];
    }
    final streams = info['streams'] as Map?;
    final playlists = info['playlists'] as Map?;
    final channels = info['channels'] as Map?;

    final List<StreamInfoItem> listVideos =
        StreamsParser.parseStreamListFromMap(streams);

    final List<YoutubePlaylist> listPlaylists = [];
    playlists?.forEach((_, map) {
      listPlaylists.add(YoutubePlaylist.fromMap(Map.from(map)));
    });
    final List<YoutubeChannel> listChannels = [];
    channels?.forEach((_, map) {
      listChannels.add(YoutubeChannel.fromMap(Map.from(map)));
    });
    if (singleList) {
      return <dynamic>[...listPlaylists, ...listVideos];
    } else {
      return [listVideos, listPlaylists, listChannels];
    }
  }

  /// Retrieves a list of StreamInfoItem from the method channel response map
  static List<StreamInfoItem> parseStreamListFromMap(info) {
    final List<StreamInfoItem> streams = [];
    info?.forEach((_, map) {
      streams.add(StreamInfoItem.fromMap(Map.from(map)));
    });
    return streams;
  }

  /// Retrieves a list of StreamSegment from Map
  static List<StreamSegment> parseStreamSegmentListFromMap(info) {
    final List<StreamSegment> segments = <StreamSegment>[];
    info?.forEach((_, map) {
      segments.add(
        StreamSegment.fromMap(Map.from(map)),
      );
    });
    return segments;
  }
}
