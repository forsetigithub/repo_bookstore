import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:repo_bookstore/controllers/home.dart';

import 'models/book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Repo Book Store'),
        ),
        body: MyHomePage(),
      )
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  final HomeController _homeController = HomeController();

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _Form(widget._homeController, _refreshList),
        _BookTable(widget._homeController, _refreshList)
      ]);
  }
}

class _Form extends StatefulWidget {
  final HomeController _homeController;
  final VoidCallback _refreshList;

  const _Form(this._homeController,this._refreshList);

  @override
  _FormState createState() => _FormState();
}

class _FormState extends State<_Form> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleFieldController = TextEditingController();
  final TextEditingController _yearFieldController = TextEditingController();

  @override
  void dispose() {
    _titleFieldController.dispose();
    _yearFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _titleFieldController,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter book title';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _yearFieldController,
              decoration: const InputDecoration(
                labelText: 'Year'
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d]')),
              ],
              validator: (String? value) {
                if(value == null || value.isEmpty) {
                  return 'Please enter released year';
                }
                return null;
              },
            ),
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                onPressed: () async{
                  if(_formKey.currentState!.validate())
                    await widget._homeController.addBook(Book(
                      id: 0,
                      title:  _titleFieldController.text,
                      year: int.parse(_yearFieldController.text)
                    ));
                    _titleFieldController.clear();
                    _yearFieldController.clear();
                    widget._refreshList();
                  },

                child: const Text('Add book'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BookTable extends StatelessWidget {
  final HomeController _homeController;
  final VoidCallback _refreshList;

  
  const _BookTable(this._homeController, this._refreshList);
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _homeController.getAllBooks(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return const Center(child: Text('Loading...'));
        } else {
          return DataTable(columns: _createBookTableColumns(),
              rows: _createBookTableRows(snapshot.data ?? []));
        }
      }
    );
  }

  List<DataColumn> _createBookTableColumns() {
    return [
      const DataColumn(label: Text('ID')),
      const DataColumn(label: Text('Book')),
      const DataColumn(label: Text('Action')),
    ];
  }

  List<DataRow> _createBookTableRows(List<Book> books) {
    return books.map((book) => DataRow(cells: [
      DataCell(Text('#' + book.id.toString())),
      DataCell(Text('${book.title} (${book.year.toString()})')),
      DataCell(IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async {
          await _homeController.removeBook(book.id!);
          _refreshList();
        },
      ))
    ])).toList();
  }
}


