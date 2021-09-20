import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/rapper.dart';
import '../bloc/rapper_bloc.dart';
import 'rapper_profile_page.dart';

/// A page containing a list of rapper people.
class RapperListPage extends StatelessWidget {
  static const routeName = '/list';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LilRapApp: List'),
      ),
      body: buildList(context),
    );
  }

  BlocProvider<RapperBloc> buildList(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RapperBloc>(),
      child: BlocBuilder<RapperBloc, RapperState>(
        builder: (context, state) {
          if (state is Initial) {
            refreshList(context);
          }
          if (state is Error) {
            return Center(child: Text(state.message));
          } else if (state is Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is Loaded) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    onSubmitted: (value) {
                      filterList(context, value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Type an artists name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(8.0),
                    shrinkWrap: true,
                    children: <Widget>[
                      ...[
                        for (Rapper rapper in state.rapperList)
                          Card(
                            key: UniqueKey(),
                            child: ListTile(
                              leading: CachedNetworkImage(
                                imageUrl: rapper.image,
                                imageBuilder: (context, imageProvider) =>
                                    CircleAvatar(
                                  backgroundImage: imageProvider,
                                ),
                                placeholder: (context, url) =>
                                    CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              title: Text('${rapper.name}',
                                  style: const TextStyle(
                                      fontSize: 24, color: Colors.green)),
                              subtitle: Text('${rapper.description}',
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      const TextStyle(color: Colors.blueGrey)),
                              trailing: Icon(Icons.arrow_forward),
                              onTap: () {
                                Navigator.pushNamed(
                                    context, RapperProfilePage.routeName,
                                    arguments: rapper.id);
                              },
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('Nothing to see here!'));
          }
        },
      ),
    );
  }

  /// Send an event requesting a fresh list of rapper people.
  void refreshList(BuildContext context) {
    BlocProvider.of<RapperBloc>(context).add(GetRapperListEvent());
  }

  /// Send an event requesting a filtered list of rapper people.
  void filterList(BuildContext context, String expression) {
    BlocProvider.of<RapperBloc>(context)
        .add(GetFilteredRapperListEvent(expression: expression));
  }
}
