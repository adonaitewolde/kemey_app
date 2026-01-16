import 'package:flutter/material.dart';
import 'package:kemey_app/models/learning_path.dart';
import 'package:kemey_app/theme/app_theme.dart';

class CurrentUnitHeader extends StatelessWidget {
  const CurrentUnitHeader({super.key, required this.unit});

  final Unit unit;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Material(
        color: AppColors.primaryOrange,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              unit.title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}
