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

    return FutureBuilder<ActorStringHelper>(
      future: getHelper(),
      builder:
          (BuildContext context, AsyncSnapshot<ActorStringHelper> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          var slivers = <Widget>[
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  ProfileHead(actor: snapshot.data!.actor!),
                ],
              ),
            ),
          ];

          if (!isOwnProfile) {
            slivers.insert(
              0,
              const SliverAppBar(
                primary: true,
                pinned: true,
              ),
            );
          }

          child = Scaffold(
            body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return slivers;
              },
              body: ProfileGallery(
                isInbox: isOwnProfile,
                firstPage: snapshot.data!.string!,
              ),
            ),
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
