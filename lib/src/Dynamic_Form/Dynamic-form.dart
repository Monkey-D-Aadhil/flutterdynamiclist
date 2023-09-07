import '../Dynamic_Form/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

import '../Dynamic-Page/Details_page.dart';
import '../base_client.dart';
import 'form-modal.dart';

class Dynamic_Form extends StatefulWidget {
  const Dynamic_Form({super.key});

  @override
  State<Dynamic_Form> createState() => _Dynamic_FormState();
}

class _Dynamic_FormState extends State<Dynamic_Form> {
  List<ResponseForm> formResponse = [];
  List<Fields>? formResponse_fields;
  dynamic DetailsForm;
  dynamic FormData;
  List<Group> group = [];

  dynamic isDynamicApi;
  bool isDynamicApi_DD = false;

  //var dateController = TextEditingController();
  bool switchValue = false;
  Options? dropdownvalue;

  List categoryItemlist = [];
  List dynamic_DD_Value = [];

  getFormJson() async {
    String Data =
        await DefaultAssetBundle.of(context).loadString("assets/form.json");
    final jsonResult = jsonDecode(Data);
    setState(() {
      jsonResult.forEach((x) => formResponse.add(ResponseForm.fromJson(x)));
    });

    //  print(formResponse.length);
  }

  Future getAllCategory() async {
    var baseUrl = "https://gssskhokhar.com/api/classes/";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      setState(() {
        categoryItemlist = jsonData;
      });
    }
  }

  Future<void> getFormFields() async {
    dynamic data = await BaseClient().getFormFields();
    final json = jsonDecode(data);
    setState(() {
      if (json['Form'] != null) {
        List _form = json['Form'];
        DetailsForm = _form.where((x) => x["FormType"] == 15).first;

        if (DetailsForm != null) {
          if (DetailsForm["FormData"] != null) {
            FormData = jsonDecode(DetailsForm["FormData"]);

            group = [];

            List PageGroup =
                FormData["PageGroup"] != null ? FormData["PageGroup"] : [];
            for (var i = 0; i < PageGroup.length; i++) {
              List _Groups = PageGroup[i]["Groups"];
              if (_Groups.length > 0) {
                Group _grp = new Group();
                List _fields = _Groups[0]["Fields"];
                dynamic _header =
                    _fields.where((x) => x["DataType"] == "31").first;
                _grp.title = _header["Description"];
                _grp.fields =
                    _fields.where((x) => x["DataType"] != "31").toList();
                group.add(_grp);
              }
            }
          }
        }
      }
      // print(FormFields);

      final _dd = group;
      formResponse = [];
      for (var i = 0; i < group.length; i++) {
        ResponseForm _formField = new ResponseForm();
        _formField.title = group[i].title;

        _formField.fields = [];

        if (group[i].fields!.length > 0) {
          for (var f = 0; f < group[i].fields!.length; f++) {
            var _gffield = group[i].fields![f];
            Fields _FF = Fields();
            _FF.FieldName = _gffield["Description"].toString();
            _FF.label = _gffield["Label"].toString();
            _FF.controller = new TextEditingController();
            _FF.fieldType = _gffield["DataType"].toString();

            if (_gffield["FieldData"] != null) {
              dynamic fieldData = jsonDecode(_gffield["FieldData"]);
              _FF.fieldData = _gffield["FieldData"];

              // List _fieldData =
              //     _gffield["FieldData"] != null ? _gffield["FieldData"] : [];

              isDynamicApi = fieldData["isDynamic"];
              if (isDynamicApi == false) {
                var _Data = fieldData["options"];
                List<dynamic> _fieldData = new List<dynamic>.from(_Data);

                _FF.options = [];

                for (var fd = 0; fd < _fieldData.length; fd++) {
                  // var isDynamicApi = fieldData[fd]["isDynamicApi"];
                  var FD = _fieldData[fd];
                  Options? _FD = Options();
                  _FD.optionLabel = FD["text"].toString();
                  _FD.optionValue = FD["value"].toString();
                  _FD.isDynamic = false;

                  _FF.options!.add(_FD);
                }
              } else {
                isDynamicApi_DD = true;

                _FF.options = [];

                getAllCategory();

                Options? _FD = Options();
                _FD.isDynamic = true;

                _FF.options!.add(_FD);
              }
            }

            _formField.fields!.add(_FF);
          }
        }

        formResponse.add(_formField);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await
          // getFormJson();
          // getAllCategory();
          getFormFields();
      buildDynamicForm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dynamic Form"),
      ),
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: getFormFields,
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: PageScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              //  Text(formResponse[index].title!),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.grey[300],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 10.0),
                                    child: Text(
                                      formResponse[index].title!.toString(),
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 17.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              myFormType(index),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 20,
                          );
                        },
                        itemCount: formResponse.length),
                  ),
                  new Container(
                    child: ElevatedButton(
                        onPressed: submitData, child: Text("submit")),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //TextEditingController controller = new TextEditingController();
  dynamic formvalue = {};
  submitData() {
    // print(formvalue);
    // print(formResponse[1].fields![1].controller!.text);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("close"))
              ],
              title: Text("Form value"),
              contentPadding: EdgeInsets.all(20.0),
              content: Text(formvalue.toString()),
            ));
    BaseClient().insertDynamic(formvalue);
  }

  Widget myFormType(int index) {
    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: PageScrollPhysics(),
        itemBuilder: (ctx, i) {
          Widget? _ret;

          switch (formResponse[index].fields![i].fieldType) {
            case "1":
              {
                _ret = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formResponse[index].fields![i].label.toString()),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                        controller: formResponse[index].fields![i].controller,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: formResponse[index].fields![i].label),
                        onChanged: (value) {
                          setState(() {
                            formvalue[formResponse[index]
                                .fields![i]
                                .FieldName] = value;
                          });
                        }),
                  ],
                );
                break;
              }
            case "3":
              {
                _ret = myDatePicker(index, i);
                break;
              }
            case "9":
              {
                _ret = SwitchListTile(
                    value: switchValue,
                    title: Text(formResponse[index].fields![i].label!),
                    onChanged: (value) {
                      setState(() {
                        switchValue = !switchValue;
                        formvalue[formResponse[index].fields![i].FieldName] =
                            value;
                      });
                    });
                break;
              }
            case "8":
              {
                _ret = dropDownWidget(
                    formResponse[index].fields![i].options, index, i);
                break;
              }
          }

          return _ret;
        },
        separatorBuilder: (ctx, i) {
          return SizedBox(
            height: 20,
          );
        },
        itemCount: formResponse[index].fields!.length);
  }

  Widget myDatePicker(int index, int i) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formResponse[index].fields![i].label.toString()),
        SizedBox(
          height: 10.0,
        ),
        Container(
          child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _selectDate(context, index, i);
              },
              child: AbsorbPointer(
                child: TextFormField(
                  onChanged: (value) {
                    setState(() {});
                  },
                  controller: formResponse[index].fields![i].controller,
                  obscureText: false,
                  cursorColor: Theme.of(context).primaryColor,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14.0,
                  ),
                  decoration: InputDecoration(
                    labelStyle:
                        TextStyle(color: Theme.of(context).primaryColor),
                    focusColor: Theme.of(context).primaryColor,
                    filled: true,
                    enabledBorder: UnderlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    labelText: "Date select",
                    prefixIcon: const Icon(
                      Icons.calendar_today,
                      size: 18,
                    ),
                  ),
                ),
              )),
        ),
      ],
    );
  }

  DateTime selectedDate = DateTime.now();

  Future _selectDate(BuildContext context, int index, int i) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970),
        lastDate: DateTime(2050));
    if (picked != null && picked != selectedDate) {
      setState(() {
        var date = DateTime.parse(picked.toString());
        var formatted = "${date.year}-${date.month}-${date.day}";
        formResponse[index].fields![i].controller = TextEditingController();
        formvalue[formResponse[index].fields![i].FieldName] = formatted;
        formResponse[index].fields![i].controller =
            TextEditingController(text: formatted.toString());
      });
    }
  }

  dropDownWidget(List<Options>? items, index, i) {
    //  if (items != null) {

    // List<Options> newitems = dynamicDropdownOption(index, i);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formResponse[index].fields![i].label.toString()),
        SizedBox(
          height: 10.0,
        ),
        // Container(
        //   child: DropdownButtonFormField<Options>(
        //     // Initial Value
        //     value: dropdownvalue,
        //     key: UniqueKey(),
        //     decoration: InputDecoration(
        //       border: const OutlineInputBorder(
        //         borderRadius: BorderRadius.all(
        //           Radius.circular(10.0),
        //         ),
        //       ),
        //       filled: true,
        //       hintStyle: TextStyle(color: Colors.grey[800]),
        //       hintText: formResponse[index].fields![i].label.toString(),
        //     ),
        //     borderRadius: BorderRadius.circular(10),

        //     // Down Arrow Icon
        //     icon: const Icon(Icons.keyboard_arrow_down),

        //     // Array list of items

        //     items: newitems.map((x) {
        //       return DropdownMenuItem(
        //         value: x,
        //         child: Text(x.optionValue!),
        //       );
        //     }).toList(),

        //     // items: categoryItemlist.map((item) {
        //     //   return DropdownMenuItem(
        //     //     value: item['ClassCode'].toString(),
        //     //     child: Text(item['ClassName'].toString()),
        //     //   );
        //     // }).toList(),

        //     // After selecting the desired option,it will
        //     // change button value to selected value
        //     onChanged: (value) {
        //       setState(() {
        //         formvalue[formResponse[index].fields![i].FieldName] =
        //             value?.optionValue;
        //         formResponse[index].fields![i].fieldValue =
        //             value?.optionValue.toString();
        //         dynamic _ss = value?.optionValue;
        //         dropdownvalue = _ss;
        //       });
        //     },
        //     onTap: () {
        //       print("Done");
        //     },
        //   ),
        // ),
        Container(
          // child: OutlinedButton(
          //     onPressed: () async {
          //       await dynamicDropdownOptionnew(index, i);
          //       // await showModalBottomSheet<void>(
          //       //   isScrollControlled: true,
          //       //   context: context,
          //       //   builder: (BuildContext context) {
          //       //     return Container(
          //       //       // height: 200,
          //       //       color: Colors.amber,
          //       //       child: Center(
          //       //         child: Column(
          //       //           mainAxisAlignment: MainAxisAlignment.center,
          //       //           mainAxisSize: MainAxisSize.min,
          //       //           children: <Widget>[
          //       //             const Text('Modal BottomSheet'),
          //       //             ElevatedButton(
          //       //               child: const Text('Close BottomSheet'),
          //       //               onPressed: () => Navigator.pop(context),
          //       //             ),
          //       //           ],
          //       //         ),
          //       //       ),
          //       //     );
          //       //   },
          //       // );
          //       print("no");
          //     },
          //     child: Text(
          //       formResponse[index].fields![i].label.toString(),
          //     )),
          child: TextField(
              readOnly: true,
              controller: formResponse[index].fields![i].controller,
              decoration: InputDecoration(
                filled: true,
                border: OutlineInputBorder(),
                hintText: formResponse[index].fields![i].label,
                suffixIcon: Icon(Icons.arrow_drop_down),
              ),
              onTap: () async {
                await dynamicDropdownOptionnew(index, i);
              },
              onChanged: (value) {
                setState(() {
                  formvalue[formResponse[index].fields![i].FieldName] = value;
                });
              }),
        ),
      ],
    );
    // } else {
    //   return SizedBox(
    //     height: 2,
    //   );
    // }
  }

  List formfields = [];

  buildDynamicForm() {
    dynamic _json;
    // dynamic _Fields = {"Field": null, "Controller": null, "Datatype": null};
    // Fields _Fields;

    for (var i = 0; i < formResponse.length; i++) {
      ResponseForm json = formResponse[i];
      for (var j = 0; j < json.fields!.length; j++) {
        Fields field = json.fields![j];

        Fields _Fields = Fields(
            label: field.label,
            FieldName: field.FieldName,
            fieldType: field.fieldType,
            controller: new TextEditingController());

        setState(() {
          formvalue[_Fields.FieldName] = null;
          formfields.add(_Fields);
        });

        print(formfields.toString());
      }
    }
  }

  dynamicDropdownOption(int index, int i) {
    List<Options>? ddloptionList = [];
    // Fields Field = formResponse[index].fields![i];
    dynamic _Field = jsonDecode(formResponse[index].fields![i].fieldData);

    if (_Field != null) {
      bool isdynamic = _Field["isDynamic"];
      if (isdynamic) {
        List _Data = [];
        //  DataSourceType _DataSourceType = DataSourceType.RestApi;

        if (formResponse[index].fields![i].optionsData == null) {
          var Dy_api = _Field["rest"];
          var _DataSourceType = Dy_api["DataSourceType"];
          var _valueField = Dy_api["valueField"];
          var _Column = Dy_api["Column"];
          var _FieldLable = _Column[0]["Field"].toString();

          int _RestApi = DataSourceType.RestApi.intValue;

          // if (_DataSourceType == 1) {
          //   var _url = Dy_api["URL"];
          //   var _Method = Dy_api["Method"];
          //   _getDynamic_DD(_url);
          // }
          switch (_DataSourceType) {
            case 1:
              {
                var _url = Dy_api["URL"];
                var _Method = Dy_api["Method"];
                //  _getDynamic_DD(_url, index, i);
                _getDynamic_DD(_url, index, i, "").then((as) async {
                  formResponse[index].fields![i].optionsData = await as;
                });
                // _getDynamic_DD(_url, index, i).then(
                //   (value) {
                //     print(value);
                //   },
                // );
                // dynamic _Data = _getDynamic_DD(_url, Field);
                // Field.optionsData = _Data;
                break;
              }
            default:
              {}
          }

          if (formResponse[index].fields![i].optionsData != null) {
            formResponse[index].fields![i].optionsData!.forEach((x) => {
                  _Data.add(x),
                });

            for (var i = 0; i < _Data.length; i++) {
              String optionLabel = _Data[i][_valueField].toString();
              String optionText = _Data[i][_FieldLable].toString();

              Options ddloption = Options(
                optionLabel: optionLabel,
                optionValue: optionText,
              );

              ddloptionList.add(ddloption);
            }
          }
        }
      } else {
        List _Data = [];

        if (_Field["options"] != null) {
          _Data = _Field["options"];

          for (var i = 0; i < _Data.length; i++) {
            String optionLabel = _Data[i]["text"].toString();
            String optionText = _Data[i]["value"].toString();

            // DropdownMenuItem<Options> ddloption = DropdownMenuItem<Options>(
            //   optionLabel: optionLabel,
            //   optionValue: Text(optionText),
            // );

            Options ddloption = Options(
              optionLabel: optionLabel,
              optionValue: optionText,
            );

            ddloptionList.add(ddloption);
          }
        }
      }
    }

    // categoryItemlist.map((item) {
    //   return DropdownMenuItem(
    //     value: item['ClassCode'].toString(),
    //     child: Text(item['ClassName'].toString()),
    //   );
    // }).toList();

    // ddloptionList.map((Options items) {
    //   return DropdownMenuItem<Options>(
    //     value: items,
    //     child: Text(items.optionValue!),
    //   );
    // }).toList();

    return ddloptionList;
  }

  dynamicDropdownOptionnew(int index, int i) async {
    List<Options>? ddloptionList = [];
    // Fields Field = formResponse[index].fields![i];
    dynamic _Field = jsonDecode(formResponse[index].fields![i].fieldData);

    if (_Field != null) {
      bool isdynamic = _Field["isDynamic"];
      if (isdynamic) {
        List _Data = [];
        //  DataSourceType _DataSourceType = DataSourceType.RestApi;

        var Dy_api = _Field["rest"];
        var _DataSourceType = Dy_api["DataSourceType"];
        var _valueField = Dy_api["valueField"];
        var _Column = Dy_api["Column"];
        var _FieldLable = _Column[0]["Field"].toString();

        var _ResponseView = Dy_api["ResponseView"];

        int _RestApi = DataSourceType.RestApi.intValue;

        // if (_DataSourceType == 1) {
        //   var _url = Dy_api["URL"];
        //   var _Method = Dy_api["Method"];
        //   _getDynamic_DD(_url);
        // }
        switch (_DataSourceType) {
          case 1:
            {
              var _url = Dy_api["URL"];
              var _Method = Dy_api["Method"];
              await _getDynamic_DD(_url, index, i, _ResponseView);
              // _getDynamic_DD(_url, index, i).then((as) async {
              //   formResponse[index].fields![i].optionsData = await as;
              // });

              // _getDynamic_DD(_url, index, i).then(
              //   (value) {
              //     print(value);
              //   },
              // );
              // dynamic _Data = _getDynamic_DD(_url, Field);
              // Field.optionsData = _Data;
              break;
            }
          default:
            {}
        }

        if (formResponse[index].fields![i].optionsData != null) {
          formResponse[index].fields![i].optionsData!.forEach((x) => {
                _Data.add(x),
              });

          for (var i = 0; i < _Data.length; i++) {
            String optionLabel = _Data[i][_valueField].toString();
            String optionText = _Data[i][_FieldLable].toString();

            Options ddloption = Options(
              optionLabel: optionLabel,
              optionValue: optionText,
            );

            ddloptionList.add(ddloption);
          }
        }
      } else {
        List _Data = [];

        if (_Field["options"] != null) {
          _Data = _Field["options"];

          for (var i = 0; i < _Data.length; i++) {
            String optionLabel = _Data[i]["text"].toString();
            String optionText = _Data[i]["value"].toString();

            // DropdownMenuItem<Options> ddloption = DropdownMenuItem<Options>(
            //   optionLabel: optionLabel,
            //   optionValue: Text(optionText),
            // );

            Options ddloption = Options(
              optionLabel: optionLabel,
              optionValue: optionText,
            );

            ddloptionList.add(ddloption);
          }
        }
      }
    }

    // categoryItemlist.map((item) {
    //   return DropdownMenuItem(
    //     value: item['ClassCode'].toString(),
    //     child: Text(item['ClassName'].toString()),
    //   );
    // }).toList();

    // ddloptionList.map((Options items) {
    //   return DropdownMenuItem<Options>(
    //     value: items,
    //     child: Text(items.optionValue!),
    //   );
    // }).toList();
    if (ddloptionList.length > 0 ||
        formResponse[index].fields![i].optionsData != null) {
      // await showModalBottomSheet<void>(
      //   // isScrollControlled: true,
      //   context: context,
      //   builder: (BuildContext context) {
      //     return Container(
      //       height: 200,
      //       color: Colors.amber,
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         mainAxisSize: MainAxisSize.min,
      //         children: <Widget>[
      //           Expanded(
      //               child: ListView.builder(
      //                   itemCount: ddloptionList.length,
      //                   itemBuilder: (context, index) {
      //                     return Container(
      //                       child: Center(
      //                         child: Text(ddloptionList[index].optionValue!),
      //                       ),
      //                     );
      //                   })),
      //           ElevatedButton(
      //             child: const Text('Close BottomSheet'),
      //             onPressed: () => Navigator.pop(context),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // );

      await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              title: Text(formResponse[index].fields![i].FieldName.toString()),
              message: Text("Your options are"),
              actions: ddloptionList
                  .map((item) => CupertinoActionSheetAction(
                        child: Text(item.optionValue!),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            formvalue[formResponse[index]
                                .fields![i]
                                .FieldName] = item.optionLabel!;
                            formResponse[index].fields![i].fieldValue =
                                item.optionLabel!.toString();
                            formResponse[index].fields![i].controller!.text =
                                item.optionValue!;
                          });
                        },
                      ))
                  .toList(),
              cancelButton: CupertinoActionSheetAction(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
          });
      return await ddloptionList;
    }
  }

  // bindDDdata(index,i){
  //   if (formResponse[index].fields![i].optionsData != null) {
  //           formResponse[index].fields![i].optionsData!.forEach((x) => {
  //                 _Data.add(x),
  //               });

  //           for (var i = 0; i < _Data.length; i++) {
  //             String optionLabel = _Data[i][_valueField].toString();
  //             String optionText = _Data[i][_FieldLable].toString();

  //             Options ddloption = Options(
  //               optionLabel: optionLabel,
  //               optionValue: optionText,
  //             );

  //             ddloptionList.add(ddloption);
  //           }
  //         }
  // }

  // Future _async() async{

  // }

  Future _getDynamic_DD(_url, int index, int i, String? _ResponseView) async {
    dynamic data = await BaseClient().getDynamic_DD(_url);
    dynamic json = await jsonDecode(data);

    dynamic _jsonData = json;

    if (_ResponseView != null) {
      List _rview = _ResponseView.split(".");

      _rview.forEach((x) {
        if (_jsonData != null && !_jsonData.isEmpty) {
          _jsonData = _jsonData[x];
          json = _jsonData;
        } else
          json = [];
      });
    }

    formResponse[index].fields![i].optionsData = await json;

    // if (json != null) {
    //   showModalBottomSheet<void>(
    //     isScrollControlled: true,
    //     context: context,
    //     builder: (BuildContext context) {
    //       return Container(
    //         // height: 200,
    //         color: Colors.amber,
    //         child: Center(
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             mainAxisSize: MainAxisSize.min,
    //             children: <Widget>[
    //               const Text('Modal BottomSheet'),
    //               ElevatedButton(
    //                 child: const Text('Close BottomSheet'),
    //                 onPressed: () => Navigator.pop(context),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   );
    // }

    // return formResponse[index].fields![i].optionsData;
  }

  Future DisplayBottomSheet() {
    return showCupertinoModalPopup(context: context, builder: buildActionSheet);
  }

  Widget buildActionSheet(BuildContext context) {
    return CupertinoActionSheet(
      title: Text("header"),
      message: Text("msg data"),
      actions: [
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, 1);
          },
          child: Text("Action 1"),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, 2);
          },
          child: Text("Action 2"),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, 3);
          },
          child: Text("Action 3"),
        ),
        CupertinoActionSheetAction(
          onPressed: () {
            Navigator.pop(context, 4);
          },
          child: Text("Action 4"),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}


//  ElevatedButton(
//                                 onPressed: () async {
//                                   final dynamic? Data =
//                                       await showCupertinoModalPopup(
//                                           context: context,
//                                           builder: buildActionSheet);

//                                   print("object$Data");
//                                 },
//                                 child: Text("new"),
//                               ),
//                               Center(
//                                 child: ElevatedButton(
//                                   child: const Text('showModalBottomSheet'),
//                                   onPressed: () {
//                                     showModalBottomSheet<void>(
//                                       isScrollControlled: true,
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return Container(
//                                           // height: 200,
//                                           color: Colors.amber,
//                                           child: Center(
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               mainAxisSize: MainAxisSize.min,
//                                               children: <Widget>[
//                                                 const Text('Modal BottomSheet'),
//                                                 ElevatedButton(
//                                                   child: const Text(
//                                                       'Close BottomSheet'),
//                                                   onPressed: () =>
//                                                       Navigator.pop(context),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     );
//                                   },
//                                 ),
//                               ),