// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:newpipeextractor_dart/newpipeextractor_dart.dart';
import 'package:newpipeextractor_dart/utils/stringChecker.dart';

class YoutubePlaylist extends YoutubeFeed {
  /// Playlist ID
  final String? id;

  /// Playlist name
  final String? name;

  /// Playlist full URL
  final String? url;

  /// Playlist authors name
  final String? uploaderName;

  /// Playlist author avatar url
  final String? uploaderAvatarUrl;

  /// Playlist channel url
  final String? uploaderUrl;

  /// Playlist banner url
  final String? bannerUrl;

  /// Playlist thumbnail url
  final String? thumbnailUrl;

  /// Playlist videos ammount
  final int streamCount;

  final PlaylistType? playlistType;

  final bool? isUploaderVerified;

  final String? description;

  /// Playlist streams (Videos)
  final List<StreamInfoItem> streams;

  YoutubePlaylist({
    required this.id,
    required this.name,
    required this.url,
    required this.uploaderName,
    required this.uploaderAvatarUrl,
    required this.uploaderUrl,
    required this.bannerUrl,
    required this.thumbnailUrl,
    required this.streamCount,
    required this.playlistType,
    required this.isUploaderVerified,
    required this.description,
    this.streams = const <StreamInfoItem>[],
  });

  /// Transform this object into a PlaylistInfoItem which is smaller and
  /// allows saving or transporting it via Strings
  // PlaylistInfoItem toPlaylistInfoItem() {
  //   return PlaylistInfoItem(
  //     url,
  //     name,
  //     uploaderName,
  //     thumbnailUrl,
  //     streamCount,
  //   );
  // }

  bool _fetchingStreams = false;
  bool _fetchingStreamsNextPage = false;

  /// Retrieve this Playlist list of streams (List of StreamInfoItem).
  ///
  /// Calling this after [getStreamsNextPage] means that
  /// all streams that were fetched inside [streams] will be cleared.
  Future<List<StreamInfoItem>> getStreams() async {
    if (!_fetchingStreams) {
      _fetchingStreams = true;
      final s = await NewPipeExtractorDart.playlists.getPlaylistStreams(url);
      streams
        ..clear()
        ..addAll(s);
      _fetchingStreams = false;
      return s;
    }
    return [];
  }

  /// This will fetch the next streams, or initial if there was none before
  ///
  /// i.e. no need to call [getStreams] first.
  Future<List<StreamInfoItem>> getStreamsNextPage() async {
    if (!_fetchingStreamsNextPage) {
      _fetchingStreamsNextPage = true;
      final s =
          await NewPipeExtractorDart.playlists.getPlaylistStreamsNextPage(url);
      streams.addAll(s);
      _fetchingStreamsNextPage = false;
      return s;
    }
    return [];
  }

  YoutubePlaylist copyWith({
    String? id,
    String? name,
    String? url,
    String? uploaderName,
    String? uploaderAvatarUrl,
    String? uploaderUrl,
    String? bannerUrl,
    String? thumbnailUrl,
    int? streamCount,
    List<StreamInfoItem>? streams,
    PlaylistType? playlistType,
    bool? isUploaderVerified,
    String? description,
  }) {
    return YoutubePlaylist(
      id: id ?? this.id,
      name: name ?? this.name,
      url: url ?? this.url,
      uploaderName: uploaderName ?? this.uploaderName,
      uploaderAvatarUrl: uploaderAvatarUrl ?? this.uploaderAvatarUrl,
      uploaderUrl: uploaderUrl ?? this.uploaderUrl,
      bannerUrl: bannerUrl ?? this.bannerUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      streamCount: streamCount ?? this.streamCount,
      streams: streams ?? this.streams,
      playlistType: playlistType ?? this.playlistType,
      isUploaderVerified: isUploaderVerified ?? this.isUploaderVerified,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'url': url,
      'uploaderName': uploaderName,
      'uploaderAvatarUrl': uploaderAvatarUrl,
      'uploaderUrl': uploaderUrl,
      'bannerUrl': bannerUrl,
      'thumbnailUrl': thumbnailUrl,
      'streamCount': streamCount,
      'streams': streams.map((x) => x.toMap()).toList(),
      'playlistType': playlistType?.name,
      'isUploaderVerified': isUploaderVerified.toString(),
      'description': description,
    };
  }

  factory YoutubePlaylist.fromMap(Map<String, dynamic> map) {
    return YoutubePlaylist(
      id: map['id'] as String?,
      name: map['name'] as String?,
      url: map['url'] as String?,
      uploaderName: map['uploaderName'] as String?,
      uploaderAvatarUrl: map['uploaderAvatarUrl'] as String?,
      uploaderUrl: map['uploaderUrl'] as String?,
      bannerUrl: map['bannerUrl'] as String?,
      thumbnailUrl: map['thumbnailUrl'] as String?,
      streamCount: int.tryParse(map['streamCount'] ?? '') ?? 0,
      streams: List<StreamInfoItem>.from(
        (map['streams'] as List?)?.map(
                (x) => StreamInfoItem.fromMap(x as Map<String, dynamic>)) ??
            [],
      ),
      playlistType: PlaylistType.values.getEnum(map['playlistType']),
      isUploaderVerified: (map['isUploaderVerified'] as String?)?.checkTrue(),
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory YoutubePlaylist.fromJson(String source) =>
      YoutubePlaylist.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'YoutubePlaylist(id: $id, name: $name, url: $url, uploaderName: $uploaderName, uploaderAvatarUrl: $uploaderAvatarUrl, uploaderUrl: $uploaderUrl, bannerUrl: $bannerUrl, thumbnailUrl: $thumbnailUrl, streamCount: $streamCount, streams: $streams, playlistType: $playlistType, description: $description, isUploaderVerified: $isUploaderVerified)';
  }

  @override
  bool operator ==(covariant YoutubePlaylist other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.url == url &&
        other.uploaderName == uploaderName &&
        other.uploaderAvatarUrl == uploaderAvatarUrl &&
        other.uploaderUrl == uploaderUrl &&
        other.bannerUrl == bannerUrl &&
        other.thumbnailUrl == thumbnailUrl &&
        other.streamCount == streamCount &&
        listEquals(other.streams, streams);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        url.hashCode ^
        uploaderName.hashCode ^
        uploaderAvatarUrl.hashCode ^
        uploaderUrl.hashCode ^
        bannerUrl.hashCode ^
        thumbnailUrl.hashCode ^
        streamCount.hashCode ^
        streams.hashCode;
  }
}
