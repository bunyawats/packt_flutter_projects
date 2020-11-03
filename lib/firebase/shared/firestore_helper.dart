import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_detail.dart';
import '../models/favorite.dart';

class FirestoreHelper {
  static final Firestore db = Firestore.instance;

  static Future testData() async {
    var data = await db.collection('event_details').getDocuments();
    var details = data.documents.toList();
    details.forEach((d) {
      print(d.documentID);
    });
  }

  static Future addFavourite(EventDetail eventDetail, String uid) {
    Favourite fav = Favourite(null, eventDetail.id, uid);

    var result = db
        .collection('favourites')
        .add(fav.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));

    return result;
  }

  static Future deleteFavourite(String favId) async {
    await db.collection('favourites').document(favId).delete();
  }

  static Future<List<Favourite>> getUserFavourites(String uid) async {
    List<Favourite> favs;
    QuerySnapshot docs = await db
        .collection('favourites')
        .where(
          'userId',
          isEqualTo: uid,
        )
        .getDocuments();

    if (docs != null) {
      favs = docs.documents
          .map(
            (data) => Favourite.map(data),
          )
          .toList();
    }

    return favs;
  }
}
