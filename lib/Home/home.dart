import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CoffeeListPage extends StatefulWidget {
  @override
  _CoffeeListPageState createState() => _CoffeeListPageState();
}

class _CoffeeListPageState extends State<CoffeeListPage> {
  Dio dio = Dio();
  List<dynamic> coffeeData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hot Coffee List'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: coffeeData.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(coffeeData[index]['title']),
                    leading: Text('${index + 1}'),
                    trailing: coffeeData[index]['image'] == null
                        ? null
                        : CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(coffeeData[index]['image']),
                          ),
                    onTap: () {
                      _showCoffeeDetails(coffeeData[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      Response response = await dio.get('https://api.sampleapis.com/coffee/hot');
      setState(() {
        coffeeData = response.data;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _showCoffeeDetails(coffee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(coffee['title']),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  coffee['image'] == null
                      ? SizedBox.shrink() // ไม่มีรูปภาพในกรณีนี้
                      : Image.network(
                          coffee['image'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ), // แสดงรูปภาพเมื่อมี
                  SizedBox(width: 10),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${coffee['description']}'),
                        SizedBox(height: 10),
                        Text('Ingredients: ${coffee['ingredients']}'),
                        SizedBox(height: 10),
                        Text('ID: ${coffee['id']}'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Coffee App',
    home: CoffeeListPage(),
  ));
}
