class AImages {
  static String logo = "images/logo.png";
  static String logoDark = "images/empty.svg";
  static String empty = "images/empty.svg";
  static String profileImage = "images/profile_image.png";

  static getAssetFolder({String path = ""}) {
    return "assets/" + path;
  }
}
