import 'dart:developer';
import 'dart:io';
import 'package:electronics_market/models/product_upload.dart';
import 'package:electronics_market/services/api_service.dart';
import 'package:electronics_market/widgets/go_back_widget.dart';
import 'package:electronics_market/widgets/texts/subtitle_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../loading_manager.dart';
import '../../providers/auth_provider.dart';
import '../../providers/category_provider.dart';
import '../../services/global_method.dart';
import '../../services/utils.dart';

class UploadProductForm extends StatefulWidget {
  static const routeName = '/UploadProductForm';

  const UploadProductForm({super.key});

  @override
  State<UploadProductForm> createState() => _UploadProductFormState();
}

class _UploadProductFormState extends State<UploadProductForm> {
  final _formKey = GlobalKey<FormState>();
  String? _categoryValue;
  bool _isLoading = false;
  String? url;
  var uuid = const Uuid();
  late TextEditingController
      //  _categoryController,
      //     _brandController,
      _titleController,
      _priceController,
      _descriptionController,
      _quantityController;

  @override
  void initState() {
    // _categoryController = TextEditingController();
    // _brandController = TextEditingController();
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    _descriptionController = TextEditingController();
    _quantityController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // _categoryController.dispose();
    // _brandController.dispose();
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void clearForm() {
    _titleController.clear();
    _priceController.clear();
    _descriptionController.clear();
    _quantityController.clear();
    setState(() {
      _categoryValue = null;
    });
    _removeImage();
  }

  void _uploadProduct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    final authProv = Provider.of<AuthProvider>(context, listen: false);
    if (isValid) {
      _formKey.currentState!.save();
    }
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_pickedImage == null) {
          await GlobalMethods.warningOrErrorDialog(
            subtitle: 'Please pick an image',
            context: context,
            fct: () {},
          );
          return;
        } else if (_categoryValue == null) {
          await GlobalMethods.warningOrErrorDialog(
            subtitle: 'Make sure to choose the correct category',
            context: context,
            fct: () {},
            isError: true,
          );
          return;
        } else {
          setState(() {
            _isLoading = true;
          });
          final product = UploadProductModel(
            name: _titleController.text,
            description: _descriptionController.text,
            price: double.parse(_priceController.text),
            inStock: int.parse(_quantityController
                .text), // Now an integer representing quantity
            categoryId: int.parse(_categoryValue!),
          );

          await APIServices.addProduct(
            product: product,
            pickedImage: _pickedImage!,
            token: authProv.getToken!,
          );
          // log("authProv.getToken!authProv.getToken!authProv.getToken!authProv.getToken!authProv.getToken! ${authProv.getToken!}");
          Fluttertoast.showToast(
              msg: "Product has been uploaded successfully ");
          if (!mounted) return;
          await GlobalMethods.warningOrErrorDialog(
            subtitle: "Clear form?",
            fct: () {
              clearForm();
            },
            context: context,
          );
        }
      } catch (error) {
        GlobalMethods.warningOrErrorDialog(
          subtitle: "$error",
          context: context,
          fct: () {},
          isError: true,
        );
        // print('error occured ${error}');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  XFile? _pickedImage;
  Future<void> getFromGallery() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _pickedImage = image;
    });
  }

  Future<void> getFromCamera() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      _pickedImage = image;
    });
  }

  void _removeImage() {
    setState(() {
      _pickedImage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ctgProvider = Provider.of<CategoryProvider>(context);
    return LoadingManager(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: const GoBackWidget(),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: const SubtitlesTextWidget(
            label: "Upload a new product",
          ),
        ),
        bottomSheet: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: TextButton.styleFrom(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.zero)),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // minimumSize: Size.zero, // Set this
              padding: EdgeInsets.zero, // and this
            ),
            onPressed: () {
              _uploadProduct();
            },
            icon: const Icon(
              IconlyLight.upload,
              size: 20,
            ),
            label: const Text(
              "Upload",
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              flex: 3,
                              child: TextFormField(
                                controller: _titleController,
                                key: const ValueKey('Title'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter a Title';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  labelText: 'Product Title',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                controller: _priceController,
                                key: const ValueKey('Price \$'),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Price is missed';
                                  }
                                  return null;
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                                ],
                                decoration: const InputDecoration(
                                  labelText: 'Price \$',
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextFormField(
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                key: const ValueKey('Quantity'),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Quantity is missed';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        /* Image picker here ***********************************/
                        Row(
                          children: [
                            Expanded(
                              //  flex: 2,
                              child: _pickedImage == null
                                  ? Container(
                                      margin: const EdgeInsets.all(10),
                                      height:
                                          Utils(context).getScreenSize.height *
                                              0.3,
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 1),
                                        borderRadius: BorderRadius.circular(4),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .background,
                                      ),
                                    )
                                  : Container(
                                      margin: const EdgeInsets.all(10),
                                      height:
                                          Utils(context).getScreenSize.height *
                                              0.25,
                                      child: Image.file(
                                        File(
                                          _pickedImage!.path,
                                        ),
                                        fit: BoxFit.fill,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                            ),
                            FittedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton.icon(
                                    // textColor: Colors.white,
                                    onPressed: getFromCamera,
                                    icon: const Icon(Icons.camera,
                                        color: Colors.purpleAccent),
                                    label: const Text(
                                      'Camera',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      try {
                                        getFromGallery();
                                      } catch (error) {
                                        log("An error has been occured $error");
                                      }
                                    },
                                    icon: const Icon(Icons.image,
                                        color: Colors.purpleAccent),
                                    label: const Text(
                                      'Gallery',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  TextButton.icon(
                                    // textColor: Colors.white,
                                    onPressed: _removeImage,
                                    icon: const Icon(
                                      Icons.remove_circle_rounded,
                                      color: Colors.red,
                                    ),
                                    label: const Text(
                                      'Remove',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                        FittedBox(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: DropdownButton<String>(
                              // dropdownColor: Theme.of(context).textButtonTheme.style?.foregroundColor,
                              elevation: 3,
                              underline: const SizedBox.shrink(),
                              items: List<DropdownMenuItem<String>>.generate(
                                ctgProvider.getCategories!.length,
                                (idx) => DropdownMenuItem(
                                  value: ctgProvider.getCategories![idx].id
                                      .toString(),
                                  child: Text(
                                      ctgProvider.getCategories![idx].name),
                                ),
                              ),

                              hint: TextButton(
                                child: const Text(
                                  'Select Category',
                                ),
                                onPressed: () {},
                              ),
                              value: _categoryValue,
                              onChanged: (String? value) {
                                setState(() {
                                  _categoryValue = value;
                                });
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                            key: const ValueKey('Description'),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'product description is required';
                              }
                              return null;
                            },
                            controller: _descriptionController,
                            maxLines: 6,
                            maxLength: 1000,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                              hintText: 'Product description',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (text) {
                              // setState(() => charLength -= text.length);
                            }),
                        //    SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
