// TODO(6): Add GraphQL API
class TemporaryGroceryItem {
  const TemporaryGroceryItem(
    this.count,
    this.name,
    this.isBought,
  );

  final int count;
  final String name;
  final bool isBought;

  @override
  int get hashCode => Object.hash(count, name, isBought);

  @override
  bool operator ==(Object other) {
    return other is TemporaryGroceryItem &&
        other.name == name &&
        other.isBought == isBought &&
        other.count == count;
  }

  TemporaryGroceryItem copyWith({
    int? count,
    String? name,
    bool? isBought,
  }) {
    return TemporaryGroceryItem(
      count ?? this.count,
      name ?? this.name,
      isBought ?? this.isBought,
    );
  }
}
