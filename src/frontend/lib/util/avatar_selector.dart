import 'dart:math';
import 'package:flutter/material.dart';
import 'package:avatar_plus/avatar_plus.dart';

class AvatarSelector extends StatefulWidget {
  const AvatarSelector({super.key, required this.onSelect});

  final onSelect;

  @override
  AvatarState createState() => AvatarState();
}

class AvatarState extends State<AvatarSelector> {
  List<String> randomStrings = [];

  final int count = 10;
  final int length = 10;

  @override
  void initState() {
    randomStrings.addAll(generateRandomStrings(count, length));
    super.initState();
  }

  List<String> generateRandomStrings(int count, int length) {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random random = Random();

    List<String> strings = [];

    for (int i = 0; i < count; i++) {
      String randomString = '';
      for (int j = 0; j < length; j++) {
        randomString += chars[random.nextInt(chars.length)];
      }
      strings.add(randomString);
    }

    return strings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          randomStrings.addAll(generateRandomStrings(count, length));
          setState(() {});
        },
        tooltip: 'Load more',
        label: const Text("Load more"),
        icon: const Icon(Icons.add),
      ),
      body: GridView.builder(
          padding: const EdgeInsets.all(12.0),
          itemCount: randomStrings.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
          itemBuilder: (context, index) {
            return Card(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Scaffold(
                                appBar: AppBar(
                                  title: const Text("Avatar"),
                                  leading: IconButton(
                                    icon: const Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                bottomNavigationBar: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ;
                                        widget.onSelect(randomStrings[index]);
                                      },
                                      child: const Text("Select",
                                          style: TextStyle(fontSize: 40)),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    )
                                  ],
                                ),
                                body: Center(
                                  child: Hero(
                                    tag: randomStrings[index],
                                    child: AvatarPlus(
                                      randomStrings[index],
                                      height:
                                          MediaQuery.of(context).size.width -
                                              20,
                                      width: MediaQuery.of(context).size.width -
                                          20,
                                    ),
                                  ),
                                ),
                              )));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Hero(
                    tag: randomStrings[index],
                    child: AvatarPlus(
                      randomStrings[index],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
