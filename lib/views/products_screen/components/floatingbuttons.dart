import '../../../const/const.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

SpeedDialChild speedDialChild({icon, label, onPress}) {
  return SpeedDialChild(
    //speed dial child
    child: Icon(icon),
    backgroundColor: Colors.red,
    foregroundColor: Colors.white,
    label: label,
    labelStyle: const TextStyle(fontSize: 18.0),
    onTap: onPress,
  );
}
