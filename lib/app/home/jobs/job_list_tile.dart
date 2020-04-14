
import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/models/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({Key key, @required this.job }) : super(key: key);
  final Job job;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
