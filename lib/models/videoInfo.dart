import 'package:newpipeextractor_dart/models/channel.dart';
import 'package:newpipeextractor_dart/models/enums.dart';
import 'package:newpipeextractor_dart/models/infoItems/video.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';

class VideoInfo {
  const VideoInfo({
    this.id,
    this.url,
    this.name,
    this.uploaderName,
    this.uploaderUrl,
    this.uploaderAvatarUrl,
    this.uploadDate,
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
    this.privacy,
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
  final String? uploadDate;

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
      uploadDate: map['uploadDate'],
      description: map['description'],
      duration: map['length'] == null
          ? null
          : Duration(seconds: int.tryParse(map['length']) ?? 0),
      viewCount:
          map['viewCount'] == null ? null : int.tryParse(map['viewCount']),
      likeCount:
          map['likeCount'] == null ? null : int.tryParse(map['likeCount']),
      dislikeCount: map['dislikeCount'] == null
          ? null
          : int.tryParse(map['dislikeCount']),
      category: map['category'],
      ageLimit: map['ageLimit'] == null ? null : int.tryParse(map['ageLimit']),
      thumbnailUrl: map['thumbnailUrl'],
      tags: map['tags'],
      isUploaderVerified: (map['isUploaderVerified'] as String?)?.checkTrue(),
      textualUploadDate: map['textualUploadDate'],
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
      'uploadDate': uploadDate,
      'description': description,
      'length': duration?.inSeconds.toString(),
      'viewCount': viewCount?.toString(),
      'dislikeCount': dislikeCount?.toString(),
      'category': category,
      'ageLimit': ageLimit.toString(),
      'thumbnailUrl': thumbnailUrl,
      'tags': tags,
      'isUploaderVerified': isUploaderVerified.toString(),
      'textualUploadDate': textualUploadDate,
      'privacy': privacy?.name,
    };
  }

  /// Generate a VideoInfo Item from StreamInfoItem
  static VideoInfo fromStreamInfoItem(StreamInfoItem item) {
    return VideoInfo(
      id: item.id,
      url: item.url,
      name: item.name,
      uploadDate: item.uploadDate,
      uploaderUrl: item.uploaderUrl,
      uploaderName: item.uploaderName,
      duration: item.duration,
      viewCount: item.viewCount,
      thumbnailUrl: item.thumbnails?.hqdefault,
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
