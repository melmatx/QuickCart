import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickcart/constants/constants.dart';
import 'package:quickcart/screens/favourite_screen/widgets/single_favourite_item.dart';

import '../../provider/app_provider.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colo,
        title: const Text(
          "Favourite Screen",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          appProvider.getFavouriteProductList.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      appProvider.clearFavouriteListFirebase();
                      showMessage("Wishlist cleared!");
                    });
                  },
                  icon: const Icon(Icons.delete_sweep),
                )
              : const IconButton(
                  onPressed: null, icon: Icon(Icons.delete_sweep_outlined))
        ],
      ),
      body: appProvider.getFavouriteProductList.isEmpty
          ? const Center(
              child: Text("Empty"),
            )
          : ListView.builder(
              itemCount: appProvider.getFavouriteProductList.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (ctx, index) {
                return SingleFavouriteItem(
                  singleProduct: appProvider.getFavouriteProductList[index],
                );
              }),
    );
  }
}
