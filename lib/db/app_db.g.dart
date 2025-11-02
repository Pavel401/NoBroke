// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $SavingsTable extends Savings with TableInfo<$SavingsTable, Saving> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemNameMeta = const VerificationMeta(
    'itemName',
  );
  @override
  late final GeneratedColumn<String> itemName = GeneratedColumn<String>(
    'item_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIconNameMeta = const VerificationMeta(
    'itemIconName',
  );
  @override
  late final GeneratedColumn<String> itemIconName = GeneratedColumn<String>(
    'item_icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _investmentNameMeta = const VerificationMeta(
    'investmentName',
  );
  @override
  late final GeneratedColumn<String> investmentName = GeneratedColumn<String>(
    'investment_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _finalValueMeta = const VerificationMeta(
    'finalValue',
  );
  @override
  late final GeneratedColumn<double> finalValue = GeneratedColumn<double>(
    'final_value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _returnPctMeta = const VerificationMeta(
    'returnPct',
  );
  @override
  late final GeneratedColumn<double> returnPct = GeneratedColumn<double>(
    'return_pct',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemName,
    itemIconName,
    amount,
    symbol,
    investmentName,
    finalValue,
    returnPct,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Saving> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_name')) {
      context.handle(
        _itemNameMeta,
        itemName.isAcceptableOrUnknown(data['item_name']!, _itemNameMeta),
      );
    } else if (isInserting) {
      context.missing(_itemNameMeta);
    }
    if (data.containsKey('item_icon_name')) {
      context.handle(
        _itemIconNameMeta,
        itemIconName.isAcceptableOrUnknown(
          data['item_icon_name']!,
          _itemIconNameMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('investment_name')) {
      context.handle(
        _investmentNameMeta,
        investmentName.isAcceptableOrUnknown(
          data['investment_name']!,
          _investmentNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_investmentNameMeta);
    }
    if (data.containsKey('final_value')) {
      context.handle(
        _finalValueMeta,
        finalValue.isAcceptableOrUnknown(data['final_value']!, _finalValueMeta),
      );
    } else if (isInserting) {
      context.missing(_finalValueMeta);
    }
    if (data.containsKey('return_pct')) {
      context.handle(
        _returnPctMeta,
        returnPct.isAcceptableOrUnknown(data['return_pct']!, _returnPctMeta),
      );
    } else if (isInserting) {
      context.missing(_returnPctMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Saving map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Saving(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      itemName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_name'],
      )!,
      itemIconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}item_icon_name'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      investmentName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}investment_name'],
      )!,
      finalValue: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}final_value'],
      )!,
      returnPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}return_pct'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SavingsTable createAlias(String alias) {
    return $SavingsTable(attachedDatabase, alias);
  }
}

class Saving extends DataClass implements Insertable<Saving> {
  final int id;
  final String itemName;
  final String? itemIconName;
  final double amount;
  final String symbol;
  final String investmentName;
  final double finalValue;
  final double returnPct;
  final DateTime createdAt;
  const Saving({
    required this.id,
    required this.itemName,
    this.itemIconName,
    required this.amount,
    required this.symbol,
    required this.investmentName,
    required this.finalValue,
    required this.returnPct,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_name'] = Variable<String>(itemName);
    if (!nullToAbsent || itemIconName != null) {
      map['item_icon_name'] = Variable<String>(itemIconName);
    }
    map['amount'] = Variable<double>(amount);
    map['symbol'] = Variable<String>(symbol);
    map['investment_name'] = Variable<String>(investmentName);
    map['final_value'] = Variable<double>(finalValue);
    map['return_pct'] = Variable<double>(returnPct);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SavingsCompanion toCompanion(bool nullToAbsent) {
    return SavingsCompanion(
      id: Value(id),
      itemName: Value(itemName),
      itemIconName: itemIconName == null && nullToAbsent
          ? const Value.absent()
          : Value(itemIconName),
      amount: Value(amount),
      symbol: Value(symbol),
      investmentName: Value(investmentName),
      finalValue: Value(finalValue),
      returnPct: Value(returnPct),
      createdAt: Value(createdAt),
    );
  }

  factory Saving.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Saving(
      id: serializer.fromJson<int>(json['id']),
      itemName: serializer.fromJson<String>(json['itemName']),
      itemIconName: serializer.fromJson<String?>(json['itemIconName']),
      amount: serializer.fromJson<double>(json['amount']),
      symbol: serializer.fromJson<String>(json['symbol']),
      investmentName: serializer.fromJson<String>(json['investmentName']),
      finalValue: serializer.fromJson<double>(json['finalValue']),
      returnPct: serializer.fromJson<double>(json['returnPct']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemName': serializer.toJson<String>(itemName),
      'itemIconName': serializer.toJson<String?>(itemIconName),
      'amount': serializer.toJson<double>(amount),
      'symbol': serializer.toJson<String>(symbol),
      'investmentName': serializer.toJson<String>(investmentName),
      'finalValue': serializer.toJson<double>(finalValue),
      'returnPct': serializer.toJson<double>(returnPct),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Saving copyWith({
    int? id,
    String? itemName,
    Value<String?> itemIconName = const Value.absent(),
    double? amount,
    String? symbol,
    String? investmentName,
    double? finalValue,
    double? returnPct,
    DateTime? createdAt,
  }) => Saving(
    id: id ?? this.id,
    itemName: itemName ?? this.itemName,
    itemIconName: itemIconName.present ? itemIconName.value : this.itemIconName,
    amount: amount ?? this.amount,
    symbol: symbol ?? this.symbol,
    investmentName: investmentName ?? this.investmentName,
    finalValue: finalValue ?? this.finalValue,
    returnPct: returnPct ?? this.returnPct,
    createdAt: createdAt ?? this.createdAt,
  );
  Saving copyWithCompanion(SavingsCompanion data) {
    return Saving(
      id: data.id.present ? data.id.value : this.id,
      itemName: data.itemName.present ? data.itemName.value : this.itemName,
      itemIconName: data.itemIconName.present
          ? data.itemIconName.value
          : this.itemIconName,
      amount: data.amount.present ? data.amount.value : this.amount,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      investmentName: data.investmentName.present
          ? data.investmentName.value
          : this.investmentName,
      finalValue: data.finalValue.present
          ? data.finalValue.value
          : this.finalValue,
      returnPct: data.returnPct.present ? data.returnPct.value : this.returnPct,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Saving(')
          ..write('id: $id, ')
          ..write('itemName: $itemName, ')
          ..write('itemIconName: $itemIconName, ')
          ..write('amount: $amount, ')
          ..write('symbol: $symbol, ')
          ..write('investmentName: $investmentName, ')
          ..write('finalValue: $finalValue, ')
          ..write('returnPct: $returnPct, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    itemName,
    itemIconName,
    amount,
    symbol,
    investmentName,
    finalValue,
    returnPct,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Saving &&
          other.id == this.id &&
          other.itemName == this.itemName &&
          other.itemIconName == this.itemIconName &&
          other.amount == this.amount &&
          other.symbol == this.symbol &&
          other.investmentName == this.investmentName &&
          other.finalValue == this.finalValue &&
          other.returnPct == this.returnPct &&
          other.createdAt == this.createdAt);
}

class SavingsCompanion extends UpdateCompanion<Saving> {
  final Value<int> id;
  final Value<String> itemName;
  final Value<String?> itemIconName;
  final Value<double> amount;
  final Value<String> symbol;
  final Value<String> investmentName;
  final Value<double> finalValue;
  final Value<double> returnPct;
  final Value<DateTime> createdAt;
  const SavingsCompanion({
    this.id = const Value.absent(),
    this.itemName = const Value.absent(),
    this.itemIconName = const Value.absent(),
    this.amount = const Value.absent(),
    this.symbol = const Value.absent(),
    this.investmentName = const Value.absent(),
    this.finalValue = const Value.absent(),
    this.returnPct = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SavingsCompanion.insert({
    this.id = const Value.absent(),
    required String itemName,
    this.itemIconName = const Value.absent(),
    required double amount,
    required String symbol,
    required String investmentName,
    required double finalValue,
    required double returnPct,
    this.createdAt = const Value.absent(),
  }) : itemName = Value(itemName),
       amount = Value(amount),
       symbol = Value(symbol),
       investmentName = Value(investmentName),
       finalValue = Value(finalValue),
       returnPct = Value(returnPct);
  static Insertable<Saving> custom({
    Expression<int>? id,
    Expression<String>? itemName,
    Expression<String>? itemIconName,
    Expression<double>? amount,
    Expression<String>? symbol,
    Expression<String>? investmentName,
    Expression<double>? finalValue,
    Expression<double>? returnPct,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemName != null) 'item_name': itemName,
      if (itemIconName != null) 'item_icon_name': itemIconName,
      if (amount != null) 'amount': amount,
      if (symbol != null) 'symbol': symbol,
      if (investmentName != null) 'investment_name': investmentName,
      if (finalValue != null) 'final_value': finalValue,
      if (returnPct != null) 'return_pct': returnPct,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SavingsCompanion copyWith({
    Value<int>? id,
    Value<String>? itemName,
    Value<String?>? itemIconName,
    Value<double>? amount,
    Value<String>? symbol,
    Value<String>? investmentName,
    Value<double>? finalValue,
    Value<double>? returnPct,
    Value<DateTime>? createdAt,
  }) {
    return SavingsCompanion(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      itemIconName: itemIconName ?? this.itemIconName,
      amount: amount ?? this.amount,
      symbol: symbol ?? this.symbol,
      investmentName: investmentName ?? this.investmentName,
      finalValue: finalValue ?? this.finalValue,
      returnPct: returnPct ?? this.returnPct,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemName.present) {
      map['item_name'] = Variable<String>(itemName.value);
    }
    if (itemIconName.present) {
      map['item_icon_name'] = Variable<String>(itemIconName.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (investmentName.present) {
      map['investment_name'] = Variable<String>(investmentName.value);
    }
    if (finalValue.present) {
      map['final_value'] = Variable<double>(finalValue.value);
    }
    if (returnPct.present) {
      map['return_pct'] = Variable<double>(returnPct.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsCompanion(')
          ..write('id: $id, ')
          ..write('itemName: $itemName, ')
          ..write('itemIconName: $itemIconName, ')
          ..write('amount: $amount, ')
          ..write('symbol: $symbol, ')
          ..write('investmentName: $investmentName, ')
          ..write('finalValue: $finalValue, ')
          ..write('returnPct: $returnPct, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imagePathMeta = const VerificationMeta(
    'imagePath',
  );
  @override
  late final GeneratedColumn<String> imagePath = GeneratedColumn<String>(
    'image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dobMeta = const VerificationMeta('dob');
  @override
  late final GeneratedColumn<DateTime> dob = GeneratedColumn<DateTime>(
    'dob',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, imagePath, dob, gender];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('image_path')) {
      context.handle(
        _imagePathMeta,
        imagePath.isAcceptableOrUnknown(data['image_path']!, _imagePathMeta),
      );
    }
    if (data.containsKey('dob')) {
      context.handle(
        _dobMeta,
        dob.isAcceptableOrUnknown(data['dob']!, _dobMeta),
      );
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      imagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_path'],
      ),
      dob: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}dob'],
      ),
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String? name;
  final String? imagePath;
  final DateTime? dob;
  final String? gender;
  const Profile({
    required this.id,
    this.name,
    this.imagePath,
    this.dob,
    this.gender,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || imagePath != null) {
      map['image_path'] = Variable<String>(imagePath);
    }
    if (!nullToAbsent || dob != null) {
      map['dob'] = Variable<DateTime>(dob);
    }
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      imagePath: imagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(imagePath),
      dob: dob == null && nullToAbsent ? const Value.absent() : Value(dob),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String?>(json['name']),
      imagePath: serializer.fromJson<String?>(json['imagePath']),
      dob: serializer.fromJson<DateTime?>(json['dob']),
      gender: serializer.fromJson<String?>(json['gender']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String?>(name),
      'imagePath': serializer.toJson<String?>(imagePath),
      'dob': serializer.toJson<DateTime?>(dob),
      'gender': serializer.toJson<String?>(gender),
    };
  }

  Profile copyWith({
    int? id,
    Value<String?> name = const Value.absent(),
    Value<String?> imagePath = const Value.absent(),
    Value<DateTime?> dob = const Value.absent(),
    Value<String?> gender = const Value.absent(),
  }) => Profile(
    id: id ?? this.id,
    name: name.present ? name.value : this.name,
    imagePath: imagePath.present ? imagePath.value : this.imagePath,
    dob: dob.present ? dob.value : this.dob,
    gender: gender.present ? gender.value : this.gender,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      imagePath: data.imagePath.present ? data.imagePath.value : this.imagePath,
      dob: data.dob.present ? data.dob.value : this.dob,
      gender: data.gender.present ? data.gender.value : this.gender,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('dob: $dob, ')
          ..write('gender: $gender')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, imagePath, dob, gender);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.name == this.name &&
          other.imagePath == this.imagePath &&
          other.dob == this.dob &&
          other.gender == this.gender);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String?> name;
  final Value<String?> imagePath;
  final Value<DateTime?> dob;
  final Value<String?> gender;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.dob = const Value.absent(),
    this.gender = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.imagePath = const Value.absent(),
    this.dob = const Value.absent(),
    this.gender = const Value.absent(),
  });
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? imagePath,
    Expression<DateTime>? dob,
    Expression<String>? gender,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (imagePath != null) 'image_path': imagePath,
      if (dob != null) 'dob': dob,
      if (gender != null) 'gender': gender,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String?>? name,
    Value<String?>? imagePath,
    Value<DateTime?>? dob,
    Value<String?>? gender,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      dob: dob ?? this.dob,
      gender: gender ?? this.gender,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (imagePath.present) {
      map['image_path'] = Variable<String>(imagePath.value);
    }
    if (dob.present) {
      map['dob'] = Variable<DateTime>(dob.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('imagePath: $imagePath, ')
          ..write('dob: $dob, ')
          ..write('gender: $gender')
          ..write(')'))
        .toString();
  }
}

class $CatalogItemsTable extends CatalogItems
    with TableInfo<$CatalogItemsTable, CatalogItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emojiMeta = const VerificationMeta('emoji');
  @override
  late final GeneratedColumn<String> emoji = GeneratedColumn<String>(
    'emoji',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _kidSpecificMeta = const VerificationMeta(
    'kidSpecific',
  );
  @override
  late final GeneratedColumn<bool> kidSpecific = GeneratedColumn<bool>(
    'kid_specific',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("kid_specific" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _defaultPriceMeta = const VerificationMeta(
    'defaultPrice',
  );
  @override
  late final GeneratedColumn<double> defaultPrice = GeneratedColumn<double>(
    'default_price',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    emoji,
    iconName,
    description,
    kidSpecific,
    defaultPrice,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('emoji')) {
      context.handle(
        _emojiMeta,
        emoji.isAcceptableOrUnknown(data['emoji']!, _emojiMeta),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('kid_specific')) {
      context.handle(
        _kidSpecificMeta,
        kidSpecific.isAcceptableOrUnknown(
          data['kid_specific']!,
          _kidSpecificMeta,
        ),
      );
    }
    if (data.containsKey('default_price')) {
      context.handle(
        _defaultPriceMeta,
        defaultPrice.isAcceptableOrUnknown(
          data['default_price']!,
          _defaultPriceMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      emoji: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}emoji'],
      ),
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      kidSpecific: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}kid_specific'],
      )!,
      defaultPrice: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}default_price'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CatalogItemsTable createAlias(String alias) {
    return $CatalogItemsTable(attachedDatabase, alias);
  }
}

class CatalogItem extends DataClass implements Insertable<CatalogItem> {
  final int id;
  final String name;
  final String category;
  final String? emoji;
  final String? iconName;
  final String? description;
  final bool kidSpecific;
  final double? defaultPrice;
  final DateTime createdAt;
  const CatalogItem({
    required this.id,
    required this.name,
    required this.category,
    this.emoji,
    this.iconName,
    this.description,
    required this.kidSpecific,
    this.defaultPrice,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || emoji != null) {
      map['emoji'] = Variable<String>(emoji);
    }
    if (!nullToAbsent || iconName != null) {
      map['icon_name'] = Variable<String>(iconName);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['kid_specific'] = Variable<bool>(kidSpecific);
    if (!nullToAbsent || defaultPrice != null) {
      map['default_price'] = Variable<double>(defaultPrice);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CatalogItemsCompanion toCompanion(bool nullToAbsent) {
    return CatalogItemsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      emoji: emoji == null && nullToAbsent
          ? const Value.absent()
          : Value(emoji),
      iconName: iconName == null && nullToAbsent
          ? const Value.absent()
          : Value(iconName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      kidSpecific: Value(kidSpecific),
      defaultPrice: defaultPrice == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultPrice),
      createdAt: Value(createdAt),
    );
  }

  factory CatalogItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      emoji: serializer.fromJson<String?>(json['emoji']),
      iconName: serializer.fromJson<String?>(json['iconName']),
      description: serializer.fromJson<String?>(json['description']),
      kidSpecific: serializer.fromJson<bool>(json['kidSpecific']),
      defaultPrice: serializer.fromJson<double?>(json['defaultPrice']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'emoji': serializer.toJson<String?>(emoji),
      'iconName': serializer.toJson<String?>(iconName),
      'description': serializer.toJson<String?>(description),
      'kidSpecific': serializer.toJson<bool>(kidSpecific),
      'defaultPrice': serializer.toJson<double?>(defaultPrice),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CatalogItem copyWith({
    int? id,
    String? name,
    String? category,
    Value<String?> emoji = const Value.absent(),
    Value<String?> iconName = const Value.absent(),
    Value<String?> description = const Value.absent(),
    bool? kidSpecific,
    Value<double?> defaultPrice = const Value.absent(),
    DateTime? createdAt,
  }) => CatalogItem(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    emoji: emoji.present ? emoji.value : this.emoji,
    iconName: iconName.present ? iconName.value : this.iconName,
    description: description.present ? description.value : this.description,
    kidSpecific: kidSpecific ?? this.kidSpecific,
    defaultPrice: defaultPrice.present ? defaultPrice.value : this.defaultPrice,
    createdAt: createdAt ?? this.createdAt,
  );
  CatalogItem copyWithCompanion(CatalogItemsCompanion data) {
    return CatalogItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      emoji: data.emoji.present ? data.emoji.value : this.emoji,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      description: data.description.present
          ? data.description.value
          : this.description,
      kidSpecific: data.kidSpecific.present
          ? data.kidSpecific.value
          : this.kidSpecific,
      defaultPrice: data.defaultPrice.present
          ? data.defaultPrice.value
          : this.defaultPrice,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('emoji: $emoji, ')
          ..write('iconName: $iconName, ')
          ..write('description: $description, ')
          ..write('kidSpecific: $kidSpecific, ')
          ..write('defaultPrice: $defaultPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    emoji,
    iconName,
    description,
    kidSpecific,
    defaultPrice,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.emoji == this.emoji &&
          other.iconName == this.iconName &&
          other.description == this.description &&
          other.kidSpecific == this.kidSpecific &&
          other.defaultPrice == this.defaultPrice &&
          other.createdAt == this.createdAt);
}

class CatalogItemsCompanion extends UpdateCompanion<CatalogItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<String?> emoji;
  final Value<String?> iconName;
  final Value<String?> description;
  final Value<bool> kidSpecific;
  final Value<double?> defaultPrice;
  final Value<DateTime> createdAt;
  const CatalogItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.emoji = const Value.absent(),
    this.iconName = const Value.absent(),
    this.description = const Value.absent(),
    this.kidSpecific = const Value.absent(),
    this.defaultPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CatalogItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    this.emoji = const Value.absent(),
    this.iconName = const Value.absent(),
    this.description = const Value.absent(),
    this.kidSpecific = const Value.absent(),
    this.defaultPrice = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name),
       category = Value(category);
  static Insertable<CatalogItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<String>? emoji,
    Expression<String>? iconName,
    Expression<String>? description,
    Expression<bool>? kidSpecific,
    Expression<double>? defaultPrice,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (emoji != null) 'emoji': emoji,
      if (iconName != null) 'icon_name': iconName,
      if (description != null) 'description': description,
      if (kidSpecific != null) 'kid_specific': kidSpecific,
      if (defaultPrice != null) 'default_price': defaultPrice,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CatalogItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<String?>? emoji,
    Value<String?>? iconName,
    Value<String?>? description,
    Value<bool>? kidSpecific,
    Value<double?>? defaultPrice,
    Value<DateTime>? createdAt,
  }) {
    return CatalogItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      emoji: emoji ?? this.emoji,
      iconName: iconName ?? this.iconName,
      description: description ?? this.description,
      kidSpecific: kidSpecific ?? this.kidSpecific,
      defaultPrice: defaultPrice ?? this.defaultPrice,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (emoji.present) {
      map['emoji'] = Variable<String>(emoji.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (kidSpecific.present) {
      map['kid_specific'] = Variable<bool>(kidSpecific.value);
    }
    if (defaultPrice.present) {
      map['default_price'] = Variable<double>(defaultPrice.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('emoji: $emoji, ')
          ..write('iconName: $iconName, ')
          ..write('description: $description, ')
          ..write('kidSpecific: $kidSpecific, ')
          ..write('defaultPrice: $defaultPrice, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $MarketCacheTable extends MarketCache
    with TableInfo<$MarketCacheTable, MarketCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarketCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
    'symbol',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _closesJsonMeta = const VerificationMeta(
    'closesJson',
  );
  @override
  late final GeneratedColumn<String> closesJson = GeneratedColumn<String>(
    'closes_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [symbol, updatedAt, closesJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'market_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<MarketCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('symbol')) {
      context.handle(
        _symbolMeta,
        symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta),
      );
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('closes_json')) {
      context.handle(
        _closesJsonMeta,
        closesJson.isAcceptableOrUnknown(data['closes_json']!, _closesJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_closesJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {symbol};
  @override
  MarketCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarketCacheData(
      symbol: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}symbol'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      closesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}closes_json'],
      )!,
    );
  }

  @override
  $MarketCacheTable createAlias(String alias) {
    return $MarketCacheTable(attachedDatabase, alias);
  }
}

class MarketCacheData extends DataClass implements Insertable<MarketCacheData> {
  final String symbol;
  final DateTime updatedAt;
  final String closesJson;
  const MarketCacheData({
    required this.symbol,
    required this.updatedAt,
    required this.closesJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['symbol'] = Variable<String>(symbol);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    map['closes_json'] = Variable<String>(closesJson);
    return map;
  }

  MarketCacheCompanion toCompanion(bool nullToAbsent) {
    return MarketCacheCompanion(
      symbol: Value(symbol),
      updatedAt: Value(updatedAt),
      closesJson: Value(closesJson),
    );
  }

  factory MarketCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarketCacheData(
      symbol: serializer.fromJson<String>(json['symbol']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      closesJson: serializer.fromJson<String>(json['closesJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'symbol': serializer.toJson<String>(symbol),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'closesJson': serializer.toJson<String>(closesJson),
    };
  }

  MarketCacheData copyWith({
    String? symbol,
    DateTime? updatedAt,
    String? closesJson,
  }) => MarketCacheData(
    symbol: symbol ?? this.symbol,
    updatedAt: updatedAt ?? this.updatedAt,
    closesJson: closesJson ?? this.closesJson,
  );
  MarketCacheData copyWithCompanion(MarketCacheCompanion data) {
    return MarketCacheData(
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      closesJson: data.closesJson.present
          ? data.closesJson.value
          : this.closesJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarketCacheData(')
          ..write('symbol: $symbol, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('closesJson: $closesJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(symbol, updatedAt, closesJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarketCacheData &&
          other.symbol == this.symbol &&
          other.updatedAt == this.updatedAt &&
          other.closesJson == this.closesJson);
}

class MarketCacheCompanion extends UpdateCompanion<MarketCacheData> {
  final Value<String> symbol;
  final Value<DateTime> updatedAt;
  final Value<String> closesJson;
  final Value<int> rowid;
  const MarketCacheCompanion({
    this.symbol = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.closesJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MarketCacheCompanion.insert({
    required String symbol,
    required DateTime updatedAt,
    required String closesJson,
    this.rowid = const Value.absent(),
  }) : symbol = Value(symbol),
       updatedAt = Value(updatedAt),
       closesJson = Value(closesJson);
  static Insertable<MarketCacheData> custom({
    Expression<String>? symbol,
    Expression<DateTime>? updatedAt,
    Expression<String>? closesJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (symbol != null) 'symbol': symbol,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (closesJson != null) 'closes_json': closesJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MarketCacheCompanion copyWith({
    Value<String>? symbol,
    Value<DateTime>? updatedAt,
    Value<String>? closesJson,
    Value<int>? rowid,
  }) {
    return MarketCacheCompanion(
      symbol: symbol ?? this.symbol,
      updatedAt: updatedAt ?? this.updatedAt,
      closesJson: closesJson ?? this.closesJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (closesJson.present) {
      map['closes_json'] = Variable<String>(closesJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarketCacheCompanion(')
          ..write('symbol: $symbol, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('closesJson: $closesJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  $AppDbManager get managers => $AppDbManager(this);
  late final $SavingsTable savings = $SavingsTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $CatalogItemsTable catalogItems = $CatalogItemsTable(this);
  late final $MarketCacheTable marketCache = $MarketCacheTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    savings,
    profiles,
    catalogItems,
    marketCache,
  ];
}

typedef $$SavingsTableCreateCompanionBuilder =
    SavingsCompanion Function({
      Value<int> id,
      required String itemName,
      Value<String?> itemIconName,
      required double amount,
      required String symbol,
      required String investmentName,
      required double finalValue,
      required double returnPct,
      Value<DateTime> createdAt,
    });
typedef $$SavingsTableUpdateCompanionBuilder =
    SavingsCompanion Function({
      Value<int> id,
      Value<String> itemName,
      Value<String?> itemIconName,
      Value<double> amount,
      Value<String> symbol,
      Value<String> investmentName,
      Value<double> finalValue,
      Value<double> returnPct,
      Value<DateTime> createdAt,
    });

class $$SavingsTableFilterComposer extends Composer<_$AppDb, $SavingsTable> {
  $$SavingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemIconName => $composableBuilder(
    column: $table.itemIconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get investmentName => $composableBuilder(
    column: $table.investmentName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get finalValue => $composableBuilder(
    column: $table.finalValue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get returnPct => $composableBuilder(
    column: $table.returnPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SavingsTableOrderingComposer extends Composer<_$AppDb, $SavingsTable> {
  $$SavingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemName => $composableBuilder(
    column: $table.itemName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemIconName => $composableBuilder(
    column: $table.itemIconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get investmentName => $composableBuilder(
    column: $table.investmentName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get finalValue => $composableBuilder(
    column: $table.finalValue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get returnPct => $composableBuilder(
    column: $table.returnPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SavingsTableAnnotationComposer
    extends Composer<_$AppDb, $SavingsTable> {
  $$SavingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemName =>
      $composableBuilder(column: $table.itemName, builder: (column) => column);

  GeneratedColumn<String> get itemIconName => $composableBuilder(
    column: $table.itemIconName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get investmentName => $composableBuilder(
    column: $table.investmentName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get finalValue => $composableBuilder(
    column: $table.finalValue,
    builder: (column) => column,
  );

  GeneratedColumn<double> get returnPct =>
      $composableBuilder(column: $table.returnPct, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SavingsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $SavingsTable,
          Saving,
          $$SavingsTableFilterComposer,
          $$SavingsTableOrderingComposer,
          $$SavingsTableAnnotationComposer,
          $$SavingsTableCreateCompanionBuilder,
          $$SavingsTableUpdateCompanionBuilder,
          (Saving, BaseReferences<_$AppDb, $SavingsTable, Saving>),
          Saving,
          PrefetchHooks Function()
        > {
  $$SavingsTableTableManager(_$AppDb db, $SavingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> itemName = const Value.absent(),
                Value<String?> itemIconName = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<String> symbol = const Value.absent(),
                Value<String> investmentName = const Value.absent(),
                Value<double> finalValue = const Value.absent(),
                Value<double> returnPct = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsCompanion(
                id: id,
                itemName: itemName,
                itemIconName: itemIconName,
                amount: amount,
                symbol: symbol,
                investmentName: investmentName,
                finalValue: finalValue,
                returnPct: returnPct,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String itemName,
                Value<String?> itemIconName = const Value.absent(),
                required double amount,
                required String symbol,
                required String investmentName,
                required double finalValue,
                required double returnPct,
                Value<DateTime> createdAt = const Value.absent(),
              }) => SavingsCompanion.insert(
                id: id,
                itemName: itemName,
                itemIconName: itemIconName,
                amount: amount,
                symbol: symbol,
                investmentName: investmentName,
                finalValue: finalValue,
                returnPct: returnPct,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SavingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $SavingsTable,
      Saving,
      $$SavingsTableFilterComposer,
      $$SavingsTableOrderingComposer,
      $$SavingsTableAnnotationComposer,
      $$SavingsTableCreateCompanionBuilder,
      $$SavingsTableUpdateCompanionBuilder,
      (Saving, BaseReferences<_$AppDb, $SavingsTable, Saving>),
      Saving,
      PrefetchHooks Function()
    >;
typedef $$ProfilesTableCreateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> imagePath,
      Value<DateTime?> dob,
      Value<String?> gender,
    });
typedef $$ProfilesTableUpdateCompanionBuilder =
    ProfilesCompanion Function({
      Value<int> id,
      Value<String?> name,
      Value<String?> imagePath,
      Value<DateTime?> dob,
      Value<String?> gender,
    });

class $$ProfilesTableFilterComposer extends Composer<_$AppDb, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDb, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imagePath => $composableBuilder(
    column: $table.imagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dob => $composableBuilder(
    column: $table.dob,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDb, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get imagePath =>
      $composableBuilder(column: $table.imagePath, builder: (column) => column);

  GeneratedColumn<DateTime> get dob =>
      $composableBuilder(column: $table.dob, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDb, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDb db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<DateTime?> dob = const Value.absent(),
                Value<String?> gender = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                name: name,
                imagePath: imagePath,
                dob: dob,
                gender: gender,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<String?> imagePath = const Value.absent(),
                Value<DateTime?> dob = const Value.absent(),
                Value<String?> gender = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                name: name,
                imagePath: imagePath,
                dob: dob,
                gender: gender,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDb, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$CatalogItemsTableCreateCompanionBuilder =
    CatalogItemsCompanion Function({
      Value<int> id,
      required String name,
      required String category,
      Value<String?> emoji,
      Value<String?> iconName,
      Value<String?> description,
      Value<bool> kidSpecific,
      Value<double?> defaultPrice,
      Value<DateTime> createdAt,
    });
typedef $$CatalogItemsTableUpdateCompanionBuilder =
    CatalogItemsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> category,
      Value<String?> emoji,
      Value<String?> iconName,
      Value<String?> description,
      Value<bool> kidSpecific,
      Value<double?> defaultPrice,
      Value<DateTime> createdAt,
    });

class $$CatalogItemsTableFilterComposer
    extends Composer<_$AppDb, $CatalogItemsTable> {
  $$CatalogItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get kidSpecific => $composableBuilder(
    column: $table.kidSpecific,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get defaultPrice => $composableBuilder(
    column: $table.defaultPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogItemsTableOrderingComposer
    extends Composer<_$AppDb, $CatalogItemsTable> {
  $$CatalogItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get emoji => $composableBuilder(
    column: $table.emoji,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get kidSpecific => $composableBuilder(
    column: $table.kidSpecific,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get defaultPrice => $composableBuilder(
    column: $table.defaultPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogItemsTableAnnotationComposer
    extends Composer<_$AppDb, $CatalogItemsTable> {
  $$CatalogItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get emoji =>
      $composableBuilder(column: $table.emoji, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get kidSpecific => $composableBuilder(
    column: $table.kidSpecific,
    builder: (column) => column,
  );

  GeneratedColumn<double> get defaultPrice => $composableBuilder(
    column: $table.defaultPrice,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CatalogItemsTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $CatalogItemsTable,
          CatalogItem,
          $$CatalogItemsTableFilterComposer,
          $$CatalogItemsTableOrderingComposer,
          $$CatalogItemsTableAnnotationComposer,
          $$CatalogItemsTableCreateCompanionBuilder,
          $$CatalogItemsTableUpdateCompanionBuilder,
          (
            CatalogItem,
            BaseReferences<_$AppDb, $CatalogItemsTable, CatalogItem>,
          ),
          CatalogItem,
          PrefetchHooks Function()
        > {
  $$CatalogItemsTableTableManager(_$AppDb db, $CatalogItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> emoji = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> kidSpecific = const Value.absent(),
                Value<double?> defaultPrice = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CatalogItemsCompanion(
                id: id,
                name: name,
                category: category,
                emoji: emoji,
                iconName: iconName,
                description: description,
                kidSpecific: kidSpecific,
                defaultPrice: defaultPrice,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                Value<String?> emoji = const Value.absent(),
                Value<String?> iconName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> kidSpecific = const Value.absent(),
                Value<double?> defaultPrice = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CatalogItemsCompanion.insert(
                id: id,
                name: name,
                category: category,
                emoji: emoji,
                iconName: iconName,
                description: description,
                kidSpecific: kidSpecific,
                defaultPrice: defaultPrice,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $CatalogItemsTable,
      CatalogItem,
      $$CatalogItemsTableFilterComposer,
      $$CatalogItemsTableOrderingComposer,
      $$CatalogItemsTableAnnotationComposer,
      $$CatalogItemsTableCreateCompanionBuilder,
      $$CatalogItemsTableUpdateCompanionBuilder,
      (CatalogItem, BaseReferences<_$AppDb, $CatalogItemsTable, CatalogItem>),
      CatalogItem,
      PrefetchHooks Function()
    >;
typedef $$MarketCacheTableCreateCompanionBuilder =
    MarketCacheCompanion Function({
      required String symbol,
      required DateTime updatedAt,
      required String closesJson,
      Value<int> rowid,
    });
typedef $$MarketCacheTableUpdateCompanionBuilder =
    MarketCacheCompanion Function({
      Value<String> symbol,
      Value<DateTime> updatedAt,
      Value<String> closesJson,
      Value<int> rowid,
    });

class $$MarketCacheTableFilterComposer
    extends Composer<_$AppDb, $MarketCacheTable> {
  $$MarketCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get closesJson => $composableBuilder(
    column: $table.closesJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MarketCacheTableOrderingComposer
    extends Composer<_$AppDb, $MarketCacheTable> {
  $$MarketCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get symbol => $composableBuilder(
    column: $table.symbol,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get closesJson => $composableBuilder(
    column: $table.closesJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MarketCacheTableAnnotationComposer
    extends Composer<_$AppDb, $MarketCacheTable> {
  $$MarketCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<String> get closesJson => $composableBuilder(
    column: $table.closesJson,
    builder: (column) => column,
  );
}

class $$MarketCacheTableTableManager
    extends
        RootTableManager<
          _$AppDb,
          $MarketCacheTable,
          MarketCacheData,
          $$MarketCacheTableFilterComposer,
          $$MarketCacheTableOrderingComposer,
          $$MarketCacheTableAnnotationComposer,
          $$MarketCacheTableCreateCompanionBuilder,
          $$MarketCacheTableUpdateCompanionBuilder,
          (
            MarketCacheData,
            BaseReferences<_$AppDb, $MarketCacheTable, MarketCacheData>,
          ),
          MarketCacheData,
          PrefetchHooks Function()
        > {
  $$MarketCacheTableTableManager(_$AppDb db, $MarketCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> symbol = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<String> closesJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MarketCacheCompanion(
                symbol: symbol,
                updatedAt: updatedAt,
                closesJson: closesJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String symbol,
                required DateTime updatedAt,
                required String closesJson,
                Value<int> rowid = const Value.absent(),
              }) => MarketCacheCompanion.insert(
                symbol: symbol,
                updatedAt: updatedAt,
                closesJson: closesJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MarketCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDb,
      $MarketCacheTable,
      MarketCacheData,
      $$MarketCacheTableFilterComposer,
      $$MarketCacheTableOrderingComposer,
      $$MarketCacheTableAnnotationComposer,
      $$MarketCacheTableCreateCompanionBuilder,
      $$MarketCacheTableUpdateCompanionBuilder,
      (
        MarketCacheData,
        BaseReferences<_$AppDb, $MarketCacheTable, MarketCacheData>,
      ),
      MarketCacheData,
      PrefetchHooks Function()
    >;

class $AppDbManager {
  final _$AppDb _db;
  $AppDbManager(this._db);
  $$SavingsTableTableManager get savings =>
      $$SavingsTableTableManager(_db, _db.savings);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$CatalogItemsTableTableManager get catalogItems =>
      $$CatalogItemsTableTableManager(_db, _db.catalogItems);
  $$MarketCacheTableTableManager get marketCache =>
      $$MarketCacheTableTableManager(_db, _db.marketCache);
}
