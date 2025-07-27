import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planner/classes/Budget.dart';
import 'package:event_planner/classes/Event.dart';
import 'package:event_planner/classes/Guest.dart';
import 'package:event_planner/classes/ShoppingList.dart';
import 'package:event_planner/classes/ToDoList.dart';
import 'package:event_planner/components/Toast.dart';
import 'package:event_planner/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';

class FirebaseHelper {
  final _instance = FirebaseFirestore.instance;

  void addEvent(Event ev, BuildContext context) {
    _instance.runTransaction((transaction) async {
      var res = await _instance.collection('events').add(ev.toJson());
      if (res.id != null) {
        showToast("Event added Successfully");
        Navigator.popAndPushNamed(
          context,
          HomeScreen.id,
        );
      }
    });
  }

  void updateGuests(List<Guest> guests, String id) {
    List objs = new List();
    guests.forEach((element) {
      objs.add(element.toJson());
    });
    _instance.runTransaction((transaction) async {
      var res =
          await _instance.collection('events').doc(id).update({'guests': objs});
    });
    showToast("Guest updated");
  }

  void updateEvent(location, title, note, String id) {
    _instance.runTransaction((transaction) async {
      var res = await _instance
          .collection('events')
          .doc(id)
          .update({'location': location, 'title': title, 'note': note});
    });
    showToast("Event updated");
  }

  void addGuest(String id, Guest guest, BuildContext context) {
    List obj = [guest.toJson()];
    _instance.runTransaction((transaction) async {
      var res = await _instance
          .collection('events')
          .doc(id)
          .update({'guests': FieldValue.arrayUnion(obj)});
    });
    showToast("Guest added");
  }

  void addTodo(String id, ToDoList todo, BuildContext context) {
    List obj = [todo.toJson()];
    _instance.runTransaction((transaction) async {
      var res = await _instance
          .collection('events')
          .doc(id)
          .update({'todoList': FieldValue.arrayUnion(obj)});
      showToast("Todo item added");
    });
  }

  void updateToDo(List<ToDoList> todo, String id) {
    List objs = new List();
    todo.forEach((element) {
      objs.add(element.toJson());
    });
    _instance.runTransaction((transaction) async {
      var res = await _instance
          .collection('events')
          .doc(id)
          .update({'todoList': objs});
    });
    showToast("Todo updated");
  }

  void addShoppingList(String id, ShoppingList shoppingList) {
    List obj = [shoppingList.toJson()];
    _instance.runTransaction((transaction) async {
      var res = await _instance
          .collection('events')
          .doc(id)
          .update({'shoppingList': FieldValue.arrayUnion(obj)});
      showToast("Shopping item added");
    });
  }

  void updateShopping(List<ShoppingList> shopping, String id) {
    List objs = new List();
    shopping.forEach((element) {
      objs.add(element.toJson());
    });
    _instance.runTransaction((transaction) async {
      var res = await _instance
          .collection('events')
          .doc(id)
          .update({'shoppingList': objs});
    });
    showToast("Shopping list updated");
  }

  void addBudget(String id, Budget budget) {
    _instance.runTransaction((transaction) async {
      var res = await _instance
          .collection('events')
          .doc(id)
          .update({'budget': budget.toJson()});
      showToast("Budget saved");
    });
  }

  void removeEvent(String id) {
    _instance.runTransaction((transaction) async {
      var res = await _instance.collection('events').doc(id).delete();
      showToast("Event Deleted");
    });
  }

  void removeGuest(String id, Guest guest) {
    List obj = [guest.toJson()];
    _instance.runTransaction((transaction) async {
      var res = await _instance
          .collection('events')
          .doc(id)
          .update({'guests': FieldValue.arrayRemove(obj)});
      showToast("Guest removed");
    });
  }
}
