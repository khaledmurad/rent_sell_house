import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

abstract class DataBase{

}

class FireStoreDataBase implements DataBase{

  FireStoreDataBase({@required this.uid}) : assert (uid != null);
  final String uid;

}