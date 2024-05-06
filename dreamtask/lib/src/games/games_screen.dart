import 'package:dreamtask/src/game_details/game_details_screen.dart';
import 'package:dreamtask/src/games/bloc/games_bloc.dart';
import 'package:dreamtask/src/games/game_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamesScreen extends StatefulWidget {
  static const routeName = '/games';
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  var selectedStatus = 'open';
  final gamesBloc = GamesBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          ElevatedButton(
              onPressed: () {
                // gamesBloc.add(FetchGamesEvent(''));
                gamesBloc.add(CreateNewGameEvent());
                gamesBloc.add(FetchGamesEvent(''));
              },
              child: const Text('Create new game')),
          BlocProvider(
            create: (context) => gamesBloc,
            child: BlocListener<GamesBloc, GamesState>(
              listener: (context, state) {
                // if (state is SuccessfulCreateNewGameState) {
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                //     content: Text('New game created successfully'),
                //   ));
                // }
              },
              child: BlocBuilder<GamesBloc, GamesState>(
                builder: (context, state) {
                  if (state is SuccessfulGamesState) {
                    // int lastResultIndex = int.parse(state.gamesResponse.next
                    //     .substring(state.gamesResponse.next.length - 2));
                    // int firstResultIndex = lastResultIndex - 10;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              (state.gamesResponse.previous.isEmpty)
                                  ? Container()
                                  : ElevatedButton(
                                      onPressed: () {
                                        gamesBloc.add(FetchGamesEvent(
                                            state.gamesResponse.previous));
                                      },
                                      child: const Text('Previous')),
                              const Spacer(),
                              (state.gamesResponse.next.isEmpty)
                                  ? Container()
                                  : ElevatedButton(
                                      onPressed: () {
                                        gamesBloc.add(FetchGamesEvent(
                                            state.gamesResponse.next));
                                      },
                                      child: const Text('Next')),
                            ],
                          ),
                        ),
                        // Align(
                        //   alignment: Alignment.centerLeft,
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(8.0),
                        //     child: Text(
                        //         'Showing $firstResultIndex-$lastResultIndex of ${state.gamesResponse.count} total'),
                        //   ),
                        // )
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              // Text(
                              //     'Showing $firstResultIndex-$lastResultIndex of ${state.gamesResponse.count} total'),
                              const Spacer(),
                              DropdownButton(
                                value: selectedStatus,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'open',
                                    child: Text('open'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'progress',
                                    child: Text('progress'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'finished',
                                    child: Text('finished'),
                                  )
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    selectedStatus = value!;

                                    gamesBloc.add(FetchGamesEvent(
                                        'https://tictactoe.aboutdream.io/games/?status=$value'));
                                  });
                                },
                              ),
                            ],
                          ),
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
          BlocProvider(
            create: (context) => gamesBloc,
            child: BlocListener<GamesBloc, GamesState>(
              listener: (context, state) {},
              child: BlocBuilder<GamesBloc, GamesState>(
                builder: (context, state) {
                  if (state is GamesInitial) {
                    gamesBloc.add(FetchGamesEvent(''));
                    return const Text('initial');
                  }
                  if (state is GamesLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is SuccessfulGamesState) {
                    return GamesListWidget(
                      gamesList: state.gamesResponse.gamesList,
                      userId: state.id,
                    );
                  }
                  if (state is ErrorGamesState) {
                    return Text(state.gamesError);
                  } else {
                    return const Text('Unhandled state');
                  }
                },
              ),
            ),
          )
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.gamepad), label: 'Games'),
          BottomNavigationBarItem(
              icon: Icon(Icons.format_list_numbered), label: 'Rank list')
        ],
      ),
    );
  }
}

class GamesListWidget extends StatelessWidget {
  final List<GameModel> gamesList;
  final int userId;
  const GamesListWidget(
      {super.key, required this.gamesList, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: gamesList.length,
        itemBuilder: (context, index) {
          return GameCard(
            game: gamesList[index],
            userId: userId,
          );
        },
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final GameModel game;
  final int userId;
  const GameCard({super.key, required this.game, required this.userId});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, GameDetailsScreen.routeName,
            arguments: game.id);
      },
      child: Card(
        child: SizedBox(
          height: 75.0,
          child: Column(
            children: [
              Text(game.id.toString()),
              Text(game.status),
              Text(game.created),
              (userId == game.firstPlayer['id'])
                  ? const Text('You have created this game')
                  : Container(),
              (userId == game.secondPlayer['id'])
                  ? const Text('You are playing this game')
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
