import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:highlandcoffeeapp/apis/api.dart';
import 'package:highlandcoffeeapp/models/model.dart';
import 'package:highlandcoffeeapp/widgets/category_dropdown.dart';
import 'package:highlandcoffeeapp/widgets/custom_alert_dialog.dart';
import 'package:highlandcoffeeapp/widgets/image_picker_widget.dart';
import 'package:highlandcoffeeapp/widgets/labeled_text_field.dart';
import 'package:highlandcoffeeapp/widgets/my_button.dart';
import 'package:highlandcoffeeapp/themes/theme.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProductPage extends StatefulWidget {
  static const String routeName = '/update_product_page';

  const UpdateProductPage({Key? key}) : super(key: key);

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final _textSearchProductController = TextEditingController();
  TextEditingController _editIdController = TextEditingController();
  TextEditingController _editNameController = TextEditingController();
  TextEditingController _editDescriptionController = TextEditingController();
  TextEditingController _editPriceController = TextEditingController();
  TextEditingController _editSizeController = TextEditingController();
  TextEditingController _editUnitController = TextEditingController();

  File? _imagePath;
  File? _imageDetailPath;

  final AdminApi adminApi = AdminApi();
  final CategoryApi categoryApi = CategoryApi();
  List<Category> categories = [];
  Map<String, List<Product>> productsMap = {};
  String selectedCategoryId = '';
  String selectedCategoryName = '';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      categories = await categoryApi.getCategories();
      setState(() {
        if (categories.isNotEmpty) {
          selectedCategoryId = categories.first.categoryid;
          selectedCategoryName = categories.first.categoryname;
          loadData();
        }
      });
    } catch (e) {
      print('Error fetching categories: $e');
      showCustomAlertDialog(
        context,
        'Lỗi',
        'Đã xảy ra lỗi khi tải danh mục sản phẩm.',
      );
    }
  }

  void loadData() async {
    if (categories.isEmpty) return;

    for (Category category in categories) {
      List<Product> products = await getProductsFromApi(category.categoryid);
      productsMap[category.categoryname] = products;
    }
    setState(() {});
  }

  Future<List<Product>> getProductsFromApi(String categoryid) async {
    try {
      List<Product> products = await adminApi.getProducts(categoryid);
      return products.map((product) {
        return Product(
          productid: product.productid,
          categoryid: product.categoryid,
          productname: product.productname,
          description: product.description,
          size: product.size,
          price: product.price,
          unit: product.unit,
          image: product.image,
          imagedetail: product.imagedetail,
        );
      }).toList();
    } catch (e) {
      print('Error getting products from API for $categoryid: $e');
      return [];
    }
  }

  void updateSelectedProducts(String categoryid, String categoryname) {
    setState(() {
      selectedCategoryId = categoryid;
      selectedCategoryName = categoryname;
      loadData();
    });
  }

  Future<void> updateProduct(Product product) async {
    try {
      await adminApi.updateProduct(product);
      Navigator.pop(context);
      showCustomAlertDialog(
        context,
        'Thông báo',
        'Cập nhật sản phẩm thành công.',
      );
      loadData();
    } catch (e) {
      showCustomAlertDialog(
        context,
        'Lỗi',
        'Cập nhật sản phẩm thất bại. Vui lòng thử lại.',
      );
      print('Error updating product: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePath = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageDetail() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageDetailPath = File(pickedFile.path);
      });
    }
  }

  void _showUpdateProductForm(BuildContext context, Product product) {
    List<String> _categories =
        categories.map((category) => category.categoryname).toList();
    _editIdController.text = product.productid;
    _editNameController.text = product.productname;
    _editDescriptionController.text = product.description;
    _editPriceController.text = product.price.toString();
    _editSizeController.text = product.size;
    _editUnitController.text = product.unit;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 830,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              top: 30.0,
              right: 18.0,
              bottom: 18.0,
            ),
            child: Column(
              children: [
                Text(
                  'Cập nhật sản phẩm',
                  style: GoogleFonts.arsenal(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: primaryColors,
                  ),
                ),
                SizedBox(height: 10),
                CategoryDropdown(
                  categories: _categories,
                  selectedCategory: selectedCategoryName,
                  onChanged: (String? value) {
                    setState(() {
                      selectedCategoryName = value ?? '';
                    });
                  },
                ),
                LabeledTextField(
                  label: 'Tên sản phẩm',
                  controller: _editNameController,
                ),
                LabeledTextField(
                  label: 'Mô tả sản phẩm',
                  controller: _editDescriptionController,
                ),
                LabeledTextField(
                  label: 'Giá',
                  controller: _editPriceController,
                ),
                LabeledTextField(
                  label: 'Size',
                  controller: _editSizeController,
                ),
                LabeledTextField(
                  label: 'Đơn vị tính',
                  controller: _editUnitController,
                ),
                SizedBox(height: 10),
                ImagePickerWidget(
                  imagePath: _imagePath,
                  onPressed: _pickImage,
                  label: 'Hình ảnh sản phẩm',
                ),
                ImagePickerWidget(
                  imagePath: _imageDetailPath,
                  onPressed: _pickImageDetail,
                  label: 'Hình ảnh chi tiết sản phẩm',
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        Product updateNewProduct = Product(
                          productid: _editIdController.text,
                          categoryid: product.categoryid,
                          productname: _editNameController.text,
                          description: _editDescriptionController.text,
                          size: _editSizeController.text,
                          price: int.tryParse(_editPriceController.text) ?? 0,
                          unit: _editUnitController.text,
                          image: _imagePath != null
                              ? base64Encode(
                                  _imagePath!.readAsBytesSync(),
                                )
                              : product.image,
                          imagedetail: _imageDetailPath != null
                              ? base64Encode(
                                  _imageDetailPath!.readAsBytesSync(),
                                )
                              : product.imagedetail,
                        );
                        if (updateNewProduct.productname.isEmpty ||
                            updateNewProduct.description.isEmpty ||
                            updateNewProduct.size.isEmpty ||
                            updateNewProduct.price == 0 ||
                            updateNewProduct.unit.isEmpty ||
                            updateNewProduct.image.isEmpty ||
                            updateNewProduct.imagedetail.isEmpty) {
                          showCustomAlertDialog(
                            context,
                            'Lỗi',
                            'Vui lòng nhập đầy đủ thông tin sản phẩm.',
                          );
                          return;
                        }
                        await updateProduct(updateNewProduct);
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: green),
                      child: Row(
                        children: [
                          Text(
                            'Lưu',
                            style: TextStyle(color: white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 18.0,
              top: 18.0,
              right: 18.0,
              bottom: 10,
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Sửa sản phẩm',
                    style: GoogleFonts.arsenal(
                      fontSize: 30,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                TextField(
                  controller: _textSearchProductController,
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sản phẩm',
                    contentPadding: EdgeInsets.symmetric(),
                    alignLabelWithHint: true,
                    filled: true,
                    fillColor: white,
                    prefixIcon: const Icon(
                      Icons.search,
                      size: 20,
                    ),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                            color: background, shape: BoxShape.circle),
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.clear,
                              size: 10,
                            ),
                            onPressed: () {
                              _textSearchProductController.clear();
                            },
                          ),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(28.0),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Danh sách sản phẩm',
                    style: GoogleFonts.arsenal(
                      fontSize: 20,
                      color: brown,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      final bool isSelected =
                          category.categoryid == selectedCategoryId;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            updateSelectedProducts(
                                category.categoryid, category.categoryname);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? primaryColors : white,
                          ),
                          child: Text(
                            category.categoryname,
                            style: TextStyle(
                              color: isSelected ? white : black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
            child: ListView.builder(
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: 1,
              itemBuilder: (context, index) {
                List<Product> products = selectedCategoryName.isNotEmpty
                    ? productsMap[selectedCategoryName] ?? []
                    : [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        selectedCategoryName.isNotEmpty
                            ? selectedCategoryName
                            : categories.isNotEmpty
                                ? categories[index].categoryname
                                : '',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: brown,
                        ),
                      ),
                    ),
                    ...products.map((product) {
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Image.memory(
                                base64Decode(product.image),
                                height: 80,
                                width: 80,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.productname,
                                    style: GoogleFonts.arsenal(
                                      fontSize: 18,
                                      color: primaryColors,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    product.price.toStringAsFixed(3) + 'đ',
                                    style: GoogleFonts.roboto(
                                      color: primaryColors,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Size: ',
                                        style: GoogleFonts.roboto(
                                          color: primaryColors,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        product.size,
                                        style: GoogleFonts.roboto(
                                          color: primaryColors,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: blue,
                                ),
                                onPressed: () {
                                  _showUpdateProductForm(context, product);
                                },
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, bottom: 25.0),
          child: MyButton(
            text: 'Hoàn thành',
            onTap: () {
              Navigator.pushNamed(context, '/admin_page');
            },
            buttonColor: primaryColors,
          ),
        )
      ],
    );
  }
}
