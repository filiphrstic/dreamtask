import 'package:dreamtask/src/game_details/game_details_screen.dart';
import 'package:dreamtask/src/game_details/game_details_arguments.dart';
import 'package:dreamtask/src/games/bloc/games_bloc.dart';
import 'package:dreamtask/src/games/game_model.dart';
import 'package:dreamtask/src/login/bloc/login_bloc.dart';
import 'package:dreamtask/src/login/login_screen.dart';
import 'package:dreamtask/src/users/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class GamesScreen extends StatefulWidget {
  static const routeName = '/games';
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  var selectedStatus = '';
  final gamesBloc = GamesBloc();
  final loginBloc = LoginBloc();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is SuccessfulLogoutState) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('You have logged out successfully!'),
            ));
            Navigator.popAndPushNamed(context, LoginScreen.routeName);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(title: const Text('Games'), actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                gamesBloc.add(FetchGamesEvent(''));
                selectedStatus = '';
              },
            ),
            IconButton(
                onPressed: () {
                  loginBloc.add(UserLogoutEvent());
                },
                icon: const Icon(Icons.logout))
          ]),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        gamesBloc.add(CreateNewGameEvent());
                        gamesBloc.add(FetchGamesEvent(''));
                      },
                      child: const Text('Create new game')),
                  BlocProvider(
                    create: (context) => gamesBloc,
                    child: BlocListener<GamesBloc, GamesState>(
                      listener: (context, state) {},
                      child: BlocBuilder<GamesBloc, GamesState>(
                        builder: (context, state) {
                          if (state is SuccessfulGamesState) {
                            return Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    children: [
                                      (state.gamesResponse.previous.isEmpty)
                                          ? Container()
                                          : ElevatedButton(
                                              onPressed: () {
                                                gamesBloc.add(FetchGamesEvent(
                                                    state.gamesResponse
                                                        .previous));
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
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Row(
                                    children: [
                                      Text(
                                          'Total results: ${state.gamesResponse.count}'),
                                      const Spacer(),
                                      DropdownButton(
                                        value: selectedStatus,
                                        items: const [
                                          DropdownMenuItem(
                                            value: '',
                                            child: Text('all'),
                                          ),
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
                            return const CircularProgressIndicator();
                          }
                          if (state is GamesLoading) {
                            return const CircularProgressIndicator();
                          }
                          if (state is SuccessfulGamesState) {
                            return GamesListWidget(
                              gamesList: state.gamesResponse.gamesList,
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
              BottomNavigationBarItem(
                  icon: Icon(Icons.gamepad), label: 'Games'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.format_list_numbered), label: 'Rank list')
            ],
          ),
        ),
      ),
    );
  }
}

class GamesListWidget extends StatelessWidget {
  final List<GameModel> gamesList;
  const GamesListWidget({super.key, required this.gamesList});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: gamesList.length,
        itemBuilder: (context, index) {
          return GameCard(
            game: gamesList[index],
          );
        },
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  final GameModel game;
  const GameCard({
    super.key,
    required this.game,
  });

  @override
  Widget build(BuildContext context) {
    CurrentUserSingleton currentUser = CurrentUserSingleton.instance;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          GameDetailsScreen.routeName,
          arguments: GameDetailsArguments(game.id, game.firstPlayer['id'] ?? 0,
              game.secondPlayer['id'] ?? 0),
        );
      },
      child: Padding(
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
                    'Game ${game.id}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Column(
                        children: [
                          (game.status == 'finished')
                              ? const FaIcon(
                                  FontAwesomeIcons.circleCheck,
                                  color: Colors.red,
                                )
                              : (game.status == 'progress')
                                  ? const FaIcon(
                                      FontAwesomeIcons.spinner,
                                      color: Colors.amber,
                                    )
                                  : (game.status == 'open')
                                      ? const FaIcon(
                                          FontAwesomeIcons.circle,
                                          color: Colors.green,
                                        )
                                      : Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(game.status),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        (currentUser.id == game.firstPlayer['id'])
                            ? const Text(
                                'You have created this game',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        (currentUser.id == game.secondPlayer['id'])
                            ? const Text(
                                'You are playing this game',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Container(),
                        Text(DateFormat('MM/dd/yyyy hh:mm a')
                            .format(
                              DateTime.parse(game.created),
                            )
                            .toString()),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
