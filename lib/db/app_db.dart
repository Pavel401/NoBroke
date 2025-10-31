import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_db.g.dart';

class Savings extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get itemName => text()();
  // Replaced legacy emoji with icon name from Material icons util
  TextColumn get itemIconName => text().nullable()();
  RealColumn get amount => real()();
  TextColumn get symbol => text()();
  TextColumn get investmentName => text()();
  RealColumn get finalValue => real()();
  RealColumn get returnPct => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class CatalogItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  // Prefer emoji for user-created items; icons optional for seeded items
  TextColumn get emoji => text().nullable()();
  TextColumn get iconName => text().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get kidSpecific => boolean().withDefault(const Constant(false))();
  RealColumn get defaultPrice => real().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Profiles extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  TextColumn get name => text().nullable()();
  TextColumn get imagePath => text().nullable()();
  DateTimeColumn get dob => dateTime().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

@DriftDatabase(tables: [Savings, Profiles, CatalogItems])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.createTable(catalogItems);
      }
      if (from < 3) {
        // Recreate savings table without legacy NOT NULL item_emoji column.
        // 1) Create new table with the desired schema
        await m.database.customStatement('''
          CREATE TABLE IF NOT EXISTS savings_new (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_name TEXT NOT NULL,
            item_icon_name TEXT,
            amount REAL NOT NULL,
            symbol TEXT NOT NULL,
            investment_name TEXT NOT NULL,
            final_value REAL NOT NULL,
            return_pct REAL NOT NULL,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
          );
        ''');
        // 2) Copy data from old table, dropping the old emoji column
        await m.database.customStatement('''
          INSERT INTO savings_new (id, item_name, amount, symbol, investment_name, final_value, return_pct, created_at)
          SELECT id, item_name, amount, symbol, investment_name, final_value, return_pct, created_at FROM savings;
        ''');
        // 3) Replace old table
        await m.database.customStatement('DROP TABLE savings;');
        await m.database.customStatement(
          'ALTER TABLE savings_new RENAME TO savings;',
        );
      }
      if (from < 4) {
        // Ensure databases that were already at v3 but still had NOT NULL item_emoji
        // are migrated by recreating the table to the latest schema.
        await m.database.customStatement('''
          CREATE TABLE IF NOT EXISTS savings_new (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_name TEXT NOT NULL,
            item_icon_name TEXT,
            amount REAL NOT NULL,
            symbol TEXT NOT NULL,
            investment_name TEXT NOT NULL,
            final_value REAL NOT NULL,
            return_pct REAL NOT NULL,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
          );
        ''');
        await m.database.customStatement('''
          INSERT INTO savings_new (id, item_name, amount, symbol, investment_name, final_value, return_pct, created_at)
          SELECT id, item_name, amount, symbol, investment_name, final_value, return_pct, created_at FROM savings;
        ''');
        await m.database.customStatement('DROP TABLE savings;');
        await m.database.customStatement(
          'ALTER TABLE savings_new RENAME TO savings;',
        );
      }
      if (from < 5) {
        // Fix created_at to have DEFAULT CURRENT_TIMESTAMP for existing v4 installs
        await m.database.customStatement('''
          CREATE TABLE IF NOT EXISTS savings_new (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_name TEXT NOT NULL,
            item_icon_name TEXT,
            amount REAL NOT NULL,
            symbol TEXT NOT NULL,
            investment_name TEXT NOT NULL,
            final_value REAL NOT NULL,
            return_pct REAL NOT NULL,
            created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
          );
        ''');
        await m.database.customStatement('''
          INSERT INTO savings_new (id, item_name, amount, symbol, investment_name, final_value, return_pct, created_at)
          SELECT id, item_name, amount, symbol, investment_name, final_value, return_pct, created_at FROM savings;
        ''');
        await m.database.customStatement('DROP TABLE savings;');
        await m.database.customStatement(
          'ALTER TABLE savings_new RENAME TO savings;',
        );
      }
    },
  );

  // Savings ops
  Stream<List<Saving>> watchSavings() => select(savings).watch();
  Future<int> addSaving(SavingsCompanion data) {
    final payload = data.createdAt.present
        ? data
        : data.copyWith(createdAt: Value(DateTime.now()));
    return into(savings).insert(payload);
  }

  Future<void> clearSavings() => delete(savings).go();
  Future<int> deleteSaving(int id) =>
      (delete(savings)..where((tbl) => tbl.id.equals(id))).go();

  // Profile ops
  Future<Profile?> getProfile() async {
    final rows = await select(profiles).get();
    return rows.isNotEmpty ? rows.first : null;
  }

  Future<void> upsertProfile(ProfilesCompanion data) async {
    await into(profiles).insertOnConflictUpdate(data);
  }

  // Catalog items ops
  Stream<List<CatalogItem>> watchCatalogItems() => select(catalogItems).watch();
  Future<List<CatalogItem>> getAllCatalogItems() => select(catalogItems).get();
  Future<int> addCatalogItem(CatalogItemsCompanion data) =>
      into(catalogItems).insert(data);
  Future<int> deleteCatalogItem(int id) =>
      (delete(catalogItems)..where((tbl) => tbl.id.equals(id))).go();
  Future<int> addCatalogItemRaw({
    required String name,
    required String category,
    String? emoji,
    String? iconName,
    String? description,
    bool kidSpecific = false,
    double? defaultPrice,
  }) async {
    return addCatalogItem(
      CatalogItemsCompanion.insert(
        name: name,
        category: category,
        emoji: Value(emoji),
        iconName: Value(iconName),
        description: Value(description),
        kidSpecific: Value(kidSpecific),
        defaultPrice: Value(defaultPrice),
      ),
    );
  }

  Future<int> countCatalogItems() async {
    final exp = catalogItems.id.count();
    final q = selectOnly(catalogItems)..addColumns([exp]);
    final row = await q.getSingle();
    return row.read(exp) ?? 0;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'what_if_invested.db'));
    return NativeDatabase.createInBackground(file);
  });
}
