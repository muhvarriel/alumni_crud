import 'package:flutter/material.dart';
import 'package:movie_mobile/model/user_response.dart';
import 'package:movie_mobile/repository/user_provider.dart';

class ApiScreen extends StatefulWidget {
  const ApiScreen({super.key});

  @override
  State<ApiScreen> createState() => _ApiScreenState();
}

class _ApiScreenState extends State<ApiScreen> {
  List<DataUser> listUser = [];
  bool isLoading = false;
  bool isLoadingMore = false;

  UserResponse? response;

  bool isAsc = true;

  @override
  void initState() {
    super.initState();
    read();
  }

  void read() async {
    setState(() {
      isLoading = true;
    });

    await UserProvider.getUser(1).then((value) {
      if (value?.data?.isNotEmpty ?? false) {
        response = value ?? UserResponse();

        listUser = value?.data ?? [];
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  void readLoad() async {
    setState(() {
      isLoadingMore = true;
    });

    await UserProvider.getUser((response?.page ?? 1) + 1).then((value) {
      if (value?.data?.isNotEmpty ?? false) {
        response = value ?? UserResponse();
        listUser.addAll(value?.data ?? []);
      }
    });

    setState(() {
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    listUser.sort((a, b) => isAsc
        ? (a.firstName
                ?.toLowerCase()
                .compareTo(b.firstName?.toLowerCase() ?? "") ??
            0)
        : (b.firstName
                ?.toLowerCase()
                .compareTo(a.firstName?.toLowerCase() ?? "") ??
            0));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Using API"),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isAsc = !isAsc;
                });
              },
              icon: const Icon(Icons.star_border))
        ],
      ),
      floatingActionButton: (response?.page != response?.totalPages)
          ? FloatingActionButton(
              child: const Icon(Icons.expand_more),
              onPressed: () {
                readLoad();
              })
          : null,
      body: isLoading
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
                  child: NotificationListener(
                    onNotification: (n) {
                      if (response?.page != response?.totalPages) {
                        if (!isLoadingMore) {
                          if (n is ScrollEndNotification) {
                            readLoad();
                          }
                        }
                      }
                      return true;
                    },
                    child: RefreshIndicator(
                      color: Colors.blue,
                      backgroundColor: Colors.white,
                      strokeWidth: 4.0,
                      onRefresh: () async {
                        read();
                      },
                      child: ListView(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: listUser.length,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, i) {
                              return ListTile(
                                title: Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  listUser[i].avatar ?? ""))),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(listUser[i].firstName ?? ""),
                                        Text(listUser[i].email ?? ""),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          if (isLoadingMore)
                            const Center(child: CircularProgressIndicator())
                        ],
                      ),
                    ),
                  ),
                )),
    );
  }
}
