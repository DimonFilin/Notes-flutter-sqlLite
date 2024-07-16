import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _StringTODO = "";
  List TodoList = [];

  @override
  void initState() {
    super.initState();

    TodoList.addAll(['Купить молоко','Покормить кота','123']);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Список дел'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: TodoList.length,
        itemBuilder: (BuildContext context, int index){
          return Dismissible(key: Key(TodoList[index]),
              child: Card(
                child: ListTile(
                    title: Text(TodoList[index]),
                trailing: IconButton(icon: Icon(
                    Icons.delete_outlined,
                    color: Colors.lightBlue),
                  onPressed:(){setState(() {
                    TodoList.removeAt(index);

                  });} ,
                )
                  ,)
              ),
              onDismissed: (direction){
                setState(() {
                  TodoList.removeAt(index);
                });
          },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: (){
        showDialog(context: context, builder: (BuildContext context2){
          return AlertDialog(
            title: Text("Добавление задачи"),
            content: TextField(
              onChanged: (String value){
                _StringTODO = value;
              }
            ),
              actions: [
                ElevatedButton(onPressed: (){
                  setState(() {
                    TodoList.add(_StringTODO);
                  });
                  Navigator.of(context2).pop();
                }, child: Icon(Icons.add, color: Colors.lightBlue,))
            ],
          );
        });
        },
        child: Icon(Icons.add, color: Colors.lightBlue,),
      ),
    );
  }
}

