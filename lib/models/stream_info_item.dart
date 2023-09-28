import 'dart:convert';

import 'package:newpipeextractor_dart/models/yt_feed.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';
import 'package:newpipeextractor_dart/models/thumbnails.dart';

class StreamInfoItem extends YoutubeFeed {
  /// Video URL
  final String? url;

  /// Video ID
  final String? id;

  /// Video name
  final String? name;

  /// Video uploader Name
  final String? uploaderName;

  /// Video uploader channel url
  final String? uploaderUrl;

  /// Video uploader avatar url
  final String? uploaderAvatarUrl;

  final String? thumbnailUrl;

  /// Video full date
  final DateTime? date;

  final String? textualUploadDate;

  final bool? isDateApproximation;

  /// Video duration
  final Duration? duration;

  /// Video view count
  final int? viewCount;

  /// uploader is verified
  final bool? isUploaderVerified;

  final bool? isShortFormContent;

  final String? shortDescription;

  const StreamInfoItem({
    required this.url,
    required this.id,
    required this.name,
    required this.uploaderName,
    required this.uploaderUrl,
    required this.uploaderAvatarUrl,
    required this.thumbnailUrl,
    required this.date,
    required this.textualUploadDate,
    required this.isDateApproximation,
    required this.duration,
    required this.viewCount,
    required this.isUploaderVerified,
    required this.isShortFormContent,
    required this.shortDescription,
  });

  /// Stream Thumbnails
  StreamThumbnail? get thumbnails => id == null ? null : StreamThumbnail(id);

  /// Gets full YoutubeVideo containing more Information and
  /// all necessary streams for Streaming and Downloading
  // Future<YoutubeVideo> get getVideo async {
  //   return await VideoExtractor.getStream(url);
  // }

  // /// Obtains the full information of the authors Channel
  // /// into a YoutubeChannel object
  // Future<YoutubeChannel> get getChannel async {
  //   return await ChannelExtractor.channelInfo(uploaderUrl);
  // }

  /// Transform object toMap
  Map<String, String?> toMap() {
    return {
      'url': url,
      'id': id,
      'name': name,
      'uploaderName': uploaderName,
      'uploaderUrl': uploaderUrl,
      'uploaderAvatarUrl': uploaderAvatarUrl,
      'thumbnailUrl': thumbnailUrl,
      'date': date?.millisecondsSinceEpoch.toString(),
      'textualUploadDate': textualUploadDate,
      'isDateApproximation': isDateApproximation.toString(),
      'duration': duration?.inSeconds.toString(),
      'viewCount': viewCount.toString(),
      'isUploaderVerified': isUploaderVerified.toString(),
      'isShortFormContent': isShortFormContent.toString(),
      'shortDescription': shortDescription,
    };
  }

  /// Get StreamInfoItem object fromMap
  factory StreamInfoItem.fromMap(Map<dynamic, dynamic> map) {
    return StreamInfoItem(
      url: map['url'],
      id: map['id'],
      name: map['name'],
      uploaderName: map['uploaderName'],
      uploaderUrl: map['uploaderUrl'],
      uploaderAvatarUrl: map['uploaderAvatarUrl'],
      thumbnailUrl: map['thumbnailUrl'],
      date: (map['date'] as String?)?.getDateTimeFromMSSEString(),
      textualUploadDate: map['textualUploadDate'],
      isDateApproximation: (map["isDateApproximation"] as String?)?.checkTrue(),
      duration: Duration(seconds: int.tryParse(map['duration'] ?? '') ?? 0),
      viewCount: int.tryParse(map['viewCount'] ?? ''),
      isUploaderVerified: (map['isUploaderVerified'] as String?)?.checkTrue(),
      isShortFormContent: (map['isShortFormContent'] as String?)?.checkTrue(),
      shortDescription: map['shortDescription'],
    );
  }

  /// Get a list of StreamInfoItem from a simple (valid) json String
  static List<StreamInfoItem> fromJsonString(String jsonString) {
    final Map<String, dynamic> decodedMap = jsonDecode(jsonString);
    final List<dynamic>? list = decodedMap['listStream'];
    if (list == null) return [];

    final List<StreamInfoItem> streams = [];
    for (final element in list) {
      final str = StreamInfoItem.fromMap(element);
      streams.add(str);
    }
    return streams;
  }

  /// Transform a list of StreamInfoItem into a simple json String
  static String listToJson(List<StreamInfoItem> list) {
    final List<Map<String, String?>> x = list.map((e) => e.toMap()).toList();
    Map<String, dynamic> map() => {'listStream': x};
    return jsonEncode(map());
  }
}
