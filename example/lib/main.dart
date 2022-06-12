import 'package:flutter/material.dart';
import 'package:network_state_handler/network_state_handler.dart';
import 'package:networking_freezed_dio/repos/api_repo.dart';
import 'model/list_user_response.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ListUser(),
    );
  }
}

class ListUser extends StatefulWidget {
  const ListUser({Key? key}) : super(key: key);

  @override
  _ListUserState createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  final APIRepository _apiRepository = APIRepository();
  ResultState<ListUserResponse> state = const ResultState.loading();
  ResultState<bool> boolstate = const ResultState.loading();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  Future getUsers() async {
    ApiResult<ListUserResponse> apiResult =
        await _apiRepository.fetchListOfUser();

    apiResult.when(success: (ListUserResponse? user) {
      setState(() {
        state = ResultState.data(data: user);
      });
    }, failure: (NetworkExceptions? error) {
      print(error.toString());
      setState(() {
        state = ResultState.error(error: error);
      });
    });
    return state;
  }

  Future deleteUser(int userId) async {
    ApiResult<bool> apiResult = await _apiRepository.deleteUser(userId);

    apiResult.when(success: (bool? user) {
      setState(() {
        boolstate = ResultState.data(data: user);
      });
    }, failure: (NetworkExceptions? error) {
      print(error.toString());
      setState(() {
        boolstate = ResultState.error(error: error);
      });
    });
    return state;
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: SafeArea(
        child: state.when(
            idle: () => Container(),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            data: (ListUserResponse? data) {
              return data!.user!.isEmpty
                  ? const Center(
                      child: Text(
                        "No Data found",
                      ),
                    )
                  : ListView.separated(
                      itemCount: data.user!.length,
                      separatorBuilder: (_, __) => const Divider(),
                      itemBuilder: (ctx, index) => Dismissible(
                        key: ValueKey(data.user![index].id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            // dismissed to the left
                            await deleteUser(data.user![index].id!);
                            data.user!.removeAt(index);
                            SnackBar snackBar = const SnackBar(
                              content: Text('Deleted Successfully'),
                            );
                            _scaffoldkey.currentState?.showSnackBar(snackBar);
                          }
                        },
                        direction: DismissDirection.startToEnd,
                        child: ListTile(
                            title: Text(data.user![index].first_name ?? ""),
                            subtitle: Text(data.user![index].email ?? ""),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                data.user![index].avatar ?? "",
                              ),
                              radius: 30,
                            )),
                      ),
                    );
            },
            error: (NetworkExceptions? error) {
              return Text(NetworkExceptions.getErrorMessage(error!));
            }),
      ),
    );
  }
}
