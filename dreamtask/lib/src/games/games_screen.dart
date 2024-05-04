import 'package:dreamtask/src/games/bloc/games_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GamesScreen extends StatefulWidget {
  static const routeName = '/games';
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
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
                gamesBloc.add(FetchGamesEvent());
              },
              child: const Text('Create new game')),
          // Text('Token: ' + storage.read(key: 'token').toString())

          BlocProvider(
            create: (context) => gamesBloc,
            child: BlocListener<GamesBloc, GamesState>(
              listener: (context, state) {},
              child: BlocBuilder<GamesBloc, GamesState>(
                builder: (context, state) {
                  if (state is GamesInitial) {
                    return Text('initial');
                  }
                  if (state is GamesLoading) {
                    return CircularProgressIndicator();
                  }
                  if (state is SuccessfulGamesState) {
                    return Text(state.gamesResponse.toString());
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
