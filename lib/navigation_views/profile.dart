import 'package:activitypub/APIs/actor_api.dart';
import 'package:activitypub/Models/actor.dart';
import 'package:fedodo_general/widgets/profile/profile_head.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({
    super.key,
    required this.profileId,
  });

  final String profileId;

  @override
  Widget build(BuildContext context) {
    ActorAPI actorProvider = ActorAPI();
    Future<Actor> actorFuture = actorProvider.getActor(profileId);

    return FutureBuilder<Actor>(
      future: actorFuture,
      builder: (BuildContext context, AsyncSnapshot<Actor> snapshot) {
        Widget child;
        if (snapshot.hasData) {
          child = Column(
            children: [
              ProfileHead(actor: snapshot.data!),
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
  }
}
