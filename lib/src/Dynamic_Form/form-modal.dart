import 'package:flutter/material.dart';

class ResponseForm {
  String? title;
  List<Fields>? fields;

  ResponseForm({this.title, this.fields});

  ResponseForm.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['fields'] != null) {
      fields = <Fields>[];
      json['fields'].forEach((v) {
        fields!.add(Fields.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (fields != null) {
      data['fields'] = fields!.map((v) => v.toJson()).toList();
    }

    return data;
  }

  forEach(Map Function(dynamic field) param0) {}
}

class Fields {
  String? FieldName;
  String? label;
  String? fieldType;
  dynamic fieldValue;
  TextEditingController? controller;
  dynamic fieldData;
  List<Options>? options;
  List? optionsData;

  Fields({
    this.FieldName,
    this.label,
    this.fieldType,
    this.options,
    this.controller,
  });

  Fields.fromJson(Map<String, dynamic> json) {
    FieldName = json['FieldName'];
    label = json['label'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }

    fieldType = json['fieldType'];
    controller = new TextEditingController();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['FieldName'] = FieldName;
    data['label'] = label;

    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }

    data['fieldType'] = fieldType;

    return data;
  }
}

class Options {
  String? color;
  bool? isFaulty;
  bool? isDynamic;
  String? optionLabel;
  String? optionValue;

  Options(
      {this.color,
      this.isFaulty,
      this.optionLabel,
      this.optionValue,
      this.isDynamic});

  Options.fromJson(Map<String, dynamic> json) {
    color = json['color'];
    isFaulty = json['is_faulty'];
    optionLabel = json['optionLabel'];
    optionValue = json['optionValue'];
    isDynamic = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['optionLabel'] = optionLabel;
    data['optionValue'] = optionValue;
    return data;
  }
}
