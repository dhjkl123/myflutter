import 'package:eyebody2/data/data.dart';
import 'package:eyebody2/style.dart';
import 'package:eyebody2/widget/Card.dart';
import 'package:flutter/material.dart';

Widget HomeWidget(
  DateTime date,
  List<Food> foods,
  List<Workout> workouts,
  List<Eyebody> bodies,
  Weight? weight,
) {
  return SingleChildScrollView(
    child: Column(
      children: [
        Row(
          children: [
            for (Food food in foods)
              Container(
                height: CardSize,
                width: CardSize,
                child: FoodCard(food: food),
              )
          ],
        ),
        Row(
          children: [
            for (int i = 0; i < 3; i++)
              Container(
                height: CardSize,
                width: CardSize,
                color: mainColor,
              )
          ],
        ),
        Row(
          children: [
            for (int i = 0; i < 3; i++)
              Container(
                height: CardSize,
                width: CardSize,
                color: mainColor,
              )
          ],
        ),
      ],
    ),
  );
}
