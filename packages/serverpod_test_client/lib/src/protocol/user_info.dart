/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class UserInfo extends SerializableEntity {
  String get className => 'UserInfo';

  int? id;
  String? name;
  String? password;
  int? another;
  String? test;

  UserInfo({
    this.id,
    this.name,
    this.password,
    this.another,
    this.test,
});

  UserInfo.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    name = _data['name'];
    password = _data['password'];
    another = _data['another'];
    test = _data['test'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'name': name,
      'password': password,
      'another': another,
      'test': test,
    });
  }
}

