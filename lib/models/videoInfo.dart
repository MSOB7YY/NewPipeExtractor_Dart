import 'package:newpipeextractor_dart/models/channel.dart';
import 'package:newpipeextractor_dart/models/enums.dart';
import 'package:newpipeextractor_dart/models/stream_info_item.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';

class VideoInfo {
  const VideoInfo({
    this.id,
    this.url,
    this.name,
    this.uploaderName,
    this.uploaderUrl,
    this.uploaderAvatarUrl,
    this.date,
    this.isDateApproximation,
    this.description,
    this.duration,
    this.viewCount,
    this.likeCount,
    this.dislikeCount,
    this.category,
    this.ageLimit,
    this.tags,
    this.thumbnailUrl,
    this.isUploaderVerified,
    this.textualUploadDate,
    this.uploaderSubscriberCount,
    this.privacy,
    this.isShortFormContent,
  });

  /// Video Id (ex: dQw4w9WgXcQ)
  final String? id;

  /// Video full Url (ex: https://www.youtube.com/watch?v=dQw4w9WgXcQ)
  final String? url;

  /// Video Title
  final String? name;

  /// Video uploader name (Channel name)
  final String? uploaderName;

  /// Url to the uploader Channel
  final String? uploaderUrl;

  /// Url to the uploader avatar image
  final String? uploaderAvatarUrl;

  /// Video upload date
  final DateTime? date;

  final bool? isDateApproximation;

  /// Video description
  final String? description;

  /// Video duration
  final Duration? duration;

  /// View Count
  final int? viewCount;

  /// Like Count
  final int? likeCount;

  /// Dislike Count
  final int? dislikeCount;

  /// Video category
  final String? category;

  /// Age limit (int)
  final int? ageLimit;

  /// Video Tags
  final String? tags;

  /// Video Thumbnail Url
  final String? thumbnailUrl;

  final bool? isUploaderVerified;

  final String? textualUploadDate;

  final int? uploaderSubscriberCount;

  final bool? isShortFormContent;

  final VideoPrivacy? privacy;

  /// Retrieve a new [VideoInfo] object from Map
  factory VideoInfo.fromMap(Map<String, dynamic> map) {
    return VideoInfo(
      id: map['id'],
      url: map['url'],
      name: map['name'],
      uploaderName: map['uploaderName'],
      uploaderAvatarUrl: map['uploaderAvatarUrl'],
      uploaderUrl: map['uploaderUrl'],
      date: (map['date'] as String?)?.getDateTimeFromMSSEString(),
      isDateApproximation: (map["isDateApproximation"] as String?)?.checkTrue(),
      description: map['description'],
      duration: map['length'] == null ? null : Duration(seconds: int.tryParse(map['length']) ?? 0),
      viewCount: map['viewCount'] == null ? null : int.tryParse(map['viewCount']),
      likeCount: map['likeCount'] == null ? null : int.tryParse(map['likeCount']),
      dislikeCount: map['dislikeCount'] == null ? null : int.tryParse(map['dislikeCount']),
      category: map['category'],
      ageLimit: map['ageLimit'] == null ? null : int.tryParse(map['ageLimit']),
      thumbnailUrl: map['thumbnailUrl'],
      tags: map['tags'],
      isUploaderVerified: (map['isUploaderVerified'] as String?)?.checkTrue(),
      isShortFormContent: (map['isShortFormContent'] as String?)?.checkTrue(),
      textualUploadDate: map['textualUploadDate'],
      uploaderSubscriberCount: int.tryParse(map['uploaderSubscriberCount'] ?? ''),
      privacy: VideoPrivacy.values.getEnum(map['privacy']),
    );
  }

  Map<String, String?> toMap() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'uploaderName': uploaderName,
      'uploaderAvatarUrl': uploaderAvatarUrl,
      'uploaderUrl': uploaderUrl,
      'date': date?.millisecondsSinceEpoch.toString(),
      'isDateApproximation': isDateApproximation.toString(),
      'description': description,
      'length': duration?.inSeconds.toString(),
      'viewCount': viewCount?.toString(),
      'likeCount': likeCount?.toString(),
      'dislikeCount': dislikeCount?.toString(),
      'category': category,
      'ageLimit': ageLimit.toString(),
      'thumbnailUrl': thumbnailUrl,
      'tags': tags,
      'isUploaderVerified': isUploaderVerified.toString(),
      'isShortFormContent': isShortFormContent.toString(),
      'textualUploadDate': textualUploadDate,
      'uploaderSubscriberCount': uploaderSubscriberCount.toString(),
      'privacy': privacy?.name,
    };
  }

  /// Generate a VideoInfo Item from StreamInfoItem
  static VideoInfo fromStreamInfoItem(StreamInfoItem item) {
    return VideoInfo(
      id: item.id,
      url: item.url,
      name: item.name,
      date: item.date,
      uploaderUrl: item.uploaderUrl,
      uploaderName: item.uploaderName,
      duration: item.duration,
      viewCount: item.viewCount,
      thumbnailUrl: item.thumbnails?.hqdefault,
      description: item.shortDescription,
      uploaderAvatarUrl: item.uploaderAvatarUrl,
      isUploaderVerified: item.isUploaderVerified,
    );
  }

  /// Generate a ChannelInfoItem from this video details
  YoutubeChannel getChannel() {
    return YoutubeChannel(
      url: uploaderUrl,
      name: uploaderName,
      description: '',
      thumbnailUrl: uploaderAvatarUrl,
      subscriberCount: null,
      streamCount: -1,
    );
  }
}
