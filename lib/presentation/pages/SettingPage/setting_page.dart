import 'package:flutter/material.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: [
          _buildProfileTile(),
          _buildSwitchTile('Dark Mode', true),
          _buildNavigationTile('Notifications', Icons.notifications),
          _buildNavigationTile('Privacy', Icons.lock),
          _buildNavigationTile('Security', Icons.security),
          _buildNavigationTile('Main', Icons.home),
          _buildNavigationTile('Appearance', Icons.palette),
          _buildLanguageTile(),
          _buildNavigationTile('Ask a Question', Icons.question_answer),
          _buildNavigationTile('FAQ', Icons.help),
        ],
      ),
    );
  }

  Widget _buildProfileTile() {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/profile_image.jpg'),
        radius: 25,
      ),
      title: Text('Jim Kein', style: TextStyle(color: Colors.white)),
      subtitle: Text('+8 902 21 00 00', style: TextStyle(color: Colors.grey)),
      trailing: Icon(Icons.chevron_right, color: Colors.white),
    );
  }

  Widget _buildSwitchTile(String title, bool value) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(color: Colors.white)),
      value: value,
      onChanged: (bool newValue) {},
      activeColor: Colors.purple,
    );
  }

  Widget _buildNavigationTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.purple),
      title: Text(title, style: TextStyle(color: Colors.white)),
      trailing: Icon(Icons.chevron_right, color: Colors.white),
    );
  }

  Widget _buildLanguageTile() {
    return ListTile(
      leading: Icon(Icons.language, color: Colors.purple),
      title: Text('Language', style: TextStyle(color: Colors.white)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('English', style: TextStyle(color: Colors.grey)),
          SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.white),
        ],
      ),
    );
  }
}
