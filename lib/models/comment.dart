import 'package:newpipeextractor_dart/utils/stringChecker.dart';

class YoutubeComment {
  /// Comment Author
  final String? author;

  /// Full comment text
  final String? commentText;

  /// Comment upload date
  final String? uploadDate;

  /// Comment upload raw
  final DateTime? date;

  /// Author avatar image Url
  final String? uploaderAvatarUrl;

  /// Author channel url
  final String? uploaderUrl;

  /// Comment Id
  final String? commentId;

  final String? name;

  final String? thumbnailUrl;

  final String? url;

  /// Like Count
  final int? likeCount;

  /// Reply Count
  final int? replyCount;

  /// Total Comments Count
  final int? totalCommentsCount;

  /// Is comment hearted by the video Author
  final bool? hearted;

  /// Is comment pinned by the video Author
  final bool? pinned;

  const YoutubeComment({
    this.author,
    this.commentText,
    this.uploadDate,
    this.date,
    this.uploaderAvatarUrl,
    this.uploaderUrl,
    this.commentId,
    this.name,
    this.thumbnailUrl,
    this.url,
    this.likeCount,
    this.replyCount,
    this.totalCommentsCount,
    this.hearted,
    this.pinned,
  });

  factory YoutubeComment.fromMap(Map<dynamic, dynamic> map) {
    return YoutubeComment(
      author: map['author'],
      commentText: map['commentText'],
      uploadDate: map['uploadDate'],
      date: (map['date'] as String?)?.getDateTimeFromMSSEString(),
      uploaderAvatarUrl: map['uploaderAvatarUrl'],
      uploaderUrl: map['uploaderUrl'],
      commentId: map['commentId'],
      name: map['name'],
      thumbnailUrl: map['thumbnailUrl'],
      url: map['url'],
      likeCount: int.tryParse(map['likeCount'] ?? ''),
      replyCount: int.tryParse(map['replyCount'] ?? ''),
      totalCommentsCount: int.tryParse(map['totalCommentsCount'] ?? ''),
      hearted: (map['hearted'] as String?)?.checkTrue(),
      pinned: (map['pinned'] as String?)?.checkTrue(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'commentText': commentText,
      'uploadDate': uploadDate,
      'date': date?.millisecondsSinceEpoch.toString(),
      'uploaderAvatarUrl': uploaderAvatarUrl,
      'uploaderUrl': uploaderUrl,
      'commentId': commentId,
      'name': name,
      'thumbnailUrl': thumbnailUrl,
      'url': url,
      'likeCount': likeCount.toString(),
      'replyCount': replyCount.toString(),
      'totalCommentsCount': totalCommentsCount.toString(),
      'hearted': hearted.toString(),
      'pinned': pinned.toString(),
    };
  }
}
