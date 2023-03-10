import 'package:flutter/material.dart';

class ActiveExerciseRow {

  static const double SPACER_SIZE = 10;

  static Row build({
    required Widget set,
    required Widget previous,
    required Widget option1,
    Widget? option2,
    Widget? rpe,
    Widget? checkbox,
  }) {
    return Row(
      children: [

        const SizedBox(width: SPACER_SIZE),

        Container(width: 35, alignment: Alignment.center, child: set),

        const SizedBox(width: SPACER_SIZE),

        Container(width: 90, alignment: Alignment.center, child: previous),

        const SizedBox(width: SPACER_SIZE),

        Expanded(child: Container(alignment: Alignment.center, child: option1)),

        if(option2 != null) ...[
          const SizedBox(width: SPACER_SIZE),
          Expanded(child: Container(alignment: Alignment.center, child: option2))
        ],

        if(rpe != null) ...[
          const SizedBox(width: SPACER_SIZE),
          Expanded(child: Container(alignment: Alignment.center, child: rpe))
        ],

        if(checkbox != null) ...[
          const SizedBox(width: SPACER_SIZE),
          SizedBox(width: 46, child: checkbox),
          const SizedBox(width: SPACER_SIZE)
        ] else const SizedBox(width: SPACER_SIZE),
      ],
    );
  }
}
