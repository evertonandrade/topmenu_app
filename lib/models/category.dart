class Category {
  String? id;
  String? title;
  String? backgroundUrl;
  DateTime? updatedAt;
  String? idMenu;

  Category({
    this.id,
    this.title,
    this.backgroundUrl,
    this.updatedAt,
    this.idMenu,
  });

  factory Category.fromJson(Map data) {
    return Category(
      id: data['id'] as String,
      title: data['title'] as String,
      backgroundUrl: data['bannerUrl'] as String,
      updatedAt: DateTime.parse(data['updatedAt']),
      idMenu: data['idMenu'] as String,
    );
  }
}
