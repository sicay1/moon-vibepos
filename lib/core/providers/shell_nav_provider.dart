import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShellNavState {
  final bool showDashboard;
  final bool showSettings;
  const ShellNavState({this.showDashboard = false, this.showSettings = false});
}

class ShellNavNotifier extends StateNotifier<ShellNavState> {
  ShellNavNotifier() : super(const ShellNavState());

  void toggleDashboard() => state = ShellNavState(
        showDashboard: !state.showDashboard,
        showSettings: false,
      );

  void toggleSettings() => state = ShellNavState(
        showSettings: !state.showSettings,
        showDashboard: false,
      );

  void close() => state = const ShellNavState();
}

final shellNavProvider =
    StateNotifierProvider<ShellNavNotifier, ShellNavState>(
  (ref) => ShellNavNotifier(),
);
