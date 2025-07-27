import 'dart:collection';

import 'package:event_planner/classes/Budget.dart';
import 'package:event_planner/classes/Guest.dart';
import 'package:event_planner/classes/ShoppingList.dart';
import 'package:event_planner/classes/ToDoList.dart';

class Event {
  String id;
  String title;
  String location;
  String note;
  final DateTime startDate;
  final DateTime endDate;
  Budget budget;
  final String userId;
  List<Guest> guests;
  List<ShoppingList> shoppingList;
  List<ToDoList> todoList;
  Event(this.title, this.location, this.note, this.startDate, this.endDate,
      this.budget, this.userId, this.guests, this.shoppingList, this.todoList);

  set guestsList(Guest guest) {
    guests.add(guest);
  }

  set eventId(String id) {
    this.id = id;
  }

  set addToShoppingList(ShoppingList item) {
    shoppingList.add(item);
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'location': location,
        'note': note,
        'startDate': startDate,
        'endDate': endDate,
        'budget': budget,
        'userId': userId,
        'guests': [],
        'shoppingList': [],
        'todoList': []
      };
}
