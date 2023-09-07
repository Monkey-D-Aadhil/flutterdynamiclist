import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:awesome_dialog/awesome_dialog.dart';

const String baseUrl = 'https://test.arco.sa/SystemApi/api/v1/';

class BaseClient {
  var client = http.Client();

  Future<dynamic> get(String api) async {
    var url = Uri.parse(api);
    var response = await client.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {}
  }

  Future<dynamic> post(String api, dynamic object) async {
    var url = Uri.parse(api);
    var _payload = json.encode(object);
    var response = await client.post(url, body: _payload);
    if (response.statusCode == 200) {
      return response.body;
    } else {}
  }

  Future<dynamic> put(String api) async {}
  Future<dynamic> delete(String api) async {}

  Future<dynamic> getFormFields([int? EntityId]) async {
    if (EntityId == null) {
      EntityId = 10404;
    }

    var _api =
        'https://test.arco.sa/SystemApi/api/v1/entitytype/setup/details?entitytyperecId=$EntityId';
    var url = Uri.parse(_api);
    var _headers = {
      "Appcode": "App0000005",
      "Area": "System",
      "Authorization": "Bearer Public",
      "Clientsecretid": "E4A793E4-DC3E-46AB-A01E-AD12BADCA5BD",
      "Clientuserid": "Public",
      "Companycode": "FTS",
      "Environmentcode": "Live",
      "User-Id": "Public",
      "Username": "Public"
    };
    var response = await client.get(url, headers: _headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {}
  }

  Future<dynamic> getFormData([int? EntityId, dynamic? criteria]) async {
    // var _api =
    //     'https://test.arco.sa/SystemApi/api/v1//platform/sql/sysobjectexecute?recId=5&object_Type=V&objectName=IR_Summary_DemandLetter_BI';
    // var url = Uri.parse(_api);

    if (EntityId == null) {
      EntityId = 10404;
    }

    var _api =
        'https://test.arco.sa/SystemApi/api/v1/entitytype/dynamic/get/?entityTypeRecId=$EntityId';
    if (criteria != null) {
      var pagging = criteria["Pagging"];
      var _page = pagging["PageNo"];
      var _size = pagging["PageSize"];

      var pd = "&\$page=$_page&\$size=$_size";
      _api += pd;
    }
    var url = Uri.parse(_api);
    var _headers = {
      "Clientsecretid": "E4A793E4-DC3E-46AB-A01E-AD12BADCA5BD",
      "Clientuserid": "Public"
    };
    var response = await client.get(url, headers: _headers);

    // var response = await client.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {}
  }

  Future<dynamic> insertDynamic([dynamic object]) async {
    object["EntityTypeId"] = "10404";
    object["EntityType "] = "100";
    object["EnvironmentId "] = "Live";
    var _payload = json.encode(object);
    final queryParameters = {
      'EntityData': _payload,
    };
    var _api = '${baseUrl}entitytype/dynamic/insert';
    // var Url = Uri.https('test.arco.sa',        '/SystemApi/api/v1/entitytype/dynamic/insert', queryParameters);
    var Url = Uri.parse(_api);

    var map = new Map<String, dynamic>();
    map['EntityData'] = _payload;

    var _headers = {
      "Appcode": "App0000005",
      "Area": "System",
      "Authorization": "Bearer Public",
      "Clientsecretid": "E4A793E4-DC3E-46AB-A01E-AD12BADCA5BD",
      "Clientuserid": "Public",
      "Companycode": "FTS",
      "Environmentcode": "Live",
      "User-Id": "Public",
      "Username": "Public"
    };
    var response = await client.post(Url, headers: _headers, body: map);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      // AwesomeDialog(
      //       context: context,
      //       dialogType: DialogType.info,
      //       animType: AnimType.rightSlide,,
      //       title: 'Dialog Title',
      //       desc: 'Dialog description here.............',
      //       btnCancelOnPress: () {},
      //       btnOkOnPress: () {},
      //       )..show();
    }
  }

  Future<dynamic> getDynamic_DD([String? api]) async {
    var _Api = api;

    if (api!.contains("{{System.FrameworkUrl}}")) {
      String str = api!;
      String substr = "{{System.FrameworkUrl}}";
      String replacement = "https://test.arco.sa/SystemApi/";

      String _NApi = str.replaceFirst(substr, replacement);
      _Api = _NApi;
    }

    var url = Uri.parse(_Api!);
    var _headers = {
      "Appcode": "App0000005",
      "Area": "System",
      "Authorization": "Bearer Public",
      "Clientsecretid": "E4A793E4-DC3E-46AB-A01E-AD12BADCA5BD",
      "Clientuserid": "Public",
      "Companycode": "FTS",
      "Environmentcode": "Live",
      "User-Id": "Public",
      "Username": "Public"
    };
    var response = await client.get(url);

    // var response = await client.get(url);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return "[]";
    }
  }
}
