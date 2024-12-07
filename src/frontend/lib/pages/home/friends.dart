import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:avatar_plus/avatar_plus.dart';
import 'package:provider/provider.dart';

import '../../model/global.dart';
import '../../provider/friend_provider.dart';

class FriendsPage extends StatefulWidget {
  FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 147, 139, 174),
        title: Text(
          'Your Travel Buddies',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: ChangeNotifierProvider(
        create: (context) => FriendProvider()..fetchFriends(),
        child: Consumer<FriendProvider>(
          builder: (context, friendProvider, child) {
            print("invite ${friendProvider.invites}");
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    // _getFriendsFilter(),
                    const Divider(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _getSectionHeader('Calendar Invites'),
                          friendProvider.invites.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Let connect with others',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 130,
                                  child: ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: friendProvider.invites
                                        .map<Widget>((invite) {
                                      return Card(
                                          child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(8, 0, 8, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              invite.eventName,
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'From ${invite.friend}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              timePassedSince(invite.since),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Provider.of<FriendProvider>(
                                                            context,
                                                            listen: false)
                                                        .deleteInvite(
                                                            invite.id);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            255, 186, 187, 190),
                                                  ),
                                                  child: const Text("Deny"),
                                                ),
                                                const SizedBox(width: 8),
                                                ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: const Color
                                                        .fromARGB(255, 147, 139,
                                                        174), // Set the background color
                                                  ),
                                                  onPressed: () => {
                                                    Provider.of<FriendProvider>(
                                                            context,
                                                            listen: false)
                                                        .acceptInvite(invite.id)
                                                  },
                                                  child: const Text("Accept",
                                                      style: TextStyle(
                                                          color: Colors.white)),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ));
                                    }).toList(),
                                  ),
                                ),
                          _getSectionHeader('Friends'),
                          const SizedBox(height: 5),
                          friendProvider.friends.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Let make some friends',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    for (var friend in friendProvider.friends)
                                      _getFriendRequest(context, friend),
                                  ],
                                ),
                          const Divider(),
                          _getSectionHeader('Pending Requests'),
                          const SizedBox(height: 5),
                          friendProvider.requests.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No pending requests',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    for (var friend in friendProvider.requests)
                                      _getFriendRequest(context, friend),
                                  ],
                                ),
                          const Divider(),
                          _getSectionHeader('Your Requests'),
                          const SizedBox(height: 5),
                          friendProvider.receives.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No request! Let others know you want to be friends',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    for (var friend in friendProvider.receives)
                                      _getFriendRequest(context, friend),
                                  ],
                                ),
                          const Divider(),
                          _getSectionHeader('People You May Know'),
                          friendProvider.suggestions.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No friend suggestions',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 18,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: <Widget>[
                                    for (var friend
                                        in friendProvider.suggestions)
                                      _getFriendRequest(context, friend),
                                  ],
                                ),
                        ],
                      ),
                    ),
                    const Divider(),
                  ]),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _getSectionHeader(String _title) {
    return Container(
      child: Text(
        _title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _getFriendAvatar(image) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, maxHeight: 100),
      child: AvatarPlus(
        image,
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }

  Widget _getFriendRequest(context, friend) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _getFriendAvatar(friend.friendImage),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      friend.friendName,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    !friend.isFriend
                        ? Text(
                            '${friend.mutuals} mutual friends',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          )
                        : Text(
                            'Since ${friend.friendSince.year}-${friend.friendSince.month}-${friend.friendSince.day}',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                    friend.isSuggested
                        ? ElevatedButton(
                            onPressed: () {
                              Provider.of<FriendProvider>(context,
                                      listen: false)
                                  .addFriend(friend.id, friend.friendId);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 147, 139, 174),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text('Add Friend',
                                style: TextStyle(color: Colors.white)),
                          )
                        : !friend.isFriend
                            ? friend.isReceiving
                                ? Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await Provider.of<FriendProvider>(
                                                    context,
                                                    listen: false)
                                                .acceptFriend(friend.id,
                                                    friend.friendshipId);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 147, 139, 174),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: const Text('Confirm',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            await Provider.of<FriendProvider>(
                                                    context,
                                                    listen: false)
                                                .removeFriendOrRequest(
                                                    friend.id,
                                                    friend.friendshipId);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 186, 187, 190),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          child: const Text('Delete',
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ),
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      Provider.of<FriendProvider>(context,
                                              listen: false)
                                          .removeFriendOrRequest(
                                              friend.id, friend.friendshipId);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 186, 187, 190),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    child: const Text('Cancel Request',
                                        style: TextStyle(color: Colors.black)),
                                  )
                            : ElevatedButton(
                                onPressed: () {
                                  Provider.of<FriendProvider>(context,
                                          listen: false)
                                      .removeFriendOrRequest(
                                          friend.id, friend.friendshipId);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 186, 187, 190),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text('Unfriend',
                                    style: TextStyle(color: Colors.black)),
                              )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget _getFriendsFilter() {
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
  //     child: Row(
  //       children: <Widget>[
  //         TextButton(
  //           onPressed: () {},
  //           style: TextButton.styleFrom(
  //             backgroundColor: const Color(0xffEBECF0),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(30)),
  //           ),
  //           child: const Text('Suggestions',
  //               style: TextStyle(color: Colors.black)),
  //         ),
  //         const SizedBox(width: 10),
  //         TextButton(
  //           onPressed: () {},
  //           style: TextButton.styleFrom(
  //             backgroundColor: const Color(0xffEBECF0),
  //             shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(30)),
  //           ),
  //           child: const Text('All Friends',
  //               style: TextStyle(color: Colors.black)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}

String timePassedSince(DateTime date) {
  final now = DateTime.now();
  final difference = now.difference(date);

  if (difference.inDays > 365) {
    final years = (difference.inDays / 365).floor();
    return '$years year${years > 1 ? 's' : ''} ago';
  } else if (difference.inDays > 30) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} ago';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}
