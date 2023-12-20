import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_mobile/model/user_response.dart';
import 'package:movie_mobile/repository/user_provider.dart';
import 'package:movie_mobile/widget/custom_text.dart';

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

  TextEditingController controller = TextEditingController();

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
    List<DataUser> filteredUser = controller.text.isEmpty
        ? listUser
        : listUser
            .where((e) =>
                e.firstName
                    ?.toLowerCase()
                    .contains(controller.text.toLowerCase()) ??
                false)
            .toList();

    filteredUser.sort((a, b) => isAsc
        ? (a.firstName
                ?.toLowerCase()
                .compareTo(b.firstName?.toLowerCase() ?? "") ??
            0)
        : (b.firstName
                ?.toLowerCase()
                .compareTo(a.firstName?.toLowerCase() ?? "") ??
            0));

    return OrientationBuilder(builder: (context, orientation) {
      String ori =
          orientation == Orientation.portrait ? "Portrait" : "Landscape";
      double width = orientation == Orientation.portrait ? 50 : 100;

      return Scaffold(
        appBar: AppBar(
          title: Text("$ori Using API"),
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
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: CupertinoTextField(
                controller: controller,
                placeholder: "Search",
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (filteredUser.isEmpty
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
                                    itemCount: filteredUser.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, i) {
                                      return ListTile(
                                        title: Row(
                                          children: [
                                            CachedNetworkImage(
                                              imageUrl:
                                                  filteredUser[i].avatar ?? "",
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      AnimatedContainer(
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.easeIn,
                                                width: width,
                                                height: width,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              progressIndicatorBuilder:
                                                  (context, url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  CustomText(
                                                    text: filteredUser[i]
                                                            .firstName ??
                                                        "",
                                                  ),
                                                  CustomText(
                                                    text:
                                                        filteredUser[i].email ??
                                                            "",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                  if (isLoadingMore)
                                    const Center(
                                        child: CircularProgressIndicator())
                                ],
                              ),
                            ),
                          ),
                        )),
            ),
          ],
        ),
      );
    });
  }
}
