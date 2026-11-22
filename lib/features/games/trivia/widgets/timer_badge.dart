import 'package:flutter/material.dart';

import 'package:ovinapp/core/theme/theme.dart';

/// Indicador circular del tiempo restante por pregunta.
class TimerBadge extends StatelessWidget {
  final int secondsLeft;
  final int totalSeconds;
  final bool danger;

  const TimerBadge({
    super.key,
    required this.secondsLeft,
    required this.totalSeconds,
    required this.danger,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.wrongBorder : AppColors.illInk;

    return SizedBox(
      width: 44,
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              value: secondsLeft / totalSeconds,
              strokeWidth: 5,
              backgroundColor: AppColors.inkTrack,
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          Text(
            '$secondsLeft',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}

