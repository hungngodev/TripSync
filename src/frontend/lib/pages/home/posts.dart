import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

import '../../model/global.dart';
import '../../provider/post_provider.dart';
import '../../services/django/api_service.dart';
import '../../util/user_avatar.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool hasStory = true;
  final apiService = ApiService();
  late List<Item> _items = <Item>[Item('', '')];
  String chosenCalendar = '';
  String editChosenCalendar = '';
  TextEditingController postTitleController = TextEditingController();
  TextEditingController postSubController = TextEditingController();
  TextEditingController postTitleEditController = TextEditingController();
  TextEditingController postSubEditController = TextEditingController();

  bool loading = true;
  dynamic currentUser = {
    'username': '',
    'image': '',
  };
  bool isSubmitting = false;

  @override
  void initState() {
    getInformations();
    super.initState();
  }

  Future<void> getInformations() async {
    final List<dynamic> calendarNames = await apiService.getCalendars();
    final currentUserData = await apiService.getCurrentUser();
    setState(() {
      _items = calendarNames
          .map((event) => Item(event['name'], event['id']))
          .toList();
      currentUser = currentUserData;
    });
    setState(() {
      loading = false;
    });
  }

  Widget _getFriendAvatar(image, [size = 100.0]) {
    return Container(
      constraints: BoxConstraints(maxWidth: size, maxHeight: size),
      child: AvatarPlus(
        image,
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 147, 139, 174),
          // title: Text(
          //   currentTrip != '' ? 'Search for $currentTrip' : 'Your First Trip',
          //   style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
          // ),
          title: Text(
            'New Feeds',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        body: ChangeNotifierProvider(
            create: (context) => PostProvider()..fetchPosts(),
            child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(0),
                  child: AppBar(backgroundColor: Colors.white, elevation: 0),
                ),
                body: Consumer<PostProvider>(
                    builder: (context, postProvider, child) {
                  final posts = postProvider.posts;
                  return CustomScrollView(
                    slivers: <Widget>[
                      SliverList(
                        delegate: SliverChildListDelegate([
                          _getSeparator(5),
                          Container(
                            decoration:
                                const BoxDecoration(color: Colors.white),
                            child: Column(children: <Widget>[
                              Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          _getFriendAvatar(
                                              currentUser['image']),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: TextField(
                                              controller: postTitleController,
                                              decoration: const InputDecoration(
                                                hintText:
                                                    'What\'s on your mind ?',
                                                hintStyle: TextStyle(
                                                    color: Colors.black87),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      TextField(
                                        controller: postSubController,
                                        decoration: const InputDecoration(
                                            label: Text('Description'),
                                            hintText: "Insert your message",
                                            border: InputBorder.none),
                                        autofocus: true,
                                      ),
                                      ListTile(
                                        title: Text(
                                            _items.isNotEmpty
                                                ? 'Select Calendar'
                                                : 'No Calendar',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            )),
                                        leading: const Icon(
                                            Icons.calendar_month,
                                            color: const Color.fromARGB(
                                                255, 147, 139, 174)),
                                      ),
                                      _items.isNotEmpty
                                          ? CustomDropdown<Item>(
                                              hintText: 'Select Calendar',
                                              items: _items,
                                              initialItem: _items.firstWhere(
                                                (item) =>
                                                    item.id == chosenCalendar,
                                                orElse: () => _items[0],
                                              ),
                                              onChanged: (value) async {
                                                setState(() {
                                                  chosenCalendar = value!.id;
                                                });
                                              },
                                            )
                                          : const SizedBox.shrink(),
                                    ],
                                  )),
                              const Divider(),
                              Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    _buildPostOptionButton(
                                        Icons.video_call, 'Live'),
                                    _buildPostOptionButton(
                                        Icons.photo, 'Photo'),
                                    _buildPostOptionButton(
                                        Icons.location_on, 'Check In'),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 6, 20, 6),
                                child: MaterialButton(
                                  height: 50,
                                  minWidth: double.infinity,
                                  onPressed: !loading
                                      ? () async {
                                          setState(() {
                                            isSubmitting = true;
                                          });
                                          final title =
                                              postTitleController.text;
                                          final subtitle =
                                              postSubController.text;
                                          final calendar = chosenCalendar;
                                          await Provider.of<PostProvider>(
                                                  context,
                                                  listen: false)
                                              .addPost({
                                            'title': title,
                                            'content': subtitle,
                                            'calendar': calendar
                                          });
                                          postTitleController.clear();
                                          postSubController.clear();

                                          setState(() {
                                            isSubmitting = false;
                                          });
                                          const snackBar = SnackBar(
                                            /// need to set following properties for best effect of awesome_snackbar_content
                                            elevation: 0,
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: Colors.transparent,
                                            content: AwesomeSnackbarContent(
                                              title: 'Great!',
                                              message:
                                                  'Your post has been successfully posted!',

                                              /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                              contentType: ContentType.success,
                                            ),
                                          );

                                          ScaffoldMessenger.of(context)
                                            ..hideCurrentSnackBar()
                                            ..showSnackBar(snackBar);
                                        }
                                      : null,
                                  color:
                                      const Color.fromARGB(255, 147, 139, 174),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: !isSubmitting
                                      ? const Text(
                                          "Post",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              color: Colors.white),
                                        )
                                      : const CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ]),
                          ),
                          _getSeparator(10),
                          postProvider.posts.isEmpty
                              ? const Padding(
                                  padding: const EdgeInsets.all(180),
                                  child: const CircularProgressIndicator())
                              : Column(
                                  children: postProvider.posts
                                      .map((post) => _getPost(post, context))
                                      .expand((element) => element)
                                      .toList(),
                                )
                        ]),
                      ),
                    ],
                  );
                }))));
  }

  Widget _getSeparator(double height) {
    return Container(
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 186, 187, 190)),
      constraints: BoxConstraints(maxHeight: height),
    );
  }

  Widget _buildPostOptionButton(IconData icon, String label) {
    return Expanded(
      child: TextButton.icon(
        icon: Icon(icon, color: Colors.red),
        label: Text(label),
        style: TextButton.styleFrom(foregroundColor: Colors.grey),
        onPressed: () {},
      ),
    );
  }

  List<Widget> _getPost(Post post, context) {
    final postUserName = post.postUserName;
    final postTime = post.postTime;
    final postUserImage = post.postUserImage;
    final postTitle = post.postTitle;
    final postSubtitle = post.postSubtitle;
    final events = post.events;
    final calendarName = post.calendarName;
    final likes = post.likes;
    final isLiked = post.isLiked;
    final id = post.id;
    final belong = post.belong;
    final isEditing = post.isEditing;
    final calendarId = post.calendarId;
    final isFriend = post.isFriend;
    final receiveRequest = post.receiveRequest;
    final sendRequest = post.sendRequest;
    final friendshipId = post.friendshipId;
    return [
      Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                _getFriendAvatar(postUserImage, 50.0),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(postUserName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                              fontSize: 20,
                            )),
                        (!isFriend &&
                                !receiveRequest &&
                                !sendRequest &&
                                !belong)
                            ? Center(
                                child: Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                    print('Follow button clicked!');
                                    Provider.of<PostProvider>(context,
                                            listen: false)
                                        .addFriend(id);
                                  },
                                  icon: const Icon(Icons.person_add,
                                      color:
                                          Colors.blue), // Icon for the button
                                  label: const Text('Follow',
                                      style: TextStyle(
                                          color: Colors.blue)), // Text label
                                ),
                              ))
                            : const SizedBox.shrink(),
                        (isFriend && !receiveRequest && !sendRequest)
                            ? Center(
                                child: Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    // // Add your onPressed logic here
                                    // print('Unfollow button clicked!');
                                    // Provider.of<PostProvider>(context,
                                    //         listen: false)
                                    //     .removeFriend(id, friendshipId);
                                  },
                                  icon: const Icon(
                                    Icons.people,
                                    color: const Color.fromARGB(
                                        255, 147, 139, 174),
                                  ), // Icon for the button
                                  label: const Text('Friend',
                                      style: TextStyle(
                                          color: const Color.fromARGB(255, 147,
                                              139, 174))), // Text label
                                ),
                              ))
                            : const SizedBox.shrink(),
                        (receiveRequest && !isFriend && !sendRequest)
                            ? Center(
                                child: Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                    print('Accept button clicked!');
                                    Provider.of<PostProvider>(context,
                                            listen: false)
                                        .acceptFriend(id, friendshipId);
                                  },
                                  icon: const Icon(Icons.person_add,
                                      color:
                                          Colors.green), // Icon for the button
                                  label: const Text('Accept',
                                      style: TextStyle(
                                          color: Colors.green)), // Text label
                                ),
                              ))
                            : const SizedBox.shrink(),
                        (sendRequest && !isFriend && !receiveRequest)
                            ? Center(
                                child: Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    // Add your onPressed logic here
                                    print('Cancel button clicked!');
                                    Provider.of<PostProvider>(context,
                                            listen: false)
                                        .removeFriend(id, friendshipId);
                                  },
                                  icon: const Icon(Icons.person_remove,
                                      color: Colors.red), // Icon for the button
                                  label: const Text('Cancel',
                                      style: TextStyle(
                                          color: Colors.red)), // Text label
                                ),
                              ))
                            : const SizedBox.shrink(),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(timeAgo(postTime),
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 16)),
                        const SizedBox(width: 5),
                        const Icon(Icons.language, size: 15, color: Colors.grey)
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const Icon(Icons.more_horiz, color: Colors.grey)
          ],
        ),
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: ListTile(
              title: !isEditing
                  ? Text(postTitle, style: const TextStyle(fontSize: 20))
                  : TextField(
                      controller: postTitleEditController,
                      decoration: InputDecoration(
                        hintText: postTitle,
                        hintStyle: const TextStyle(color: Colors.black87),
                      ),
                    ),
              leading: const Icon(Icons.album,
                  color: const Color.fromARGB(255, 147, 139, 174)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: !isEditing
                ? Text(postSubtitle, style: const TextStyle(fontSize: 15))
                : TextField(
                    controller: postSubEditController,
                    decoration: InputDecoration(
                        hintText: postSubtitle, border: InputBorder.none),
                    autofocus: true,
                  ),
          ),
        ],
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
          child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // Background color
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Shadow color
                    offset: const Offset(4.0, 4.0), // Shadow position (x, y)
                    blurRadius: 10.0, // Blur effect
                    spreadRadius: 2.0, // Spread the shadow outwards
                  ),
                ],
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
              ),
              child: Column(
                children: [
                  ListTile(
                    title: !isEditing
                        ? Text(calendarName,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ))
                        : CustomDropdown<Item>(
                            hintText: _items
                                .firstWhere(
                                  (item) => item.id == editChosenCalendar,
                                  orElse: () => _items[
                                      0], // Optionally, handle the case where no item is found
                                )
                                .name,
                            items: _items,
                            initialItem: _items.firstWhere(
                              (item) => item.id == editChosenCalendar,
                              orElse: () => _items[
                                  0], // Optionally, handle the case where no item is found
                            ),
                            onChanged: (value) async {
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .changeCalendarEdit(id, value!.id);
                              setState(() {
                                editChosenCalendar = value!.id;
                              });
                            },
                          ),
                    leading: const Icon(Icons.calendar_today,
                        color: Color.fromARGB(255, 147, 139, 174)),
                  ),
                  SizedBox(
                    height: 300,
                    child: SfCalendar(
                      allowAppointmentResize: true,
                      allowDragAndDrop: true,
                      view: CalendarView.schedule,
                      scheduleViewSettings: ScheduleViewSettings(
                        hideEmptyScheduleWeek: true,
                        monthHeaderSettings: MonthHeaderSettings(
                          monthFormat: 'MMMM yyyy',
                          height: 0,
                          backgroundColor: calendarColors[0].withOpacity(0.5),
                          monthTextStyle: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                      allowViewNavigation: true,
                      todayHighlightColor: Colors.blue,
                      showNavigationArrow: true,
                      firstDayOfWeek: 1,
                      showCurrentTimeIndicator: true,
                      dataSource: events,
                      // initialDisplayDate: DateTime(DateTime.now().year,
                      //     DateTime.now().month, DateTime.now().day, 0, 0, 0),
                    ),
                  ),
                ],
              ))),
      const Divider(),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              RawMaterialButton(
                shape:
                    const CircleBorder(side: BorderSide(color: Colors.white)),
                fillColor: Colors.blue,
                onPressed: () async {
                  await Provider.of<PostProvider>(context, listen: false)
                      .toggleLike(id, !isLiked);
                },
                child:
                    const Icon(Icons.thumb_up, color: Colors.white, size: 14),
              ),
              // _buildFavoriteButton(),
              Text(likes.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
            ],
          ),
          Row(
            children: [
              belong
                  ? IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        Provider.of<PostProvider>(context, listen: false)
                            .deletePost(id);
                      },
                      iconSize: 40.0,
                      color: Colors.red,
                    )
                  : const SizedBox.shrink(),
              belong
                  ? !isEditing
                      ? IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            postTitleEditController.text = postTitle;
                            postSubEditController.text = postSubtitle;
                            setState(() {
                              editChosenCalendar = calendarId.toString();
                            });
                            Provider.of<PostProvider>(context, listen: false)
                                .beginEdit(id);
                          },
                          iconSize: 40.0,
                          color: Colors.orange,
                        )
                      : IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            await Provider.of<PostProvider>(context,
                                    listen: false)
                                .editPost(
                                    id,
                                    {
                                      'title': postTitleEditController.text,
                                      'content': postSubEditController.text,
                                      'calendar': editChosenCalendar
                                    },
                                    _items
                                        .firstWhere(
                                          (item) =>
                                              item.id == editChosenCalendar,
                                          orElse: () => _items[
                                              0], // Optionally, handle the case where no item is found
                                        )
                                        .name);
                            postSubEditController.clear();
                            postTitleEditController.clear();
                            Provider.of<PostProvider>(context, listen: false)
                                .stopEdit(id);
                          },
                          iconSize: 40.0,
                          color: Colors.green,
                        )
                  : const SizedBox.shrink(),
            ],
          )
        ],
      ),
      _getSeparator(10),
    ];
  }
}

String timeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inDays > 365) {
    int years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  } else if (difference.inDays > 30) {
    int months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else if (difference.inSeconds > 0) {
    return '${difference.inSeconds} second${difference.inSeconds > 1 ? 's' : ''} ago';
  } else {
    return 'just now';
  }
}

const List<Color> calendarColors = [
  Color(0x00f5d4),
  Color(0x00bbf9),
  Color(0xfee440),
  Color(0xf15bb5),
  Color(0x9b5de5),
  Color(0xff0054),
  Color(0x8ac926),
];

class Item {
  Item(this.name, this.id);
  String name;
  String id;
  @override
  String toString() => name;
}
