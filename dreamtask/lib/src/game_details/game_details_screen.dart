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
  int gameId;
  int firstPlayer;
  int secondPlayer;

  _GameDetailsScreenState(this.gameId, this.firstPlayer, this.secondPlayer);

  @override
  Widget build(BuildContext context) {
    CurrentUserSingleton currentUser = CurrentUserSingleton.instance;
    // GameModel game = ModalRoute.of(context)?.settings.arguments as GameModel;
    // List<dynamic> boardList = game.board[0] + game.board[1] + game.board[2];
    // int firstPlayerId = game.firstPlayer['id'];
    // int secondPlayerId = game.secondPlayer['id'] ?? 0;
    // GameDetailsArguments gameDetailsArguments =
    //     ModalRoute.of(context)?.settings.arguments as GameDetailsArguments;
    // int firstPlayer = ModalRoute.of(context)?.settings.arguments as int;
    // int secondPlayer = ModalRoute.of(context)?.settings.arguments as int;
    final gamesBloc = GamesBloc();
    final userBloc = UsersBloc();
    final userBloc2 = UsersBloc();

    // UserModel? firstPlayerModel;
    // UserModel? secondPlayerModel;

    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, GamesScreen.routeName);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Game $gameId'),
        ),
        // body: Text(game.id.toString()),
        body: BlocProvider(
          create: (context) => gamesBloc,
          child: BlocListener<GamesBloc, GamesState>(
            listener: (context, state) {
              // if (state is SuccessfulFirstPlayer) {
              //   firstPlayerModel = state.firstPlayer;
              // }
              // if (state is SuccessfulSecondPlayer) {
              //   secondPlayerModel = state.secondPlayer;
              // }
            },
            child: BlocBuilder<GamesBloc, GamesState>(
              builder: (context, state) {
                if (state is GamesInitial) {
                  // gamesBloc.add(FetchFirstPlayer(firstPlayer));
                  // gamesBloc.add(FetchSecondPlayer(secondPlayer));
                  gamesBloc.add(FetchCurrentGameDetails(gameId));
                  return const Text('initial');
                } else if (state is GamesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SuccessfulCurrentGameDetails) {
                  GameModel game = state.currentGameResponse;
                  List<dynamic> boardList =
                      game.board[0] + game.board[1] + game.board[2];
                  // int firstPlayerId = game.firstPlayer['id'];
                  // int secondPlayerId = game.secondPlayer['id'] ?? 0;
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
                              // (firstPlayerModel == null)
                              //     ? Text(firstPlayerModel!.username)
                              //     : Text('shiet'),

                              (firstPlayer != 0)
                                  ? BlocProvider(
                                      create: (context) => userBloc,
                                      child: BlocListener<UsersBloc,
                                              UsersState>(
                                          listener: (context, stateUser) {},
                                          child: BlocBuilder<UsersBloc,
                                                  UsersState>(
                                              builder: (context, stateUser) {
                                            if (stateUser is UsersInitial) {
                                              userBloc.add(FetchUserDetails(
                                                  firstPlayer));
                                            }
                                            if (stateUser
                                                is FetchUserDetailsSuccessful) {
                                              return Column(
                                                children: [
                                                  (game.status == 'finished' &&
                                                          stateUser.user.id ==
                                                              game.winner['id'])
                                                      ? FaIcon(FontAwesomeIcons
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
                                              );
                                            } else {
                                              return Container();
                                            }
                                          })))
                                  : Text('Waiting for first player'),
                              const Text(
                                'vs',
                                style: TextStyle(fontSize: 20),
                              ),
                              (secondPlayer != 0)
                                  ? BlocProvider(
                                      create: (context) => userBloc2,
                                      child: BlocListener<UsersBloc,
                                              UsersState>(
                                          listener: (context, stateUser2) {},
                                          child: BlocBuilder<UsersBloc,
                                                  UsersState>(
                                              builder: (context, stateUser2) {
                                            if (stateUser2 is UsersInitial) {
                                              userBloc2.add(FetchUserDetails2(
                                                  secondPlayer));
                                            }
                                            if (stateUser2
                                                is FetchUser2DetailsSuccessful) {
                                              return Column(
                                                children: [
                                                  (game.status == 'finished' &&
                                                          stateUser2.user2.id ==
                                                              game.winner['id'])
                                                      ? FaIcon(FontAwesomeIcons
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
                                              );
                                            } else {
                                              return Container();
                                            }
                                          })))
                                  : Text('Waiting for second player'),
                            ],
                          ),
                        ),
                        (firstPlayer == currentUser.id &&
                                numberOfMoves.length.isEven &&
                                game.status == 'progress')
                            ? Text('Your turn to play!')
                            : Container(),
                        (secondPlayer == currentUser.id &&
                                numberOfMoves.length.isOdd)
                            ? Text('Your turn to play!')
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
                                      )),
                                    );
                                  } else if (boardList[index] == secondPlayer) {
                                    return Container(
                                      color: Colors.white,
                                      child: const Center(
                                          child: Text(
                                        'O',
                                        style: TextStyle(fontSize: 35),
                                      )),
                                    );
                                  } else if (boardList[index] == null &&
                                      firstPlayer == state.currentPlayerId &&
                                      numberOfMoves.length.isEven) {
                                    return InkWell(
                                      onTap: () {
                                        Map<String, dynamic>
                                            paramsForRequestBody =
                                            getCoordinatesFromIndex(index);
                                        gamesBloc.add(MakeMoveEvent(
                                            gameId, paramsForRequestBody));
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
                                  gamesBloc.add(JoinGameEvent(
                                      state.currentGameResponse.id));
                                  ;
                                },
                                child: const Text('Join game'))
                            : Container(),
                        // Text(game.id.toString()),

                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Game info',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),

                        // Text('Game created by: ${game.firstPlayer['id']}'),
                        // (game.status == 'finished')
                        //     ? Text('Winner: ${game.winner['id']}')
                        //     : Container(),
                        Text('Game status: ${game.status}'),
                        Text(
                            'Created: ${DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.parse(game.created))}'),

                        // Text(boardList.toString()),
                      ],
                    ),
                  );
                } else if (state is ErrorGamesState) {
                  return Center(child: Text(state.gamesError));
                } else {
                  return CircularProgressIndicator();
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

    // print('row: ' + row.toString() + ' column: ' + column.toString());

    Map<String, dynamic> paramsForRequestBody = {"row": row, "col": column};

    return paramsForRequestBody;
  }
}
