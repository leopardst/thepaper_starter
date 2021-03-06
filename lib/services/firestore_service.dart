import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = false,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.set(data, SetOptions(merge: merge));
  }

  Future<void> updateData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path: $data');
    await reference.update(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  // Stream<List<T>> collectionStream<T>({
  //   @required String path,
  //   @required T builder(Map<String, dynamic> data, String documentID),
  //   Query queryBuilder(Query query),
  //   int sort(T lhs, T rhs),
  // }) {
  //   Query query = Firestore.instance.collection(path);
  //   if (queryBuilder != null) {
  //     query = queryBuilder(query);
  //   }
  //   final Stream<QuerySnapshot> snapshots = query.snapshots();
  //   return snapshots.map((snapshot) {
  //     final result = snapshot.documents
  //         .map((snapshot) => builder(snapshot.data, snapshot.documentID))
  //         .where((value) => value != null)
  //         .toList();
  //     if (sort != null) {
  //       result.sort(sort);
  //     }
  //     return result;
  //   });
  // }

   Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
    Query Function(Query query)? queryBuilder,
    int Function(T lhs, T rhs)? sort,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  Future<List<T>> collectionList<T>({
    required String path,
    required T builder(Map<String, dynamic> data, String documentID),
    QuerySnapshot queryBuilder(QuerySnapshot query)?,
    int sort(T lhs, T rhs)?,
  }) async {
    QuerySnapshot query = await FirebaseFirestore.instance.collection(path).get();
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    // final Future<QuerySnapshot> snapshots = query.snapshots();

    final list = query.docs.map((snapshot) => 
      builder(snapshot.data() as Map<String, dynamic>, snapshot.id)).toList();

    if (sort != null) {
      list.sort(sort);
    }
      return list;
  }

  // Stream<T> documentStream<T>({
  //   @required String path,
  //   @required T builder(Map<String, dynamic> data, String documentID),
  // }) {
  //   final DocumentReference reference = FirebaseFirestore.instance.doc(path);
  //   final Stream<DocumentSnapshot> snapshots = reference.snapshots();
  //   return snapshots
  //       .map((snapshot) => builder(snapshot.data(), snapshot.id));
  // }

  Stream<T> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic>? data, String documentID) builder,
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data() as Map<String, dynamic>?, snapshot.id));
  }

  Future<T> documentFuture<T>({
    required String path,
    required T builder(Map<String, dynamic>? data, String documentID),
  }) {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot> snapshot = reference.snapshots();
    return snapshot
        .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>?, snapshot.id)).first;
  }

}
