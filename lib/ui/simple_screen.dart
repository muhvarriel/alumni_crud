import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mobile/database/list_database.dart';

class SimpleScreen extends StatefulWidget {
  const SimpleScreen({super.key});

  @override
  State<SimpleScreen> createState() => _SimpleScreenState();
}

class _SimpleScreenState extends State<SimpleScreen> {
  List<String> listString = [];

  @override
  void initState() {
    super.initState();
    read();
  }

  void create(String text) async {
    await ListDatabase.createString(text).then((value) {
      setState(() {
        listString = value;
      });
    });
  }

  void read() async {
    await ListDatabase.readString().then((value) {
      setState(() {
        listString = value;
      });
    });
  }

  void update({String? text, int? index}) async {
    await ListDatabase.updateString(text ?? "", index ?? 0).then((value) {
      setState(() {
        listString = value;
      });
    });
  }

  void delete(int index) async {
    await ListDatabase.deleteString(index).then((value) {
      setState(() {
        listString = value;
      });
    });
  }

  void modalButton({String? text, int? index}) async {
    TextEditingController createController = TextEditingController();

    bool isUpdate = text != null && text.isNotEmpty && index != null;

    if (isUpdate) {
      createController.text = text;
    }

    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "${isUpdate ? "Update" : "Create"} String",
              style: const TextStyle(fontSize: 16),
            ),
            content: CupertinoTextField(controller: createController),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () {
                    if (createController.text.isEmpty) {
                    } else {
                      Navigator.pop(context);

                      if (isUpdate) {
                        update(text: createController.text, index: index);
                      } else {
                        create(createController.text);
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
        title: const Text("Home"),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add_rounded),
          onPressed: () {
            modalButton();
          }),
      body: listString.isEmpty
          ? const Center(
              child: Text("No Data"),
            )
          : Scrollbar(child: buildList()),
    );
  }

  Widget buildList() {
    return ListView.builder(
      itemCount: listString.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Row(
            children: [
              Expanded(child: Text(listString[index])),
              IconButton(
                onPressed: () {
                  modalButton(text: listString[index], index: index);
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
    );
  }
}
