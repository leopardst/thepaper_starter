// import 'package:flutter/foundation.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:thepaper_starter/app/home/models/funeral.dart';
// import 'package:thepaper_starter/services/firestore_database.dart';
// import 'package:thepaper_starter/app/home/funerals/funeral_list_tile.dart';

// class FuneralsViewModel {
//   FuneralsViewModel({@required this.database});
//   final FirestoreDatabase database;

//   /// combine List<Job>, List<Entry> into List<EntryJob>
//   // Stream<List<EntryJob>> get _allEntriesStream => CombineLatestStream.combine2(
//   //       database.entriesStream(),
//   //       database.jobsStream(),
//   //       _entriesJobsCombiner,
//   //     );

//   // static List<EntryJob> _entriesJobsCombiner(
//   //     List<Entry> entries, List<Job> jobs) {
//   //   return entries.map((entry) {
//   //     final job = jobs.firstWhere((job) => job.id == entry.jobId);
//   //     return EntryJob(entry, job);
//   //   }).toList();
//   // }

//   /// Output stream
//   Stream<List<Funeral>> get funeralsModelStream =>
//       _allEntriesStream.map(_createModels);

//   static List<EntriesListTileModel> _createModels(List<EntryJob> allEntries) {
//     if (allEntries.isEmpty) {
//       return [];
//     }

//     return <EntriesListTileModel>[
//       EntriesListTileModel(
//         leadingText: 'All Entries',
//         middleText: Format.currency(totalPay),
//         trailingText: Format.hours(totalDuration),
//       ),
//       for (DailyJobsDetails dailyJobsDetails in allDailyJobsDetails) ...[
//         EntriesListTileModel(
//           isHeader: true,
//           leadingText: Format.date(dailyJobsDetails.date),
//           middleText: Format.currency(dailyJobsDetails.pay),
//           trailingText: Format.hours(dailyJobsDetails.duration),
//         ),
//         for (JobDetails jobDuration in dailyJobsDetails.jobsDetails)
//           EntriesListTileModel(
//             leadingText: jobDuration.name,
//             middleText: Format.currency(jobDuration.pay),
//             trailingText: Format.hours(jobDuration.durationInHours),
//           ),
//       ]
//     ];
//   }
// }
