import 'package:flutter/material.dart';
import '../../services/django/api_service.dart';
import 'package:avatar_plus/avatar_plus.dart';
import '../../util/avatar_selector.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<ProfilePage> {
  final apiService = ApiService();
  bool edit = false;
  int friends = 0;
  int calendars = 0;
  List<ProfileInfoItem> _items = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  dynamic currentUser = {};

  @override
  void initState() {
    super.initState();
    getInformations();
  }

  Future<void> getInformations() async {
    final friendsData = await apiService.getFriends();
    final calendarsData = await apiService.getCalendars();
    final currentUserData = await apiService.getCurrentUser();

    setState(() {
      friends = friendsData.where((friend) => friend['status']).toList().length;
      calendars = calendarsData.length;
      _items = [
        ProfileInfoItem("Calendars", calendars),
        ProfileInfoItem("Places", 15),
        ProfileInfoItem("Following", friends),
      ];
      currentUser = currentUserData;
      print(currentUser);
    });
  }

  Future<void> updateUser() async {
    await apiService.updateCurrentUser({
      'username': currentUser['username'],
      'email': currentUser['email'],
      'last_name': currentUser['image']
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      child: Column(
        children: [
          Expanded(
              flex: 2,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 50),
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              const Color.fromARGB(255, 186, 187, 190),
                              const Color.fromARGB(255, 147, 139, 174)
                            ]),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) => ProfilePage()));
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          AvatarPlus(
                                            currentUser['image'],
                                            height: MediaQuery.of(context)
                                                .size
                                                .width,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            },
                            child: AvatarPlus(
                              currentUser['image'],
                              height: MediaQuery.of(context).size.width - 20,
                              width: MediaQuery.of(context).size.width - 20,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 110,
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: IconButton(
                                  icon: Icon(Icons.change_circle,
                                      color: Colors.green),
                                  onPressed: () {
                                    setState(() {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title:
                                                  const Text('Select a photo'),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                    width: double.infinity,
                                                    height: 400,
                                                    child: AvatarSelector(
                                                        onSelect: (String
                                                            avatar) async {
                                                      await updateUser();
                                                      setState(() {
                                                        currentUser['image'] =
                                                            avatar;
                                                      });
                                                    }),
                                                  ),
                                                ],
                                              ),
                                            );
                                          });
                                    });
                                  },
                                  iconSize: 20.0,
                                  color: edit ? Colors.green : Colors.orange,
                                )),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: IconButton(
                                  icon: Icon(
                                    edit ? Icons.check : Icons.edit,
                                  ),
                                  onPressed: () async {
                                    if (!edit) {
                                      titleController.text =
                                          currentUser['username'];
                                      emailController.text =
                                          currentUser['email'];
                                    } else {
                                      await updateUser();
                                    }
                                    setState(() {
                                      edit = !edit;
                                    });
                                  },
                                  iconSize: 20.0,
                                  color: edit ? Colors.green : Colors.orange,
                                )),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      !edit
                          ? Text(
                              currentUser['username'] ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            )
                          : Container(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: TextField(
                                autofocus: true,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                controller: titleController,
                                decoration: InputDecoration(
                                  hintText: currentUser['username'] ?? '',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                      !edit
                          ? Text(
                              currentUser['email'] ?? '',
                              style: Theme.of(context).textTheme.headlineSmall,
                            )
                          : Container(
                              constraints: const BoxConstraints(maxWidth: 200),
                              child: TextField(
                                textAlign: TextAlign.center,
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: currentUser['email'] ?? '',
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 80,
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _items
                          .map((item) => Expanded(
                                  child: Row(
                                children: [
                                  if (_items.indexOf(item) != 0)
                                    const VerticalDivider(),
                                  Expanded(child: _singleItem(context, item)),
                                ],
                              )))
                          .toList(),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _singleItem(BuildContext context, ProfileInfoItem item) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.value.toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Text(
            item.title,
            style: Theme.of(context).textTheme.bodySmall,
          )
        ],
      );
}

class ProfileInfoItem {
  final String title;
  final int value;
  const ProfileInfoItem(this.title, this.value);
}
