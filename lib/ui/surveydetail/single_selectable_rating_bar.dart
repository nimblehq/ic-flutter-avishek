import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedIndexProvider = StateProvider.autoDispose<int>((_) => -1);

class SingleSelectableRatingBar extends ConsumerWidget {
  final List<Widget> selectedItems;
  final List<Widget> unselectedItems;
  final Function onRate;

  const SingleSelectableRatingBar({
    super.key,
    required this.selectedItems,
    required this.unselectedItems,
    required this.onRate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 100,
      alignment: Alignment.center,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: min(selectedItems.length, unselectedItems.length),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => onItemTapped(ref, index),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Consumer(
                  builder: (context, widgetRef, _) {
                    final selectedIndex = ref.watch(selectedIndexProvider);
                    return index == selectedIndex
                        ? selectedItems[index]
                        : unselectedItems[index];
                  },
                ),
              ),
            );
          }),
    );
  }

  void onItemTapped(WidgetRef ref, int selectedIndex) {
    final lastSelectedIndex = ref.read(selectedIndexProvider.notifier);
    if (lastSelectedIndex.state == selectedIndex) return;
    lastSelectedIndex.state = selectedIndex;
    onRate(selectedIndex + 1);
  }
}
