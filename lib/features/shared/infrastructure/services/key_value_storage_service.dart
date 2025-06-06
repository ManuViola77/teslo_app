abstract class KeyValueStorageService {
  Future<void> saveKeyValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<bool> removeKey(String key);
}
