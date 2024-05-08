import 'package:dreamtask/src/games/games_screen.dart';
import 'package:dreamtask/src/rank_list/bloc/rank_list_bloc.dart';
import 'package:dreamtask/src/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RankListScreen extends StatefulWidget {
  static const routeName = '/ranklist';
  const RankListScreen({super.key});

  @override
  State<RankListScreen> createState() => _RankListScreenState();
}

class _RankListScreenState extends State<RankListScreen> {
  int currentScreenIndex = 1;
  final rankListBloc = RankListBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text('Rank List'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Games'),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered), label: 'Rank list')
        ],
        onTap: (value) {
          switch (value) {
            case 0:
              Navigator.pushReplacementNamed(context, GamesScreen.routeName);
            case 1:
              Navigator.pushReplacementNamed(context, RankListScreen.routeName);
          }
          setState(() {
            currentScreenIndex = value;
          });
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocProvider(
            create: (context) => rankListBloc,
            child: BlocListener<RankListBloc, RankListState>(
              listener: (context, state) {},
              child: BlocBuilder<RankListBloc, RankListState>(
                builder: (context, state) {
                  if (state is SuccessfulRankListState) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              (state.rankListResponseModel.previous.isEmpty)
                                  ? Container()
                                  : ElevatedButton(
                                      onPressed: () {
                                        rankListBloc.add(FetchRankListEvent(
                                            state.rankListResponseModel
                                                .previous));
                                      },
                                      child: const Text('Previous')),
                              const Spacer(),
                              (state.rankListResponseModel.next.isEmpty)
                                  ? Container()
                                  : ElevatedButton(
                                      onPressed: () {
                                        rankListBloc.add(FetchRankListEvent(
                                            state.rankListResponseModel.next));
                                      },
                                      child: const Text('Next')),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                              'Total results: ${state.rankListResponseModel.count}'),
                        )
                      ],
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: BlocProvider(
              create: (context) => rankListBloc,
              child: BlocListener<RankListBloc, RankListState>(
                listener: (context, state) {},
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: BlocProvider(
                    create: (context) => rankListBloc,
                    child: BlocListener<RankListBloc, RankListState>(
                      listener: (context, state) {},
                      child: BlocBuilder<RankListBloc, RankListState>(
                        builder: (context, state) {
                          if (state is RankListInitial) {
                            rankListBloc.add(FetchRankListEvent(''));
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (state is RankListLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (state is SuccessfulRankListState) {
                            return RankListWidget(
                              rankList:
                                  state.rankListResponseModel.allUsersList,
                            );
                          }
                          if (state is ErrorRankListState) {
                            return Text(state.rankListError);
                          } else {
                            return const Text('Unhandled state');
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RankListWidget extends StatelessWidget {
  final List<UserModel> rankList;
  const RankListWidget({super.key, required this.rankList});

  @override
  Widget build(BuildContext context) {
    rankList.sort(
      (a, b) => b.win_rate.compareTo(a.win_rate),
    );
    return ListView.builder(
      itemCount: rankList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return RankListCard(
          user: rankList[index],
        );
      },
    );
  }
}

class RankListCard extends StatelessWidget {
  final UserModel user;
  const RankListCard({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Card(
        elevation: 4,
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 5),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  user.username,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: [
                  Text(
                      'Win percentage: ${double.parse((user.win_rate * 100).toStringAsFixed(2))}%'),
                  Text('Games played: ${user.game_count}'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
