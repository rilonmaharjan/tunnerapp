import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tunnerapp/bloc/cubit/theme_cubit/theme_cubit.dart';
import 'package:tunnerapp/helper/constants.dart';
import 'package:tunnerapp/model/songs_model.dart';


class SongchordPage extends StatefulWidget {
  const SongchordPage(
      {super.key, required this.song});
  final SongsModel song;

  @override
  State<SongchordPage> createState() => _SongchordPageState();
}

class _SongchordPageState extends State<SongchordPage> {
  late ScrollController controller;
  bool autoScroll = false;
  int scrollTime = 6;
  double sliderval = 0.1;
  double fontsize = 15;
  late bool isLightmode;

  @override
  void initState() {
    super.initState();
    isLightmode = BlocProvider.of<ThemeCubit>(context).state;
    controller = ScrollController()
      ..addListener(() {
        // debugPrint(controller.offset.toString());
        if (autoScroll) {
          if(controller.position.maxScrollExtent == controller.offset) {
            setState(() {
              autoScroll = false;
            });
          }
          // controller.animateTo(controller.position.maxScrollExtent, duration: Duration(seconds: (controller.position.maxScrollExtent.round().toInt()/scrollTime).round()), curve: Curves.ease);
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepTeal,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            GestureDetector(
              onPanDown: (details) {
                log(details.toString());
              },
              child: NotificationListener(
                onNotification: (Notification notification) {
                  if (notification is ScrollEndNotification || notification is DraggableScrollableNotification) {
                    // log(notification.toString());
                    // User interaction ended, perform auto scroll
                    if(autoScroll) {
                      animate();
                    } else {
                      return false;
                    }
                  }
                  return true;
                },
                child: SingleChildScrollView(
                  controller: controller,
                  child: Stack(
                    children: [
                      //contexnt lyrics chords
                      Container(
                        padding: const EdgeInsets.all(14.0)
                            .copyWith(top: 220, bottom: 100),
                        width: double.infinity,
                        color:  isLightmode ? AppColors.white : AppColors.charcoal,
                        child: Text(
                          widget.song.content.toString(),
                          style: TextStyle(fontSize: fontsize,height: 1.5, letterSpacing: 1.0),
                        ),
                      ),
                      //top
                      Container(
                        height: 130,
                        color: AppColors.deepTeal,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    FluentIcons.arrow_circle_left_48_regular,
                                    size: 40,
                                    color: AppColors.white7,
                                  ),
                                ),
                                const Spacer(),
                                IconButton(
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      side: BorderSide(
                                        color: AppColors.white7,
                                        width: 1
                                      )
                                    ))
                                  ),
                                  onPressed: () {
                                    controller
                                        .animateTo(200,
                                            duration: const Duration(milliseconds: 250),
                                            curve: Curves.linear)
                                        .whenComplete(() => animate());
                                    setState(() {
                                      autoScroll = true;
                                    });
                                  },
                                  tooltip: "Autoplay",
                                  icon: Row(
                                    children: [
                                      const Icon(
                                        FluentIcons.play_circle_48_regular,
                                        size: 18,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text("Autoplay", style: TextStyle(color: AppColors.white7),)
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      //mid song & artist info
                      Container(
                        margin: const EdgeInsets.all(30).copyWith(top: 70),
                        height: 125,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: AppColors.olive,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 20,
                                  color: AppColors.charcoal.withOpacity(0.4),
                                  offset: const Offset(2, 2))
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColors.white.withOpacity(0.7)),
                                child: const Icon(
                                  FluentIcons.music_note_2_24_filled,
                                  color: AppColors.neonBlue,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Hero(
                                    tag: widget.song.docId,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Text(
                                        widget.song.title,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(color: AppColors.white7, fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.6),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    widget.song.artist,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style : TextStyle(color: AppColors.white7, fontSize: 15, fontWeight: FontWeight.w400,letterSpacing: 0.6),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            // const Expanded(
                            //   flex: 1,
                            //   child: Icon(
                            //     FluentIcons.heart_48_filled,
                            //     color: AppColors.charcoal
                            //   )
                            // ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            autoScroll 
              ? const SizedBox()
              : Container(
                padding: const EdgeInsets.only(top: 30),
                alignment: Alignment.centerRight,
                height: 250,
                width: 60,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: Slider(
                    label: "Text Scale",
                    activeColor: AppColors.deepTeal,
                    value: fontsize/100,
                    min: 0.14,
                    max: 0.20, 
                    onChanged: (val) {
                      setState(() {
                        fontsize = val * 100;
                      });
                    }
                  ),
                ),
              )
          ],
        ),
      ),
      floatingActionButton: autoScroll
          ? Container(
              color: AppColors.deepTeal,
              alignment: Alignment.center,
              height: 60,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Slider(
                      activeColor: AppColors.gunmetal,
                      value: sliderval,
                      onChanged: (value) {
                        debugPrint((value * 100).round().toString());
                        setState(() {
                          sliderval = value;
                          scrollTime = (5 + (value * 100)).round();
                          animate();
                        });
                      },
                    ),
                  ),
                  IconButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: AppColors.white7,
                          width: 1
                        )
                      ))
                    ),
                    onPressed: () {
                      setState(() {
                        autoScroll = false;
                        controller.animateTo(0,
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.linear);
                      });
                    },
                    tooltip: "Cancel Autoplay",
                    icon: const Row(
                      children: [
                        Icon(
                          FluentIcons.pause_circle_48_regular,
                          size: 18,
                          color: AppColors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Cancel")
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
              ),
            )
          : const SizedBox(
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


  animate() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.animateTo(controller.position.maxScrollExtent,
          duration: Duration(
              seconds: /* scrollTime */
                  (controller.position.maxScrollExtent.round().toInt() /
                          scrollTime)
                      .round()),
          curve: Curves.linear);
    });
  }
}