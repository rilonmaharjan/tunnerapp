
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import 'package:tunnerapp/bloc/bloc/homebloc/home_bloc.dart';
import 'package:tunnerapp/bloc/cubit/theme_cubit/theme_cubit.dart';
import 'package:tunnerapp/helper/constants.dart';
import 'package:tunnerapp/view/song_chord.dart';
import 'package:tunnerapp/view/tuner.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchCon = TextEditingController();
  var searchedSong = "";

  @override
  void initState() {
    context.read<HomeBloc>().add(const SongsEvent(filterBy: "title"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isLightmode) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: AppColors.white,
          floatingActionButton: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.deepTeal),
            onPressed: ()async{
              await recordPerm(context);
            },  
            child: const Text("Tuner", style: TextStyle(color: Colors.white),)
          ),
          body: SafeArea(
            child: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state is HomeLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HomeLoadedState) {
                  var result = state.songs;
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: StickyHeader(
                      header: Container(
                        color: AppColors.deepTeal,
                        height: 80,
                        padding: const EdgeInsets.only(top: 15, bottom: 15, left: 30,right: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 300,
                              child: TextFormField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color.fromARGB(255, 238, 238, 238), // White background
                                  contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                    borderSide: const BorderSide(
                                      color: AppColors.sage, // Grey border color
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0), // Rounded corners on focus
                                    borderSide: const BorderSide(
                                      color: AppColors.sage, // Grey border color on focus
                                      width: 1.5,
                                    ),
                                  ),
                                  hintText: 'Search',
                                  hintStyle: const TextStyle(color: AppColors.sage),
                                  prefixIcon: const Icon(Icons.search, color: AppColors.sage,)
                                ),
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                                keyboardType: TextInputType.text,
                                controller: searchCon,
                                onChanged: (val){
                                  setState(() {
                                    searchedSong = val;
                                  });
                                },
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (String value) {
                                // Handle the selection here
                                if (value == 'Artist') {
                                  context.read<HomeBloc>().add(const SongsEvent(filterBy: "artist"));
                                } else if (value == 'Title') {
                                  context.read<HomeBloc>().add(const SongsEvent(filterBy: "title"));
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                return [
                                  const PopupMenuItem<String>(
                                    value: 'Artist',
                                    child: Text('ARTIST'),
                                  ),
                                  const PopupMenuDivider(),
                                  const PopupMenuItem<String>(
                                    value: 'Title',
                                    child: Text('TITLE'),
                                  ),
                                ];
                              },
                              offset: const Offset(-10, 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: const Icon(Icons.more_vert, color: AppColors.white,), // Icon for the popup menu button
                            )
                          ],
                        ),
                      ),
                      content: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          if(result[index].title.toLowerCase().contains(searchedSong.toLowerCase()) || result[index].artist.toLowerCase().contains(searchedSong.toLowerCase())) {
                            return ListTile(
                              tileColor: isLightmode? AppColors.white : AppColors.sage,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SongchordPage(
                                              song: result[index]),
                                    ));
                              },
                              title: Hero(
                                tag: result[index].docId,
                                child: Material(
                                  color: Colors.transparent,
                                  child: Text(
                                    result[index].title.toString(),
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.charcoal.withOpacity(.8)),
                                  ),
                                ),
                              ),
                              subtitle: Text(
                                  result[index].artist.toString(),
                                  style: const TextStyle(color: AppColors.olive),
                              )
                            );
                          }
                          else{
                            return const SizedBox();
                          }
                        },
                      ),
                    ),
                  );
                }
                if (state is HomeErrorState) {
                  return Center(
                    child: Text(state.message.toString()),
                  );
                }
                return Container();
              },
            ),
          ),
        );
      },
    );
  }
  
  recordPerm(context)async{
    final result = await Permission.microphone.request();
    if (result.isGranted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const TunerPage()));
    } else {
      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(
          "Permission Denied"
        )));
        Navigator.pop(context);
      }
    }
  }
}