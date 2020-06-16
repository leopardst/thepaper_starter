import 'dart:async';

import 'package:meta/meta.dart';
import 'package:thepaper_starter/app/home/models/entry.dart';
import 'package:thepaper_starter/app/home/models/job.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:thepaper_starter/app/home/models/user_profile.dart';

import 'package:thepaper_starter/services/firestore_path.dart';
import 'package:thepaper_starter/services/firestore_service.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase {
  FirestoreDatabase({@required this.uid}) : assert(uid != null);
  final String uid;

  final _service = FirestoreService.instance;

  Future<void> setJob(Job job) async => await _service.setData(
        path: FirestorePath.job(uid, job.id),
        data: job.toMap(),
      );

  Future<void> deleteJob(Job job) async {
    // delete where entry.jobId == job.jobId
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    // delete job
    await _service.deleteData(path: FirestorePath.job(uid, job.id));
  }

  Stream<Job> jobStream({@required String jobId}) => _service.documentStream(
        path: FirestorePath.job(uid, jobId),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: FirestorePath.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  Future<void> setEntry(Entry entry) async => await _service.setData(
        path: FirestorePath.entry(uid, entry.id),
        data: entry.toMap(),
      );

  Future<void> deleteEntry(Entry entry) async =>
      await _service.deleteData(path: FirestorePath.entry(uid, entry.id));

  Stream<List<Entry>> entriesStream({Job job}) =>
      _service.collectionStream<Entry>(
        path: FirestorePath.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  Stream<Funeral> funeralStream({@required String funeralId}) => _service.documentStream(
        path: FirestorePath.funeral(funeralId),
        builder: (data, documentId) => Funeral.fromMap(data, documentId),
      );

  Stream<List<Funeral>> funeralsStream() => _service.collectionStream(
        path: FirestorePath.funerals(),
        queryBuilder: (query) => query.where('isLive', isEqualTo: true)
          .where('isDeleted', isEqualTo: false),
          
        builder: (data, documentId) => Funeral.fromMap(data, documentId),
        sort: (lhs, rhs) => rhs.createdDate.compareTo(lhs.createdDate),
      );
  
  Stream<List<Condolence>> condolencesStream({@required Funeral funeral}) => _service.collectionStream(
        path: FirestorePath.condolences(funeral.id),
        builder: (data, documentId) => Condolence.fromMap(data, documentId),
        sort: (lhs, rhs) => rhs.updatedAt.compareTo(lhs.updatedAt),
      );
  
  Future<void> setCondolence(Condolence condolence, String funeralId) async => await _service.setData(
      path: FirestorePath.condolence(funeralId, uid),
      data: condolence.toMap(),
    );

  Stream<Condolence> condolenceStream({@required String funeralId}) => _service.documentStream(
        path: FirestorePath.condolence(funeralId, uid),
        builder: (data, documentId) => Condolence.fromMap(data, documentId),
  );

  Future<List<Condolence>> condolencesList({@required String funeralId}) async => await _service.collectionList(
        path: FirestorePath.condolences(funeralId),
        builder: (data, documentId) => Condolence.fromMap(data, documentId),
  );

  Future<void> deleteCondolence(String funeralId) async =>
      await _service.deleteData(path: FirestorePath.condolence(funeralId, uid));
  
  Stream<List<Comment>> commentsStream({@required Funeral funeral}) => _service.collectionStream(
        path: FirestorePath.comments(funeral.id),
        queryBuilder: (query) => query.where('isPublic', isEqualTo: true),
        builder: (data, documentId) => Comment.fromMap(data, documentId),
        sort: (lhs, rhs) => rhs.createdAt.compareTo(lhs.createdAt),

      );
  
  Future<List<Comment>> commentsList({@required Funeral funeral}) => _service.collectionList(
      path: FirestorePath.comments(funeral.id),
      builder: (data, documentId) => Comment.fromMap(data, documentId),
    );


  Future<void> setComment(Comment comment, String funeralId) async => await _service.setData(
    path: FirestorePath.comment(funeralId, uid),
    data: comment.toMap(),
  );

  Stream<UserProfile> userProfileStream({@required String uid}) => _service.documentStream(
    path: FirestorePath.userProfile(uid),
    builder: (data, documentId) => UserProfile.fromMap(data, documentId),
  );

  Future<UserProfile> userProfileFuture({@required String uid}) => _service.documentFuture(
    path: FirestorePath.userProfile(uid),
    builder: (data, documentId) => UserProfile.fromMap(data, documentId),
  );

}
