import 'dart:async';

import 'package:meta/meta.dart';
import 'package:thepaper_starter/app/home/models/entry.dart';
import 'package:thepaper_starter/app/home/models/group.dart';
import 'package:thepaper_starter/app/home/models/job.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:thepaper_starter/app/home/models/user_profile.dart';

import 'package:thepaper_starter/services/firestore_path.dart';
import 'package:thepaper_starter/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Stream<Funeral> funeralStream({required String? funeralId}) => _service.documentStream(
        path: FirestorePath.funeral(funeralId),
        builder: (data, documentId) => Funeral.fromMap(data!, documentId),
      );

  Stream<List<Funeral>> funeralsStream() => _service.collectionStream(
        path: FirestorePath.funerals(),
        queryBuilder: (query) => query.where('isLive', isEqualTo: true)
          .where('isDeleted', isEqualTo: false),
          
        builder: (data, documentId) => Funeral.fromMap(data, documentId),
        sort: (lhs, rhs) => rhs.createdDate!.compareTo(lhs.createdDate!),
      );

    Stream<List<Funeral>> funeralsStreamAfterDate({required int daysAfter}) => _service.collectionStream(
        path: FirestorePath.funerals(),
        queryBuilder: (query) => query.where('isLive', isEqualTo: true)
          .where('isDeleted', isEqualTo: false)
          .where('funeralDate', isGreaterThanOrEqualTo: new DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day + daysAfter)),
        builder: (data, documentId) => Funeral.fromMap(data, documentId),
        sort: (lhs, rhs) => rhs.createdDate!.compareTo(lhs.createdDate!),
      );

    Stream<List<Funeral>> funeralsStreamSinceDaysAgo({required int daysAgo}) => _service.collectionStream(
        path: FirestorePath.funerals(),
        queryBuilder: (query) => query.where('isLive', isEqualTo: true)
          .where('isDeleted', isEqualTo: false)
          .where('createdDate', isGreaterThanOrEqualTo: new DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day - daysAgo)),
        builder: (data, documentId) => Funeral.fromMap(data, documentId),
        sort: (lhs, rhs) => rhs.createdDate!.compareTo(lhs.createdDate!),
      );
  
  Stream<List<Condolence>> condolencesStream({required Funeral funeral}) => _service.collectionStream(
        path: FirestorePath.condolences(funeral.id),
        queryBuilder: (query) => query.where('isPublic', isEqualTo: true)
          .where('isDeleted', isEqualTo: false),
        builder: (data, documentId) => Condolence.fromMap(data, documentId),
        sort: (lhs, rhs) => rhs.updatedAt.compareTo(lhs.updatedAt),
      );
  
  Future<void> setCondolence(Condolence condolence, String funeralId, {bool merge = false}) async => await _service.setData(
      path: FirestorePath.condolence(funeralId, uid),
      data: condolence.toMap(),
      merge: merge,
    );

  Stream<Condolence> condolenceStream({required String funeralId}) => _service.documentStream(
        path: FirestorePath.condolence(funeralId, uid),
        builder: (data, documentId) => Condolence.fromMap(data!, documentId),
  );

  Future<List<Condolence>> condolencesList({required Funeral funeral}) async => await _service.collectionList(
        path: FirestorePath.condolences(funeral.id),
        builder: (data, documentId) => Condolence.fromMap(data, documentId),
  );

    Future<List<Comment>> commentsList({required Funeral funeral}) => _service.collectionList(
      path: FirestorePath.comments(funeral.id),
      builder: (data, documentId) => Comment.fromMap(data, documentId),
  );


  Future<void> deleteCondolence(String funeralId) async => 
      await _service.deleteData(path: FirestorePath.condolence(funeralId, uid));
  
  Stream<List<Comment>> commentsStream({required Funeral funeral}) => _service.collectionStream(
      path: FirestorePath.comments(funeral.id),
      queryBuilder: (query) => query.where('isPublic', isEqualTo: true)
        .where('isDeleted', isEqualTo: false),
      builder: (data, documentId) => Comment.fromMap(data, documentId),
      sort: (lhs, rhs) => rhs.updatedAt.compareTo(lhs.updatedAt),
  );
  

  Future<void> setComment(Comment comment, String funeralId, {bool merge = false}) async => await _service.setData(
      path: FirestorePath.comment(funeralId, uid),
      data: comment.toMap(),
      merge: merge,
    );

  Future<void> updateUserProfile(Map<String, dynamic> userProfileUpdates) async => await _service.updateData(
    path: FirestorePath.userProfile(uid),
    data: userProfileUpdates,
  );

  Stream<UserProfile> userProfileStream({required String uid}) => _service.documentStream(
    path: FirestorePath.userProfile(uid),
    builder: (data, documentId) => UserProfile.fromMap(data!, documentId),
  );

  Future<UserProfile> userProfileFuture({required String uid}) => _service.documentFuture(
    path: FirestorePath.userProfile(uid),
    builder: (data, documentId) => UserProfile.fromMap(data!, documentId),
  );

  Stream<List<UserCondolence>> userCondolencesStream({required String uid}) => _service.collectionStream(
        path: FirestorePath.usercondolences(uid),
        queryBuilder: (query) => query.where('isDeleted', isEqualTo: false),
        builder: (data, documentId) => UserCondolence.fromMap(data, documentId)
        // sort: (lhs, rhs) => rhs.updatedAt.compareTo(lhs.updatedAt),
      );

  Stream<Group> groupStream({required String groupId}) => _service.documentStream(
        path: FirestorePath.group(groupId),
        builder: (data, documentId) => Group.fromMap(data!, documentId),
  );

  
}
