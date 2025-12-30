import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing sensitive data like API keys.
/// Uses platform-specific secure storage:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences / Keystore
/// - Web: Encrypted localStorage
/// - macOS: Keychain
/// - Windows: Windows Credential Manager
/// - Linux: libsecret
class SecureStorageService {
  static const String _openaiApiKeyKey = 'openai_api_key';
  static const String _systemPromptKey = 'system_prompt';
  static const String _webhookUrlKey = 'webhook_url';
  static const String _webhookApiKeyKey = 'webhook_api_key';

  final FlutterSecureStorage _storage;

  SecureStorageService()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        );

  // OpenAI API Key

  /// Save the OpenAI API key securely.
  Future<void> saveOpenAIApiKey(String apiKey) async {
    await _storage.write(key: _openaiApiKeyKey, value: apiKey);
  }

  /// Get the stored OpenAI API key.
  /// Returns null if no key is stored.
  Future<String?> getOpenAIApiKey() async {
    return await _storage.read(key: _openaiApiKeyKey);
  }

  /// Check if an OpenAI API key is stored.
  Future<bool> hasOpenAIApiKey() async {
    final key = await _storage.read(key: _openaiApiKeyKey);
    return key != null && key.isNotEmpty;
  }

  /// Delete the stored OpenAI API key.
  Future<void> deleteOpenAIApiKey() async {
    await _storage.delete(key: _openaiApiKeyKey);
  }

  // System Prompt

  /// Save the custom system prompt.
  Future<void> saveSystemPrompt(String prompt) async {
    await _storage.write(key: _systemPromptKey, value: prompt);
  }

  /// Get the stored system prompt.
  /// Returns null if no custom prompt is stored.
  Future<String?> getSystemPrompt() async {
    return await _storage.read(key: _systemPromptKey);
  }

  /// Delete the stored system prompt (revert to default).
  Future<void> deleteSystemPrompt() async {
    await _storage.delete(key: _systemPromptKey);
  }

  // Webhook Configuration

  /// Save the webhook URL.
  Future<void> saveWebhookUrl(String url) async {
    await _storage.write(key: _webhookUrlKey, value: url);
  }

  /// Get the stored webhook URL.
  Future<String?> getWebhookUrl() async {
    return await _storage.read(key: _webhookUrlKey);
  }

  /// Save the webhook API key.
  Future<void> saveWebhookApiKey(String apiKey) async {
    await _storage.write(key: _webhookApiKeyKey, value: apiKey);
  }

  /// Get the stored webhook API key.
  Future<String?> getWebhookApiKey() async {
    return await _storage.read(key: _webhookApiKeyKey);
  }

  /// Check if webhook is configured.
  Future<bool> hasWebhookConfig() async {
    final url = await _storage.read(key: _webhookUrlKey);
    return url != null && url.isNotEmpty;
  }

  /// Delete all webhook configuration.
  Future<void> deleteWebhookConfig() async {
    await _storage.delete(key: _webhookUrlKey);
    await _storage.delete(key: _webhookApiKeyKey);
  }

  // Generic Methods

  /// Save a custom key-value pair.
  Future<void> saveValue(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Get a custom value by key.
  Future<String?> getValue(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete a custom value by key.
  Future<void> deleteValue(String key) async {
    await _storage.delete(key: key);
  }

  /// Check if a key exists.
  Future<bool> hasValue(String key) async {
    final value = await _storage.read(key: key);
    return value != null && value.isNotEmpty;
  }

  /// Delete all stored data.
  /// Use with caution!
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
