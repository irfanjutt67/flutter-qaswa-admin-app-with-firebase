import '../../const/const.dart';
import 'test_style.dart';

Widget ourButton({title, color = purpleColor, onPress}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      // ignore: deprecated_member_use
      primary: color,
      padding: const EdgeInsets.all(12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    onPressed: onPress,
    child: normalText(
      text: title,
      size: 16.0,
    ),
  );
}
