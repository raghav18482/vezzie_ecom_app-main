import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart'; // Import easy_autocomplete
import '../../Data/Network/base_api_services.dart';
import '../../Data/Network/network_api_services.dart';
import '../../module/product/model/product_list_model.dart';
import '../../module/product/product_search_result.dart';
import '../color/colors.dart';
import 'package:ecom_app/src/Resource/images/app_images.dart';

import '../const/api.dart';

class CustomAppBarWithSearch extends StatefulWidget
    implements PreferredSizeWidget {
  CustomAppBarWithSearch({
    Key? key,
    this.onTapHome,
    this.onTap,
    this.showBackButton = false,
    this.onTapSearch,
  }) : super(key: key);

  final bool showBackButton;
  void Function()? onTap;
  final void Function()? onTapHome;
  final void Function()? onTapSearch;

  @override
  _CustomAppBarWithSearchState createState() => _CustomAppBarWithSearchState();

  @override
  Size get preferredSize =>
      const Size.fromHeight(100); // Adjust the height as needed
}

class _CustomAppBarWithSearchState extends State<CustomAppBarWithSearch> {
  TextEditingController searchQuery = TextEditingController();
  bool showCross = false;
  final BaseAPiServices apiServices = NetworkApiService();
  List<Product> productListing = [];
  List<String> searchList = [];
  getProduct({required String search}) {
    apiServices.httpGet(
        api: "${API.searchAPI}$search",
        showLoader: false,
        success: (sucess) {
          String jsonString = json.encode(sucess);

          final getProduct = getProductFromJson(jsonString);
          setState(() {
            productListing = getProduct.products;
            //     productListing.clear();
            searchList.clear();
          });
          for (var i = 0; i < productListing.length; i++) {
            searchList.add(productListing[i].name);
            setState(() {});
          }
        },
        failure: (error) {
          if (kDebugMode) {
            print("eerror $error");
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: widget.showBackButton,
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: AppColors.buttonColor,
          statusBarIconBrightness: Brightness.light),
      toolbarHeight: widget.preferredSize.height,
      actions: [
        GestureDetector(
          onTap: widget.onTap,
          child: const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.shopping_cart),
              )),
        )
      ],
      flexibleSpace: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: kToolbarHeight, // Adjust the height as needed
            child: Center(
              child: Image.asset(
                AppImages.appBarLogo,
                width: 70, // Adjust the height as needed
              ),
            ),
          ),
          // Search Bar
          Container(
            margin: const EdgeInsets.only(top: 1, bottom: 1),
            // Adjust the height as needed
            width: MediaQuery.of(context).size.width * 0.69,

            child: EasyAutocomplete(
              onChanged: (searchValue) {
                if (searchValue.isNotEmpty) {
                  setState(() {
                    showCross = true;
                  });
                }
                if (searchValue.isEmpty) {
                  setState(() {
                    showCross = false;
                  });
                }

                getProduct(search: searchValue);
              },
              controller: searchQuery,
              decoration: InputDecoration(
                hintText: 'Search',
                constraints: const BoxConstraints(minWidth: 40),
                filled: true,
                alignLabelWithHint: true,
                isDense: true,
                fillColor: Colors.white,
                suffixIcon: Visibility(
                  visible: (searchQuery.text.isNotEmpty),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: InkWell(
                      onTap: () {
                        searchQuery.clear();
                        setState(() {});
                        FocusScope.of(context).unfocus();
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: AppColors.commonTextColor,
                      ),
                    ),
                  ),
                ),
                suffixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                ),
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(top: 2), // Adjust top padding here
                  child: Icon(Icons.search),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              suggestions: searchList,
              onSubmitted: (suggestion) {
                Product? data;
                if (kDebugMode) {
                  print("suggestion $suggestion");
                }
                // Find the index of the selected suggestion
                try {
                  final selectedIndex = searchList.indexOf(suggestion);

                  if (selectedIndex != -1 &&
                      selectedIndex < productListing.length) {
                    final selectedProduct = productListing[selectedIndex];
                    final productId = selectedProduct.id;

                    for (int i = 0; i < productListing.length; i++) {
                      if (productListing[i].id == productId) {
                        data = productListing[i];
                        break;
                      }
                    }

                    // Get the product ID
                    // Perform any action you need with the product ID

                    // Example: Navigate to a product detail screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductSearchScreen(
                          search: suggestion,
                          productData: data!,
                          productCatogeryID: data.category,
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (kDebugMode) {
                    print("errox while gettin gindex $e");
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
