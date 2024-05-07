import 'package:dreamtask/src/games/bloc/games_bloc.dart';
import 'package:dreamtask/src/games/game_model.dart';
import 'package:dreamtask/src/games/games_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class GameDetailsScreen extends StatefulWidget {
  static const routeName = '/game_details';

  const GameDetailsScreen({super.key});

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    // GameModel game = ModalRoute.of(context)?.settings.arguments as GameModel;
    // List<dynamic> boardList = game.board[0] + game.board[1] + game.board[2];
    // int firstPlayerId = game.firstPlayer['id'];
    // int secondPlayerId = game.secondPlayer['id'] ?? 0;
    int gameId = ModalRoute.of(context)?.settings.arguments as int;
    final gamesBloc = GamesBloc();

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
            listener: (context, state) {},
            child: BlocBuilder<GamesBloc, GamesState>(
              builder: (context, state) {
                if (state is GamesInitial) {
                  gamesBloc.add(FetchCurrentGameDetails(gameId));
                  return const Text('initial');
                } else if (state is GamesLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SuccessfulCurrentGameDetails) {
                  GameModel game = state.currentGameResponse;
                  List<dynamic> boardList =
                      game.board[0] + game.board[1] + game.board[2];
                  int firstPlayerId = game.firstPlayer['id'];
                  int secondPlayerId = game.secondPlayer['id'] ?? 0;
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
                              Text(
                                game.firstPlayer['id'].toString(),
                                style: const TextStyle(fontSize: 25),
                              ),
                              const Text(
                                'vs',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(game.secondPlayer['id'].toString(),
                                  style: const TextStyle(fontSize: 25)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
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
                                  if (boardList[index] == firstPlayerId) {
                                    return Container(
                                      color: Colors.white,
                                      child: const Center(
                                          child: Text(
                                        'X',
                                        style: TextStyle(fontSize: 35),
                                      )),
                                    );
                                  } else if (boardList[index] ==
                                      secondPlayerId) {
                                    return Container(
                                      color: Colors.white,
                                      child: const Center(
                                          child: Text(
                                        'O',
                                        style: TextStyle(fontSize: 35),
                                      )),
                                    );
                                  } else if (boardList[index] == null &&
                                      firstPlayerId == state.currentPlayerId &&
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
                                        color: Colors.green,
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
                          height: 50,
                        ),
                        (state.currentGameResponse.status == "open" &&
                                state.currentGameResponse.firstPlayer['id'] !=
                                    state.currentPlayerId)
                            ? ElevatedButton(
                                onPressed: () {
                                  gamesBloc.add(JoinGameEvent(
                                      state.currentGameResponse.id));
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

                        Text('Game created by: ${game.firstPlayer['id']}'),
                        (game.status == 'finished')
                            ? Text('Winner: ${game.winner['id']}')
                            : Container(),
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
                  return const Text('Unhandled state');
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
