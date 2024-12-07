import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../bloc/authentication_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './profile_page.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 147, 139, 174),
          title: Text(
            'Setting Page',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 24),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        backgroundColor: const Color(0xfff6f6f6),
        body: Container(
          height: MediaQuery.of(context).size.height * 1.2,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              ProfilePage(),
              Center(
                child: Container(
                  constraints:
                      const BoxConstraints(maxWidth: 400, maxHeight: 320),
                  child: ListView(
                    children: [
                      _SingleSection(
                        title: "General",
                        children: [
                          _CustomListTile(
                              title: "Dark Mode",
                              icon: CupertinoIcons.moon,
                              trailing: CupertinoSwitch(
                                  value: false, onChanged: (value) {})),
                        ],
                      ),
                      _SingleSection(
                        title: "Network",
                        children: [
                          _CustomListTile(
                            title: "Tracking",
                            icon: CupertinoIcons.location,
                            trailing: CupertinoSwitch(
                                value: true, onChanged: (val) {}),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0), // Add horizontal padding
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.25, // Make the width 25% of the screen
                          child: ElevatedButton(
                            onPressed: () {
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(LoggedOut());
                            },
                            style: ElevatedButton.styleFrom(
                              shape: const StadiumBorder(
                                side: BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _CustomListTile(
      {Key? key, required this.title, required this.icon, this.trailing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing ?? const Icon(CupertinoIcons.forward, size: 18),
      onTap: () {},
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SingleSection({
    Key? key,
    required this.title,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontSize: 16),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }
}
