import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_survey/ui/home/user_ui_model.dart';

import '../../theme/app_colors.dart';

const double _drawerWidthFactor = 240.0 / 376.0;

class HomeDrawer extends StatelessWidget {
  const HomeDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: AppColors.nero90,
      ),
      child: FractionallySizedBox(
        widthFactor: _drawerWidthFactor,
        child: Drawer(
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(
                top: 50.0,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _bindUserInfo(context),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                  ),
                  const SizedBox(
                    height: 35.0,
                  ),
                  _bindMenu(context),
                  const Expanded(child: SizedBox.shrink()),
                  _buildVersionInfo(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bindUserInfo(BuildContext context) {
    return Consumer(
      builder: (BuildContext _, WidgetRef widgetRef, __) {
        // TODO: replace in integrate task.
        final user = UserUiModel(
          id: "1234",
          email: "email@example.com",
          name: "John Doe",
          avatarUrl: "https://i.pravatar.cc/450",
        );
        return Row(
          children: [
            Expanded(
              child: Text(
                user.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            CachedNetworkImage(
              imageUrl: user.avatarUrl,
              imageBuilder: (_, imageProvider) => Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image:
                      DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _bindMenu(BuildContext context) {
    return Consumer(
      builder: (BuildContext _, WidgetRef widgetRef, __) {
        return GestureDetector(
          onTap: () => {
            // TODO: log out.
          },
          child: Text(
            AppLocalizations.of(context)!.logout,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 20.0,
                ),
          ),
        );
      },
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Consumer(
      builder: (BuildContext _, WidgetRef widgetRef, __) {
        // TODO: replace with real version number in the integrate task.
        const versionInfo = "v0.1.0 (1562903885)";
        return Text(
          versionInfo,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11.0,
              ),
        );
      },
    );
  }
}
