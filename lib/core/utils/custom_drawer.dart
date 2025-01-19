import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone_demo/core/firebase/auth_service.dart';
import 'package:tiktok_clone_demo/feature/home/controllers/home_controller.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  HomeController homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: SizedBox(
                height: 120,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.red),
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    'KotKit',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              )),
            ],
          ),

          // favorite page
          ListTile(
            trailing: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            title: const Text('Favorites'),
            onTap: () {
              homeController
                  .videos[homeController.tempIndex.value].videoController!
                  .pause();
              Get.toNamed('/favorites');
            },
          ),

          Spacer(),

          // logout button
          ListTile(
            trailing: Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async {
              Get.back();
              if (await AuthService().signOut()) {
                Get.offAllNamed('/login');
              }
            },
          ),
        ],
      ),
    );
  }
}
