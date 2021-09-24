class Menu {
  int? id;
  String? title;
  String? bannerUrl;
  String? qrCode;
  String? isActive;
  String? updatedAt;

  Menu(this.title, this.bannerUrl, this.qrCode, this.isActive, this.updatedAt);

  Menu.fromMap(Map map) {
    this.id = map["id"];
    this.title = map["title"];
    this.bannerUrl = map["bannerUrl"];
    this.qrCode = map["qrCode"];
    this.isActive = map["isActive"];
    this.updatedAt = map["updatedAt"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "title": this.title,
      "bannerUrl": this.bannerUrl,
      "qrCode": this.qrCode,
      "isActive": this.isActive,
      "updatedAt": this.updatedAt
    };
    if (this.id != null) {
      map["id"] = this.id;
    }
    return map;
  }
}
