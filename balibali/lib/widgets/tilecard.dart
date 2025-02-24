// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class TileCard extends StatefulWidget {
  final Text vocaKr;
  final Text vocaCn;
  final bool isMemorized;
  final Text? vocaExp;
  final Checkbox checkbox;
  final Function inkWellOnPressed;
  final bool isExpanded;

  const TileCard({
    Key? key,
    required this.vocaKr,
    required this.vocaCn,
    required this.isMemorized,
    required this.checkbox,
    required this.inkWellOnPressed,
    required this.isExpanded,
    this.vocaExp,
  }) : super(key: key);

  @override
  State<TileCard> createState() => _TileCardState();
}

class _TileCardState extends State<TileCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular((12)))),
          child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            onTap: () {
              widget.inkWellOnPressed();
              print(widget.isExpanded);
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: widget.vocaKr,
                        flex: 5,
                      ),
                      Expanded(child: widget.vocaCn, flex: 5),
                      Expanded(child: widget.checkbox)
                    ],
                  ),
                ),
                if (widget.vocaExp != null && widget.isExpanded)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Divider(
                      height: 0,
                      thickness: 2,
                    ),
                  ),
                if (widget.vocaExp != null && widget.isExpanded)
                  Padding(
                    //EXP 칸
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Container(
                        child: widget.vocaExp, alignment: Alignment.topLeft),
                  )
              ],
              mainAxisSize: MainAxisSize.min,
            ),
          ),
        ),
        if (widget.vocaExp != null)
          Positioned(
            //화살표 아이콘 칸
            top: 0,
            right: 3,
            child: widget.isExpanded
                ? const Icon(
                    Icons.expand_less,
                    size: 24,
                  )
                : const Icon(
                    Icons.expand_more,
                    size: 24,
                  ),
          ),
      ],
    );
  }
}
