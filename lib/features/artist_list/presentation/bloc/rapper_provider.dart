import 'package:flutter/cupertino.dart';

import '../../../../injection_container.dart';
import 'rapper_bloc.dart';

/// Provides a bloc for accessing rapper data.
class RapperProvider extends InheritedWidget {
  RapperProvider({
    Key? key,
    RapperBloc? rapperBloc,
    required Widget child,
  })  : this.bloc = rapperBloc ?? getIt<RapperBloc>(),
        super(key: key, child: child);

  final RapperBloc bloc;

  static RapperProvider of(BuildContext context) {
    final RapperProvider? result =
        context.dependOnInheritedWidgetOfExactType<RapperProvider>();
    assert(result != null, 'No RapperProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(RapperProvider old) => bloc != old.bloc;
}
