/*

Formate la manière d'afficher la date

Convertit un Timestamp en String dans un format
lisible par nos utilisateurs

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return DateFormat('dd-MM-yyyy HH:mm').format(dateTime);
}