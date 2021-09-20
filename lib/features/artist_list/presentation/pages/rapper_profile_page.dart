import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bloc/rapper_bloc.dart';
import '../bloc/rapper_provider.dart';

/// A page containing the expanded profile of a rapper person.
class RapperProfilePage extends StatelessWidget {
  RapperProfilePage({required this.rapperId});

  static const routeName = '/profile';
  final String rapperId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LilRapApp: Profile'),
      ),
      body: RapperProvider(
        child: Builder(
          builder: (BuildContext innerContext) => buildProfile(innerContext),
        ),
      ),
    );
  }

  Widget buildProfile(BuildContext context) {
    RapperBloc bloc = RapperProvider.of(context).bloc;

    return StreamBuilder<RapperState>(
      stream: bloc.rapperState,
      builder: (context, snapshot) {
        RapperState? state = snapshot.data;

        if (state == null) return Center(child: Text("Something went wrong!"));

        if (state is Initial) {
          getRapperById(context, rapperId);
        }
        if (state is Error) {
          return Center(child: Text(state.message));
        } else if (state is Loading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is Loaded) {
          return Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: state.rapperList[0].image,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  SizedBox(
                    height: 16.0,
                  ),
                  Text('${state.rapperList[0].name}',
                      style:
                          const TextStyle(fontSize: 24, color: Colors.green)),
                  Divider(),
                  Text('${state.rapperList[0].description}',
                      // overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.blueGrey)),
                ],
              ));
        } else {
          return Center(child: Text('Nothing to see here!'));
        }
      },
    );
  }

  /// Send an event requesting the profile of a rapper individual.
  void getRapperById(BuildContext context, String id) {
    RapperProvider.of(context).bloc.rapperEvent.add(GetRapperEvent(id: id));
  }
}
