import 'package:flutter/material.dart';
import '../models/event_model.dart';

class AddEventScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final titleCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final locationCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Event")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(controller: titleCtrl, validator: (v)=>v!.isEmpty?"Enter title":null, decoration: InputDecoration(labelText: "Event Title")),
            TextFormField(controller: dateCtrl, validator: (v)=>v!.isEmpty?"Enter date":null, decoration: InputDecoration(labelText: "Date")),
            TextFormField(controller: locationCtrl, validator: (v)=>v!.isEmpty?"Enter location":null, decoration: InputDecoration(labelText: "Location")),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(context, Event(
                    title: titleCtrl.text,
                    date: dateCtrl.text,
                    location: locationCtrl.text,
                  ));
                }
              },
              child: Text("Add Event"),
            )
          ]),
        ),
      ),
    );
  }
}
