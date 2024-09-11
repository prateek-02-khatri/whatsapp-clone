import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/user_model.dart';
import 'package:whatsapp_clone/resource/app_colors.dart';
import 'package:whatsapp_clone/resource/components/custom_icon_button.dart';
import 'package:whatsapp_clone/resource/theme/extension/custom_theme_extension.dart';
import 'package:whatsapp_clone/view/chat/widgets/custom_list_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.user, required this.status});

  final UserModel user;
  final String status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: context.theme.profilePageBg,

      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverPersistentDelegate(user: user)
          ),

          SliverToBoxAdapter(
            child: Column(
              children: [

                const SizedBox(height: 10),

                Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 24
                        ),
                      ),

                      const SizedBox(height: 10,),

                      Text(
                        user.phoneNumber,
                        style: TextStyle(
                          color: context.theme.greyColor,
                          fontSize: 20
                        ),
                      ),

                      const SizedBox(height: 10,),

                      Text(
                        status,
                        style: TextStyle(
                          color: context.theme.greyColor,
                          fontSize: 16
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    iconWithText(icon: Icons.call, text: 'Call'),
                    iconWithText(icon: Icons.video_call, text: 'Video'),
                    iconWithText(icon: Icons.search, text: 'Search'),
                  ],
                ),

                const SizedBox(height: 10),

                ListTile(
                  contentPadding: const EdgeInsets.only(left: 30),
                  title: const Text(
                    'Hey there! I am using WhatsApp',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  subtitle: Text(
                    '17th February',
                    style: TextStyle(
                        fontSize: 15,
                        color: context.theme.greyColor
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  color: context.theme.greyColor!.withOpacity(0.3),
                  child: Column(
                    children: [
                      CustomListTile(
                        leading: Icons.notifications_outlined,
                        title: 'Mute notification',
                        trailing: Switch(value: false, onChanged: (val) {}),
                      ),

                      CustomListTile(
                        leading: Icons.photo,
                        title: 'Media visibility',
                        trailing: Switch(value: false, onChanged: (val) {}),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  color: context.theme.greyColor!.withOpacity(0.3),
                  child: Column(
                    children: [
                      const CustomListTile(
                        leading: Icons.lock_outline,
                        title: 'Encryption',
                        subtitle: 'Messages and calls are end-to-end encrypted. Tap to verify.',
                        trailing: SizedBox(width: 50),
                      ),

                      const CustomListTile(
                        leading: Icons.timer_sharp,
                        title: 'Disappearing messages',
                        subtitle: 'Off',
                      ),

                      CustomListTile(
                        leading: Icons.lock_outline,
                        title: 'Chat lock',
                        subtitle: 'Lock and hide this chat on this device.',
                        trailing: Switch(value: false, onChanged: (val) {}),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  color: context.theme.greyColor!.withOpacity(0.3),
                  child: CustomListTile(
                    leading: Icons.group,
                    title: 'Create group with ${user.username}',
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  color: context.theme.greyColor!.withOpacity(0.3),
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 25, right: 10),
                        leading: const Icon(
                          Icons.block,
                          size: 26,
                          color: Color(0xFFF15C6D),
                        ),
                        title: Text(
                          'Block ${user.username}',
                          style: const TextStyle(
                            color: Color(0xFFF15C6D),
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                      ),

                      ListTile(
                        contentPadding: const EdgeInsets.only(left: 25, right: 10),
                        leading: const Icon(
                          Icons.thumb_down,
                          size: 26,
                          color: Color(0xFFF15C6D),
                        ),
                        title: Text(
                          'Report ${user.username}',
                          style: const TextStyle(
                              color: Color(0xFFF15C6D),
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                          ),
                        ),

                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          )
        ],
      ),
    );
  }

  iconWithText({
    required IconData icon,
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 30,
            color: AppColors.greenDark,
          ),

          const SizedBox(
            height: 10,
          ),

          Text(
            text,
            style: const TextStyle(
              color: AppColors.greenDark
            ),
          )
        ],
      ),
    );
  }
}

class SliverPersistentDelegate extends SliverPersistentHeaderDelegate {

  final UserModel user;

  SliverPersistentDelegate({required this.user});

  final double maxHeaderHeight = 180;
  final double minHeaderHeight = kToolbarHeight + 50;

  final double maxImageSize = 130;
  final double minImageSize = 40;


  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final Size size = MediaQuery.of(context).size;

    final percent1 = shrinkOffset / (maxHeaderHeight - 35);
    final percent2 = shrinkOffset / maxHeaderHeight;

    final currentImageSize = (maxImageSize * (1 - percent1)).clamp(
      minImageSize,
      maxImageSize,
    );
    final currentImagePosition = ((size.width / 2 - 65) * (1 - percent1)).clamp(
      minImageSize,
      maxImageSize,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Container(
        color: Theme.of(context).appBarTheme.backgroundColor!.withOpacity(percent2 * 2 < 1 ? percent2 * 2 : 1),
        child: Stack(
          children: [
            Positioned(
              left: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: BackButton(
                color: percent2 > 0.3 ? Colors.white.withOpacity(percent2) : null,
              )
            ),

            Positioned(
              right: 0,
              top: MediaQuery.of(context).viewPadding.top + 5,
              child: CustomIconButton(
                onPressed: () {},
                icon: Icons.more_vert,
                iconColor: percent2 > 0.3 ? Colors.white.withOpacity(percent2) : Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),

            Positioned(
              left: currentImagePosition + 25,
              top: MediaQuery.of(context).viewPadding.top + 5,
              bottom: 0,
              child: Hero(
                tag: 'profile',
                child: Container(
                  width: currentImageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(user.profileUrl)
                    )
                  ),
                ),
              ),
            ),

            Positioned(
              left: currentImagePosition + currentImageSize + 35,
              top: MediaQuery.of(context).viewPadding.top + 15,
              child: Text(
                user.username,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white.withOpacity(percent2)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeaderHeight;

  @override
  double get minExtent => minHeaderHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}
