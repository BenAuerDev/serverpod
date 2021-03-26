/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class DistributedCacheEntry extends SerializableEntity {
  String get className => 'DistributedCacheEntry';

  int? id;
  String? data;

  DistributedCacheEntry({
    this.id,
    this.data,
});

  DistributedCacheEntry.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    data = _data['data'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'data': data,
    });
  }
}

