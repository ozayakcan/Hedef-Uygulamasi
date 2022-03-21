class AImages {
  static String logo = "images/logo.png";
  static String logoDark = "images/empty.svg";
  static const String empty = "images/empty.svg";
  static String profileImage = "images/profile_image.png";
  static String check = "images/check.svg";

  static getAssetFolder({String path = ""}) {
    return "assets/" + path;
  }
}
