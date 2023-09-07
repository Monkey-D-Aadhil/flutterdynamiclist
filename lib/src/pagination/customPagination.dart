import 'package:flutter/material.dart';
import '../constants.dart';
// import '../default/variables.dart';

class Pagination extends StatefulWidget {
  final Function(dynamic searchCriteria) getPaginatedData;
  final int totalRecords;

  const Pagination({
    Key? key,
    required this.getPaginatedData,
    this.totalRecords = 0,
  }) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  int pageSize = itemPerPage.first;
  int totalPages = 0;
  int currentPage = 1;
  dynamic searchCriteria = {};
  TextEditingController pageNoFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      searchCriteria = {
        "Pagging": {"PageNo": 1, "PageSize": pageSize},
        "Where": [],
        "SortOrder": {"field": null, "direction": null}
      };
      pageNoFieldController.text = currentPage.toString();
    });
  }

  void setTotalPages() {
    setState(() {
      totalPages = (widget.totalRecords / pageSize).ceil();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          searchCriteria = {
                            "Pagging": {"PageNo": 1, "PageSize": pageSize},
                            "Where": [],
                            "SortOrder": {"field": null, "direction": null}
                          };
                          pageNoFieldController.text = "1";
                          widget.getPaginatedData.call(searchCriteria);
                        },
                        icon: const Icon(
                          Icons.skip_previous,
                          color: Colors.black54,
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: IconButton(
                          onPressed: () {
                            if (currentPage > 1) {
                              currentPage--;
                              pageNoFieldController.text =
                                  currentPage.toString();
                              searchCriteria = {
                                "Pagging": {
                                  "PageNo": currentPage,
                                  "PageSize": pageSize
                                },
                                "Where": [],
                                "SortOrder": {"field": null, "direction": null}
                              };
                              widget.getPaginatedData.call(searchCriteria);
                            }
                          },
                          icon: const Icon(
                            Icons.chevron_left,
                            color: Colors.black54,
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: SizedBox(
                        height: 40,
                        width: 80,
                        child: TextField(
                            keyboardType: TextInputType.number,
                            controller: pageNoFieldController,
                            onSubmitted: (String value) {
                              setState(() {
                                if (totalPages <= 0) {
                                  setTotalPages();
                                }
                                currentPage = int.parse(value);
                                if (int.parse(value) < totalPages &&
                                    totalPages > 0) {
                                  searchCriteria = {
                                    "Pagging": {
                                      "PageNo": currentPage,
                                      "PageSize": pageSize
                                    },
                                    "Where": [],
                                    "SortOrder": {
                                      "field": null,
                                      "direction": null
                                    }
                                  };
                                  widget.getPaginatedData.call(searchCriteria);
                                }
                              });
                            },
                            decoration: InputDecoration(
                                labelText: "Page",
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(255, 1, 90, 4)),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                labelStyle: const TextStyle(
                                    fontStyle: FontStyle.italic))),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: Text(
                        "of ${totalPages.toString()}",
                        style: const TextStyle(fontStyle: FontStyle.italic),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: IconButton(
                          onPressed: () {
                            if (totalPages <= 0) {
                              setTotalPages();
                            }
                            if (currentPage < totalPages) {
                              currentPage++;
                              pageNoFieldController.text =
                                  currentPage.toString();
                              searchCriteria = {
                                "Pagging": {
                                  "PageNo": currentPage,
                                  "PageSize": pageSize
                                },
                                "Where": [],
                                "SortOrder": {"field": null, "direction": null}
                              };
                              widget.getPaginatedData.call(searchCriteria);
                            }
                          },
                          icon: const Icon(
                            Icons.chevron_right,
                            color: Colors.black54,
                          )),
                    ),
                    IconButton(
                        onPressed: () {
                          if (totalPages <= 0) {
                            setTotalPages();
                          }
                          searchCriteria = {
                            "Pagging": {
                              "PageNo": totalPages,
                              "PageSize": pageSize
                            },
                            "Where": [],
                            "SortOrder": {"field": null, "direction": null}
                          };
                          pageNoFieldController.text = totalPages.toString();
                          widget.getPaginatedData.call(searchCriteria);
                        },
                        icon: const Icon(
                          Icons.skip_next,
                          color: Colors.black54,
                        )),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40,
                  width: 80,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      labelText: 'Items per page',
                      labelStyle: const TextStyle(fontStyle: FontStyle.italic),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: pageSize,
                        icon: const Icon(Icons.arrow_drop_down),
                        iconSize: 25,
                        elevation: 10,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        onChanged: (int? value) {
                          setState(() {
                            setState(() {
                              pageSize = value!;
                              setTotalPages();
                              searchCriteria = {
                                "Pagging": {"PageNo": 1, "PageSize": pageSize},
                                "Where": [],
                                "SortOrder": {"field": null, "direction": null}
                              };
                              widget.getPaginatedData.call(searchCriteria);
                            });
                          });
                        },
                        items:
                            itemPerPage.map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(
                              value.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Text(
                    "Total Records: ${widget.totalRecords.toString()}",
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}
