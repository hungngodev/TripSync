part of event_calendar;

class AppointmentEditor extends StatefulWidget {
  const AppointmentEditor({super.key});

  @override
  AppointmentEditorState createState() => AppointmentEditorState();
}

class AppointmentEditorState extends State<AppointmentEditor> {
  final TextEditingController activityController = TextEditingController();
  final TextEditingController _subjectController =
      TextEditingController(text: _subject);

  @override
  void dispose() {
    activityController.dispose();
    super.dispose();
  }

  Widget _getAppointmentEditor(BuildContext context) {
    dynamic currentActivity = (chosenList
            .where((activity) => activity['id'] == _selectedActivity)
            .isNotEmpty
        ? chosenList
            .firstWhere((activity) => activity['id'] == _selectedActivity)
        : {
            'category': 'Select type',
            'location': 'Where is it happening?',
            'address': 'Address awaits!',
            'description': 'What makes it special?',
            'source_link': 'Learn more here!'
          });

    return Container(
        color: Colors.white,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
              leading: const Text(''),
              title: TextField(
                controller: _subjectController,
                onChanged: (String value) {
                  _subject = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add title',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading: const Icon(
                  Icons.access_time,
                  color: Colors.black54,
                ),
                title: Row(children: <Widget>[
                  const Expanded(
                    child: Text('All-day'),
                  ),
                  Expanded(
                      child: Align(
                          alignment: Alignment.centerRight,
                          child: Switch(
                            value: _isAllDay,
                            onChanged: (bool value) {
                              setState(() {
                                _isAllDay = value;
                              });
                            },
                          ))),
                ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading:
                    const Icon(Icons.share_arrival_time, color: Colors.black87),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                                DateFormat('EEE, MMM dd yyyy')
                                    .format(_startDate),
                                textAlign: TextAlign.left),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: _startDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _startDate) {
                                setState(() {
                                  final Duration difference =
                                      _endDate.difference(_startDate);
                                  _startDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _startTime.hour,
                                      _startTime.minute,
                                      0);
                                  _endDate = _startDate.add(difference);
                                  _endTime = TimeOfDay(
                                      hour: _endDate.hour,
                                      minute: _endDate.minute);
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                                  child: Text(
                                    DateFormat('hh:mm a').format(_startDate),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () async {
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _startTime.hour,
                                                minute: _startTime.minute));

                                    if (time != null && time != _startTime) {
                                      setState(() {
                                        _startTime = time;
                                        final Duration difference =
                                            _endDate.difference(_startDate);
                                        _startDate = DateTime(
                                            _startDate.year,
                                            _startDate.month,
                                            _startDate.day,
                                            _startTime.hour,
                                            _startTime.minute,
                                            0);
                                        _endDate = _startDate.add(difference);
                                        _endTime = TimeOfDay(
                                            hour: _endDate.hour,
                                            minute: _endDate.minute);
                                      });
                                    }
                                  })),
                    ])),
            ListTile(
                contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                leading:
                    const Icon(Icons.departure_board, color: Colors.black87),
                title: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 7,
                        child: GestureDetector(
                            child: Text(
                              DateFormat('EEE, MMM dd yyyy').format(_endDate),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () async {
                              final DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: _endDate,
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );

                              if (date != null && date != _endDate) {
                                setState(() {
                                  final Duration difference =
                                      _endDate.difference(_startDate);
                                  _endDate = DateTime(
                                      date.year,
                                      date.month,
                                      date.day,
                                      _endTime.hour,
                                      _endTime.minute,
                                      0);
                                  if (_endDate.isBefore(_startDate)) {
                                    _startDate = _endDate.subtract(difference);
                                    _startTime = TimeOfDay(
                                        hour: _startDate.hour,
                                        minute: _startDate.minute);
                                  }
                                });
                              }
                            }),
                      ),
                      Expanded(
                          flex: 3,
                          child: _isAllDay
                              ? const Text('')
                              : GestureDetector(
                                  child: Text(
                                    DateFormat('hh:mm a').format(_endDate),
                                    textAlign: TextAlign.right,
                                  ),
                                  onTap: () async {
                                    final TimeOfDay? time =
                                        await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay(
                                                hour: _endTime.hour,
                                                minute: _endTime.minute));

                                    if (time != null && time != _endTime) {
                                      setState(() {
                                        _endTime = time;
                                        final Duration difference =
                                            _endDate.difference(_startDate);
                                        _endDate = DateTime(
                                            _endDate.year,
                                            _endDate.month,
                                            _endDate.day,
                                            _endTime.hour,
                                            _endTime.minute,
                                            0);
                                        if (_endDate.isBefore(_startDate)) {
                                          _startDate =
                                              _endDate.subtract(difference);
                                          _startTime = TimeOfDay(
                                              hour: _startDate.hour,
                                              minute: _startDate.minute);
                                        }
                                      });
                                    }
                                  })),
                    ])),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: const Icon(
                Icons.public,
                color: Colors.black87,
              ),
              title: Text(_timeZoneCollection[_selectedTimeZoneIndex]),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return _TimeZonePicker();
                  },
                ).then((dynamic value) => setState(() {}));
              },
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
              leading: Icon(Icons.lens, color: _selectedColorIndex),
              title: Text(
                'Color',
                style: GoogleFonts.getFont('Roboto', fontSize: 18),
              ),
              trailing:
                  Icon(Icons.arrow_forward_ios, color: _selectedColorIndex),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return _ColorPicker();
                  },
                ).then((dynamic value) => setState(() {}));
              },
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(5),
              leading: const Icon(
                Icons.subject,
                color: Colors.black87,
              ),
              title: TextField(
                controller: TextEditingController(text: _notes),
                onChanged: (String value) {
                  _notes = value;
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Add description',
                ),
              ),
            ),
            const Divider(
              height: 1.0,
              thickness: 1,
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              leading: Icon(
                  currentActivity['category'] == 'restaurant'
                      ? Icons.restaurant
                      : currentActivity['category'] == 'hotel'
                          ? Icons.hotel
                          : Icons.local_activity,
                  color: Colors.black),
              title: Text(
                // ignore: prefer_interpolation_to_compose_strings
                (chosenList
                        .where(
                            (activity) => activity['id'] == _selectedActivity)
                        .isNotEmpty
                    ? chosenList.firstWhere((activity) =>
                        activity['id'] == _selectedActivity)['title']
                    : 'Choose your activity'), // Return 'No activity found' if no match exists
                style: GoogleFonts.getFont('Lora', fontSize: 18),
              ),
              trailing: Icon(Icons.arrow_downward, color: _selectedColorIndex),
              onTap: () {
                showDialog<Widget>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        color: Colors.white,
                        width: double.maxFinite,
                        child: DropdownMenu(
                          initialSelection: _selectedActivity,
                          controller: activityController,
                          // requestFocusOnTap is enabled/disabled by platforms when it is null.
                          // On mobile platforms, this is false by default. Setting this to true will
                          // trigger focus request on the text field and virtual keyboard will appear
                          // afterward. On desktop platforms however, this defaults to true.
                          requestFocusOnTap: true,
                          label: const Text('Activity'),
                          onSelected: (activity) {
                            setState(() {
                              _selectedActivity = activity;
                            });
                            Future.delayed(const Duration(milliseconds: 20),
                                () {
                              // When task is over, close the dialog
                              Navigator.pop(context);
                            });
                          },

                          dropdownMenuEntries:
                              chosenList.map<DropdownMenuEntry>((activity) {
                            return DropdownMenuEntry(
                              value: activity['id'],
                              label: activity['title'],
                              style: MenuItemButton.styleFrom(
                                foregroundColor: Colors.black,
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    );
                  },
                ).then((dynamic value) => setState(() {}));
              },
            ),
            ListTile(
              isThreeLine: true,
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              leading: const Icon(Icons.location_on, color: Colors.black),
              title: Text(
                // ignore: prefer_interpolation_to_compose_strings
                currentActivity[
                    'location'], // Return 'No location found' if no match exists
                style: GoogleFonts.getFont('Lora', fontSize: 18),
              ),
              subtitle: Text(
                // ignore: prefer_interpolation_to_compose_strings
                currentActivity[
                    'address'], // Return 'No address found' if no match exists
                style: GoogleFonts.getFont('Nunito', fontSize: 13),
              ),
            ),
            ListTile(
              isThreeLine: true,
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              leading: const Icon(Icons.description, color: Colors.black),
              title: Text(
                // ignore: prefer_interpolation_to_compose_strings
                'Description:', // Return 'No description found' if no match exists

                style: GoogleFonts.getFont('Lora', fontSize: 18),
              ),
              subtitle: Text(
                // ignore: prefer_interpolation_to_compose_strings
                currentActivity[
                    'description'], // Return 'No description found' if no match exists
                style: GoogleFonts.getFont('Nunito', fontSize: 18),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              leading: const Icon(Icons.link, color: Colors.black),
              title: Text(
                // ignore: prefer_interpolation_to_compose_strings
                currentActivity[
                    'source_link'], // Return 'No source link found' if no match exists
                style: GoogleFonts.getFont('Lato',
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text(
                getTitle(),
                style: const TextStyle(
                  color: Colors.white, // Change this to your desired color
                ),
              ),
              backgroundColor: _selectedColorIndex,
              leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                    icon: const Icon(
                      Icons.done,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      if (_selectedAppointment != null &&
                          _selectedAppointment!.resourceIds != null &&
                          !_selectedAppointment!.resourceIds!
                              .contains(userId)) {
                        const snackBar = SnackBar(
                          /// need to set following properties for best effect of awesome_snackbar_content
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: '',
                            message: 'You have modified other activity!',

                            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                            contentType: ContentType.success,
                          ),
                        );

                        // Show SnackBar
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);

                        // Show confirmation dialog
                        bool? isConfirmed = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Are you sure?'),
                              content: Text('You will modify other activity.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(false); // User pressed No
                                  },
                                  child: Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(true); // User pressed Yes
                                  },
                                  child: Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );

                        if (isConfirmed == false) {
                          return;
                          // Proceed with the operation if user presses Yes
                          // Add the logic to modify the activity here
                        }
                      }
                      final List<Meeting> meetings = <Meeting>[];

                      final data = {
                        'activity': _selectedActivity,
                        'start_date': _startDate.toString(),
                        'end_date': _endDate.toString(),
                        'title': _subject,
                        'description': _notes,
                        'isAllDay': _isAllDay,
                        'color': _selectedColorIndex.toHexString().toString(),
                        'startTimeZone': _selectedTimeZoneIndex == 0
                            ? ''
                            : _timeZoneCollection[_selectedTimeZoneIndex],
                        'endTimeZone': _selectedTimeZoneIndex == 0
                            ? ''
                            : _timeZoneCollection[_selectedTimeZoneIndex],
                        'calendar': int.parse(currentCalendar),
                      };
                      final chosenId = _selectedMeeting != -1
                          ? _selectedMeeting.toString()
                          : await apiService.addChosenActivity(data);
                      if (_selectedMeeting != -1) {
                        await apiService.updateChosenActivity(chosenId, data);
                      }
                      meetings.add(Meeting(
                        from: _startDate,
                        to: _endDate,
                        background: _selectedColorIndex,
                        startTimeZone: _selectedTimeZoneIndex == 0
                            ? ''
                            : _timeZoneCollection[_selectedTimeZoneIndex],
                        endTimeZone: _selectedTimeZoneIndex == 0
                            ? ''
                            : _timeZoneCollection[_selectedTimeZoneIndex],
                        description: _notes,
                        isAllDay: _isAllDay,
                        eventName: _subject == '' ? '(No title)' : _subject,
                        resourceIds: <String>[userId],
                        activity: _selectedActivity,
                        id: int.parse(chosenId),
                      ));

                      _events.appointments!.add(meetings[0]);

                      _events.notifyListeners(
                          CalendarDataSourceAction.add, meetings);
                      if (_selectedAppointment != null) {
                        _events.appointments!.removeAt(_events.appointments!
                            .indexOf(_selectedAppointment));
                        _events.notifyListeners(CalendarDataSourceAction.remove,
                            <Meeting>[]..add(_selectedAppointment!));
                      }
                      _selectedAppointment = null;

                      Navigator.pop(context);
                    })
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Stack(
                children: <Widget>[_getAppointmentEditor(context)],
              ),
            ),
            floatingActionButton: _selectedAppointment == null
                ? const Text('')
                : FloatingActionButton(
                    onPressed: () async {
                      if (_selectedAppointment != null) {
                        _events.appointments!.removeAt(_events.appointments!
                            .indexOf(_selectedAppointment));
                        _events.notifyListeners(CalendarDataSourceAction.remove,
                            <Meeting>[]..add(_selectedAppointment!));
                        await apiService.deleteChosenActivity(
                            _selectedAppointment!.id.toString());
                        _selectedAppointment = null;
                        Navigator.pop(context);
                      }
                    },
                    // ignore: sort_child_properties_last
                    child:
                        const Icon(Icons.delete_outline, color: Colors.white),
                    backgroundColor: Colors.red,
                  )));
  }

  String getTitle() {
    return _subject.isEmpty ? 'New event' : 'Event details';
  }
}
