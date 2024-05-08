part of 'rank_list_bloc.dart';

@immutable
sealed class RankListState {}

final class RankListInitial extends RankListState {}

final class RankListLoading extends RankListState {}

final class SuccessfulRankListState extends RankListState {
  final RankListResponseModel rankListResponseModel;

  SuccessfulRankListState(this.rankListResponseModel);
}

final class ErrorRankListState extends RankListState {
  final String rankListError;
  ErrorRankListState(this.rankListError);
}
