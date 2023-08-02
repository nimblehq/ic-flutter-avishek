import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/utils/extension/date_time_ext.dart';

import '../home/home_screen.dart';
import '../home/user_ui_model.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          DateTime.now().toFormattedFullDayMonthYear().toUpperCase(),
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 5.0),
        Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.today,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            GestureDetector(
              key: HomeScreenKey.ivAvatar,
              onTap: () => Scaffold.of(context).openEndDrawer(),
              child: Consumer(
                builder: (BuildContext _, WidgetRef widgetRef, __) {
                  // TODO: use real value in the integrate task.
                  final user = UserUiModel(
                    id: "1234",
                    email: "email@example.com",
                    name: "John Doe",
                    avatarUrl: "https://i.pravatar.cc/450",
                  );
                  return CachedNetworkImage(
                    imageUrl: user.avatarUrl,
                    imageBuilder: (_, imageProvider) => Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
