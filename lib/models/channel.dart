import 'dart:convert';

import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';

class YoutubeChannel extends YoutubeFeed {
  /// Channel URL
  final String? url;

  /// Channel name
  final String? name;

  /// Channel description
  final String? description;

  /// Channel avatar url
  final String? thumbnailUrl;

  /// Channel subscriber count
  final int? subscriberCount;

  /// Channel number of videos uploaded
  final int streamCount;

  /// Channel Id
  final String? id;

  /// Channel avatar image Url
  final String? avatarUrl;

  /// Channel banner image Url
  final String? bannerUrl;

  /// Channel feed Url
  final String? feedUrl;

  final bool? isVerified;

  const YoutubeChannel({
    required this.url,
    required this.name,
    required this.description,
    required this.thumbnailUrl,
    required this.subscriberCount,
    required this.streamCount,
    this.id,
    this.avatarUrl,
    this.bannerUrl,
    this.feedUrl,
    this.isVerified,
  });

  /// Obtains the full information of the channel
  /// into a YoutubeChannel object
  // Future<YoutubeChannel> get getChannel async {
  //   return ChannelExtractor.channelInfo(url);
  // }

  /// Transform object toMap
  Map<dynamic, dynamic> toMap() {
    return {
      'url': url,
      'name': name,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'subscriberCount': subscriberCount.toString(),
      'streamCount': streamCount.toString(),
      'id': id,
      'avatarUrl': avatarUrl,
      'bannerUrl': bannerUrl,
      'feedUrl': feedUrl,
      'isVerified': isVerified.toString(),
    };
  }

  /// Get YoutubeChannel object fromMap
  static YoutubeChannel fromMap(Map<dynamic, dynamic> map) {
    return YoutubeChannel(
      url: map['url'],
      name: map['name'],
      description: map['description'],
      thumbnailUrl: map['thumbnailUrl'],
      subscriberCount: int.tryParse(map['subscriberCount'] ?? ''),
      streamCount: int.tryParse(map['streamCount'] ?? '') ?? 0,
      id: map['id'],
      avatarUrl: map['avatarUrl'],
      bannerUrl: map['bannerUrl'],
      feedUrl: map['feedUrl'],
      isVerified: (map['isVerified'] as String?).checkTrue(),
    );
  }

  /// Get a list of YoutubeChannel from a simple (valid) json String
  static List<YoutubeChannel> fromJsonString(String jsonString) {
    final Map<dynamic, dynamic> decodedMap = jsonDecode(jsonString);
    final List<dynamic>? list = decodedMap['listChannels'];
    final List<YoutubeChannel> channels = [];
    if (list == null) return [];
    for (final element in list) {
      final c = YoutubeChannel.fromMap(element);
      channels.add(c);
    }
    return channels;
  }

  /// Transform a list of YoutubeChannel to a simple json String
  static String listToJson(List<YoutubeChannel> list) {
    final x = list.map((e) => e.toMap()).toList();
    Map<String, dynamic> map() => {'listChannels': x};
    return jsonEncode(map());
  }
}
