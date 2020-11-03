import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hello_world/firebase/models/favorite.dart';
import 'package:hello_world/firebase/screens/login_screen.dart';
import 'package:hello_world/firebase/shared/firestore_helper.dart';
import '../models/event_detail.dart';
import '../shared/authentication.dart';

class EventScreen extends StatelessWidget {
  final String uid;
  EventScreen(this.uid);

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
                  ),
                );
              });
            },
          )
        ],
      ),
      body: EventList(uid),
    );
  }
}

class EventList extends StatefulWidget {
  final String uid;
  EventList(this.uid);

  @override
  _EventListState createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  Firestore db = Firestore.instance;
  List<EventDetail> details = [];
  List<Favourite> favourites = [];

  void toggleFavourite(EventDetail ed) async {
    if (isUserFavourite(ed.id)) {
      Favourite favourite =
          favourites.firstWhere((Favourite f) => (f.eventId == ed.id));
      String favId = favourite.id;
      await FirestoreHelper.deleteFavourite(favId);
    } else {
      await FirestoreHelper.addFavourite(ed, widget.uid);
    }
    List<Favourite> updatedFavorites =
        await FirestoreHelper.getUserFavourites(widget.uid);
    setState(() {
      favourites = updatedFavorites;
    });
  }

  bool isUserFavourite(String eventId) {
    Favourite favourite = favourites.firstWhere(
      (Favourite f) => (f.eventId == eventId),
      orElse: () => null,
    );
    return (favourite == null) ? false : true;
  }

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

      FirestoreHelper.getUserFavourites(widget.uid).then((data) {
        setState(() {
          favourites = data;
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
        Color starColor = (isUserFavourite(details[position].id)
            ? Colors.amber
            : Colors.grey);

        String sub =
            'Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}';
        return ListTile(
          title: Text(details[position].description),
          subtitle: Text(sub),
          trailing: IconButton(
            icon: Icon(
              Icons.star,
              color: starColor,
            ),
            onPressed: () {
              toggleFavourite(details[position]);
            },
          ),
        );
      },
    );
  }
}
