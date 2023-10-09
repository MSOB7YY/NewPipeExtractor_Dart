enum AudioTrackType {
  /// An original audio track of the video.
  original,

  /// An audio track with the original voices replaced, typically in a different language.
  ///
  /// @see <a href="https://en.wikipedia.org/wiki/Dubbing">
  /// https://en.wikipedia.org/wiki/Dubbing</a>
  dubbed,

  /// A descriptive audio track.
  /// <p>
  /// A descriptive audio track is an audio track in which descriptions of visual elements of
  /// a video are added to the original audio, with the goal to make a video more accessible to
  /// blind and visually impaired people.
  /// </p>
  ///
  /// @see <a href="https://en.wikipedia.org/wiki/Audio_description">
  /// https://en.wikipedia.org/wiki/Audio_description</a>
  descriptive
}
