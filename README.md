
A simple friendly network state handler to handle states of a request as it's in a initial, loading, loaded or an error. You can use it with any of your favourite package either it's http or dio.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

# 🎖 Installing

1) First goto your pubspec.yaml file and add dependency:
   ```
   network_state_handler: ^0.0.1
   ```
2) run flutter pub get to update the packages dependencies.



# ⚡️ Import
3) In your code, you can use it like this:
  first import the package:
  ```
 import 'package:network_state_handler/network_state_handler.dart'


# 🎮 Code Usage
 How to use it? It's friendly and easy to work with network_state_handler, checkout inside example folder to understand how it works. 

```dart

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
        primarySwatch: Colors.blue,
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

```
# FOR MORE EXAMPLES REFER TO example/lib folder.

# 🐛 Bugs/Requests
If you encounter any problems feel free to open an issue. If you feel the library is
missing some feature, please raise a ticket on Github. Pull request are also welcome.

# 🚀 SUPPORT
You liked this package? then give it a star. If you want to help then:
Star this repository.
Send a Pull Request with new features, see Contribution Guidelines.
Share this package.
Create issues if you find a Bug or want to suggest something.
