import 'package:flutter/widgets.dart';

import 'adsCubit.dart';


class AdNavigatorObserver extends NavigatorObserver {
  final AdCubit adCubit;
  AdNavigatorObserver(this.adCubit);

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
  }
}
