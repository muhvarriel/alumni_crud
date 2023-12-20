import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mobile/model/user.dart';
import 'package:movie_mobile/model/user_response.dart';
import 'package:movie_mobile/repository/user_provider.dart';
import 'package:movie_mobile/widget/button_widget.dart';

class CrudApiScreen extends StatefulWidget {
  const CrudApiScreen({super.key});

  @override
  State<CrudApiScreen> createState() => _CrudApiScreenState();
}

class _CrudApiScreenState extends State<CrudApiScreen> {
  List<User> listUser = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> create(User user) async {
    await UserProvider.createUser(id: user.id, name: user.name, job: user.job)
        .then((value) {
      if (value != null) {
        if (user.id != null) {
          setState(() {
            int index = listUser.indexWhere((e) => e.id == user.id);

            setState(() {
              listUser[index] =
                  User(id: user.id, name: value.name, job: value.job);
            });
          });
        } else {
          setState(() {
            listUser.add(value);
          });
        }
      }
    });
  }

  void delete(User user) async {
    await UserProvider.deleteUser(id: user.id).then((value) {
      setState(() {
        listUser.removeWhere((e) => e.id == user.id);
      });
    });
  }

  void modalButton({User? user}) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController jobController = TextEditingController();

    bool isUpdate = user != null;

    bool isCreate = false;

    if (isUpdate) {
      nameController.text = user.name ?? "";
      jobController.text = user.job ?? "";
    }

    await showCupertinoModalPopup(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "${isUpdate ? "Update" : "Create"} User",
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
                    controller: jobController,
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
                    onPressed: () async {
                      if (nameController.text.isEmpty &&
                          jobController.text.isEmpty) {
                      } else {
                        setState(() {
                          isCreate = true;
                        });
                        await create(User(
                            id: user?.id,
                            name: nameController.text,
                            job: jobController.text));

                        setState(() {
                          isCreate = false;
                        });

                        Navigator.pop(context);

                        setState(() {});
                      }
                    },
                    child: Text(isCreate
                        ? "Loading"
                        : (isUpdate ? "Update" : "Create"))),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Using API"),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () {
            modalButton();
          }),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : (listUser.isEmpty
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
                          shrinkWrap: true,
                          itemCount: listUser.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          listUser[index].name ??
                                              "Test Test Test Test Test Test Test Test Test Test",
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(listUser[index].job ?? ""),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      modalButton(user: listUser[index]);
                                    },
                                    icon: const Icon(Icons.edit_rounded),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      delete(listUser[index]);
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
                      )),
          ),
          /*
          Container(
            padding: const EdgeInsets.all(20),
            child: ButtonWidget(
              label: "Add",
              onPressed: () {},
            ),
          ),
          */
        ],
      ),
    );
  }
}
