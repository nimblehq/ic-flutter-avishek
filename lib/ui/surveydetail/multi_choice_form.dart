import 'package:flutter/material.dart';
import 'package:flutter_survey/theme/app_colors.dart';

import '../../gen/assets.gen.dart';

class MultiChoiceForm extends StatefulWidget {
  final List<Item> items;
  final ValueChanged<List<Item>> onChanged;

  const MultiChoiceForm(
      {super.key, required this.items, required this.onChanged});

  @override
  MultiChoiceFormState createState() => MultiChoiceFormState();
}

class MultiChoiceFormState extends State<MultiChoiceForm> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        return Container(
          child: _buildItem(index, context),
        );
      },
      separatorBuilder: (_, __) => const Divider(
        color: Colors.white,
        height: 0.5,
      ),
    );
  }

  Widget _buildItem(int index, BuildContext context) {
    var textStyle =
        Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 20);
    return GestureDetector(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.items[index].label,
                style: widget.items[index].isChecked
                    ? textStyle
                    : textStyle.copyWith(color: AppColors.whiteAlpha50),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: widget.items[index].isChecked
                    ? Assets.icons.icChecked.svg()
                    : Assets.icons.icUnchecked.svg()),
          ],
        ),
        onTap: () {
          setState(() {
            widget.items[index].isChecked = !widget.items[index].isChecked;
          });
          widget.onChanged(
              widget.items.where((element) => element.isChecked).toList());
        });
  }
}

class Item {
  final String id;
  final String label;
  bool isChecked = false;

  Item(this.id, this.label);

  @override
  String toString() {
    return label;
  }
}
