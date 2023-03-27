import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller/cart_provider.dart';
import 'core/sql_server.dart';
import 'modules/screens/product_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return ChangeNotifierProvider(
      create: (_) => CartProvider()..getCounter(),
      child: Builder(
        builder: (BuildContext context) {
          return MaterialApp(
            title: 'Shopping Cart',
            theme: ThemeData(
              appBarTheme:const AppBarTheme(
                elevation: 0.0,
              ),
              primarySwatch: Colors.green
            ),
            debugShowCheckedModeBanner: false,
            home:const ProductScreen(),
          );
        },
      ),
    );
  }
}