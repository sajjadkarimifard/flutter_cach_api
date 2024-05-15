import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqflite_fetchdata/data/datasource/db_provider.dart';
import 'package:flutter_sqflite_fetchdata/data/model/user_model.dart';
import 'package:flutter_sqflite_fetchdata/util/extentions/string_extention.dart';

void main() {
  runApp(const MyApp());
}

//First Connect to VPN
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<List<User>> loadData() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://dummyjson.com/users');
      final List<User> users = response.data['users']
          .map<User>(
              (e) => User.fromJson((e as Map<String, dynamic>).toLowerCase()))
          .toList();
      await DBProvider.db.addUsers(users);
      return users;
    } catch (e) {
      // print('Error${e}');
      return await DBProvider.db.loadUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cach Data'),
        leading: IconButton(
          onPressed: () async {
            loadData();
          },
          icon: const Icon(Icons.replay_outlined),
        ),
      ),
      body: FutureBuilder<List<User>>(
        future: loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Don\'t Look for data!'),
            );
          }
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    snapshot.data![index].image ??
                        'https://images.app.goo.gl/QM5BryVjCmjRyxCv6',
                  ),
                ),
                title: Text(
                  '${snapshot.data![index].firstName ?? 'null'} ${snapshot.data![index].lastName ?? 'null'}',
                ),
                subtitle: Text(
                  'id: ${snapshot.data![index].id ?? 'null'}',
                ),
                trailing: Text(snapshot.data![index].phone ?? 'null'),
              );
            },
          );
        },
      ),
    );
  }
}
