import 'package:activitypub/APIs/actor_api.dart';
import 'package:activitypub/APIs/outbox_api.dart';
import 'package:activitypub/Models/actor.dart';
import 'package:fedodo_general/Globals/general.dart';
import 'package:fedodo_general/widgets/profile/profile_head.dart';
import 'package:fedodo_ui_photo/navigation_views/profile/helper/actor_string_helper.dart';
import 'package:fedodo_ui_photo/navigation_views/profile/profile_gallery.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.profileId,
  });

  final String profileId;

  @override
  Widget build(BuildContext context) {
    bool isOwnProfile = profileId == General.fullActorId;

    var profile = FutureBuilder<ActorStringHelper>(
      future: getHelper(),
      builder:
          (BuildContext context, AsyncSnapshot<ActorStringHelper> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = Column(
            children: [
              ProfileHead(actor: snapshot.data!.actor!),
              ProfileGallery(
                isInbox: isOwnProfile,
                firstPage: snapshot.data!.string!,
              ),
            ],
          );
        } else if (snapshot.hasError) {
          child = const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          );
        } else {
          child = const Center(
            child: SizedBox(
              width: 45,
              height: 45,
              child: CircularProgressIndicator(),
            ),
          );
        }
        return child;
      },
    );

    if (isOwnProfile) {
      return profile;
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            General.appName,
            style: const TextStyle(
              fontFamily: "Righteous",
              fontSize: 25,
              fontWeight: FontWeight.w100,
              color: Colors.white,
            ),
          ),
        ),
        body: profile,
      );
    }
  }

  Future<ActorStringHelper> getHelper() async {
    ActorAPI actorProvider = ActorAPI();
    Actor actor = await actorProvider.getActor(profileId);
    String? firstPage = await getFirstPage(actor);
    ActorStringHelper helper = ActorStringHelper(
      firstPage,
      actor,
    );

    return helper;
  }

  Future<String?> getFirstPage(Actor actor) async {
    OutboxAPI outboxAPI = OutboxAPI();
    var result = await outboxAPI.getFirstPage(actor.outbox!);
    return result.first;
  }
}
