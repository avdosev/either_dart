import 'package:flutter/material.dart';
import 'package:either_dart/either.dart';

class Data {
  final String data;
  Data(this.data);
}

class ServerError {
  final String message;
  ServerError(this.message);
}

class Client {
  bool firstRequest = true;

  Future<Either<ServerError, Data>> getDataFromServer() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!firstRequest) {
      return Right(Data("other string"));
    } else {
      firstRequest = false;
      return Left(ServerError("loss connection"));
    }
  }

}

class WidgetReceivingData extends StatefulWidget {
  @override
  createState() => _WidgetReceivingDataState();
}

class _WidgetReceivingDataState extends State<WidgetReceivingData>  {
  final Client apiClient = Client();
  Future<Either<ServerError, Data>> _load;

  @override
  void initState() {
    super.initState();
    _load = apiClient.getDataFromServer();
  }

  void reloadServerData() {
    setState(() {
      _load = apiClient.getDataFromServer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Either<ServerError, Data>>(
        future: _load,
        builder: (context, snapshot) {
          return Center(
            // Error in future not handling
            child: snapshot.hasData && snapshot.connectionState != ConnectionState.waiting ?
              snapshot.data.unite<Widget>(
                (err) => ServerErrorWidget(err, onReload: reloadServerData),
                (data) => DataWidget(data)
              ) :
              CircularProgressIndicator()
          );
        }
      )
    );
  }
}

class DataWidget extends StatelessWidget {
  final Data _data;
  const DataWidget(this._data);

  @override
  Widget build(BuildContext context) {
    return Text("Data: ${_data.data}");
  }

}

class ServerErrorWidget extends StatelessWidget {
  final ServerError _error;
  final VoidCallback onReload;
  const ServerErrorWidget(this._error, {this.onReload});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
       children: [
         Text("Error: ${_error.message}"),
         SizedBox(height: 20),
         FlatButton(
           onPressed: onReload,
           child: Text("Try reload"),
         )
       ]
    );
  }

}

main() => runApp(
    MaterialApp(
      home: WidgetReceivingData(),
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    )
);
