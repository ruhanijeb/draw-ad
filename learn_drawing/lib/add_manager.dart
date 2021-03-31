import 'dart:io';
class AddManager{
static String get appId {
  if (Platform.isAndroid) {
    return "ca-app-pub-8555540144019011~2630737816";
  } else if (Platform.isIOS) {
    return "ca-app-pub-8555540144019011~3257423776";
  }
  else {
    throw new UnsupportedError("Unsupported platform");
  }
}
static String get bannerAdUnitId{
  if (Platform.isAndroid) {
    return "ca-app-pub-8555540144019011/1098164290";
  } else if (Platform.isIOS) {
    return "ca-app-pub-8555540144019011/5697908372";
  }
  else {
    throw new UnsupportedError("Unsupported platform");
  }
}
static String get interstialAdUnitId {
  if (Platform.isAndroid) {
    return "ca-app-pub-8555540144019011/3832138848";
  } else if (Platform.isIOS) {
    return "ca-app-pub-8555540144019011/3071745031";
  }
  else {
    throw new UnsupportedError("Unsupported platform");
  }
}
  static String get rewardedAdUnitId{
    if (Platform.isAndroid) {
      return "ca-app-pub-8555540144019011/9822832128";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8555540144019011/8563744865";
    }
    else {
      throw new UnsupportedError("Unsupported platform");
    }
}

}