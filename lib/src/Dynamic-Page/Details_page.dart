import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants.dart';

class Details_page extends StatefulWidget {
  dynamic Data;
  dynamic Form;
  dynamic Fields;

  Details_page({super.key, this.Data, this.Form, this.Fields});

  @override
  State<Details_page> createState() => _Details_pageState(Data, Form, Fields);
}

class _Details_pageState extends State<Details_page> {
  dynamic _Data;
  dynamic _form;
  dynamic FormData;
  List<Group> group = [];
  dynamic _Fields;
  _Details_pageState(this._Data, this._form, this._Fields);

  dynamic Titles;

  @override
  void initState() {
    super.initState();

    if (_form != null) {
      if (_form["FormData"] != null) {
        FormData = jsonDecode(_form["FormData"]);

        group = [];

        List PageGroup =
            FormData["PageGroup"] != null ? FormData["PageGroup"] : [];
        for (var i = 0; i < PageGroup.length; i++) {
          List _Groups = PageGroup[i]["Groups"];
          if (_Groups.length > 0) {
            Group _grp = new Group();
            List _fields = _Groups[0]["Fields"];
            dynamic _header = _fields.where((x) => x["DataType"] == "31").first;
            _grp.title = _header["Description"];
            _grp.fields = _fields.where((x) => x["DataType"] != "31").toList();
            group.add(_grp);
          }
        }
      }
    }

    if (_Fields != null) {
      List subTitles =
          _Fields.where((x) => x["MobileFieldtype"] == "2").toList();
      Titles = _Fields.where((x) => x["MobileFieldtype"] == "1").first;
      dynamic Tag = _Fields.where((x) => x["MobileFieldtype"] == "4").first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Details",
          style: TextStyle(color: Colors.green),
        ),
        iconTheme: const IconThemeData(
          color: Colors.green, //change your color here
        ),
      ),
      body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      fitness,
                      height: 100.0,
                      width: 70.0,
                    ),
                  ),
                  title: Container(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      _Data[Titles["Field"]].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                flex: 3,
                                child: Text(_Data['LicenseNumber'].toString())),
                            Expanded(
                                flex: 4,
                                child: Text(_Data['Email'].toString(),
                                    overflow: TextOverflow.ellipsis)),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  _Data['StatusId'].toString(),
                                  style: const TextStyle(color: Colors.green),
                                )),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 5,
                              child: Row(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                                    child: FaIcon(
                                      FontAwesomeIcons.userGraduate,
                                      size: 15,
                                    ),
                                  ),
                                  Container(
                                    child: Text(_Data['City'].toString()),
                                  ),
                                ],
                              )),
                          Expanded(
                              flex: 5,
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                                    child:const  FaIcon(
                                      FontAwesomeIcons.globe,
                                      size: 15,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      _Data['Country'].toString(),
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                ],
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: groupMethod(),
                ),
              )
            ],
          ),
      ),
    );
  }

  List<Widget> groupMethod() {
    List<Widget> _ret = [];

    for (var i = 0; i < group.length; i++) {
      Widget _WgroupTitle = Container(
        alignment: Alignment.centerLeft,
        child: Container(
          //  transformAlignment: Alignment.center,
          // alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            // border: Border.all(
            //     style: BorderStyle.solid, color: Colors.green),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[300],
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
            child: Text(
              group[i].title.toString(),
              style: TextStyle(color: Colors.green),
            ),
          ),
        ),
      );

      List<Widget> Field = setGroupField(group[i].fields, _Data);

      SizedBox _SizedBox = const SizedBox(
        height: 30.0,
      );

      _ret.add(_WgroupTitle);
      _ret.addAll(Field);
      _ret.add(_SizedBox);
    }

    return _ret;
  }

  setGroupField(List? fields, dynamic data) {
    List<Widget> _fieldList = [];

    for (Map field in fields!) {
      SizedBox _SizedBox = const SizedBox(
        height: 10.0,
      );
      Row _row = Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              field["Description"],
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16.0),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              data[field["Description"]].toString(),
              style: const TextStyle(fontSize: 16.0),
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

class Group {
  String? title;
  List? fields;
}
