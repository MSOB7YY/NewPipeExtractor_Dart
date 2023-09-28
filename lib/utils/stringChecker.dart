import 'package:newpipeextractor_dart/exceptions/badUrlException.dart';

class StringChecker {
  static bool hasWhiteSpace(String string) {
    if (string.trim().contains(' ')) {
      return true;
    } else {
      return false;
    }
  }

  static void ensureGoodLink(String? url) {
    if (url == null || hasWhiteSpace(url)) {
      throw const BadUrlException("Url is null or contains white space");
    }
  }
}

extension JsonTrueChecker on String? {
  bool checkTrue() => this?.toLowerCase() == "true";
  DateTime? getDateTimeFromMSSEString() {
    final msse = this == null ? null : int.tryParse(this!);
    return msse == null ? null : DateTime.fromMillisecondsSinceEpoch(msse);
  }
}
