import 'package:flutter/material.dart';

import 'package:get/get.dart';

class GridContainer extends StatelessWidget {
  final Color color;
  final bool? isSmall;
  final IconData icon;
  final String taskGroup;
  final String taskCount;
  final String page;

  const GridContainer({
    Key? key,
    required this.color,
    this.isSmall = false,
    required this.icon,
    required this.taskGroup,
    required this.taskCount,
    required this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      surfaceTintColor: Colors.amber,
      clipBehavior: Clip.antiAlias,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => Get.toNamed(page),
        onLongPress: () {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
              Align(
                alignment: isSmall! ? Alignment.centerLeft : Alignment.center,
                child: Icon(
                  icon,
                  size: isSmall! ? 60 : 120,
                  color: Colors.brown,
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    taskGroup,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
