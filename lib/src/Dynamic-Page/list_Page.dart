import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Dynamic-Page/Details_page.dart';
import '../Dynamic_Form/Dynamic-form.dart';
import '../base_client.dart';
import '../colors.dart';
import '../constants.dart';
import '../pagination/customPagination.dart';

class listPage extends StatefulWidget {
  final int EntityTypeId;
  const listPage({super.key, required this.EntityTypeId});

  @override
  State<listPage> createState() => _listPageState();
}

class _listPageState extends State<listPage> {
  // int _EntityTypeId;

  int menuIndex = 0;

  @override
  void initState() {
    super.initState();
    // fetchUsers();
    getForm(widget.EntityTypeId);
  }

  dynamic searchCriteria = {
    "Pagging": {"PageNo": 1, "PageSize": 5},
    "Where": [],
    "SortOrder": {"field": null, "direction": null}
  };

  List<dynamic> users = [];
  dynamic FormFields;
  dynamic FormData = [];
  dynamic ListForm;
  dynamic DetailsForm;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          EntityTypeDescription,
          style: const TextStyle(color: Colors.green),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Dynamic_Form()));
            },
            icon: const Icon(
              Icons.add,
              color: primaryColor,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: getForm,
        color: Colors.green,
          child: Column(
            children: [
              // const SizedBox(
              //   height: 20,
              // ),
              // Row(
              //   children: [
              //     Expanded(
              //       flex: 5,
              //       child: Padding(
              //         padding: const EdgeInsets.all(10.0),
              //         child: TextField(
              //           onChanged: (value) => _runFilter(value),
              //           decoration: const InputDecoration(
              //               labelText: 'Search',
              //               suffixIcon: Icon(Icons.search)),
              //         ),
              //       ),
              //     ),
              //     Expanded(
              //         flex: 1,
              //         child: IconButton(
              //           onPressed: () {
              //             Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                     builder: (context) => Dynamic_Form()));
              //           },
              //           icon: Icon(Icons.add),
              //         )),
              //   ],
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              SizedBox(
                height: MediaQuery.of(context).size.height-222,
                width: MediaQuery.of(context).size.width ,
                child: ListView.builder(
                    // itemExtent: 150.0,
                    itemCount: FormData!.length,
                    itemBuilder: (context, index) {
                      final i = index;
                      final user = FormData[index];
              
                      return Container(
                        color: Colors.grey[200],
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ListTile(
                              title:
                                  setDynamicFieldtitle(FormFields, FormData, i),
                              subtitle: Column(
                                children: [
                                  Column(
                                    children: setDynamicField(
                                        FormFields, FormData, i),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Details_page(
                                                    Data: user,
                                                    Form: DetailsForm,
                                                    Fields: FormFields,
                                                  )));
                                    },
                                    onLongPress: () {},
                                    onFocusChange: (value) {},
                                    onHover: (value) {},
                                    style: ElevatedButton.styleFrom(
                                      onPrimary: Colors.white,
                                      primary: Colors.green[300],
                                      // minimumSize: const Size(88, 36),
                                      fixedSize: Size.fromWidth(width),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(2)),
                                      ),
                                    ),
                                    child: const Text('More Details'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
              Pagination(
                    getPaginatedData: getFormData,
                    totalRecords: totalRecords,
             )
            ],
          ),
      ),
    );
  }

  void fetchUsers() async {
    const url = 'https://randomuser.me/api/?results=10';
    final uri = Uri.parse(url);
    final Response = await http.get(uri);
    final body = Response.body;
    final json = jsonDecode(body);
    setState(() {
      users = json['results'];
    });
  }

  // void _runFilter(String EnterKeyword) {
  //   List<Map<String, dynamic>> results = [];
  //   if (EnterKeyword.isEmpty) {
  //     results = FormData;
  //   } else {
  //     results = FormData.where((x) => x["DemandLetter"]
  //         .toLowerCase()
  //         .contains(EnterKeyword.toLowerCase())).toList();
  //   }
  //   setState(() {});
  // }

  Future<void> getForm([int? _EntityTypeId]) async {
    getFormFields(_EntityTypeId);
    // getFormData(null, _EntityTypeId);
  }

  Future<void> getFormFields([int? _EntityTypeId]) async {
    dynamic data = await BaseClient().getFormFields(_EntityTypeId);
    final json = jsonDecode(data);
    setState(() {
      if (json['Form'] != null) {
        List _form = json['Form'];
        ListForm = _form.where((x) => x["FormType"] == 14).first;
        DetailsForm = _form.where((x) => x["FormType"] == 15).first;
        FormFields = ListForm["DetailsViewData"];
        FormFields = jsonDecode(FormFields);
        EntityTypeDescription = ListForm["FormName"].toString();
        getFormData(null, _EntityTypeId);
      }
      // print(FormFields);
    });
  }

  Future<void> getFormData([dynamic? criteria, int? _EntityTypeId]) async {
    setState(() {
      if (criteria != null) {
        searchCriteria = criteria;
      }
      //  loadingCardSkeleton = true;
    });
    dynamic data =
        await BaseClient().getFormData(_EntityTypeId, searchCriteria);
    final json = jsonDecode(data);
    setState(() {
      if (json['Data'] != null) {
        FormData = json['Data'];
        totalRecords = json["TotalCount"];
        //  FormData = jsonDecode(FormData);
      }
    });
  }

  setDynamicFieldtitle(List fields, dynamic data, int i) {
    dynamic Titles = fields.where((x) => x["MobileFieldtype"] == "1").first;
    dynamic Tag = fields.where((x) => x["MobileFieldtype"] == "4").first;

    Row _row = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 7,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: data[i][Titles["Field"]].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                WidgetSpan(
                  child: Icon(
                    Icons.check_circle_outline,
                    size: 15,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Center(
            child: Container(
              // margin: EdgeInsets.only(right: 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.green[50],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
                child: Text(
                  data[i][Tag["Field"]].toString(),
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return _row;
  }

  setDynamicField(List fields, dynamic data, int i) {
    List<Widget> _fieldList = [];
    List subTitles = fields.where((x) => x["MobileFieldtype"] == "2").toList();
    for (Map field in subTitles) {
      SizedBox _SizedBox = SizedBox(
        height: 10.0,
      );
      Row _row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              field["Name"],
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              data[i][field["Field"]].toString(),
              style: TextStyle(fontSize: 16.0),
            ),
          ),
        ],
      );

      _fieldList.add(_SizedBox);
      _fieldList.add(_row);
    }

    return _fieldList;
  }
}
