import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        // title: Text(
        //   currentTrip != '' ? 'Search for $currentTrip' : 'Your First Trip',
        //   style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
        // ),
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
                          _getSectionHeader('Friends'),
                          const SizedBox(height: 5),
                          friendProvider.friends.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No friends',
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
                                    'No friend requests',
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
                                    'No friend suggestions',
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

  Widget _getFriendAvatar() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 100, maxHeight: 100),
      child: CircleAvatar(
        backgroundImage: NetworkImage(userProfileImage),
        radius: 60.0,
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

  Widget _getFriendRequest(context, friend) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getFriendAvatar(),
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
                          Provider.of<FriendProvider>(context, listen: false)
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
                                            .acceptFriend(
                                                friend.id, friend.friendshipId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 147, 139, 174),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: const Text('Confirm',
                                          style:
                                              TextStyle(color: Colors.white)),
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
                                                friend.id, friend.friendshipId);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 186, 187, 190),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      child: const Text('Delete',
                                          style:
                                              TextStyle(color: Colors.black)),
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
                                  backgroundColor:
                                      const Color.fromARGB(255, 186, 187, 190),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
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
    );
  }

  Widget _getFriendSuggestion() {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getFriendAvatar(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Christian Guzman',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  '6 mutual friends',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Add Friend',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xffDCDDDF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Remove',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
