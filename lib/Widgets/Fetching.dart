import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:srvc/Configs/URL.dart';
import 'package:srvc/Pages/AppPallete.dart';
import 'package:srvc/Providers/FetchingHome.dart';
import 'package:srvc/Services/APIService.dart'; // Make sure to add the provider package

class FetchingContainer extends StatefulWidget {
  final int userID;

  const FetchingContainer({super.key, required this.userID});

  @override
  State<FetchingContainer> createState() => _FetchingContainerState();
}

class _FetchingContainerState extends State<FetchingContainer> {
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(serverURL);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDataProvider()..fetchData(context, widget.userID, _apiService),
      child: Consumer<UserDataProvider>(
        builder: (context, dataProvider, child) {
          return Scaffold(
            backgroundColor: AppPallete.purple,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'กำลังโหลดข้อมูล...',
                      style: TextStyle(
                        fontSize: 24,
                        color: AppPallete.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'thaifont',
                      ),
                    ),
                  ),
                  ...dataProvider.data.entries.map((entry) {
                    final status = entry.value['success'] ? Icons.check : Icons.error;
                    final color = entry.value['success'] ? AppPallete.green : AppPallete.error;

                    return ListTile(
                      title: Text(
                        entry.value['text'],
                        style: TextStyle(
                          color: AppPallete.white,
                          fontFamily: 'thaifont',
                        ),
                      ),
                      leading: Icon(
                        status,
                        color: color,
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
