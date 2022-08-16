import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../lang/strs.dart';
import '../../services/server_service.dart';
import '../../widget/loading_widget/loading_widget.dart';
import '../../widget/staggered_animations/flutter_staggered_animations.dart';

class ScreenUserProfile extends StatelessWidget {
  const ScreenUserProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: FutureBuilder(
        future: ServerService.updateCurrentUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            try {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: SingleChildScrollView(
                  child: AnimationLimiter(
                    child: Column(
                      children: AnimationConfiguration.toStaggeredList(
                        duration: const Duration(milliseconds: 500),
                        childAnimationBuilder: (widget) => SlideAnimation(
                          horizontalOffset: 50,
                          child: FadeInAnimation(
                            child: widget,
                          ),
                        ),
                        children: [
                          _buildTop(),
                          const SizedBox(height: 30),
                          _buildNameContent(),
                          const SizedBox(height: 35),
                          _buildDataContent(),
                          const SizedBox(height: 35),
                          _buildTeamContent(),
                          const SizedBox(height: 35),
                          _buildContactContent(),
                          const SizedBox(height: 20),
                          _buildChangePasswordContent(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            } catch (e) {
              return Center(
                child: Text(
                  "${Strs.failedToLoadDataFromServerErrorMessage.tr}\n${Strs.tryAgainErrorMessage.tr}",
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: Get.theme.textTheme.subtitle2,
                ),
              );
            }
          } else {
            return const LoadingWidget();
          }
        },
      ),
    );
  }

//   return AnimationLimiter(
//                 key: UniqueKey(),
//                 child: ListView(
//                   padding: EdgeInsets.zero,
//                   children: [
//                     AnimationConfiguration.staggeredList(
//                       position: 0,
//                       duration: const Duration(milliseconds: 500),
//                       child: SlideAnimation(
//                         verticalOffset: 50,
//                         child: FadeInAnimation(
//                           child: _buildTop(),
//                         ),
//                       ),
//                     ),
//                     AnimationConfiguration.staggeredList(
//                       position: 2,
//                       duration: const Duration(milliseconds: 500),
//                       child: SlideAnimation(
//                         verticalOffset: 50,
//                         child: FadeInAnimation(
//                           child: _buildContent(),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );

  AppBar _buildAppBar() => AppBar(
        automaticallyImplyLeading: false,
        leading: GestureDetector(
          onTap: Get.back,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(15),
            child: const Icon(
              CupertinoIcons.chevron_back,
            ),
          ),
        ),
      );

  Stack _buildTop() {
    final imgUint8List = ServerService.currentUser.profileImage;

    final coverHight = Get.height * 0.25;
    const profileHight = 120.0;
    final profileTop = coverHight - profileHight * 0.5;
    const coverBottom = profileHight * 0.5;

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: coverBottom),
          child: Container(
            color: Colors.grey,
            child: _buildCoverImg(coverHight, imgUint8List),
          ),
        ),
        Positioned(
          top: profileTop,
          child: _buildProfileImg(profileHight, imgUint8List),
        ),
      ],
    );
  }

  SizedBox _buildCoverImg(double coverHight, Uint8List? imgUint8List) =>
      SizedBox(
        height: coverHight,
        width: double.infinity,
        child: Container(
          decoration: BoxDecoration(
            image: imgUint8List == null
                ? const DecorationImage(
                    image: AssetImage('assets/user_avatar.png'),
                    fit: BoxFit.cover,
                  )
                : DecorationImage(
                    image: MemoryImage(imgUint8List),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Get.theme.colorScheme.background,
                ],
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: const SizedBox(),
            ),
          ),
        ),
      );

  Widget _buildProfileImg(double profileHight, Uint8List? imgUint8List) =>
      Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.fromBorderSide(BorderSide(
                color: Get.theme.colorScheme.background,
                width: 10,
              )),
              shape: BoxShape.circle,
            ),
            // shape: CircleBorder(
            //   side: BorderSide(
            //     color: Get.theme.colorScheme.background,
            //     width: 10,
            //   ),
            // ),
            child: CircleAvatar(
              radius: profileHight * 0.5,
              backgroundImage: const AssetImage(
                'assets/user_avatar.png',
              ),
              backgroundColor: Colors.grey,
              child: imgUint8List != null ? Image.memory(imgUint8List) : null,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: _onCameraButtonPressed,
              child: const Icon(CupertinoIcons.camera),
            ),
          ),
        ],
      );

//   Widget _buildContent() {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Padding(
//         padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             _buildNameContent(),
//             _buildDataContent(),
//             _buildTeamContent(),
//             _buildContactContent(),
//             _buildChangePasswordContent(),
//           ],
//         ),
//       ),
//     );
//   }

  Widget _buildNameContent() => Text(
        ServerService.currentUser.name ?? "",
        textAlign: TextAlign.center,
        style: Get.theme.textTheme.headlineMedium!
            .copyWith(color: Get.theme.colorScheme.onBackground),
      );

  void _onCameraButtonPressed() {}

  Widget _buildDataContent() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ServerService.currentUser.userType ?? "",
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.headline6!
                    .copyWith(color: Get.theme.colorScheme.onBackground),
              ),
              const SizedBox(height: 15),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "${Strs.nationalIdStr.tr}: ",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText2!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                  Text(
                    ServerService.currentUser.username ?? "",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText1!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "${Strs.rankingStr.tr}: ",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText2!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                  Text(
                    ServerService.currentUser.rank ?? "",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText1!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "${Strs.organPosStr.tr}: ",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText2!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                  Text(
                    ServerService.currentUser.organPos ?? "",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText1!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamContent() {
    return Card(
      margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Strs.teamStr.tr,
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.headline6!
                    .copyWith(color: Get.theme.colorScheme.onBackground),
              ),
              const SizedBox(height: 15),
              Wrap(
                spacing: Get.width * 0.1,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        "${Strs.teamNameStr.tr}: ",
                        textAlign: TextAlign.center,
                        style: Get.theme.textTheme.bodyText2!.copyWith(
                            color: Get.theme.colorScheme.onBackground),
                      ),
                      Text(
                        "${ServerService.currentUser.teamData != null ? ServerService.currentUser.teamData!['teamName'] : ''}",
                        textAlign: TextAlign.center,
                        style: Get.theme.textTheme.bodyText1!.copyWith(
                            color: Get.theme.colorScheme.onBackground),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    children: [
                      Text(
                        "${Strs.postStr.tr}: ",
                        textAlign: TextAlign.center,
                        style: Get.theme.textTheme.bodyText2!.copyWith(
                            color: Get.theme.colorScheme.onBackground),
                      ),
                      Text(
                        "${ServerService.currentUser.teamData != null ? ServerService.currentUser.teamData!['post'] : ''}",
                        textAlign: TextAlign.center,
                        style: Get.theme.textTheme.bodyText1!.copyWith(
                            color: Get.theme.colorScheme.onBackground),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactContent() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    Strs.userContactInfoStr.tr,
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.headline6!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () {},
                    child: const Icon(CupertinoIcons.pencil),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "${Strs.phoneNumberStr.tr}: ",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText2!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                  Text(
                    ServerService.currentUser.phone ?? "",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText1!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Text(
                    "${Strs.emailStr.tr}: ",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText2!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                  Text(
                    ServerService.currentUser.email ?? "",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.bodyText1!
                        .copyWith(color: Get.theme.colorScheme.onBackground),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 30),
      child: CupertinoButton(
        child: Text(
          Strs.editPasswordStr.tr,
          style: TextStyle(fontFamily: Get.theme.textTheme.button!.fontFamily),
        ),
        onPressed: () {},
      ),
    );
  }
}
