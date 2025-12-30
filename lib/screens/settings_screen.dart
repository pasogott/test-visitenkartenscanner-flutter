import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          _buildSectionHeader(context, 'AI Extraction'),
          _buildSettingsCard(
            context,
            children: [
              _buildSettingsTile(
                icon: Icons.key,
                title: 'OpenAI API Key',
                subtitle: 'Configure your API key for data extraction',
                onTap: () => _showApiKeyDialog(context),
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.chat_bubble_outline,
                title: 'System Prompt',
                subtitle: 'Customize the extraction prompt',
                onTap: () => _showSystemPromptDialog(context),
              ),
              const Divider(height: 1),
              _buildSwitchTile(
                icon: Icons.auto_awesome,
                title: 'Auto-Extract',
                subtitle: 'Automatically extract data after scanning',
                value: false,
                onChanged: (value) {
                  // TODO: Implement with SettingsProvider
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Integrations'),
          _buildSettingsCard(
            context,
            children: [
              _buildSettingsTile(
                icon: Icons.webhook,
                title: 'Webhook',
                subtitle: 'Send card data to external systems',
                onTap: () => _showComingSoon(context),
                trailing: _buildStatusChip('Not configured'),
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.cloud_sync,
                title: 'Salesforce',
                subtitle: 'Sync cards as Salesforce Leads',
                onTap: () => _showComingSoon(context),
                trailing: _buildStatusChip('Coming soon'),
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.hub,
                title: 'HubSpot',
                subtitle: 'Sync cards as HubSpot Contacts',
                onTap: () => _showComingSoon(context),
                trailing: _buildStatusChip('Coming soon'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionHeader(context, 'About'),
          _buildSettingsCard(
            context,
            children: [
              _buildSettingsTile(
                icon: Icons.info_outline,
                title: 'Version',
                subtitle: '1.0.0',
                onTap: null,
              ),
              const Divider(height: 1),
              _buildSettingsTile(
                icon: Icons.description_outlined,
                title: 'Licenses',
                subtitle: 'Open source licenses',
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'Business Card Scanner',
                  applicationVersion: '1.0.0',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blue, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
      trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: Colors.grey) : null),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blue, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 13,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: Colors.blue.withValues(alpha: 0.5),
        activeThumbColor: Colors.blue,
      ),
    );
  }

  Widget _buildStatusChip(String text) {
    final isConfigured = text == 'Connected';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isConfigured ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: isConfigured ? Colors.green[700] : Colors.grey[600],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _showApiKeyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('OpenAI API Key'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your OpenAI API key to enable automatic data extraction from business cards.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'API Key',
                hintText: 'sk-...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.key),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Implement with SettingsProvider
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('API key will be saved when SettingsProvider is implemented')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showSystemPromptDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('System Prompt'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Customize the prompt used to extract data from business cards.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 150),
                child: const TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Extract the following information...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
        actionsOverflowButtonSpacing: 8,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Reset to default
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Implement with SettingsProvider
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
