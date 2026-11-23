import 'package:flutter/material.dart';
import 'shop_service.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ShopService _service = ShopService();

  bool _isLoading = false;
  String _user = '';
  List<String> _products = [];
  List<String> _orders = [];
  String _error = '';

  // Конкурентне (паралельне) завантаження даних
  Future<void> _loadData({bool simulateError = false}) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Запускаємо всі 3 методи одночасно через Future.wait
      final results = await Future.wait([
        _service.getUser(),
        _service.getProducts(hasError: simulateError),
        _service.getOrders(),
      ]);

      setState(() {
        _user = results[0] as String;
        _products = results[1] as List<String>;
        _orders = results[2] as List<String>;
      });
    } catch (e) {
      // Перехоплюємо помилку
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _user = '';
        _products = [];
        _orders = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Інтернет-магазин'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () => _loadData(),
                    child: const Text('Оновити дані'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => _loadData(simulateError: true),
                    child: const Text('Тест помилки'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_error.isNotEmpty)
              Text(
                _error,
                style: const TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
              )
            else ...[
                const Text('Користувач:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(_user),
                const SizedBox(height: 16),

                const Text('Доступні товари:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                for (var item in _products) Text('• $item'),
                const SizedBox(height: 16),

                const Text('Історія замовлень:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                for (var order in _orders) Text('• $order'),
              ],
          ],
        ),
      ),
    );
  }
}