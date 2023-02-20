import '../../const/const.dart';
import 'test_style.dart';

Widget customTextField({
  label,
  hint,
  controller,
  isDesc = false,
  onchange,
}) {
  return TextFormField(
    validator: (value) {
      if (value!.isEmpty) {
        return '*Required';
      } else {
        return null;
      }
    },
    autofocus: true,
    autocorrect: true,
    textInputAction: TextInputAction.next,
    onChanged: onchange,
    style: const TextStyle(color: white),
    controller: controller,
    maxLines: isDesc ? 4 : 1,
    decoration: InputDecoration(
      isDense: true,
      label: normalText(text: label),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: white),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: white),
      ),
      hintText: hint,
      hintStyle: const TextStyle(color: lightGrey),
    ),
  );
}
