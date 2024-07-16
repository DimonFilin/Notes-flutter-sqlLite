import 'package:flutter/material.dart';
import 'package:flutter_app/models/todo_item.dart';
import 'package:flutter_app/services/db.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      theme: ThemeData(primarySwatch: Colors.lightBlue),
      home: MyHomePage(title: 'Заметки'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 1;

  String _task = '';

  List<TodoItem> _tasks = [];

  //TextStyle _style = TextStyle(color: Colors.white, fontSize: 24 );

  List<Widget> get _items => _tasks.map((item) => format(item)).toList();

  Widget format(TodoItem item) {
    _index = item.id;
    return Dismissible(
      key: Key(item.id.toString()),
      child:
      Card(
        //color: Colors.white,
    child:
      Padding(
        padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(item.task, style: TextStyle(color: item.complete ? Colors.blueGrey :Colors.lightBlue ,fontSize: 24)),
          // IconButton(icon: Icon(
          //     Icons.delete_outlined,
          //     color: Colors.lightBlue),
          //   onPressed:(){setState(() {
          //     _delete(item);

          //  });} ,),
              Icon(
                item.complete ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                color: Colors.lightBlue,
              )
            ],
          ),
          onPressed: () { _toggle(item);},
        ),
      ),
      ),
      onDismissed: (DismissDirection direction) => _delete(item),
    );
  }

  void _toggle(TodoItem item) async {
    item.complete = !item.complete;
    dynamic result = await DB.update(TodoItem.table, item);
    print(result);
    refresh();
  }

  void _delete(TodoItem item) async {
    DB.delete(TodoItem.table, item);
    refresh();
  }

  void _save() async {
    Navigator.of(context).pop();
    TodoItem item = TodoItem(
      id: ++_index,
      task: _task,
      complete: false,
    );

    await DB.insert(TodoItem.table, item);
    setState(() => _task = '');
    refresh();
  }

  void _create(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create New Task"),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () => _save(),
            ),
          ],
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(labelText: 'Task Name', hintText: 'e.g. pick up bread'),
            onChanged: (value) {
              _task = value;
            },
          ),
        );
      },
    );
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  void refresh() async {
    List<Map<String, dynamic>> _results = await DB.query(TodoItem.table);
    _tasks = _results.map((item) => TodoItem.fromMap(item)).toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: ListView(children: _items),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _create(context);
        },
        tooltip: 'New TODO',
        child: Icon(Icons.library_add),
      ),
    );
  }
}