import 'package:amplify_grocery_list/models/temporary_grocery_item.dart';
import 'package:collection/collection.dart';

// TODO(7): Add GraphQL API
class TemporaryPreviousGrocery {
  const TemporaryPreviousGrocery(
    this.totalAmount,
    this.filePath,
    this.finalizationDate,
    this.title,
    this.groceryItems,
  );

  final double? totalAmount;
  final String? filePath;
  final String? finalizationDate;
  final String? title;
  final List<TemporaryGroceryItem>? groceryItems;

  @override
  int get hashCode => Object.hash(
        totalAmount,
        filePath,
        finalizationDate,
        title,
        groceryItems,
      );

  @override
  bool operator ==(Object other) {
    return other is TemporaryPreviousGrocery &&
        const DeepCollectionEquality()
            .equals(other.groceryItems, groceryItems) &&
        other.filePath == filePath &&
        other.finalizationDate == finalizationDate &&
        other.title == title &&
        other.totalAmount == totalAmount;
  }
}
