import 'dart:async';

import 'package:dreamtask/src/games/bloc/games_bloc.dart';
import 'package:dreamtask/src/games/game_model.dart';
import 'package:dreamtask/src/games/games_screen.dart';
import 'package:dreamtask/src/users/bloc/users_bloc.dart';
import 'package:dreamtask/src/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class GameDetailsScreen extends StatefulWidget {
  static const routeName = '/game_details';

  final int gameId;
  final int firstPlayer;
  final int secondPlayer;

  const GameDetailsScreen(
      {super.key,
      required this.gameId,
      required this.firstPlayer,
      required this.secondPlayer});

  @override
  State<GameDetailsScreen> createState() =>
      // ignore: no_logic_in_create_state
      _GameDetailsScreenState(gameId, firstPlayer, secondPlayer);
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  final gamesBloc = GamesBloc();

  int gameId;
  int firstPlayer;
  int secondPlayer;

  _GameDetailsScreenState(this.gameId, this.firstPlayer, this.secondPlayer);

  // ignore: prefer_typing_uninitialized_variables
  late var timer;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      timer = Timer.periodic(
          const Duration(seconds: 5),
          (Timer t) => setState(() {
                gamesBloc.add(FetchCurrentGameDetails(gameId));
              }));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CurrentUserSingleton currentUser = CurrentUserSingleton.instance;
    final userBloc = UsersBloc();
    final userBloc2 = UsersBloc();

    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, GamesScreen.routeName);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Game $gameId'),
        ),
        body: BlocProvider(
          create: (context) => gamesBloc,
          child: BlocListener<GamesBloc, GamesState>(
            listener: (context, state) {},
            child: BlocBuilder<GamesBloc, GamesState>(
              builder: (context, state) {
                if (state is GamesInitial) {
                  gamesBloc.add(
                    FetchCurrentGameDetails(gameId),
                  );
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GamesLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is SuccessfulCurrentGameDetails) {
                  GameModel game = state.currentGameResponse;
                  List<dynamic> boardList =
                      game.board[0] + game.board[1] + game.board[2];
                  List numberOfMoves = boardList
                      .where(
                        (element) => element != null,
                      )
                      .toList();
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              (firstPlayer != 0)
                                  ? BlocProvider(
                                      create: (context) => userBloc,
                                      child:
                                          BlocListener<UsersBloc, UsersState>(
                                        listener: (context, stateUser) {},
                                        child:
                                            BlocBuilder<UsersBloc, UsersState>(
                                                builder: (context, stateUser) {
                                          if (stateUser is UsersInitial) {
                                            userBloc.add(
                                                FetchUserDetails(firstPlayer));
                                          }
                                          if (stateUser
                                              is FetchFirstPlayerSuccessfully) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Column(
                                                children: [
                                                  (game.status == 'finished' &&
                                                          stateUser.user.id ==
                                                              game.winner['id'])
                                                      ? const FaIcon(
                                                          FontAwesomeIcons
                                                              .crown)
                                                      : Container(),
                                                  Text(
                                                    stateUser.user.username,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                      ),
                                    )
                                  : const Text('Waiting for first player'),
                              const Text(
                                'vs',
                                style: TextStyle(fontSize: 20),
                              ),
                              (secondPlayer != 0)
                                  ? BlocProvider(
                                      create: (context) => userBloc2,
                                      child:
                                          BlocListener<UsersBloc, UsersState>(
                                        listener: (context, stateUser2) {},
                                        child:
                                            BlocBuilder<UsersBloc, UsersState>(
                                                builder: (context, stateUser2) {
                                          if (stateUser2 is UsersInitial) {
                                            userBloc2.add(
                                              FetchUserDetails2(secondPlayer),
                                            );
                                          }
                                          if (stateUser2
                                              is FetchSecondPlayerSuccessfully) {
                                            return SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: Column(
                                                children: [
                                                  (game.status == 'finished' &&
                                                          stateUser2.user2.id ==
                                                              game.winner['id'])
                                                      ? const FaIcon(
                                                          FontAwesomeIcons
                                                              .crown)
                                                      : Container(),
                                                  Text(
                                                    stateUser2.user2.username,
                                                    style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                      ),
                                    )
                                  : const Text('Waiting for second player'),
                            ],
                          ),
                        ),
                        (firstPlayer == currentUser.id &&
                                numberOfMoves.length.isEven &&
                                game.status == 'progress')
                            ? const Text('Your turn to play!')
                            : Container(),
                        (secondPlayer == currentUser.id &&
                                numberOfMoves.length.isOdd &&
                                game.status == 'progress')
                            ? const Text('Your turn to play!')
                            : Container(),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                              color: Colors.grey,
                              width: 300,
                              height: 300,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 2.0,
                                        crossAxisSpacing: 2.0),
                                itemCount: 9,
                                itemBuilder: (context, index) {
                                  if (boardList[index] == firstPlayer) {
                                    return Container(
                                      color: Colors.white,
                                      child: const Center(
                                        child: Text(
                                          'X',
                                          style: TextStyle(fontSize: 35),
                                        ),
                                      ),
                                    );
                                  } else if (boardList[index] == secondPlayer) {
                                    return Container(
                                      color: Colors.white,
                                      child: const Center(
                                        child: Text(
                                          'O',
                                          style: TextStyle(fontSize: 35),
                                        ),
                                      ),
                                    );
                                  } else if (boardList[index] == null &&
                                      firstPlayer == currentUser.id &&
                                      numberOfMoves.length.isEven) {
                                    return InkWell(
                                      onTap: () {
                                        Map<String, dynamic>
                                            paramsForRequestBody =
                                            getCoordinatesFromIndex(index);
                                        gamesBloc.add(
                                          MakeMoveEvent(
                                              gameId, paramsForRequestBody),
                                        );
                                      },
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    );
                                  } else if (boardList[index] == null &&
                                      secondPlayer == currentUser.id &&
                                      numberOfMoves.length.isOdd) {
                                    return InkWell(
                                      onTap: () {
                                        Map<String, dynamic>
                                            paramsForRequestBody =
                                            getCoordinatesFromIndex(index);
                                        gamesBloc.add(
                                          MakeMoveEvent(
                                              gameId, paramsForRequestBody),
                                        );
                                      },
                                      child: Container(
                                        color: Colors.white,
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      color: Colors.white,
                                    );
                                  }
                                },
                              )),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        (state.currentGameResponse.status == "open" &&
                                state.currentGameResponse.firstPlayer['id'] !=
                                    state.currentPlayerId)
                            ? ElevatedButton(
                                onPressed: () {
                                  secondPlayer = currentUser.id;
                                  gamesBloc.add(
                                    JoinGameEvent(state.currentGameResponse.id),
                                  );
                                },
                                child: const Text('Join game'))
                            : Container(),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Game info',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Text('Game status: ${game.status}'),
                        Text(
                            'Created: ${DateFormat('MM/dd/yyyy hh:mm a').format(
                          DateTime.parse(game.created),
                        )}'),
                      ],
                    ),
                  );
                } else if (state is ErrorGamesState) {
                  return Center(
                    child: Text(state.gamesError),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Map<String, dynamic> getCoordinatesFromIndex(int index) {
    int row = index ~/ 3;
    int column = (index % 3).toInt();
    Map<String, dynamic> paramsForRequestBody = {"row": row, "col": column};
    return paramsForRequestBody;
  }
}
