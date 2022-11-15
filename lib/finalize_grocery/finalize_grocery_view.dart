import 'package:amplify_grocery_list/grocery_list/previous_groceries_page.dart';
import 'package:amplify_grocery_list/models/temporary_grocery_item.dart';
import 'package:amplify_grocery_list/models/temporary_previous_grocery.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FinalizeGroceryView extends StatefulWidget {
  const FinalizeGroceryView({
    required this.items,
    required this.onFinalized,
    Key? key,
  }) : super(key: key);

  final VoidCallback onFinalized;
  final List<TemporaryGroceryItem> items;

  @override
  State<FinalizeGroceryView> createState() => _FinalizeGroceryViewState();
}

class _FinalizeGroceryViewState extends State<FinalizeGroceryView> {
  final _formKey = GlobalKey<FormState>();

  bool _shouldShowFileUploadErrorMessage = false;

  late final TextEditingController titleController;
  late final TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Material(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Grocery Title',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please do not leave the title field empty.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Total Amount',
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please do not leave the amount field empty.';
                  }
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null) {
                    return 'The value you entered is not a number.';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                _shouldShowFileUploadErrorMessage
                    ? 'Please upload your invoice to finalize the groceries!'
                    : 'Once you finalize the groceries, you will be expected to upload a receipt/invoice. \n\nYou can not finalize the grocery list \nwithout uploading your receipt/invoice.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _shouldShowFileUploadErrorMessage ? Colors.red : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    final platformFile = await pickFile();
                    if (platformFile != null) {
                      // TODO(8): Add GraphQL API
                      // TODO(11): Add Storage
                      previousGroceries.add(
                        TemporaryPreviousGrocery(
                          double.parse(amountController.text),
                          platformFile.name,
                          DateTime.now().toIso8601String(),
                          titleController.text,
                          List.from(widget.items),
                        ),
                      );
                      if (mounted) {
                        Navigator.of(context).pop();
                        widget.onFinalized();
                      }
                    } else {
                      setState(() {
                        _shouldShowFileUploadErrorMessage = true;
                      });
                    }
                  }
                },
                child: const Text('Finalize Grocery'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'png', 'jpeg'],
    );

    if (result != null) {
      return result.files.single;
    }
    return null;
  }
}
