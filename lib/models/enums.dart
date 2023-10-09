enum PlaylistType {
  /// A normal playlist (not a mix)
  normal,

  /// A mix made only of streams related to a particular stream, for example YouTube mixes
  mixStream,

  /// A mix made only of music streams related to a particular stream, for example YouTube
  /// music mixes
  mixMusic,

  /// A mix made only of streams from (or related to) the same channel, for example YouTube
  /// channel mixes
  mixChannel,

  /// A mix made only of streams related to a particular (musical) genre, for example YouTube
  /// genre mixes
  mixGenre,
}

enum VideoPrivacy {
  public,
  unlisted,
  private,
  internal,
  other,
}

extension EnumUtils<E> on List<E> {
  E getEnum(String? string) => firstWhere(
        (element) =>
            element.toString().split('.').last.toLowerCase() ==
            string?.toLowerCase().replaceAll('_', ''),
        orElse: () => first,
      );
}
