import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:event_planner/classes/Event.dart';
import 'package:event_planner/classes/RouteArguments.dart';
import 'package:event_planner/components/Toast.dart';
import 'package:event_planner/components/button.dart';
import 'package:event_planner/constants.dart';
import 'package:event_planner/screens/guest/add_guest.dart';
import 'package:event_planner/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:event_planner/functions/FirebaseHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEvent extends StatefulWidget {
  static const String id = 'add_event';
  @override
  _AddEventState createState() => _AddEventState();
}

final globalScaffoldKey = GlobalKey<ScaffoldState>();
User loggedInUser;
final _firestore = FirebaseFirestore.instance;
final format = DateFormat("yyyy-MM-dd HH:mm");

class _AddEventState extends State<AddEvent> {
  final _auth = FirebaseAuth.instance;
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print('error $e');
    }
  }

  FocusNode myFocus = FocusNode();
  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  String name;

  String venue;
  String note;

  @override
  Widget build(BuildContext context) {
    getCurrentUser();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
          key: globalScaffoldKey,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
              title: Text('Add Event', style: TextStyle(color: Colors.white)),
              iconTheme: new IconThemeData(color: Colors.white)),
          body: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      "Add Event",
                      style: kTitleTextStyle,
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        onChanged: (v) {
                          name = v;
                        },
                        focusNode: myFocus,
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Charle\'s Birthday',
                            labelText: 'Event Name'),
                      ),
                      DateTimeField(
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Charle\'s Birthday',
                            labelText: 'Date and time'),
                        format: format,
                        onShowPicker: (context, currentValue) async {
                          final date = await showDatePicker(
                              context: context,
                              firstDate: DateTime.now(),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.fromDateTime(
                                  currentValue ?? DateTime.now()),
                            );
                            setState(() {
                              selectedDate = DateTimeField.combine(date, time);
                            });
                            return DateTimeField.combine(date, time);
                          } else {
                            return currentValue;
                          }
                        },
                      ),
                      TextField(
                        onTap: () {},
                        onChanged: (v) {
                          venue = v;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'At Hotel Shanthi', labelText: 'Venue'),
                      ),
                      TextField(
                        onChanged: (v) {
                          note = v;
                        },
                        maxLines: 7,
                        decoration: kTextFieldDecoration.copyWith(
                          hintText:
                              'Add details of the event\nThere can be many lines',
                          labelText: 'Event Description',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Center(
                    child: button(
                      title: 'Create Event',
                      onPress: () {
                        if (name != null && venue != null) {
                          Event event = new Event(
                              name,
                              venue,
                              note,
                              selectedDate,
                              selectedDate,
                              null,
                              loggedInUser.uid, [], [], []);
                          FirebaseHelper helper = new FirebaseHelper();
                          helper.addEvent(event, context);
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
