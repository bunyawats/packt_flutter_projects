import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/firebase/screens/login_screen.dart';
import '../models/event_detail.dart';
import '../shared/authentication.dart';

class EventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Authentication auth = new Authentication();

    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              auth.signOut().then((result) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ));
              });
            },
          )
        ],
      ),
      body: EventList(),
    );
  }
}

class EventList extends StatefulWidget {
  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Firestore db = Firestore.instance;
  List<EventDetail> details = [];

  Future<List<EventDetail>> getDetailList() async {
    var data = await db.collection('event_details').getDocuments();
    if (data != null) {
      details = data.documents
          .map(
            (document) => EventDetail.fromMap(document),
          )
          .toList();
      int i = 0;
      details.forEach((detail) {
        detail.id = data.documents[i].documentID;
        i++;
      });
    }
    return details;
  }

  @override
  void initState() {
    if (mounted) {
      getDetailList().then((data) {
        setState(() {
          details = data;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: (details != null) ? details.length : 0,
      itemBuilder: (context, position) {
        String sub =
            'Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}';
        return ListTile(
          title: Text(details[position].description),
          subtitle: Text(sub),
        );
      },
    );
  }
}
