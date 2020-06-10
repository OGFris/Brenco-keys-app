class Key {
  final int id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String name;
  final String key;

  const Key({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.key
  });

  factory Key.fromJson(json) {
    return Key(
      id: json["id"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      name: json["name"],
      key: json["key"],
    );
  }
}
