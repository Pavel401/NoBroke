import 'dart:async';

import 'package:get/get.dart';

import '../db/app_db.dart';

class ItemsController extends GetxController {
  final AppDb _db = Get.find<AppDb>();
  final items = <CatalogItem>[].obs;
  final categories = <String>[].obs;
  StreamSubscription<List<CatalogItem>>? _sub;

  final query = ''.obs;
  final selectedCategory = ''.obs; // empty = all

  @override
  void onInit() {
    super.onInit();
    _sub = _db.watchCatalogItems().listen((rows) {
      items.assignAll(rows);
      final cats = rows.map((e) => e.category).toSet().toList()..sort();
      categories.assignAll(cats);
    });
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  List<CatalogItem> get filteredItems {
    final q = query.value.trim().toLowerCase();
    final cat = selectedCategory.value.trim();
    return items.where((it) {
      final matchQ =
          q.isEmpty ||
          it.name.toLowerCase().contains(q) ||
          (it.description ?? '').toLowerCase().contains(q);
      final matchC = cat.isEmpty || it.category == cat;
      return matchQ && matchC;
    }).toList()..sort((a, b) => a.name.compareTo(b.name));
  }

  Future<void> addItem({
    required String name,
    required String category,
    String? emoji,
    String? iconName,
    String? description,
    bool kidSpecific = false,
    double? defaultPrice,
  }) async {
    await _db.addCatalogItemRaw(
      name: name,
      category: category,
      emoji: emoji,
      iconName: iconName,
      description: description,
      kidSpecific: kidSpecific,
      defaultPrice: defaultPrice,
    );
  }

  Future<void> deleteItem(int id) async {
    await _db.deleteCatalogItem(id);
  }
}
