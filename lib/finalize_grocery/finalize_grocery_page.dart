import 'package:amplify_grocery_list/models/GroceryItem.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

typedef GroceryFinalizer = void Function(
  double totalAmount,
  String title,
  String id,
  DateTime finalizationDate,
  String filePath,
);

class FinalizeGroceryPage extends StatefulWidget {
  const FinalizeGroceryPage({
    required this.items,
    required this.onFinalized,
    required this.currentGroceryId,
    required this.isLoading,
    this.uploadPercentage,
    this.errorMessage,
    Key? key,
  }) : super(key: key);

  final bool isLoading;
  final double? uploadPercentage;
  final String? errorMessage;
  final GroceryFinalizer onFinalized;
  final List<GroceryItem> items;
  final String currentGroceryId;

  @override
  State<FinalizeGroceryPage> createState() => _FinalizeGroceryPageState();
}

class _FinalizeGroceryPageState extends State<FinalizeGroceryPage> {
  final _formKey = GlobalKey<FormState>();

  bool _shouldShowFileUploadErrorMessage = false;

  late final TextEditingController titleController;
  late final TextEditingController amountController;

  @override
  void initState() {
    super.initState();
    final totalAmount = widget.items.fold(
        0.0,
        (previousValue, currentValue) =>
            previousValue + (currentValue.amount * currentValue.count));
    titleController = TextEditingController();
    amountController =
        TextEditingController.fromValue(TextEditingValue(text: '$totalAmount'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalize Grocery')),
      body: widget.errorMessage != null
          ? Center(child: Text(widget.errorMessage!))
          : widget.uploadPercentage != null || widget.isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.uploadPercentage != null &&
                          widget.uploadPercentage! < 1.0)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            'Uploading invoice ${(widget.uploadPercentage! * 100).toInt()}%',
                          ),
                        )
                      else
                        const Text('Saving the grocery'),
                      CircularProgressIndicator(
                        value: widget.uploadPercentage,
                      ),
                    ],
                  ),
                )
              : Form(
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
                            enabled: false,
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
                              color: _shouldShowFileUploadErrorMessage
                                  ? Colors.red
                                  : null,
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
                                  widget.onFinalized(
                                    double.parse(amountController.text),
                                    titleController.text,
                                    widget.currentGroceryId,
                                    DateTime.now(),
                                    platformFile.path!,
                                  );
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
                ),
    );
  }

  Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null) {
      return result.files.single;
    }
    return null;
  }
}
