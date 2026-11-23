import 'dart:async';

class ShopService {
  // Отримання інформації про користувача
  Future<String> getUser() async {
    await Future.delayed(const Duration(seconds: 1));
    return 'Денис Фурман';
  }

  // Отримання списку товарів
  Future<List<String>> getProducts({bool hasError = false}) async {
    await Future.delayed(const Duration(seconds: 2));
    if (hasError) {
      throw Exception('Помилка завантаження товарів з сервера');
    }
    return [
      'Ноутбук — 30 000 грн',
      'Клавіатура — 3 000 грн',
      'Мишка — 1 000 грн',
    ];
  }

  // Отримання історії замовлень
  Future<List<String>> getOrders() async {
    await Future.delayed(const Duration(seconds: 2));
    return [
      'Замовлення #1 — Виконано',
      'Замовлення #2 — В дорозі',
    ];
  }
}