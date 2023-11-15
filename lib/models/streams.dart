import 'package:newpipeextractor_dart/models/audio_track_type.dart';
import 'package:newpipeextractor_dart/models/enums.dart';

typedef VideoOnlyStream = VideoStream;

class AudioOnlyStream extends _GeneralStream {
  final String? trackName;
  final AudioTrackType? trackType;
  final String? language;
  final String? displayLanguage;
  final String? languageTag;
  final String? country;
  final String? displayCountry;
  final String? script;
  final String? displayScript;

  AudioOnlyStream({
    required super.url,
    required super.id,
    required super.averageBitrate,
    required super.bitrate,
    required super.formatName,
    required super.formatSuffix,
    required super.formatMimeType,
    required super.qualityId,
    required super.codec,
    required super.quality,
    required super.durationMS,
    required super.samplerate,
    required super.sizeInBytes,
    required this.trackName,
    required this.trackType,
    required this.language,
    required this.displayLanguage,
    required this.languageTag,
    required this.country,
    required this.displayCountry,
    required this.script,
    required this.displayScript,
  });

  factory AudioOnlyStream.fromMap(Map<dynamic, dynamic> map) {
    final info = _GeneralStream.fromMap(map);
    return AudioOnlyStream(
      url: info.url,
      id: info.id,
      averageBitrate: info.averageBitrate,
      bitrate: info.bitrate,
      formatName: info.formatName,
      formatSuffix: info.formatSuffix,
      formatMimeType: info.formatMimeType,
      qualityId: info.qualityId,
      codec: info.codec,
      quality: info.quality,
      durationMS: info.durationMS,
      samplerate: info.samplerate,
      sizeInBytes: info.sizeInBytes,
      trackName: map["trackName"],
      trackType: AudioTrackType.values.getEnum(map['trackType']),
      language: map["language"],
      displayLanguage: map["displayLanguage"],
      languageTag: map["languageTag"],
      country: map["country"],
      displayCountry: map["displayCountry"],
      script: map["script"],
      displayScript: map["displayScript"],
    );
  }
}

class VideoStream extends _GeneralStream {
  final String? resolution;
  final int? fps;
  final int? height;
  final int? width;

  VideoStream({
    required this.resolution,
    required this.fps,
    required this.height,
    required this.width,
    required super.url,
    required super.id,
    required super.averageBitrate,
    required super.bitrate,
    required super.formatName,
    required super.formatSuffix,
    required super.formatMimeType,
    required super.qualityId,
    required super.codec,
    required super.quality,
    required super.durationMS,
    required super.samplerate,
    required super.sizeInBytes,
  });

  factory VideoStream.fromMap(Map<dynamic, dynamic> map) {
    final info = _GeneralStream.fromMap(map);
    return VideoStream(
      resolution: map['resolution'],
      fps: int.tryParse(map['fps'] ?? ''),
      height: int.tryParse(map['height'] ?? ''),
      width: int.tryParse(map['width'] ?? ''),
      url: info.url,
      id: info.id,
      averageBitrate: info.averageBitrate,
      bitrate: info.bitrate,
      formatName: info.formatName,
      formatSuffix: info.formatSuffix,
      formatMimeType: info.formatMimeType,
      qualityId: info.qualityId,
      codec: info.codec,
      quality: info.quality,
      durationMS: info.durationMS,
      samplerate: info.samplerate,
      sizeInBytes: info.sizeInBytes,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    final initial = super.toMap();
    initial['resolution'] = resolution.toString();
    initial['fps'] = fps.toString();
    initial['height'] = height.toString();
    initial['width'] = width.toString();
    return initial;
  }
}

class _GeneralStream {
  final String? url;
  final String? id;
  final int averageBitrate;
  final int? bitrate;
  final String? formatName;
  final String? formatSuffix;
  final String? formatMimeType;
  final String? qualityId;
  final String? codec;
  final String? quality;
  final int? durationMS;
  final int? samplerate;
  int? sizeInBytes;

  _GeneralStream({
    required this.url,
    required this.id,
    required this.averageBitrate,
    required this.bitrate,
    required this.formatName,
    required this.formatSuffix,
    required this.formatMimeType,
    required this.qualityId,
    required this.codec,
    required this.quality,
    required this.durationMS,
    required this.samplerate,
    required this.sizeInBytes,
  });

  factory _GeneralStream.fromMap(Map<dynamic, dynamic> map) {
    return _GeneralStream(
      url: map['url'],
      id: map['id'],
      averageBitrate: int.tryParse(map['averageBitrate'] ?? '') ?? 0,
      bitrate: int.tryParse(map['bitrate'] ?? ''),
      formatName: map['formatName'],
      formatSuffix: map['formatSuffix'],
      formatMimeType: map['formatMimeType'],
      qualityId: map['qualityId'],
      codec: map['codec'],
      quality: map['quality'],
      durationMS: int.tryParse(map['durationMS'] ?? ''),
      samplerate: int.tryParse(map['samplerate'] ?? ''),
      sizeInBytes: int.tryParse(map['length'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
      'id': id,
      'averageBitrate': averageBitrate.toString(),
      'bitrate': bitrate.toString(),
      'formatName': formatName,
      'formatSuffix': formatSuffix,
      'formatMimeType': formatMimeType,
      'qualityId': qualityId,
      'codec': codec,
      'quality': quality,
      'durationMS': durationMS.toString(),
      'samplerate': samplerate.toString(),
      'length': sizeInBytes.toString(),
    };
  }

  String get bitrateText => "${(bitrate ?? 0) ~/ 1000} kb/s";

  double get totalKiloBytes => (sizeInBytes ?? 0) / 1024;

  double get totalMegaBytes => totalKiloBytes / 1024;

  double get totalGigaBytes => totalMegaBytes / 1024;
}
