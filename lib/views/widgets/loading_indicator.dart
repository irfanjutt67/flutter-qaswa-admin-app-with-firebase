import '../../const/const.dart';

Widget loadingIndicator({circleColor = purpleColor}) {
  return Center(
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(circleColor),
    ),
  );
}
