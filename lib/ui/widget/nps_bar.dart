import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NpsBar extends StatefulWidget {
  const NpsBar({
    super.key,
    required this.items,
    required this.onRatingUpdate,
    this.initialRating = 0,
    this.minRating = 0,
  });

  final ValueChanged<int> onRatingUpdate;
  final List<String> items;
  final int initialRating;
  final int minRating;

  @override
  NpsBarState createState() => NpsBarState();
}

class NpsBarState extends State<NpsBar> {
  int _rating = 0;
  late final ValueNotifier<bool> _glow;

  @override
  void initState() {
    super.initState();
    _glow = ValueNotifier(false);
    _rating = widget.initialRating;
  }

  @override
  void didUpdateWidget(NpsBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _rating = widget.initialRating;
    }
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxRating = widget.items.length;
    return Material(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 1,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Wrap(
              alignment: WrapAlignment.start,
              children: List.generate(
                widget.items.length,
                (index) => _buildRating(context, index),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.npsNotAtAllLikely,
                style: TextStyle(
                    color: (_rating <= (maxRating / 2))
                        ? Colors.white
                        : Colors.white54),
              ),
              const Expanded(
                child: SizedBox.shrink(),
              ),
              Text(
                AppLocalizations.of(context)!.npsExtremelyLikely,
                style: TextStyle(
                    color: (_rating > (maxRating / 2))
                        ? Colors.white
                        : Colors.white54),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRating(BuildContext context, int index) {
    final text = widget.items[index];
    Widget ratingWidget;
    ratingWidget = Container(
      width: 30,
      height: 50,
      decoration: (index < widget.items.length - 1)
          ? const BoxDecoration(
              border: Border(
                  right: BorderSide(
                color: Colors.white,
                width: 1,
              )),
            )
          : null,
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              color: (index > _rating) ? Colors.white54 : Colors.white),
        ),
      ),
    );

    return GestureDetector(
      onTapDown: (details) {
        int value = index;
        value = math.max(value, widget.minRating);
        widget.onRatingUpdate(value);
        _rating = value;
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.zero,
        child: ValueListenableBuilder<bool>(
          valueListenable: _glow,
          builder: (context, glow, child) {
            if (glow) {
              final glowColor = Theme.of(context).colorScheme.secondary;
              return DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withAlpha(30),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: glowColor.withAlpha(20),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: child,
              );
            }
            return child!;
          },
          child: ratingWidget,
        ),
      ),
    );
  }
}
