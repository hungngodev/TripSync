import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:provider/provider.dart';

import '../../provider/post_provider.dart';
import '../../model/global.dart';
import '../../services/django/api_service.dart';
import '../../util/user_avatar.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  int likes = 136;
  bool isLiked = false;
  bool hasStory = true;
  final apiService = ApiService();
  final List<dynamic> _events = [];
  late List<Item> _items = <Item>[Item('', '')];
  String chosenCalendar = '';
  TextEditingController postTitle = TextEditingController();
  TextEditingController postSubtitle = TextEditingController();
  bool loading = true;
  bool isSubmitting = false;

  @override
  void initState() {
    getInformations();
    super.initState();
  }

  void reactToPost() {
    setState(() {
      if (isLiked) {
        isLiked = false;
        likes--;
      } else {
        isLiked = true;
        likes++;
      }
    });
  }

  Future<void> getInformations() async {
    final List<dynamic> calendarNames = await apiService.getCalendars();
    setState(() {
      _items = calendarNames
          .map((event) => Item(event['name'], event['id']))
          .toList();
    });
    final data = await apiService.getCalendar('5');
    setState(() {
      _events.addAll(data);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PostProvider()..fetchPosts(),
        child: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: AppBar(backgroundColor: Colors.white, elevation: 0),
            ),
            body:
                Consumer<PostProvider>(builder: (context, postProvider, child) {
              final posts = postProvider.posts;
              return CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate([
                      _getSeparator(5),
                      Container(
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(children: <Widget>[
                          _addPostHeader(),
                          const Divider(),
                          _addPostOptions(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
                            child: MaterialButton(
                              height: 50,
                              minWidth: double.infinity,
                              onPressed: !loading
                                  ? () async {
                                      setState(() {
                                        isSubmitting = true;
                                      });
                                      final title = postTitle.text;
                                      final subtitle = postSubtitle.text;
                                      final calendar = chosenCalendar;
                                      await Provider.of<PostProvider>(context,
                                              listen: false)
                                          .addPost({
                                        'title': title,
                                        'content': subtitle,
                                        'calendar': calendar
                                      });
                                      setState(() {
                                        isSubmitting = false;
                                      });
                                    }
                                  : null,
                              color: Colors.blue.withOpacity(1),
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
                              children: _getPost(
                              postImage:
                                  'https://images.unsplash.com/photo-1732888169391-9001089d6342?q=80&w=3385&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3Drr',
                              postText: 'This is a post body',
                              postTime: DateTime.now(),
                              postUserImage: userProfileImage,
                              postUserName: 'John Doe',
                              postTitle: 'Title',
                              postSubtitle: 'Subtitle',
                            ))
                    ]),
                  ),
                ],
              );
            })));
  }

  Widget _getSeparator(double height) {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).dividerColor),
      constraints: BoxConstraints(maxHeight: height),
    );
  }

  Widget _addPostHeader() {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(userProfileImage),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: postTitle,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind ?',
                      hintStyle: TextStyle(color: Colors.black87),
                    ),
                  ),
                ),
              ],
            ),
            TextField(
              controller: postSubtitle,
              decoration: const InputDecoration(
                  label: Text('Description'),
                  hintText: "Insert your message",
                  border: InputBorder.none),
              autofocus: true,
            ),
            const ListTile(
              title: Text('Share your Calendar',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                  )),
              leading: Icon(Icons.calendar_month),
            ),
            CustomDropdown<Item>(
              hintText: 'Select job role',
              items: _items,
              initialItem: _items.firstWhere(
                (item) => item.id == chosenCalendar,
                orElse: () => _items[
                    0], // Optionally, handle the case where no item is found
              ),
              onChanged: (value) {
                setState(() {
                  chosenCalendar = value!.id;
                });
              },
            )
          ],
        ));
  }

  Widget _addPostOptions() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          _buildPostOptionButton(Icons.video_call, 'Live'),
          _buildPostOptionButton(Icons.photo, 'Photo'),
          _buildPostOptionButton(Icons.location_on, 'Check In'),
        ],
      ),
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

  Widget _postHeader(username, postTime, imageUrl) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              UserAvatar(
                hasStory: hasStory,
                imageUrl: imageUrl,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(username,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, color: Colors.black)),
                  Row(
                    children: <Widget>[
                      Text(timeAgo(postTime),
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                      const Icon(Icons.language, size: 15, color: Colors.grey)
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _buildLikeButton(),
              // _buildFavoriteButton(),
              Text(likes.toString(),
                  style: const TextStyle(color: Colors.black, fontSize: 20)),
              const SizedBox(width: 10),
              const Icon(Icons.more_horiz, color: Colors.grey)
            ],
          ),
        ],
      ),
    );
  }

  Widget _postBody(bodyPost, imagePost, titlePost, subtitlePost) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: ListTile(
            title: Text(titlePost, style: const TextStyle(fontSize: 20)),
            leading: const Icon(Icons.album),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(subtitlePost, style: const TextStyle(fontSize: 15)),
        ),
        // const SizedBox(height: 10),
        // Container(
        //   constraints: const BoxConstraints(maxHeight: 350),
        //   decoration: BoxDecoration(
        //     color: Colors.yellow,
        //     image: DecorationImage(
        //       image: NetworkImage(imagePost),
        //       fit: BoxFit.fill,
        //     ),
        //   ),
        // )
      ],
    );
  }

  Widget _buildLikeButton() {
    return RawMaterialButton(
      shape: const CircleBorder(side: BorderSide(color: Colors.white)),
      fillColor: Colors.blue,
      onPressed: reactToPost,
      child: const Icon(Icons.thumb_up, color: Colors.white, size: 14),
    );
  }

  // Widget _buildFavoriteButton() {
  //   return RawMaterialButton(
  //     shape: const CircleBorder(side: BorderSide(color: Colors.white)),
  //     fillColor: Colors.red,
  //     onPressed: () {},
  //     child: const Icon(Icons.favorite, color: Colors.white, size: 14),
  //   );
  // }

  List<Widget> _getPost(
      {String? postImage,
      String? postText,
      DateTime? postTime,
      String? postUserImage,
      String? postUserName,
      String? postTitle,
      String? postSubtitle,
      dynamic? events}) {
    return [
      _postHeader(postUserName, postTime, postUserImage),
      _postBody(
        postText,
        postImage,
        postTitle,
        postSubtitle,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
        child: SizedBox(
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
      ),
      const Divider(),
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
