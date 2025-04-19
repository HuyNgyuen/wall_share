import 'package:flutter/material.dart';
import 'package:wall_share/home_screen_widgets/user_info_data.dart';

class HomeAppbar extends StatelessWidget {
  const HomeAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: Row(
        children: [
          Text('WallShare', style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          const UserInfoData(),
        ],
      ),
    );
  }
}
