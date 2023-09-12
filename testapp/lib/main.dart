import 'package:flutter/material.dart';
import 'package:dynamiclist/dynamiclist.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
   int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:const listPage(EntityTypeId: 10404),         bottomNavigationBar: BottomNavigationBar(
          onTap: (Index) {
           setState(() {
              myIndex = Index;
           });
          },
          currentIndex: myIndex,
          items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home,color:Colors.green),
            label: 'Home',
            ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list,color:Colors.green),
            label: 'Agent',
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.list,color:Colors.green),
            label: 'Individual Ticket',
            ),
         ]),
    );
  }
}
