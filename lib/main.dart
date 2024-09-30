import 'package:flutter/material.dart';
import 'package:srvc/Auth/AuthController.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Models/Family.dart';
import 'package:srvc/Services/IndexProvider.dart';
import 'package:srvc/Services/auth_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => IndexProvider()),
        ChangeNotifierProvider(create: (_) => FamilyModel()),
      ],
      child: const MyApp(),
    ),
  );
}

// test add new line
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Authcontroller(),
    );
  }
}

// class KeyboardPage extends StatefulWidget {
//   @override
//   _KeyboardPageState createState() => _KeyboardPageState();
// }

// class _KeyboardPageState extends State<KeyboardPage> {
//   final TextEditingController _controller = TextEditingController();

//   void _onKeyPress(String key) {
//     _controller.text += key;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Custom Keyboard')),
//       body: Column(
//         children: [
//           TextField(
//             controller: _controller,
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               hintText: 'Type here...',
//             ),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     _buildKey("ฉัน", buttonStyle: _cardStyle),
//                     _buildKey("input", width: 3),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     _buildKey("1"),
//                     _buildKey("2"),
//                     _buildKey("3"),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     _buildKey("4"),
//                     _buildKey("5"),
//                     _buildKey("6"),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     _buildKey("7"),
//                     _buildKey("8"),
//                     _buildKey("9"),
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     _buildKey("."),
//                     _buildKey("0"),
//                     _buildKey("X"),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildKey(String key, {double width = 1, ButtonStyle? buttonStyle}) {
//     return Expanded(
//       flex: width.toInt(),
//       child: GestureDetector(
//         onTap: () => _onKeyPress(key),
//         child: Container(
//           margin: EdgeInsets.all(4),
//           child: ElevatedButton(
//             style: buttonStyle ?? _defaultButtonStyle, // Use provided style or default
//             onPressed: () => _onKeyPress(key),
//             child: Text(
//               key,
//               style: TextStyle(fontSize: 24),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   final ButtonStyle _cardStyle = ElevatedButton.styleFrom(
//     foregroundColor: Colors.white,
//     backgroundColor: Colors.indigo,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(5),
//     ),
//     elevation: 5,
//   );

//   final ButtonStyle _inputStyle = ElevatedButton.styleFrom(
//     foregroundColor: Colors.white, backgroundColor: Colors.orange,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//     elevation: 5, // Elevation
//   );
//   final ButtonStyle _defaultButtonStyle = ElevatedButton.styleFrom(
//     foregroundColor: Colors.white,
//     backgroundColor: Colors.blueAccent,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(8),
//     ),
//     elevation: 5,
//   );
// }
