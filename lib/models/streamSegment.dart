/// Some videos might be segmented, if that is the case this
/// class will define the properties of each segment a stream contains
class StreamSegment {
  final String? url;
  final String? title;
  final String? previewUrl;
  final int startTimeSeconds;

  const StreamSegment({
    required this.url,
    required this.title,
    required this.previewUrl,
    required this.startTimeSeconds,
  });

  factory StreamSegment.fromMap(Map<dynamic, dynamic> map) {
    return StreamSegment(
      url: map['url'],
      title: map['title'],
      previewUrl: map['previewUrl'],
      startTimeSeconds: int.tryParse(map['startTimeSeconds'] ?? '') ?? 0,
    );
  }
}
