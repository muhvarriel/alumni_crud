import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mobile/database/list_database.dart';

class Product {
  String? name;
  int? price;

  Product({this.name, this.price});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['price'] = price;
    return data;
  }
}

class ModelScreen extends StatefulWidget {
  const ModelScreen({super.key});

  @override
  State<ModelScreen> createState() => _ModelScreenState();
}

class _ModelScreenState extends State<ModelScreen> {
  List<Product> listProduct = [];

  @override
  void initState() {
    super.initState();
    read();
  }

  void create(Product product) async {
    await ListDatabase.createProduct(product).then((value) {
      setState(() {
        listProduct = value;
      });
    });
  }

  void read() async {
    await ListDatabase.readProduct().then((value) {
      setState(() {
        listProduct = value;
      });
    });
  }

  void update({Product? product, int? index}) async {
    if (product != null) {
      await ListDatabase.updateProduct(product, index ?? 0).then((value) {
        setState(() {
          listProduct = value;
        });
      });
    }
  }

  void delete(int index) async {
    await ListDatabase.deleteProduct(index).then((value) {
      setState(() {
        listProduct = value;
      });
    });
  }

  void modalButton({Product? product, int? index}) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    bool isUpdate = product != null && index != null;

    if (isUpdate) {
      nameController.text = product.name ?? "";
      priceController.text = (product.price ?? 0).toString();
    }

    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "${isUpdate ? "Update" : "Create"} Product",
              style: const TextStyle(fontSize: 16),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoTextField(
                  controller: nameController,
                  placeholder: "Name",
                ),
                const SizedBox(height: 12),
                CupertinoTextField(
                  controller: priceController,
                  placeholder: "Price",
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isEmpty &&
                        priceController.text.isEmpty) {
                    } else {
                      Navigator.pop(context);

                      if (isUpdate) {
                        update(
                            product: Product(
                                name: nameController.text,
                                price: int.tryParse(priceController.text)),
                            index: index);
                      } else {
                        create(Product(
                            name: nameController.text,
                            price: int.tryParse(priceController.text)));
                      }
                    }
                  },
                  child: Text(isUpdate ? "Update" : "Create")),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make Model"),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_rounded),
          onPressed: () {
            modalButton();
          }),
      body: listProduct.isEmpty
          ? const Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Data"),
                ],
              ),
            )
          : Scrollbar(
              child: ListView.builder(
                itemCount: listProduct.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(listProduct[index].name ?? ""),
                            Text("Rp ${listProduct[index].price ?? 0}"),
                          ],
                        )),
                        IconButton(
                          onPressed: () {
                            modalButton(
                                product: listProduct[index], index: index);
                          },
                          icon: const Icon(Icons.edit_rounded),
                        ),
                        IconButton(
                          onPressed: () {
                            delete(index);
                          },
                          icon: const Icon(
                            Icons.delete_rounded,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
