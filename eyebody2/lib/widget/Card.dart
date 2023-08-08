import 'package:eyebody2/data/data.dart';
import 'package:eyebody2/style.dart';
import 'package:eyebody2/utils.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.food});

  final Food food;

  String timetoString() {
    String _t = food.time.toString();

    String _m = _t.substring(_t.length - 2);
    String _h = _t.substring(0, _t.length - 2);

    TimeOfDay time = TimeOfDay(hour: int.parse(_h), minute: int.parse(_m));
    return "${time.hour > 11 ? "오후" : "오전"}${Utils.makeTwoDigit(time.hour % 12)}:${Utils.makeTwoDigit(time.minute)}";
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: [
          Positioned(
            child: Image.asset("assets/img/food.png"),
          ),
          Positioned(
            child: Container(
              color: Colors.black12,
            ),
          ),
          Positioned(
            child: Text(
              timetoString(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            right: 6,
            bottom: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                mealTime[food.meal!],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  const WorkoutCard({super.key, required this.workout});

  final Workout workout;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AspectRatio(
        aspectRatio: 1,
        child: Column(children: [
          Row(
            children: [
              Container(
                child: Image.asset("assets/img/${workout.type}.png"),
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                    color: iBgColor, borderRadius: BorderRadius.circular(70)),
              ),
              Expanded(
                child: Text(
                  "${Utils.makeTwoDigit(workout.time! ~/ 60)}:"
                  "${Utils.makeTwoDigit(workout.time! % 60)}:",
                  textAlign: TextAlign.end,
                ),
              ),
              Expanded(child: Text(workout.name!)),
              Text(workout.calorie == 0 ? "" : "${workout.calorie}kcal"),
              Text(workout.distance == 0 ? "" : "${workout.distance}km"),
            ],
          )
        ]),
      ),
    );
  }
}
