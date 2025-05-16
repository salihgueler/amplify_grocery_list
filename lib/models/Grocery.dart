/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Grocery type in your schema. */
class Grocery extends amplify_core.Model {
  static const classType = const _GroceryModelType();
  final String id;
  final List<GroceryItem>? _groceryItems;
  final String? _title;
  final String? _fileKey;
  final amplify_core.TemporalDate? _finalizationDate;
  final double? _totalAmount;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  GroceryModelIdentifier get modelIdentifier {
      return GroceryModelIdentifier(
        id: id
      );
  }
  
  List<GroceryItem>? get groceryItems {
    return _groceryItems;
  }
  
  String? get title {
    return _title;
  }
  
  String? get fileKey {
    return _fileKey;
  }
  
  amplify_core.TemporalDate? get finalizationDate {
    return _finalizationDate;
  }
  
  double? get totalAmount {
    return _totalAmount;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Grocery._internal({required this.id, groceryItems, title, fileKey, finalizationDate, totalAmount, createdAt, updatedAt}): _groceryItems = groceryItems, _title = title, _fileKey = fileKey, _finalizationDate = finalizationDate, _totalAmount = totalAmount, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Grocery({String? id, List<GroceryItem>? groceryItems, String? title, String? fileKey, amplify_core.TemporalDate? finalizationDate, double? totalAmount}) {
    return Grocery._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      groceryItems: groceryItems != null ? List<GroceryItem>.unmodifiable(groceryItems) : groceryItems,
      title: title,
      fileKey: fileKey,
      finalizationDate: finalizationDate,
      totalAmount: totalAmount);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Grocery &&
      id == other.id &&
      DeepCollectionEquality().equals(_groceryItems, other._groceryItems) &&
      _title == other._title &&
      _fileKey == other._fileKey &&
      _finalizationDate == other._finalizationDate &&
      _totalAmount == other._totalAmount;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Grocery {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("fileKey=" + "$_fileKey" + ", ");
    buffer.write("finalizationDate=" + (_finalizationDate != null ? _finalizationDate!.format() : "null") + ", ");
    buffer.write("totalAmount=" + (_totalAmount != null ? _totalAmount!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Grocery copyWith({List<GroceryItem>? groceryItems, String? title, String? fileKey, amplify_core.TemporalDate? finalizationDate, double? totalAmount}) {
    return Grocery._internal(
      id: id,
      groceryItems: groceryItems ?? this.groceryItems,
      title: title ?? this.title,
      fileKey: fileKey ?? this.fileKey,
      finalizationDate: finalizationDate ?? this.finalizationDate,
      totalAmount: totalAmount ?? this.totalAmount);
  }
  
  Grocery copyWithModelFieldValues({
    ModelFieldValue<List<GroceryItem>>? groceryItems,
    ModelFieldValue<String?>? title,
    ModelFieldValue<String?>? fileKey,
    ModelFieldValue<amplify_core.TemporalDate?>? finalizationDate,
    ModelFieldValue<double?>? totalAmount
  }) {
    return Grocery._internal(
      id: id,
      groceryItems: groceryItems == null ? this.groceryItems : groceryItems.value,
      title: title == null ? this.title : title.value,
      fileKey: fileKey == null ? this.fileKey : fileKey.value,
      finalizationDate: finalizationDate == null ? this.finalizationDate : finalizationDate.value,
      totalAmount: totalAmount == null ? this.totalAmount : totalAmount.value
    );
  }
  
  Grocery.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _groceryItems = json['groceryItems']  is Map
        ? (json['groceryItems']['items'] is List
          ? (json['groceryItems']['items'] as List)
              .where((e) => e != null)
              .map((e) => GroceryItem.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['groceryItems'] is List
          ? (json['groceryItems'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => GroceryItem.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _title = json['title'],
      _fileKey = json['fileKey'],
      _finalizationDate = json['finalizationDate'] != null ? amplify_core.TemporalDate.fromString(json['finalizationDate']) : null,
      _totalAmount = (json['totalAmount'] as num?)?.toDouble(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'groceryItems': _groceryItems?.map((GroceryItem? e) => e?.toJson()).toList(), 'title': _title, 'fileKey': _fileKey, 'finalizationDate': _finalizationDate?.format(), 'totalAmount': _totalAmount, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'groceryItems': _groceryItems,
    'title': _title,
    'fileKey': _fileKey,
    'finalizationDate': _finalizationDate,
    'totalAmount': _totalAmount,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<GroceryModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<GroceryModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final GROCERYITEMS = amplify_core.QueryField(
    fieldName: "groceryItems",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'GroceryItem'));
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final FILEKEY = amplify_core.QueryField(fieldName: "fileKey");
  static final FINALIZATIONDATE = amplify_core.QueryField(fieldName: "finalizationDate");
  static final TOTALAMOUNT = amplify_core.QueryField(fieldName: "totalAmount");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Grocery";
    modelSchemaDefinition.pluralName = "Groceries";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: Grocery.GROCERYITEMS,
      isRequired: true,
      ofModelName: 'GroceryItem',
      associatedKey: GroceryItem.GROCERYID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grocery.TITLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grocery.FILEKEY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grocery.FINALIZATIONDATE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Grocery.TOTALAMOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _GroceryModelType extends amplify_core.ModelType<Grocery> {
  const _GroceryModelType();
  
  @override
  Grocery fromJson(Map<String, dynamic> jsonData) {
    return Grocery.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Grocery';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Grocery] in your schema.
 */
class GroceryModelIdentifier implements amplify_core.ModelIdentifier<Grocery> {
  final String id;

  /** Create an instance of GroceryModelIdentifier using [id] the primary key. */
  const GroceryModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'GroceryModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is GroceryModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}