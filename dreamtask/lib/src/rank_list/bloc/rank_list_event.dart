part of 'rank_list_bloc.dart';

@immutable
sealed class RankListEvent {}

class FetchRankListEvent extends RankListEvent {
  final String rankListEndpoint;

  FetchRankListEvent(this.rankListEndpoint);
}
