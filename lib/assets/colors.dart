import 'dart:ui';


//Base
final Color appBlue = HexColor.fromHex("84D4FF");
final Color appPink = HexColor.fromHex("DC8BFC");

//1
//final Color appPink = HexColor.fromHex("805D93"); // Foncée
//final Color appBlue = HexColor.fromHex("FFD3BA"); // Clair

//2
//final Color appPink = HexColor.fromHex("8D6B94"); // Foncée
//final Color appBlue = HexColor.fromHex("C3A29E"); // Clair

//3
//final Color appPink = HexColor.fromHex("7A7265");
//final Color appBlue = HexColor.fromHex("C0B7B1");

//4
//final Color appPink = HexColor.fromHex("DE6E4B");
//final Color appBlue = HexColor.fromHex("C5D8D1");

//5
//final Color appPink = HexColor.fromHex("C94277");
//final Color appBlue = HexColor.fromHex("CADBC0");




extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}