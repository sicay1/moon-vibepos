import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// A centered-logo AppBar for the main tab screens.
///
/// The logo is rendered in [flexibleSpace] so it is always truly centered
/// regardless of the number of trailing [actions]. The toolbar area is
/// determined by [kToolbarHeight]; an optional [bottom] (e.g. a TabBar) is
/// rendered by the underlying AppBar unchanged below the logo bar.
class MoonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final List<Widget> actions;
  final PreferredSizeWidget? bottom;

  const MoonAppBar({super.key, this.leading, this.actions = const [], this.bottom});

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      scrolledUnderElevation: 1,
      shadowColor: AppColors.shadow,
      actions: actions,
      bottom: bottom,
      toolbarHeight: 32,
      centerTitle: true,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: SizedBox(
          height: kToolbarHeight,
          child: Image.asset(
            'assets/images/logo_only.jpg',
            height: 48,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
