import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/models/job.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/routing/router.gr.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, this.job}) : super(key: key);
  final Job job;

  static Future<void> show(BuildContext context, {Job job}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      Router.editJobPage,
      arguments: EditJobPageArguments(job: job),
    );
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        final jobs = await database.jobsStream().first;
        final allLowerCaseNames =
            jobs.map((job) => job.name.toLowerCase()).toList();
        if (widget.job != null) {
          allLowerCaseNames.remove(widget.job.name.toLowerCase());
        }
        if (allLowerCaseNames.contains(_name.toLowerCase())) {
          PlatformAlertDialog(
            title: 'Name already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await database.setJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
            onPressed: _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job name'),
        keyboardAppearance: Brightness.light,
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Rate per hour'),
        keyboardAppearance: Brightness.light,
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
