class FirestorePath {
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
  static String funeral(String funeralId) => 'funerals/$funeralId';
  static String funerals() => 'funerals';
  static String condolences(String funeralId) => 'funerals/$funeralId/condolences';
  static String condolence(String funeralId, String uid) => 'funerals/$funeralId/condolences/$uid';

}
