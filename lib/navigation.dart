import 'package:fedodo_general/globals/general.dart';
import 'package:fedodo_general/widgets/search.dart';
import 'package:fedodo_ui_photo/navigation_views/home_feed.dart';
import 'package:fedodo_ui_photo/navigation_views/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:fedodo_general/navigation.dart' as general;

class Navigation extends StatelessWidget {
  const Navigation({super.key});

  @override
  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return general.Navigation(
      title: General.appName,
      inputScreens: [
        const HomeFeed(),
        Search(
          getProfile: (String profileId) {
            return Profile(profileId: profileId);
          },
        ),
        Profile(profileId: General.fullActorId),
      ],
      appBarActions: [],
      floatingActionButton: null,
      bottomNavigationBarItems: const [
        BottomNavigationBarItem(
          label: "Home",
          icon: Icon(Icons.home),
        ),
        BottomNavigationBarItem(
          label: "Search",
          icon: Icon(Icons.search),
        ),
        BottomNavigationBarItem(
          label: "Profile",
          icon: Icon(Icons.person),
        ),
      ],
      scrollController: scrollController,
    );
  }
}
