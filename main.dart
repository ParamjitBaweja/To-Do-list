import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget 
{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Todo List',
      home: new TodoList()
    );
  }
}
class TodoList extends StatefulWidget 
{
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> 
{
  List<String> _todoItems = [];
  List<String> completedItems = [];
  // This will be called each time the + button is pressed
  /*void _addTodoItem() 
  {
    // Putting our code inside "setState" tells the app that our state has changed, and
    // it will automatically re-render the list
    setState
    (
      () 
      {
        int index = _todoItems.length;
        _todoItems.add('Item ' + index.toString());
      }
    );
  }*/

  //instead of predefining tasks, this function accepts a string
  void _addTodoItem(String task) 
  {
  // Only add the task if the user actually entered something
    if(task.length > 0) 
    {
      setState(() => _todoItems.add(task));
    }
  }

  // Build the whole list of todo items
  Widget _buildTodoList() 
  {
    return new ListView.builder
    (
      itemBuilder: (context, index) 
      {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if(index < _todoItems.length) 
        {
          return _buildTodoItem(_todoItems[index],index);
        }
      },
    );
  }
  // Build a single todo item
  Widget _buildTodoItem(String todoText,int index) 
  {
    return new ListTile
    (
      title:new Container
      (
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration
        (
          border: Border.all
          (
            color: Colors.black.withOpacity(0.4),
            width: 6,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: 
        Center
        (
          child: Text
          (
            todoText,
            style:TextStyle
            (
              fontSize: 32,
              color: Colors.black.withOpacity(0.6),
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
      onTap: () => _promptRemoveTodoItem(index)
    );
  }
  @override
  Widget build(BuildContext context) 
  {
    return new Scaffold
    (
      appBar: new AppBar
      (
        title: new Text('Todo List')
      ),  
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton
      (
        onPressed: _pushAddTodoScreen,
        tooltip: 'Add task',
        child: new Icon(Icons.add)
      ),
      bottomNavigationBar: BottomNavigationBar
      (
       currentIndex: 0, // this will be set when a new tab is tapped
       items: 
       [
         BottomNavigationBarItem
         (
           icon: new Icon(Icons.list),
           title: new Text('Tasks'),
         ),
         BottomNavigationBarItem(
           icon: new Icon(Icons.check),
           title: new Text('Completed'),
         ),
       ],
       onTap: onTapped,
     ),
    );
  }
  void onTapped(int index)
  {
    if(index==1)
    completed();
  }
  void onTappedBack(int index)
  {
    if(index==0)
    {
      Navigator.pop(context);
    }
  }
  void completed()
  {
    Navigator.of(context).push
    (
      new MaterialPageRoute
      (
        builder: (context) 
        {
          return new Scaffold
          (
            appBar: new AppBar
            (
              title: new Text('Completed tasks')
            ),
            body: buildCompletedList(),
            bottomNavigationBar: BottomNavigationBar
            (
              currentIndex: 1, // this will be set when a new tab is tapped
              items: 
              [
                BottomNavigationBarItem
                (
                  icon: new Icon(Icons.list),
                  title: new Text('Tasks'),
                ),
                BottomNavigationBarItem(
                  icon: new Icon(Icons.check),
                  title: new Text('Completed'),
                ),
              ],
              onTap: onTappedBack,
            ),
          );
        }
      )
    );
  }
  void _pushAddTodoScreen() 
  {
    // Push this page onto the stack
    Navigator.of(context).push
    (
      // MaterialPageRoute will automatically animate the screen entry, as well
      // as adding a back button to close it
      new MaterialPageRoute
      (
        builder: (context) 
        {
          return new Scaffold
          (
            appBar: new AppBar
            (
              title: new Text('Add a new task')
            ),
            body: new TextField
            (
              autofocus: true,
              onSubmitted: (val) {
                _addTodoItem(val);
                Navigator.pop(context); // Close the add todo screen
              },
              decoration: new InputDecoration(
                hintText: 'Enter something to do...',
                contentPadding: const EdgeInsets.all(16.0)
              ),
            )
          );
        }
      )
    );
  }
  //removing a list item
  void _removeTodoItem(int index) 
  {
    addCompletedItem(index);
    setState(() => _todoItems.removeAt(index));
  }
  // Show an alert dialog asking the user to confirm that the task is done
  void _promptRemoveTodoItem(int index) 
  {
    showDialog
    (
      context: context,
      builder: (BuildContext context) 
      {
        return new AlertDialog
        (
          title: new Text('Mark "${_todoItems[index]}" as done?'),
          actions: <Widget>
          [
            new FlatButton
            (
              child: new Text('CANCEL'),
              onPressed: () => Navigator.of(context).pop()
            ),
            new FlatButton
            (
              child: new Text('MARK AS DONE'),
              onPressed: () {
                _removeTodoItem(index);
                Navigator.of(context).pop();
              }
            )
          ]
        );
      }
    );
  }
  //put the completed tasks on the completed list
  void addCompletedItem(int index) 
  {
     String task=_todoItems[index];
    // Only add the task if the user actually entered something
    if(task.length > 0) 
    {
      setState(() => completedItems.add(task));
    }
  }
  //build the list on the completed page
  Widget buildCompletedList() 
  {
    return new ListView.builder
    (
      itemBuilder: (context, index) 
      {
        // itemBuilder will be automatically be called as many times as it takes for the
        // list to fill up its available space, which is most likely more than the
        // number of todo items we have. So, we need to check the index is OK.
        if(index < completedItems.length) 
        {
          return buildCompletedItem(completedItems[index],index);
        }
      },
    );
  }
  // Build a single todo item
  Widget buildCompletedItem(String todoText,int index) 
  {
    return new ListTile
    (
      title:new Container
      (
        margin: const EdgeInsets.all(15.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration
        (
          border: Border.all
          (
            color: Colors.black.withOpacity(0.4),
            width: 6,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: 
        Center
        (
          child: Text
          (
            todoText,
            style:TextStyle
            (
              fontSize: 32,
              color: Colors.black.withOpacity(0.6),
              fontFamily: 'Comfortaa',
              fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }
}






