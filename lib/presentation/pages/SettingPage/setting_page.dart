import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Settings',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileSection(),
            const SizedBox(height: 20),
            _buildSectionTitle('Account'),
            _buildSettingTile('Recipes', Icons.restaurant_menu),
            _buildSettingTile('Products', Icons.inventory_2),
            _buildSettingTile('Orders', Icons.shopping_cart),
            const SizedBox(height: 20),
            _buildSectionTitle('Preferences'),
            _buildSettingTile('Security', Icons.security),
            _buildSettingTile('Payment', Icons.payment),
            _buildSettingTile('Notifications', Icons.notifications),
            _buildLanguageTile(),
            const SizedBox(height: 20),
            _buildSectionTitle('Support'),
            _buildSettingTile('Ask a Question', Icons.question_answer),
            _buildSettingTile('FAQ', Icons.help),
            const SizedBox(height: 20),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/profile_image.jpg'),
            radius: 40,
          ),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jim Kein',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('+8 902 21 00 00', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.blue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildSettingTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }

  Widget _buildLanguageTile() {
    return ListTile(
      leading: const Icon(Icons.language, color: Colors.blue),
      title: const Text('Language'),
      trailing: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('English', style: TextStyle(color: Colors.grey)),
          SizedBox(width: 8),
          Icon(Icons.chevron_right),
        ],
      ),
      onTap: () {},
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {},
        child: const Text('Đăng xuất', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}
