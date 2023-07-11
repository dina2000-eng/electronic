import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:electronics_market/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../loading_manager.dart';
import '../models/products_model.dart';
import '../providers/products_provider.dart';
import '../services/assets_manager.dart';
import '../widgets/no_result_found.dart';
import '../widgets/product/products_widget.dart';
import '../widgets/texts/title_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //with AutomaticKeepAliveClientMixin
  // @override
  //  bool get wantKeepAlive => true;
  late TextEditingController _searchTextController;
  late FocusNode _searchTextFocusNode;
  // List<ProductModel> productListSearch = [];
  final bool _isFirstLoading = true;
  @override
  void initState() {
    _searchTextController = TextEditingController();
    _searchTextFocusNode = FocusNode();
    // WidgetsBinding.instance?.addPostFrameCallback((_) {
    //   Provider.of<ProductsProvider>(context, listen: false).fetchProducts();
    // });
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _searchTextFocusNode.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];
  Future<void> onLocalRefresh() async {
    final authProv = Provider.of<AuthProvider>(context, listen: false);
    final productsProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    await productsProvider.fetchProducts(token: authProv.getToken!);
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    // String? passedCategory =
    //     ModalRoute.of(context)!.settings.arguments as String?;
    final Map<String, dynamic>? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    String? passedCategory = args?['id'];
    String? passedCategoryName = args?['name'];
    final productsProvider = Provider.of<ProductsProvider>(context);
    final authProv = Provider.of<AuthProvider>(context);
    final List<ProductModel> productsList = passedCategory == null
        ? productsProvider.getProducts
        : productsProvider.findByCategoryId(
            categoryId: int.parse(
              passedCategory.toString(),
            ),
          );
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: TitlesTextWidget(label: passedCategoryName ?? "Store products"),
        leading: Padding(
          padding: const EdgeInsets.only(left: 15, top: 5, bottom: 5),
          child: Image.asset(
            AssetsManager.shoppingCart,
          ),
        ),
      ),
      body: LoadingManager(
        isLoading: false,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RefreshIndicator(
              onRefresh: onLocalRefresh,
              child: productsList.isEmpty
                  ? NoResultFound(
                      message: passedCategory != null
                          ? "No products belong to $passedCategory category has been added yet!"
                          : "No products has been added yet")
                  : Column(
                      children: [
                        const SizedBox(
                          height: 12,
                        ),
                        TextField(
                          controller: _searchTextController,
                          keyboardType: TextInputType.text,
                          focusNode: _searchTextFocusNode,
                          decoration: InputDecoration(
                            hintText: "Search",
                            filled: true,
                            fillColor: Theme.of(context).cardColor,
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchTextController.clear();
                                  _searchTextFocusNode.unfocus();
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              productListSearch = productsProvider.searchQuery(
                                searchText: value,
                              );
                            });
                          },
                          onSubmitted: (value) {
                            setState(() {
                              productListSearch = productsProvider.searchQuery(
                                  searchText: value);
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (_searchTextController.text.isNotEmpty &&
                            productListSearch.isEmpty) ...[
                          const NoResultFound(
                              message:
                                  'No products found!,\nPlease try different keyword'),
                        ],
                        Expanded(
                          child: DynamicHeightGridView(
                              itemCount: _searchTextController.text.isNotEmpty
                                  ? productListSearch.length
                                  : productsList.length,
                              crossAxisCount: 2,
                              builder: (ctx, index) {
                                return ProductsWidget(
                                  productId: _searchTextController
                                          .text.isNotEmpty
                                      ? productListSearch[index].id.toString()
                                      : productsList[index].id.toString(),
                                );
                              }),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );

    // u can use it with future builder
    //   FutureBuilder(
    //     future: productsProvider.fetchProducts(token: authProv.getToken!),
    //     builder: (ctx, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(child: CircularProgressIndicator());
    //       } else if (snapshot.error != null) {
    //         return Center(child: Text('An error occurred! ${snapshot.error}'));
    //       } else {
    //         final List<ProductModel> productsList = passedCategory == null
    //             ? productsProvider.getProducts
    //             : productsProvider.findByCategoryId(
    //                 categoryId: int.parse(
    //                   passedCategory.toString(),
    //                 ),
    //               );

    //       }
    //     },
    //   ),
    // );
  }
}
