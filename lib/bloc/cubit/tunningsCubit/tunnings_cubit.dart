import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:tunnerapp/model/tunnings_model.dart';

part 'tunnings_state.dart';


class TunningsCubit extends Cubit<TunningsState> {
  TunningsCubit() : super(TunningsInitial()){
    fetchTunings();
  }

  void fetchTunings()async{
    emit(TuningsLoadingState());
    try {
    final String response = 
          await rootBundle.loadString('assets/tunings.json');
    final data = await json.decode(response);
    emit(TuningsLoadedState(data:TuningsModel.fromJson(data)));
    } on Exception {
        emit(TuningsErrorState());

    }
  }
}