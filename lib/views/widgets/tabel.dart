import '../../const/const.dart';

TableRow buildRow({id, text, icon, onPress, icon1, onPress1}) {
  return TableRow(children: [
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(id).text.white.makeCentered(),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text).text.white.makeCentered(),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(icon, color: white)
              .box
              .color(red)
              .shadow
              .roundedSM
              .padding(const EdgeInsets.all(2))
              .make()
              .paddingAll(2)
              .onTap(onPress),
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(icon1, color: white)
              .box
              .color(red)
              .shadow
              .roundedSM
              .padding(const EdgeInsets.all(2))
              .make()
              .paddingAll(2)
              .onTap(onPress1),
        ),
      ],
    ),
  ]);
}
