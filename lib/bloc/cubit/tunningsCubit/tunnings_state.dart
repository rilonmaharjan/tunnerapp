part of 'tunnings_cubit.dart';

sealed class TunningsState extends Equatable {
  const TunningsState();

  @override
  List<Object> get props => [];
}

class TunningsInitial extends TunningsState {}
class TuningsLoadedState extends TunningsState {
  final TuningsModel data;

  const TuningsLoadedState({required this.data });
  
  @override
  List<Object> get props => [data];

}
class TuningsLoadingState extends TunningsState {}
class TuningsErrorState extends TunningsState {}

class SelectedInstrumentState extends TunningsState {
  final String instrument;

  const SelectedInstrumentState({required this.instrument});
  
  @override
  List<Object> get props => [instrument];
}
class SelectedTuningState extends TunningsState {
  final String tuning;

  const SelectedTuningState({required this.tuning});
  
  @override
  List<Object> get props => [tuning];
}