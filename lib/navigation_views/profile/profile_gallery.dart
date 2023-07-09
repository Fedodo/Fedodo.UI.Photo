import 'package:activitypub/APIs/inbox_api.dart';
import 'package:activitypub/APIs/outbox_api.dart';
import 'package:activitypub/Models/ObjectTypes/document.dart';
import 'package:activitypub/Models/activity.dart';
import 'package:activitypub/Models/ordered_collection_page.dart';
import 'package:activitypub/Models/post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fedodo_general/extensions/url_extensions.dart';
import 'package:fedodo_general/globals/general.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ProfileGallery extends StatefulWidget {
  const ProfileGallery({
    super.key,
    required this.firstPage,
    required this.isInbox,
  });

  final String firstPage;
  final bool isInbox;

  @override
  State<ProfileGallery> createState() => _ProfileGalleryState();
}

class _ProfileGalleryState extends State<ProfileGallery> {
  late final PagingController<String, Document> _paginationController =
      PagingController(firstPageKey: widget.firstPage);
  static const _pageSize = 20;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _paginationController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(String pageKey) async {
    try {
      OrderedCollectionPage orderedCollectionPage;

      if (widget.isInbox) {
        InboxAPI inboxProvider = InboxAPI();
        orderedCollectionPage = await inboxProvider.getPosts(pageKey);
      } else {
        OutboxAPI provider = OutboxAPI();
        orderedCollectionPage = await provider.getPosts(pageKey);
      }

      List<Document> documents = [];

      for (Activity activity in orderedCollectionPage.orderedItems) {
        if (activity.type == "Create" && activity.object.inReplyTo == null) {
          var convertedActivity = activity as Activity<Post>;

          if (convertedActivity.object.attachment != null &&
              convertedActivity.object.attachment!.isNotEmpty) {
            documents.addAll(convertedActivity.object.attachment!);
          }
        }
      }

      final isLastPage = false; // TODO
      // final isLastPage = orderedCollectionPage.orderedItems.length < _pageSize;
      if (isLastPage) {
        _paginationController.appendLastPage(documents);
      } else {
        final nextPageKey = orderedCollectionPage.next;
        _paginationController.appendPage(documents, nextPageKey);
      }
    } catch (error) {
      General.logger.e(error, "Error occurred in ProfileGallery");
      _paginationController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _paginationController.refresh(),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: PagedGridView<String, Document>(
            scrollController: null,
            addSemanticIndexes: false,
            addAutomaticKeepAlives: false,
            addRepaintBoundaries: true,
            clipBehavior: Clip.none,
            pagingController: _paginationController,
            builderDelegate: PagedChildBuilderDelegate<Document>(
              itemBuilder: (context, item, index) => Ink.image(
                fit: BoxFit.cover,
                image: CachedNetworkImageProvider(
                  item.url?.asFedodoProxyUri().toString() ?? "",
                ),
                child: InkWell(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   PageRouteBuilder(
                    //     transitionDuration: const Duration(milliseconds: 300),
                    //     reverseTransitionDuration:
                    //         const Duration(milliseconds: 300),
                    //     pageBuilder: (context, animation, animation2) =>
                    //         PhotoDetail(
                    //       url: item.url?.asFedodoProxyUri().toString() ?? "",
                    //     ),
                    //     transitionsBuilder:
                    //         (context, animation, animation2, widget) =>
                    //             SlideTransition(
                    //                 position: Tween(
                    //                   begin: const Offset(1.0, 0.0),
                    //                   end: const Offset(0.0, 0.0),
                    //                 ).animate(animation),
                    //                 child: widget),
                    //   ),
                    // );
                  },
                ),
              ),
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _paginationController.dispose();
    super.dispose();
  }
}
