part of event_calendar;

class _ColorPicker extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ColorPickerState();
  }
}

class _ColorPickerState extends State<_ColorPicker> {
  Color currentColor = Colors.amber;
  List<Color> currentColors = [Colors.yellow, Colors.green];
  List<Color> colorHistory = [];

  void changeColor(Color color) => setState(() {
        currentColor = color;
        _selectedColorIndex = color;
        Future.delayed(const Duration(milliseconds: 20), () {
          // When task is over, close the dialog
          Navigator.pop(context);
        });
      });
  void changeColors(List<Color> colors) =>
      setState(() => currentColors = colors);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
          color: Colors.white,
          width: double.maxFinite,
          child: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
          )),
    );
  }
}
