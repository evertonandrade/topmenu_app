class Menu {
  String? id;
  String? title;
  String? bannerUrl;
  bool? isActive;
  DateTime? updatedAt;

  Menu({
    this.id,
    this.title,
    this.bannerUrl,
    this.isActive,
    this.updatedAt,
  });

  factory Menu.fromJson(Map data) {
    return Menu(
      id: data['id'] as String,
      title: data['title']  as String,
      bannerUrl: data['bannerUrl'] as String,
      isActive: data['isActive'] as bool,
      updatedAt: DateTime.parse(data['updatedAt']),
    );
  }
}
