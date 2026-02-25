// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CourtsTable extends Courts with TableInfo<$CourtsTable, Court> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CourtsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _hierarchyMeta = const VerificationMeta(
    'hierarchy',
  );
  @override
  late final GeneratedColumn<String> hierarchy = GeneratedColumn<String>(
    'hierarchy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, hierarchy, city];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'courts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Court> instance, {
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
    if (data.containsKey('hierarchy')) {
      context.handle(
        _hierarchyMeta,
        hierarchy.isAcceptableOrUnknown(data['hierarchy']!, _hierarchyMeta),
      );
    } else if (isInserting) {
      context.missing(_hierarchyMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Court map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Court(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      hierarchy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hierarchy'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      ),
    );
  }

  @override
  $CourtsTable createAlias(String alias) {
    return $CourtsTable(attachedDatabase, alias);
  }
}

class Court extends DataClass implements Insertable<Court> {
  final int id;
  final String name;
  final String hierarchy;
  final String? city;
  const Court({
    required this.id,
    required this.name,
    required this.hierarchy,
    this.city,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['hierarchy'] = Variable<String>(hierarchy);
    if (!nullToAbsent || city != null) {
      map['city'] = Variable<String>(city);
    }
    return map;
  }

  CourtsCompanion toCompanion(bool nullToAbsent) {
    return CourtsCompanion(
      id: Value(id),
      name: Value(name),
      hierarchy: Value(hierarchy),
      city: city == null && nullToAbsent ? const Value.absent() : Value(city),
    );
  }

  factory Court.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Court(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      hierarchy: serializer.fromJson<String>(json['hierarchy']),
      city: serializer.fromJson<String?>(json['city']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'hierarchy': serializer.toJson<String>(hierarchy),
      'city': serializer.toJson<String?>(city),
    };
  }

  Court copyWith({
    int? id,
    String? name,
    String? hierarchy,
    Value<String?> city = const Value.absent(),
  }) => Court(
    id: id ?? this.id,
    name: name ?? this.name,
    hierarchy: hierarchy ?? this.hierarchy,
    city: city.present ? city.value : this.city,
  );
  Court copyWithCompanion(CourtsCompanion data) {
    return Court(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      hierarchy: data.hierarchy.present ? data.hierarchy.value : this.hierarchy,
      city: data.city.present ? data.city.value : this.city,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Court(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hierarchy: $hierarchy, ')
          ..write('city: $city')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, hierarchy, city);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Court &&
          other.id == this.id &&
          other.name == this.name &&
          other.hierarchy == this.hierarchy &&
          other.city == this.city);
}

class CourtsCompanion extends UpdateCompanion<Court> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> hierarchy;
  final Value<String?> city;
  const CourtsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.hierarchy = const Value.absent(),
    this.city = const Value.absent(),
  });
  CourtsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String hierarchy,
    this.city = const Value.absent(),
  }) : name = Value(name),
       hierarchy = Value(hierarchy);
  static Insertable<Court> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? hierarchy,
    Expression<String>? city,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (hierarchy != null) 'hierarchy': hierarchy,
      if (city != null) 'city': city,
    });
  }

  CourtsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? hierarchy,
    Value<String?>? city,
  }) {
    return CourtsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      hierarchy: hierarchy ?? this.hierarchy,
      city: city ?? this.city,
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
    if (hierarchy.present) {
      map['hierarchy'] = Variable<String>(hierarchy.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CourtsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('hierarchy: $hierarchy, ')
          ..write('city: $city')
          ..write(')'))
        .toString();
  }
}

class $CasesTable extends Cases with TableInfo<$CasesTable, Case> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CasesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caseTypeMeta = const VerificationMeta(
    'caseType',
  );
  @override
  late final GeneratedColumn<String> caseType = GeneratedColumn<String>(
    'case_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Active'),
  );
  static const VerificationMeta _registrationNumberMeta =
      const VerificationMeta('registrationNumber');
  @override
  late final GeneratedColumn<String> registrationNumber =
      GeneratedColumn<String>(
        'registration_number',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _dateFiledMeta = const VerificationMeta(
    'dateFiled',
  );
  @override
  late final GeneratedColumn<String> dateFiled = GeneratedColumn<String>(
    'date_filed',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _courtIdMeta = const VerificationMeta(
    'courtId',
  );
  @override
  late final GeneratedColumn<int> courtId = GeneratedColumn<int>(
    'court_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES courts (id)',
    ),
  );
  static const VerificationMeta _benchMeta = const VerificationMeta('bench');
  @override
  late final GeneratedColumn<String> bench = GeneratedColumn<String>(
    'bench',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _courtroomNumberMeta = const VerificationMeta(
    'courtroomNumber',
  );
  @override
  late final GeneratedColumn<String> courtroomNumber = GeneratedColumn<String>(
    'courtroom_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientNameMeta = const VerificationMeta(
    'clientName',
  );
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientPhoneMeta = const VerificationMeta(
    'clientPhone',
  );
  @override
  late final GeneratedColumn<String> clientPhone = GeneratedColumn<String>(
    'client_phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientCnicMeta = const VerificationMeta(
    'clientCnic',
  );
  @override
  late final GeneratedColumn<String> clientCnic = GeneratedColumn<String>(
    'client_cnic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientAddressMeta = const VerificationMeta(
    'clientAddress',
  );
  @override
  late final GeneratedColumn<String> clientAddress = GeneratedColumn<String>(
    'client_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oppositePartyMeta = const VerificationMeta(
    'oppositeParty',
  );
  @override
  late final GeneratedColumn<String> oppositeParty = GeneratedColumn<String>(
    'opposite_party',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _oppositeCounselMeta = const VerificationMeta(
    'oppositeCounsel',
  );
  @override
  late final GeneratedColumn<String> oppositeCounsel = GeneratedColumn<String>(
    'opposite_counsel',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<String> updatedAt = GeneratedColumn<String>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    caseType,
    status,
    registrationNumber,
    dateFiled,
    courtId,
    bench,
    courtroomNumber,
    clientName,
    clientPhone,
    clientCnic,
    clientAddress,
    oppositeParty,
    oppositeCounsel,
    notes,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cases';
  @override
  VerificationContext validateIntegrity(
    Insertable<Case> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('case_type')) {
      context.handle(
        _caseTypeMeta,
        caseType.isAcceptableOrUnknown(data['case_type']!, _caseTypeMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('registration_number')) {
      context.handle(
        _registrationNumberMeta,
        registrationNumber.isAcceptableOrUnknown(
          data['registration_number']!,
          _registrationNumberMeta,
        ),
      );
    }
    if (data.containsKey('date_filed')) {
      context.handle(
        _dateFiledMeta,
        dateFiled.isAcceptableOrUnknown(data['date_filed']!, _dateFiledMeta),
      );
    }
    if (data.containsKey('court_id')) {
      context.handle(
        _courtIdMeta,
        courtId.isAcceptableOrUnknown(data['court_id']!, _courtIdMeta),
      );
    }
    if (data.containsKey('bench')) {
      context.handle(
        _benchMeta,
        bench.isAcceptableOrUnknown(data['bench']!, _benchMeta),
      );
    }
    if (data.containsKey('courtroom_number')) {
      context.handle(
        _courtroomNumberMeta,
        courtroomNumber.isAcceptableOrUnknown(
          data['courtroom_number']!,
          _courtroomNumberMeta,
        ),
      );
    }
    if (data.containsKey('client_name')) {
      context.handle(
        _clientNameMeta,
        clientName.isAcceptableOrUnknown(data['client_name']!, _clientNameMeta),
      );
    }
    if (data.containsKey('client_phone')) {
      context.handle(
        _clientPhoneMeta,
        clientPhone.isAcceptableOrUnknown(
          data['client_phone']!,
          _clientPhoneMeta,
        ),
      );
    }
    if (data.containsKey('client_cnic')) {
      context.handle(
        _clientCnicMeta,
        clientCnic.isAcceptableOrUnknown(data['client_cnic']!, _clientCnicMeta),
      );
    }
    if (data.containsKey('client_address')) {
      context.handle(
        _clientAddressMeta,
        clientAddress.isAcceptableOrUnknown(
          data['client_address']!,
          _clientAddressMeta,
        ),
      );
    }
    if (data.containsKey('opposite_party')) {
      context.handle(
        _oppositePartyMeta,
        oppositeParty.isAcceptableOrUnknown(
          data['opposite_party']!,
          _oppositePartyMeta,
        ),
      );
    }
    if (data.containsKey('opposite_counsel')) {
      context.handle(
        _oppositeCounselMeta,
        oppositeCounsel.isAcceptableOrUnknown(
          data['opposite_counsel']!,
          _oppositeCounselMeta,
        ),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Case map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Case(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      caseType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}case_type'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      registrationNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}registration_number'],
      ),
      dateFiled: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date_filed'],
      ),
      courtId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}court_id'],
      ),
      bench: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bench'],
      ),
      courtroomNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}courtroom_number'],
      ),
      clientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_name'],
      ),
      clientPhone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_phone'],
      ),
      clientCnic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_cnic'],
      ),
      clientAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_address'],
      ),
      oppositeParty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opposite_party'],
      ),
      oppositeCounsel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}opposite_counsel'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CasesTable createAlias(String alias) {
    return $CasesTable(attachedDatabase, alias);
  }
}

class Case extends DataClass implements Insertable<Case> {
  final int id;
  final String title;
  final String? caseType;
  final String status;
  final String? registrationNumber;
  final String? dateFiled;
  final int? courtId;
  final String? bench;
  final String? courtroomNumber;
  final String? clientName;
  final String? clientPhone;
  final String? clientCnic;
  final String? clientAddress;
  final String? oppositeParty;
  final String? oppositeCounsel;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  const Case({
    required this.id,
    required this.title,
    this.caseType,
    required this.status,
    this.registrationNumber,
    this.dateFiled,
    this.courtId,
    this.bench,
    this.courtroomNumber,
    this.clientName,
    this.clientPhone,
    this.clientCnic,
    this.clientAddress,
    this.oppositeParty,
    this.oppositeCounsel,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || caseType != null) {
      map['case_type'] = Variable<String>(caseType);
    }
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || registrationNumber != null) {
      map['registration_number'] = Variable<String>(registrationNumber);
    }
    if (!nullToAbsent || dateFiled != null) {
      map['date_filed'] = Variable<String>(dateFiled);
    }
    if (!nullToAbsent || courtId != null) {
      map['court_id'] = Variable<int>(courtId);
    }
    if (!nullToAbsent || bench != null) {
      map['bench'] = Variable<String>(bench);
    }
    if (!nullToAbsent || courtroomNumber != null) {
      map['courtroom_number'] = Variable<String>(courtroomNumber);
    }
    if (!nullToAbsent || clientName != null) {
      map['client_name'] = Variable<String>(clientName);
    }
    if (!nullToAbsent || clientPhone != null) {
      map['client_phone'] = Variable<String>(clientPhone);
    }
    if (!nullToAbsent || clientCnic != null) {
      map['client_cnic'] = Variable<String>(clientCnic);
    }
    if (!nullToAbsent || clientAddress != null) {
      map['client_address'] = Variable<String>(clientAddress);
    }
    if (!nullToAbsent || oppositeParty != null) {
      map['opposite_party'] = Variable<String>(oppositeParty);
    }
    if (!nullToAbsent || oppositeCounsel != null) {
      map['opposite_counsel'] = Variable<String>(oppositeCounsel);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<String>(createdAt);
    map['updated_at'] = Variable<String>(updatedAt);
    return map;
  }

  CasesCompanion toCompanion(bool nullToAbsent) {
    return CasesCompanion(
      id: Value(id),
      title: Value(title),
      caseType: caseType == null && nullToAbsent
          ? const Value.absent()
          : Value(caseType),
      status: Value(status),
      registrationNumber: registrationNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(registrationNumber),
      dateFiled: dateFiled == null && nullToAbsent
          ? const Value.absent()
          : Value(dateFiled),
      courtId: courtId == null && nullToAbsent
          ? const Value.absent()
          : Value(courtId),
      bench: bench == null && nullToAbsent
          ? const Value.absent()
          : Value(bench),
      courtroomNumber: courtroomNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(courtroomNumber),
      clientName: clientName == null && nullToAbsent
          ? const Value.absent()
          : Value(clientName),
      clientPhone: clientPhone == null && nullToAbsent
          ? const Value.absent()
          : Value(clientPhone),
      clientCnic: clientCnic == null && nullToAbsent
          ? const Value.absent()
          : Value(clientCnic),
      clientAddress: clientAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(clientAddress),
      oppositeParty: oppositeParty == null && nullToAbsent
          ? const Value.absent()
          : Value(oppositeParty),
      oppositeCounsel: oppositeCounsel == null && nullToAbsent
          ? const Value.absent()
          : Value(oppositeCounsel),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Case.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Case(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      caseType: serializer.fromJson<String?>(json['caseType']),
      status: serializer.fromJson<String>(json['status']),
      registrationNumber: serializer.fromJson<String?>(
        json['registrationNumber'],
      ),
      dateFiled: serializer.fromJson<String?>(json['dateFiled']),
      courtId: serializer.fromJson<int?>(json['courtId']),
      bench: serializer.fromJson<String?>(json['bench']),
      courtroomNumber: serializer.fromJson<String?>(json['courtroomNumber']),
      clientName: serializer.fromJson<String?>(json['clientName']),
      clientPhone: serializer.fromJson<String?>(json['clientPhone']),
      clientCnic: serializer.fromJson<String?>(json['clientCnic']),
      clientAddress: serializer.fromJson<String?>(json['clientAddress']),
      oppositeParty: serializer.fromJson<String?>(json['oppositeParty']),
      oppositeCounsel: serializer.fromJson<String?>(json['oppositeCounsel']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
      updatedAt: serializer.fromJson<String>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'caseType': serializer.toJson<String?>(caseType),
      'status': serializer.toJson<String>(status),
      'registrationNumber': serializer.toJson<String?>(registrationNumber),
      'dateFiled': serializer.toJson<String?>(dateFiled),
      'courtId': serializer.toJson<int?>(courtId),
      'bench': serializer.toJson<String?>(bench),
      'courtroomNumber': serializer.toJson<String?>(courtroomNumber),
      'clientName': serializer.toJson<String?>(clientName),
      'clientPhone': serializer.toJson<String?>(clientPhone),
      'clientCnic': serializer.toJson<String?>(clientCnic),
      'clientAddress': serializer.toJson<String?>(clientAddress),
      'oppositeParty': serializer.toJson<String?>(oppositeParty),
      'oppositeCounsel': serializer.toJson<String?>(oppositeCounsel),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<String>(createdAt),
      'updatedAt': serializer.toJson<String>(updatedAt),
    };
  }

  Case copyWith({
    int? id,
    String? title,
    Value<String?> caseType = const Value.absent(),
    String? status,
    Value<String?> registrationNumber = const Value.absent(),
    Value<String?> dateFiled = const Value.absent(),
    Value<int?> courtId = const Value.absent(),
    Value<String?> bench = const Value.absent(),
    Value<String?> courtroomNumber = const Value.absent(),
    Value<String?> clientName = const Value.absent(),
    Value<String?> clientPhone = const Value.absent(),
    Value<String?> clientCnic = const Value.absent(),
    Value<String?> clientAddress = const Value.absent(),
    Value<String?> oppositeParty = const Value.absent(),
    Value<String?> oppositeCounsel = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? createdAt,
    String? updatedAt,
  }) => Case(
    id: id ?? this.id,
    title: title ?? this.title,
    caseType: caseType.present ? caseType.value : this.caseType,
    status: status ?? this.status,
    registrationNumber: registrationNumber.present
        ? registrationNumber.value
        : this.registrationNumber,
    dateFiled: dateFiled.present ? dateFiled.value : this.dateFiled,
    courtId: courtId.present ? courtId.value : this.courtId,
    bench: bench.present ? bench.value : this.bench,
    courtroomNumber: courtroomNumber.present
        ? courtroomNumber.value
        : this.courtroomNumber,
    clientName: clientName.present ? clientName.value : this.clientName,
    clientPhone: clientPhone.present ? clientPhone.value : this.clientPhone,
    clientCnic: clientCnic.present ? clientCnic.value : this.clientCnic,
    clientAddress: clientAddress.present
        ? clientAddress.value
        : this.clientAddress,
    oppositeParty: oppositeParty.present
        ? oppositeParty.value
        : this.oppositeParty,
    oppositeCounsel: oppositeCounsel.present
        ? oppositeCounsel.value
        : this.oppositeCounsel,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Case copyWithCompanion(CasesCompanion data) {
    return Case(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      caseType: data.caseType.present ? data.caseType.value : this.caseType,
      status: data.status.present ? data.status.value : this.status,
      registrationNumber: data.registrationNumber.present
          ? data.registrationNumber.value
          : this.registrationNumber,
      dateFiled: data.dateFiled.present ? data.dateFiled.value : this.dateFiled,
      courtId: data.courtId.present ? data.courtId.value : this.courtId,
      bench: data.bench.present ? data.bench.value : this.bench,
      courtroomNumber: data.courtroomNumber.present
          ? data.courtroomNumber.value
          : this.courtroomNumber,
      clientName: data.clientName.present
          ? data.clientName.value
          : this.clientName,
      clientPhone: data.clientPhone.present
          ? data.clientPhone.value
          : this.clientPhone,
      clientCnic: data.clientCnic.present
          ? data.clientCnic.value
          : this.clientCnic,
      clientAddress: data.clientAddress.present
          ? data.clientAddress.value
          : this.clientAddress,
      oppositeParty: data.oppositeParty.present
          ? data.oppositeParty.value
          : this.oppositeParty,
      oppositeCounsel: data.oppositeCounsel.present
          ? data.oppositeCounsel.value
          : this.oppositeCounsel,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Case(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('caseType: $caseType, ')
          ..write('status: $status, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('dateFiled: $dateFiled, ')
          ..write('courtId: $courtId, ')
          ..write('bench: $bench, ')
          ..write('courtroomNumber: $courtroomNumber, ')
          ..write('clientName: $clientName, ')
          ..write('clientPhone: $clientPhone, ')
          ..write('clientCnic: $clientCnic, ')
          ..write('clientAddress: $clientAddress, ')
          ..write('oppositeParty: $oppositeParty, ')
          ..write('oppositeCounsel: $oppositeCounsel, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    caseType,
    status,
    registrationNumber,
    dateFiled,
    courtId,
    bench,
    courtroomNumber,
    clientName,
    clientPhone,
    clientCnic,
    clientAddress,
    oppositeParty,
    oppositeCounsel,
    notes,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Case &&
          other.id == this.id &&
          other.title == this.title &&
          other.caseType == this.caseType &&
          other.status == this.status &&
          other.registrationNumber == this.registrationNumber &&
          other.dateFiled == this.dateFiled &&
          other.courtId == this.courtId &&
          other.bench == this.bench &&
          other.courtroomNumber == this.courtroomNumber &&
          other.clientName == this.clientName &&
          other.clientPhone == this.clientPhone &&
          other.clientCnic == this.clientCnic &&
          other.clientAddress == this.clientAddress &&
          other.oppositeParty == this.oppositeParty &&
          other.oppositeCounsel == this.oppositeCounsel &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CasesCompanion extends UpdateCompanion<Case> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> caseType;
  final Value<String> status;
  final Value<String?> registrationNumber;
  final Value<String?> dateFiled;
  final Value<int?> courtId;
  final Value<String?> bench;
  final Value<String?> courtroomNumber;
  final Value<String?> clientName;
  final Value<String?> clientPhone;
  final Value<String?> clientCnic;
  final Value<String?> clientAddress;
  final Value<String?> oppositeParty;
  final Value<String?> oppositeCounsel;
  final Value<String?> notes;
  final Value<String> createdAt;
  final Value<String> updatedAt;
  const CasesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.caseType = const Value.absent(),
    this.status = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.dateFiled = const Value.absent(),
    this.courtId = const Value.absent(),
    this.bench = const Value.absent(),
    this.courtroomNumber = const Value.absent(),
    this.clientName = const Value.absent(),
    this.clientPhone = const Value.absent(),
    this.clientCnic = const Value.absent(),
    this.clientAddress = const Value.absent(),
    this.oppositeParty = const Value.absent(),
    this.oppositeCounsel = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  CasesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.caseType = const Value.absent(),
    this.status = const Value.absent(),
    this.registrationNumber = const Value.absent(),
    this.dateFiled = const Value.absent(),
    this.courtId = const Value.absent(),
    this.bench = const Value.absent(),
    this.courtroomNumber = const Value.absent(),
    this.clientName = const Value.absent(),
    this.clientPhone = const Value.absent(),
    this.clientCnic = const Value.absent(),
    this.clientAddress = const Value.absent(),
    this.oppositeParty = const Value.absent(),
    this.oppositeCounsel = const Value.absent(),
    this.notes = const Value.absent(),
    required String createdAt,
    required String updatedAt,
  }) : title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Case> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? caseType,
    Expression<String>? status,
    Expression<String>? registrationNumber,
    Expression<String>? dateFiled,
    Expression<int>? courtId,
    Expression<String>? bench,
    Expression<String>? courtroomNumber,
    Expression<String>? clientName,
    Expression<String>? clientPhone,
    Expression<String>? clientCnic,
    Expression<String>? clientAddress,
    Expression<String>? oppositeParty,
    Expression<String>? oppositeCounsel,
    Expression<String>? notes,
    Expression<String>? createdAt,
    Expression<String>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (caseType != null) 'case_type': caseType,
      if (status != null) 'status': status,
      if (registrationNumber != null) 'registration_number': registrationNumber,
      if (dateFiled != null) 'date_filed': dateFiled,
      if (courtId != null) 'court_id': courtId,
      if (bench != null) 'bench': bench,
      if (courtroomNumber != null) 'courtroom_number': courtroomNumber,
      if (clientName != null) 'client_name': clientName,
      if (clientPhone != null) 'client_phone': clientPhone,
      if (clientCnic != null) 'client_cnic': clientCnic,
      if (clientAddress != null) 'client_address': clientAddress,
      if (oppositeParty != null) 'opposite_party': oppositeParty,
      if (oppositeCounsel != null) 'opposite_counsel': oppositeCounsel,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  CasesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? caseType,
    Value<String>? status,
    Value<String?>? registrationNumber,
    Value<String?>? dateFiled,
    Value<int?>? courtId,
    Value<String?>? bench,
    Value<String?>? courtroomNumber,
    Value<String?>? clientName,
    Value<String?>? clientPhone,
    Value<String?>? clientCnic,
    Value<String?>? clientAddress,
    Value<String?>? oppositeParty,
    Value<String?>? oppositeCounsel,
    Value<String?>? notes,
    Value<String>? createdAt,
    Value<String>? updatedAt,
  }) {
    return CasesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      caseType: caseType ?? this.caseType,
      status: status ?? this.status,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      dateFiled: dateFiled ?? this.dateFiled,
      courtId: courtId ?? this.courtId,
      bench: bench ?? this.bench,
      courtroomNumber: courtroomNumber ?? this.courtroomNumber,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      clientCnic: clientCnic ?? this.clientCnic,
      clientAddress: clientAddress ?? this.clientAddress,
      oppositeParty: oppositeParty ?? this.oppositeParty,
      oppositeCounsel: oppositeCounsel ?? this.oppositeCounsel,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (caseType.present) {
      map['case_type'] = Variable<String>(caseType.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (registrationNumber.present) {
      map['registration_number'] = Variable<String>(registrationNumber.value);
    }
    if (dateFiled.present) {
      map['date_filed'] = Variable<String>(dateFiled.value);
    }
    if (courtId.present) {
      map['court_id'] = Variable<int>(courtId.value);
    }
    if (bench.present) {
      map['bench'] = Variable<String>(bench.value);
    }
    if (courtroomNumber.present) {
      map['courtroom_number'] = Variable<String>(courtroomNumber.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (clientPhone.present) {
      map['client_phone'] = Variable<String>(clientPhone.value);
    }
    if (clientCnic.present) {
      map['client_cnic'] = Variable<String>(clientCnic.value);
    }
    if (clientAddress.present) {
      map['client_address'] = Variable<String>(clientAddress.value);
    }
    if (oppositeParty.present) {
      map['opposite_party'] = Variable<String>(oppositeParty.value);
    }
    if (oppositeCounsel.present) {
      map['opposite_counsel'] = Variable<String>(oppositeCounsel.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<String>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CasesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('caseType: $caseType, ')
          ..write('status: $status, ')
          ..write('registrationNumber: $registrationNumber, ')
          ..write('dateFiled: $dateFiled, ')
          ..write('courtId: $courtId, ')
          ..write('bench: $bench, ')
          ..write('courtroomNumber: $courtroomNumber, ')
          ..write('clientName: $clientName, ')
          ..write('clientPhone: $clientPhone, ')
          ..write('clientCnic: $clientCnic, ')
          ..write('clientAddress: $clientAddress, ')
          ..write('oppositeParty: $oppositeParty, ')
          ..write('oppositeCounsel: $oppositeCounsel, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $HearingsTable extends Hearings with TableInfo<$HearingsTable, Hearing> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HearingsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<int> caseId = GeneratedColumn<int>(
    'case_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cases (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _hearingDateMeta = const VerificationMeta(
    'hearingDate',
  );
  @override
  late final GeneratedColumn<String> hearingDate = GeneratedColumn<String>(
    'hearing_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hearingTimeMeta = const VerificationMeta(
    'hearingTime',
  );
  @override
  late final GeneratedColumn<String> hearingTime = GeneratedColumn<String>(
    'hearing_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    caseId,
    hearingDate,
    hearingTime,
    purpose,
    outcome,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hearings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Hearing> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('hearing_date')) {
      context.handle(
        _hearingDateMeta,
        hearingDate.isAcceptableOrUnknown(
          data['hearing_date']!,
          _hearingDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_hearingDateMeta);
    }
    if (data.containsKey('hearing_time')) {
      context.handle(
        _hearingTimeMeta,
        hearingTime.isAcceptableOrUnknown(
          data['hearing_time']!,
          _hearingTimeMeta,
        ),
      );
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Hearing map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Hearing(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}case_id'],
      )!,
      hearingDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hearing_date'],
      )!,
      hearingTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hearing_time'],
      ),
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      ),
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $HearingsTable createAlias(String alias) {
    return $HearingsTable(attachedDatabase, alias);
  }
}

class Hearing extends DataClass implements Insertable<Hearing> {
  final int id;
  final int caseId;
  final String hearingDate;
  final String? hearingTime;
  final String? purpose;
  final String? outcome;
  final String? notes;
  const Hearing({
    required this.id,
    required this.caseId,
    required this.hearingDate,
    this.hearingTime,
    this.purpose,
    this.outcome,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['case_id'] = Variable<int>(caseId);
    map['hearing_date'] = Variable<String>(hearingDate);
    if (!nullToAbsent || hearingTime != null) {
      map['hearing_time'] = Variable<String>(hearingTime);
    }
    if (!nullToAbsent || purpose != null) {
      map['purpose'] = Variable<String>(purpose);
    }
    if (!nullToAbsent || outcome != null) {
      map['outcome'] = Variable<String>(outcome);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  HearingsCompanion toCompanion(bool nullToAbsent) {
    return HearingsCompanion(
      id: Value(id),
      caseId: Value(caseId),
      hearingDate: Value(hearingDate),
      hearingTime: hearingTime == null && nullToAbsent
          ? const Value.absent()
          : Value(hearingTime),
      purpose: purpose == null && nullToAbsent
          ? const Value.absent()
          : Value(purpose),
      outcome: outcome == null && nullToAbsent
          ? const Value.absent()
          : Value(outcome),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Hearing.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Hearing(
      id: serializer.fromJson<int>(json['id']),
      caseId: serializer.fromJson<int>(json['caseId']),
      hearingDate: serializer.fromJson<String>(json['hearingDate']),
      hearingTime: serializer.fromJson<String?>(json['hearingTime']),
      purpose: serializer.fromJson<String?>(json['purpose']),
      outcome: serializer.fromJson<String?>(json['outcome']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caseId': serializer.toJson<int>(caseId),
      'hearingDate': serializer.toJson<String>(hearingDate),
      'hearingTime': serializer.toJson<String?>(hearingTime),
      'purpose': serializer.toJson<String?>(purpose),
      'outcome': serializer.toJson<String?>(outcome),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Hearing copyWith({
    int? id,
    int? caseId,
    String? hearingDate,
    Value<String?> hearingTime = const Value.absent(),
    Value<String?> purpose = const Value.absent(),
    Value<String?> outcome = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Hearing(
    id: id ?? this.id,
    caseId: caseId ?? this.caseId,
    hearingDate: hearingDate ?? this.hearingDate,
    hearingTime: hearingTime.present ? hearingTime.value : this.hearingTime,
    purpose: purpose.present ? purpose.value : this.purpose,
    outcome: outcome.present ? outcome.value : this.outcome,
    notes: notes.present ? notes.value : this.notes,
  );
  Hearing copyWithCompanion(HearingsCompanion data) {
    return Hearing(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      hearingDate: data.hearingDate.present
          ? data.hearingDate.value
          : this.hearingDate,
      hearingTime: data.hearingTime.present
          ? data.hearingTime.value
          : this.hearingTime,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Hearing(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('hearingDate: $hearingDate, ')
          ..write('hearingTime: $hearingTime, ')
          ..write('purpose: $purpose, ')
          ..write('outcome: $outcome, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    caseId,
    hearingDate,
    hearingTime,
    purpose,
    outcome,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Hearing &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.hearingDate == this.hearingDate &&
          other.hearingTime == this.hearingTime &&
          other.purpose == this.purpose &&
          other.outcome == this.outcome &&
          other.notes == this.notes);
}

class HearingsCompanion extends UpdateCompanion<Hearing> {
  final Value<int> id;
  final Value<int> caseId;
  final Value<String> hearingDate;
  final Value<String?> hearingTime;
  final Value<String?> purpose;
  final Value<String?> outcome;
  final Value<String?> notes;
  const HearingsCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.hearingDate = const Value.absent(),
    this.hearingTime = const Value.absent(),
    this.purpose = const Value.absent(),
    this.outcome = const Value.absent(),
    this.notes = const Value.absent(),
  });
  HearingsCompanion.insert({
    this.id = const Value.absent(),
    required int caseId,
    required String hearingDate,
    this.hearingTime = const Value.absent(),
    this.purpose = const Value.absent(),
    this.outcome = const Value.absent(),
    this.notes = const Value.absent(),
  }) : caseId = Value(caseId),
       hearingDate = Value(hearingDate);
  static Insertable<Hearing> custom({
    Expression<int>? id,
    Expression<int>? caseId,
    Expression<String>? hearingDate,
    Expression<String>? hearingTime,
    Expression<String>? purpose,
    Expression<String>? outcome,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (hearingDate != null) 'hearing_date': hearingDate,
      if (hearingTime != null) 'hearing_time': hearingTime,
      if (purpose != null) 'purpose': purpose,
      if (outcome != null) 'outcome': outcome,
      if (notes != null) 'notes': notes,
    });
  }

  HearingsCompanion copyWith({
    Value<int>? id,
    Value<int>? caseId,
    Value<String>? hearingDate,
    Value<String?>? hearingTime,
    Value<String?>? purpose,
    Value<String?>? outcome,
    Value<String?>? notes,
  }) {
    return HearingsCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      hearingDate: hearingDate ?? this.hearingDate,
      hearingTime: hearingTime ?? this.hearingTime,
      purpose: purpose ?? this.purpose,
      outcome: outcome ?? this.outcome,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<int>(caseId.value);
    }
    if (hearingDate.present) {
      map['hearing_date'] = Variable<String>(hearingDate.value);
    }
    if (hearingTime.present) {
      map['hearing_time'] = Variable<String>(hearingTime.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HearingsCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('hearingDate: $hearingDate, ')
          ..write('hearingTime: $hearingTime, ')
          ..write('purpose: $purpose, ')
          ..write('outcome: $outcome, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $DocumentFoldersTable extends DocumentFolders
    with TableInfo<$DocumentFoldersTable, DocumentFolder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentFoldersTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<int> caseId = GeneratedColumn<int>(
    'case_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cases (id) ON DELETE CASCADE',
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
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, caseId, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_folders';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentFolder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_caseIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentFolder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentFolder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}case_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $DocumentFoldersTable createAlias(String alias) {
    return $DocumentFoldersTable(attachedDatabase, alias);
  }
}

class DocumentFolder extends DataClass implements Insertable<DocumentFolder> {
  final int id;
  final int caseId;
  final String name;
  final String createdAt;
  const DocumentFolder({
    required this.id,
    required this.caseId,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['case_id'] = Variable<int>(caseId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  DocumentFoldersCompanion toCompanion(bool nullToAbsent) {
    return DocumentFoldersCompanion(
      id: Value(id),
      caseId: Value(caseId),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory DocumentFolder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentFolder(
      id: serializer.fromJson<int>(json['id']),
      caseId: serializer.fromJson<int>(json['caseId']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'caseId': serializer.toJson<int>(caseId),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  DocumentFolder copyWith({
    int? id,
    int? caseId,
    String? name,
    String? createdAt,
  }) => DocumentFolder(
    id: id ?? this.id,
    caseId: caseId ?? this.caseId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  DocumentFolder copyWithCompanion(DocumentFoldersCompanion data) {
    return DocumentFolder(
      id: data.id.present ? data.id.value : this.id,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentFolder(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, caseId, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentFolder &&
          other.id == this.id &&
          other.caseId == this.caseId &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class DocumentFoldersCompanion extends UpdateCompanion<DocumentFolder> {
  final Value<int> id;
  final Value<int> caseId;
  final Value<String> name;
  final Value<String> createdAt;
  const DocumentFoldersCompanion({
    this.id = const Value.absent(),
    this.caseId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DocumentFoldersCompanion.insert({
    this.id = const Value.absent(),
    required int caseId,
    required String name,
    required String createdAt,
  }) : caseId = Value(caseId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<DocumentFolder> custom({
    Expression<int>? id,
    Expression<int>? caseId,
    Expression<String>? name,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (caseId != null) 'case_id': caseId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DocumentFoldersCompanion copyWith({
    Value<int>? id,
    Value<int>? caseId,
    Value<String>? name,
    Value<String>? createdAt,
  }) {
    return DocumentFoldersCompanion(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<int>(caseId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentFoldersCompanion(')
          ..write('id: $id, ')
          ..write('caseId: $caseId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DocumentImagesTable extends DocumentImages
    with TableInfo<$DocumentImagesTable, DocumentImage> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentImagesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _folderIdMeta = const VerificationMeta(
    'folderId',
  );
  @override
  late final GeneratedColumn<int> folderId = GeneratedColumn<int>(
    'folder_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES document_folders (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<String> addedAt = GeneratedColumn<String>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    folderId,
    filePath,
    sortOrder,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_images';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentImage> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('folder_id')) {
      context.handle(
        _folderIdMeta,
        folderId.isAcceptableOrUnknown(data['folder_id']!, _folderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_folderIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DocumentImage map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentImage(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      folderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}folder_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $DocumentImagesTable createAlias(String alias) {
    return $DocumentImagesTable(attachedDatabase, alias);
  }
}

class DocumentImage extends DataClass implements Insertable<DocumentImage> {
  final int id;
  final int folderId;
  final String filePath;
  final int sortOrder;
  final String addedAt;
  const DocumentImage({
    required this.id,
    required this.folderId,
    required this.filePath,
    required this.sortOrder,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['folder_id'] = Variable<int>(folderId);
    map['file_path'] = Variable<String>(filePath);
    map['sort_order'] = Variable<int>(sortOrder);
    map['added_at'] = Variable<String>(addedAt);
    return map;
  }

  DocumentImagesCompanion toCompanion(bool nullToAbsent) {
    return DocumentImagesCompanion(
      id: Value(id),
      folderId: Value(folderId),
      filePath: Value(filePath),
      sortOrder: Value(sortOrder),
      addedAt: Value(addedAt),
    );
  }

  factory DocumentImage.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentImage(
      id: serializer.fromJson<int>(json['id']),
      folderId: serializer.fromJson<int>(json['folderId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      addedAt: serializer.fromJson<String>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'folderId': serializer.toJson<int>(folderId),
      'filePath': serializer.toJson<String>(filePath),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'addedAt': serializer.toJson<String>(addedAt),
    };
  }

  DocumentImage copyWith({
    int? id,
    int? folderId,
    String? filePath,
    int? sortOrder,
    String? addedAt,
  }) => DocumentImage(
    id: id ?? this.id,
    folderId: folderId ?? this.folderId,
    filePath: filePath ?? this.filePath,
    sortOrder: sortOrder ?? this.sortOrder,
    addedAt: addedAt ?? this.addedAt,
  );
  DocumentImage copyWithCompanion(DocumentImagesCompanion data) {
    return DocumentImage(
      id: data.id.present ? data.id.value : this.id,
      folderId: data.folderId.present ? data.folderId.value : this.folderId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentImage(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('filePath: $filePath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, folderId, filePath, sortOrder, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentImage &&
          other.id == this.id &&
          other.folderId == this.folderId &&
          other.filePath == this.filePath &&
          other.sortOrder == this.sortOrder &&
          other.addedAt == this.addedAt);
}

class DocumentImagesCompanion extends UpdateCompanion<DocumentImage> {
  final Value<int> id;
  final Value<int> folderId;
  final Value<String> filePath;
  final Value<int> sortOrder;
  final Value<String> addedAt;
  const DocumentImagesCompanion({
    this.id = const Value.absent(),
    this.folderId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.addedAt = const Value.absent(),
  });
  DocumentImagesCompanion.insert({
    this.id = const Value.absent(),
    required int folderId,
    required String filePath,
    this.sortOrder = const Value.absent(),
    required String addedAt,
  }) : folderId = Value(folderId),
       filePath = Value(filePath),
       addedAt = Value(addedAt);
  static Insertable<DocumentImage> custom({
    Expression<int>? id,
    Expression<int>? folderId,
    Expression<String>? filePath,
    Expression<int>? sortOrder,
    Expression<String>? addedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (folderId != null) 'folder_id': folderId,
      if (filePath != null) 'file_path': filePath,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (addedAt != null) 'added_at': addedAt,
    });
  }

  DocumentImagesCompanion copyWith({
    Value<int>? id,
    Value<int>? folderId,
    Value<String>? filePath,
    Value<int>? sortOrder,
    Value<String>? addedAt,
  }) {
    return DocumentImagesCompanion(
      id: id ?? this.id,
      folderId: folderId ?? this.folderId,
      filePath: filePath ?? this.filePath,
      sortOrder: sortOrder ?? this.sortOrder,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (folderId.present) {
      map['folder_id'] = Variable<int>(folderId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<String>(addedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentImagesCompanion(')
          ..write('id: $id, ')
          ..write('folderId: $folderId, ')
          ..write('filePath: $filePath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogTable extends ActivityLog
    with TableInfo<$ActivityLogTable, ActivityLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caseIdMeta = const VerificationMeta('caseId');
  @override
  late final GeneratedColumn<int> caseId = GeneratedColumn<int>(
    'case_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cases (id)',
    ),
  );
  static const VerificationMeta _hearingIdMeta = const VerificationMeta(
    'hearingId',
  );
  @override
  late final GeneratedColumn<int> hearingId = GeneratedColumn<int>(
    'hearing_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<String> createdAt = GeneratedColumn<String>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    caseId,
    hearingId,
    title,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('case_id')) {
      context.handle(
        _caseIdMeta,
        caseId.isAcceptableOrUnknown(data['case_id']!, _caseIdMeta),
      );
    }
    if (data.containsKey('hearing_id')) {
      context.handle(
        _hearingIdMeta,
        hearingId.isAcceptableOrUnknown(data['hearing_id']!, _hearingIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      caseId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}case_id'],
      ),
      hearingId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hearing_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivityLogTable createAlias(String alias) {
    return $ActivityLogTable(attachedDatabase, alias);
  }
}

class ActivityLogData extends DataClass implements Insertable<ActivityLogData> {
  final int id;
  final String type;
  final int? caseId;
  final int? hearingId;
  final String title;
  final String createdAt;
  const ActivityLogData({
    required this.id,
    required this.type,
    this.caseId,
    this.hearingId,
    required this.title,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || caseId != null) {
      map['case_id'] = Variable<int>(caseId);
    }
    if (!nullToAbsent || hearingId != null) {
      map['hearing_id'] = Variable<int>(hearingId);
    }
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<String>(createdAt);
    return map;
  }

  ActivityLogCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogCompanion(
      id: Value(id),
      type: Value(type),
      caseId: caseId == null && nullToAbsent
          ? const Value.absent()
          : Value(caseId),
      hearingId: hearingId == null && nullToAbsent
          ? const Value.absent()
          : Value(hearingId),
      title: Value(title),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLogData(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      caseId: serializer.fromJson<int?>(json['caseId']),
      hearingId: serializer.fromJson<int?>(json['hearingId']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<String>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'caseId': serializer.toJson<int?>(caseId),
      'hearingId': serializer.toJson<int?>(hearingId),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<String>(createdAt),
    };
  }

  ActivityLogData copyWith({
    int? id,
    String? type,
    Value<int?> caseId = const Value.absent(),
    Value<int?> hearingId = const Value.absent(),
    String? title,
    String? createdAt,
  }) => ActivityLogData(
    id: id ?? this.id,
    type: type ?? this.type,
    caseId: caseId.present ? caseId.value : this.caseId,
    hearingId: hearingId.present ? hearingId.value : this.hearingId,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
  );
  ActivityLogData copyWithCompanion(ActivityLogCompanion data) {
    return ActivityLogData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      caseId: data.caseId.present ? data.caseId.value : this.caseId,
      hearingId: data.hearingId.present ? data.hearingId.value : this.hearingId,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('caseId: $caseId, ')
          ..write('hearingId: $hearingId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, type, caseId, hearingId, title, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLogData &&
          other.id == this.id &&
          other.type == this.type &&
          other.caseId == this.caseId &&
          other.hearingId == this.hearingId &&
          other.title == this.title &&
          other.createdAt == this.createdAt);
}

class ActivityLogCompanion extends UpdateCompanion<ActivityLogData> {
  final Value<int> id;
  final Value<String> type;
  final Value<int?> caseId;
  final Value<int?> hearingId;
  final Value<String> title;
  final Value<String> createdAt;
  const ActivityLogCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.caseId = const Value.absent(),
    this.hearingId = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ActivityLogCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    this.caseId = const Value.absent(),
    this.hearingId = const Value.absent(),
    required String title,
    required String createdAt,
  }) : type = Value(type),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<ActivityLogData> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<int>? caseId,
    Expression<int>? hearingId,
    Expression<String>? title,
    Expression<String>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (caseId != null) 'case_id': caseId,
      if (hearingId != null) 'hearing_id': hearingId,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ActivityLogCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<int?>? caseId,
    Value<int?>? hearingId,
    Value<String>? title,
    Value<String>? createdAt,
  }) {
    return ActivityLogCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      caseId: caseId ?? this.caseId,
      hearingId: hearingId ?? this.hearingId,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (caseId.present) {
      map['case_id'] = Variable<int>(caseId.value);
    }
    if (hearingId.present) {
      map['hearing_id'] = Variable<int>(hearingId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<String>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('caseId: $caseId, ')
          ..write('hearingId: $hearingId, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $NotificationHistoryTable extends NotificationHistory
    with TableInfo<$NotificationHistoryTable, NotificationHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationHistoryTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _triggeredAtMeta = const VerificationMeta(
    'triggeredAt',
  );
  @override
  late final GeneratedColumn<String> triggeredAt = GeneratedColumn<String>(
    'triggered_at',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, triggeredAt, summary];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_history';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationHistoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('triggered_at')) {
      context.handle(
        _triggeredAtMeta,
        triggeredAt.isAcceptableOrUnknown(
          data['triggered_at']!,
          _triggeredAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_triggeredAtMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationHistoryData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationHistoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      triggeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}triggered_at'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
    );
  }

  @override
  $NotificationHistoryTable createAlias(String alias) {
    return $NotificationHistoryTable(attachedDatabase, alias);
  }
}

class NotificationHistoryData extends DataClass
    implements Insertable<NotificationHistoryData> {
  final int id;
  final String triggeredAt;
  final String summary;
  const NotificationHistoryData({
    required this.id,
    required this.triggeredAt,
    required this.summary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['triggered_at'] = Variable<String>(triggeredAt);
    map['summary'] = Variable<String>(summary);
    return map;
  }

  NotificationHistoryCompanion toCompanion(bool nullToAbsent) {
    return NotificationHistoryCompanion(
      id: Value(id),
      triggeredAt: Value(triggeredAt),
      summary: Value(summary),
    );
  }

  factory NotificationHistoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationHistoryData(
      id: serializer.fromJson<int>(json['id']),
      triggeredAt: serializer.fromJson<String>(json['triggeredAt']),
      summary: serializer.fromJson<String>(json['summary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'triggeredAt': serializer.toJson<String>(triggeredAt),
      'summary': serializer.toJson<String>(summary),
    };
  }

  NotificationHistoryData copyWith({
    int? id,
    String? triggeredAt,
    String? summary,
  }) => NotificationHistoryData(
    id: id ?? this.id,
    triggeredAt: triggeredAt ?? this.triggeredAt,
    summary: summary ?? this.summary,
  );
  NotificationHistoryData copyWithCompanion(NotificationHistoryCompanion data) {
    return NotificationHistoryData(
      id: data.id.present ? data.id.value : this.id,
      triggeredAt: data.triggeredAt.present
          ? data.triggeredAt.value
          : this.triggeredAt,
      summary: data.summary.present ? data.summary.value : this.summary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationHistoryData(')
          ..write('id: $id, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, triggeredAt, summary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationHistoryData &&
          other.id == this.id &&
          other.triggeredAt == this.triggeredAt &&
          other.summary == this.summary);
}

class NotificationHistoryCompanion
    extends UpdateCompanion<NotificationHistoryData> {
  final Value<int> id;
  final Value<String> triggeredAt;
  final Value<String> summary;
  const NotificationHistoryCompanion({
    this.id = const Value.absent(),
    this.triggeredAt = const Value.absent(),
    this.summary = const Value.absent(),
  });
  NotificationHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String triggeredAt,
    required String summary,
  }) : triggeredAt = Value(triggeredAt),
       summary = Value(summary);
  static Insertable<NotificationHistoryData> custom({
    Expression<int>? id,
    Expression<String>? triggeredAt,
    Expression<String>? summary,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (triggeredAt != null) 'triggered_at': triggeredAt,
      if (summary != null) 'summary': summary,
    });
  }

  NotificationHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? triggeredAt,
    Value<String>? summary,
  }) {
    return NotificationHistoryCompanion(
      id: id ?? this.id,
      triggeredAt: triggeredAt ?? this.triggeredAt,
      summary: summary ?? this.summary,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (triggeredAt.present) {
      map['triggered_at'] = Variable<String>(triggeredAt.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationHistoryCompanion(')
          ..write('id: $id, ')
          ..write('triggeredAt: $triggeredAt, ')
          ..write('summary: $summary')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  // ignore: unused_element - base class constructor for Drift
  _$AppDatabase.connect(DatabaseConnection c) : super.connect(c);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CourtsTable courts = $CourtsTable(this);
  late final $CasesTable cases = $CasesTable(this);
  late final $HearingsTable hearings = $HearingsTable(this);
  late final $DocumentFoldersTable documentFolders = $DocumentFoldersTable(
    this,
  );
  late final $DocumentImagesTable documentImages = $DocumentImagesTable(this);
  late final $ActivityLogTable activityLog = $ActivityLogTable(this);
  late final $NotificationHistoryTable notificationHistory =
      $NotificationHistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    courts,
    cases,
    hearings,
    documentFolders,
    documentImages,
    activityLog,
    notificationHistory,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('hearings', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cases',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('document_folders', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'document_folders',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('document_images', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CourtsTableCreateCompanionBuilder =
    CourtsCompanion Function({
      Value<int> id,
      required String name,
      required String hierarchy,
      Value<String?> city,
    });
typedef $$CourtsTableUpdateCompanionBuilder =
    CourtsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> hierarchy,
      Value<String?> city,
    });

final class $$CourtsTableReferences
    extends BaseReferences<_$AppDatabase, $CourtsTable, Court> {
  $$CourtsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CasesTable, List<Case>> _casesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cases,
    aliasName: $_aliasNameGenerator(db.courts.id, db.cases.courtId),
  );

  $$CasesTableProcessedTableManager get casesRefs {
    final manager = $$CasesTableTableManager(
      $_db,
      $_db.cases,
    ).filter((f) => f.courtId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_casesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CourtsTableFilterComposer
    extends Composer<_$AppDatabase, $CourtsTable> {
  $$CourtsTableFilterComposer({
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

  ColumnFilters<String> get hierarchy => $composableBuilder(
    column: $table.hierarchy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> casesRefs(
    Expression<bool> Function($$CasesTableFilterComposer f) f,
  ) {
    final $$CasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.courtId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableFilterComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CourtsTableOrderingComposer
    extends Composer<_$AppDatabase, $CourtsTable> {
  $$CourtsTableOrderingComposer({
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

  ColumnOrderings<String> get hierarchy => $composableBuilder(
    column: $table.hierarchy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CourtsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CourtsTable> {
  $$CourtsTableAnnotationComposer({
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

  GeneratedColumn<String> get hierarchy =>
      $composableBuilder(column: $table.hierarchy, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  Expression<T> casesRefs<T extends Object>(
    Expression<T> Function($$CasesTableAnnotationComposer a) f,
  ) {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.courtId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CourtsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CourtsTable,
          Court,
          $$CourtsTableFilterComposer,
          $$CourtsTableOrderingComposer,
          $$CourtsTableAnnotationComposer,
          $$CourtsTableCreateCompanionBuilder,
          $$CourtsTableUpdateCompanionBuilder,
          (Court, $$CourtsTableReferences),
          Court,
          PrefetchHooks Function({bool casesRefs})
        > {
  $$CourtsTableTableManager(_$AppDatabase db, $CourtsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CourtsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CourtsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CourtsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> hierarchy = const Value.absent(),
                Value<String?> city = const Value.absent(),
              }) => CourtsCompanion(
                id: id,
                name: name,
                hierarchy: hierarchy,
                city: city,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String hierarchy,
                Value<String?> city = const Value.absent(),
              }) => CourtsCompanion.insert(
                id: id,
                name: name,
                hierarchy: hierarchy,
                city: city,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CourtsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({casesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (casesRefs) db.cases],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (casesRefs)
                    await $_getPrefetchedData<Court, $CourtsTable, Case>(
                      currentTable: table,
                      referencedTable: $$CourtsTableReferences._casesRefsTable(
                        db,
                      ),
                      managerFromTypedResult: (p0) =>
                          $$CourtsTableReferences(db, table, p0).casesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.courtId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CourtsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CourtsTable,
      Court,
      $$CourtsTableFilterComposer,
      $$CourtsTableOrderingComposer,
      $$CourtsTableAnnotationComposer,
      $$CourtsTableCreateCompanionBuilder,
      $$CourtsTableUpdateCompanionBuilder,
      (Court, $$CourtsTableReferences),
      Court,
      PrefetchHooks Function({bool casesRefs})
    >;
typedef $$CasesTableCreateCompanionBuilder =
    CasesCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> caseType,
      Value<String> status,
      Value<String?> registrationNumber,
      Value<String?> dateFiled,
      Value<int?> courtId,
      Value<String?> bench,
      Value<String?> courtroomNumber,
      Value<String?> clientName,
      Value<String?> clientPhone,
      Value<String?> clientCnic,
      Value<String?> clientAddress,
      Value<String?> oppositeParty,
      Value<String?> oppositeCounsel,
      Value<String?> notes,
      required String createdAt,
      required String updatedAt,
    });
typedef $$CasesTableUpdateCompanionBuilder =
    CasesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> caseType,
      Value<String> status,
      Value<String?> registrationNumber,
      Value<String?> dateFiled,
      Value<int?> courtId,
      Value<String?> bench,
      Value<String?> courtroomNumber,
      Value<String?> clientName,
      Value<String?> clientPhone,
      Value<String?> clientCnic,
      Value<String?> clientAddress,
      Value<String?> oppositeParty,
      Value<String?> oppositeCounsel,
      Value<String?> notes,
      Value<String> createdAt,
      Value<String> updatedAt,
    });

final class $$CasesTableReferences
    extends BaseReferences<_$AppDatabase, $CasesTable, Case> {
  $$CasesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CourtsTable _courtIdTable(_$AppDatabase db) => db.courts.createAlias(
    $_aliasNameGenerator(db.cases.courtId, db.courts.id),
  );

  $$CourtsTableProcessedTableManager? get courtId {
    final $_column = $_itemColumn<int>('court_id');
    if ($_column == null) return null;
    final manager = $$CourtsTableTableManager(
      $_db,
      $_db.courts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_courtIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$HearingsTable, List<Hearing>> _hearingsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.hearings,
    aliasName: $_aliasNameGenerator(db.cases.id, db.hearings.caseId),
  );

  $$HearingsTableProcessedTableManager get hearingsRefs {
    final manager = $$HearingsTableTableManager(
      $_db,
      $_db.hearings,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_hearingsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$DocumentFoldersTable, List<DocumentFolder>>
  _documentFoldersRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documentFolders,
    aliasName: $_aliasNameGenerator(db.cases.id, db.documentFolders.caseId),
  );

  $$DocumentFoldersTableProcessedTableManager get documentFoldersRefs {
    final manager = $$DocumentFoldersTableTableManager(
      $_db,
      $_db.documentFolders,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _documentFoldersRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActivityLogTable, List<ActivityLogData>>
  _activityLogRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activityLog,
    aliasName: $_aliasNameGenerator(db.cases.id, db.activityLog.caseId),
  );

  $$ActivityLogTableProcessedTableManager get activityLogRefs {
    final manager = $$ActivityLogTableTableManager(
      $_db,
      $_db.activityLog,
    ).filter((f) => f.caseId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_activityLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CasesTableFilterComposer extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableFilterComposer({
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

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caseType => $composableBuilder(
    column: $table.caseType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dateFiled => $composableBuilder(
    column: $table.dateFiled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bench => $composableBuilder(
    column: $table.bench,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get courtroomNumber => $composableBuilder(
    column: $table.courtroomNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientPhone => $composableBuilder(
    column: $table.clientPhone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientCnic => $composableBuilder(
    column: $table.clientCnic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientAddress => $composableBuilder(
    column: $table.clientAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oppositeParty => $composableBuilder(
    column: $table.oppositeParty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get oppositeCounsel => $composableBuilder(
    column: $table.oppositeCounsel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CourtsTableFilterComposer get courtId {
    final $$CourtsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courtId,
      referencedTable: $db.courts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CourtsTableFilterComposer(
            $db: $db,
            $table: $db.courts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> hearingsRefs(
    Expression<bool> Function($$HearingsTableFilterComposer f) f,
  ) {
    final $$HearingsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hearings,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HearingsTableFilterComposer(
            $db: $db,
            $table: $db.hearings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> documentFoldersRefs(
    Expression<bool> Function($$DocumentFoldersTableFilterComposer f) f,
  ) {
    final $$DocumentFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentFolders,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFoldersTableFilterComposer(
            $db: $db,
            $table: $db.documentFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activityLogRefs(
    Expression<bool> Function($$ActivityLogTableFilterComposer f) f,
  ) {
    final $$ActivityLogTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityLog,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityLogTableFilterComposer(
            $db: $db,
            $table: $db.activityLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CasesTableOrderingComposer
    extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableOrderingComposer({
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

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caseType => $composableBuilder(
    column: $table.caseType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dateFiled => $composableBuilder(
    column: $table.dateFiled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bench => $composableBuilder(
    column: $table.bench,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get courtroomNumber => $composableBuilder(
    column: $table.courtroomNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientPhone => $composableBuilder(
    column: $table.clientPhone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientCnic => $composableBuilder(
    column: $table.clientCnic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientAddress => $composableBuilder(
    column: $table.clientAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oppositeParty => $composableBuilder(
    column: $table.oppositeParty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get oppositeCounsel => $composableBuilder(
    column: $table.oppositeCounsel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CourtsTableOrderingComposer get courtId {
    final $$CourtsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courtId,
      referencedTable: $db.courts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CourtsTableOrderingComposer(
            $db: $db,
            $table: $db.courts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CasesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CasesTable> {
  $$CasesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get caseType =>
      $composableBuilder(column: $table.caseType, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get registrationNumber => $composableBuilder(
    column: $table.registrationNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dateFiled =>
      $composableBuilder(column: $table.dateFiled, builder: (column) => column);

  GeneratedColumn<String> get bench =>
      $composableBuilder(column: $table.bench, builder: (column) => column);

  GeneratedColumn<String> get courtroomNumber => $composableBuilder(
    column: $table.courtroomNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientPhone => $composableBuilder(
    column: $table.clientPhone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientCnic => $composableBuilder(
    column: $table.clientCnic,
    builder: (column) => column,
  );

  GeneratedColumn<String> get clientAddress => $composableBuilder(
    column: $table.clientAddress,
    builder: (column) => column,
  );

  GeneratedColumn<String> get oppositeParty => $composableBuilder(
    column: $table.oppositeParty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get oppositeCounsel => $composableBuilder(
    column: $table.oppositeCounsel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CourtsTableAnnotationComposer get courtId {
    final $$CourtsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.courtId,
      referencedTable: $db.courts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CourtsTableAnnotationComposer(
            $db: $db,
            $table: $db.courts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> hearingsRefs<T extends Object>(
    Expression<T> Function($$HearingsTableAnnotationComposer a) f,
  ) {
    final $$HearingsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.hearings,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$HearingsTableAnnotationComposer(
            $db: $db,
            $table: $db.hearings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> documentFoldersRefs<T extends Object>(
    Expression<T> Function($$DocumentFoldersTableAnnotationComposer a) f,
  ) {
    final $$DocumentFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentFolders,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.documentFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activityLogRefs<T extends Object>(
    Expression<T> Function($$ActivityLogTableAnnotationComposer a) f,
  ) {
    final $$ActivityLogTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activityLog,
      getReferencedColumn: (t) => t.caseId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivityLogTableAnnotationComposer(
            $db: $db,
            $table: $db.activityLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CasesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CasesTable,
          Case,
          $$CasesTableFilterComposer,
          $$CasesTableOrderingComposer,
          $$CasesTableAnnotationComposer,
          $$CasesTableCreateCompanionBuilder,
          $$CasesTableUpdateCompanionBuilder,
          (Case, $$CasesTableReferences),
          Case,
          PrefetchHooks Function({
            bool courtId,
            bool hearingsRefs,
            bool documentFoldersRefs,
            bool activityLogRefs,
          })
        > {
  $$CasesTableTableManager(_$AppDatabase db, $CasesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CasesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CasesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CasesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> caseType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> registrationNumber = const Value.absent(),
                Value<String?> dateFiled = const Value.absent(),
                Value<int?> courtId = const Value.absent(),
                Value<String?> bench = const Value.absent(),
                Value<String?> courtroomNumber = const Value.absent(),
                Value<String?> clientName = const Value.absent(),
                Value<String?> clientPhone = const Value.absent(),
                Value<String?> clientCnic = const Value.absent(),
                Value<String?> clientAddress = const Value.absent(),
                Value<String?> oppositeParty = const Value.absent(),
                Value<String?> oppositeCounsel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
                Value<String> updatedAt = const Value.absent(),
              }) => CasesCompanion(
                id: id,
                title: title,
                caseType: caseType,
                status: status,
                registrationNumber: registrationNumber,
                dateFiled: dateFiled,
                courtId: courtId,
                bench: bench,
                courtroomNumber: courtroomNumber,
                clientName: clientName,
                clientPhone: clientPhone,
                clientCnic: clientCnic,
                clientAddress: clientAddress,
                oppositeParty: oppositeParty,
                oppositeCounsel: oppositeCounsel,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> caseType = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String?> registrationNumber = const Value.absent(),
                Value<String?> dateFiled = const Value.absent(),
                Value<int?> courtId = const Value.absent(),
                Value<String?> bench = const Value.absent(),
                Value<String?> courtroomNumber = const Value.absent(),
                Value<String?> clientName = const Value.absent(),
                Value<String?> clientPhone = const Value.absent(),
                Value<String?> clientCnic = const Value.absent(),
                Value<String?> clientAddress = const Value.absent(),
                Value<String?> oppositeParty = const Value.absent(),
                Value<String?> oppositeCounsel = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String createdAt,
                required String updatedAt,
              }) => CasesCompanion.insert(
                id: id,
                title: title,
                caseType: caseType,
                status: status,
                registrationNumber: registrationNumber,
                dateFiled: dateFiled,
                courtId: courtId,
                bench: bench,
                courtroomNumber: courtroomNumber,
                clientName: clientName,
                clientPhone: clientPhone,
                clientCnic: clientCnic,
                clientAddress: clientAddress,
                oppositeParty: oppositeParty,
                oppositeCounsel: oppositeCounsel,
                notes: notes,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$CasesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                courtId = false,
                hearingsRefs = false,
                documentFoldersRefs = false,
                activityLogRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (hearingsRefs) db.hearings,
                    if (documentFoldersRefs) db.documentFolders,
                    if (activityLogRefs) db.activityLog,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (courtId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.courtId,
                                    referencedTable: $$CasesTableReferences
                                        ._courtIdTable(db),
                                    referencedColumn: $$CasesTableReferences
                                        ._courtIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (hearingsRefs)
                        await $_getPrefetchedData<Case, $CasesTable, Hearing>(
                          currentTable: table,
                          referencedTable: $$CasesTableReferences
                              ._hearingsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CasesTableReferences(
                                db,
                                table,
                                p0,
                              ).hearingsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (documentFoldersRefs)
                        await $_getPrefetchedData<
                          Case,
                          $CasesTable,
                          DocumentFolder
                        >(
                          currentTable: table,
                          referencedTable: $$CasesTableReferences
                              ._documentFoldersRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CasesTableReferences(
                                db,
                                table,
                                p0,
                              ).documentFoldersRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caseId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (activityLogRefs)
                        await $_getPrefetchedData<
                          Case,
                          $CasesTable,
                          ActivityLogData
                        >(
                          currentTable: table,
                          referencedTable: $$CasesTableReferences
                              ._activityLogRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CasesTableReferences(
                                db,
                                table,
                                p0,
                              ).activityLogRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.caseId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CasesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CasesTable,
      Case,
      $$CasesTableFilterComposer,
      $$CasesTableOrderingComposer,
      $$CasesTableAnnotationComposer,
      $$CasesTableCreateCompanionBuilder,
      $$CasesTableUpdateCompanionBuilder,
      (Case, $$CasesTableReferences),
      Case,
      PrefetchHooks Function({
        bool courtId,
        bool hearingsRefs,
        bool documentFoldersRefs,
        bool activityLogRefs,
      })
    >;
typedef $$HearingsTableCreateCompanionBuilder =
    HearingsCompanion Function({
      Value<int> id,
      required int caseId,
      required String hearingDate,
      Value<String?> hearingTime,
      Value<String?> purpose,
      Value<String?> outcome,
      Value<String?> notes,
    });
typedef $$HearingsTableUpdateCompanionBuilder =
    HearingsCompanion Function({
      Value<int> id,
      Value<int> caseId,
      Value<String> hearingDate,
      Value<String?> hearingTime,
      Value<String?> purpose,
      Value<String?> outcome,
      Value<String?> notes,
    });

final class $$HearingsTableReferences
    extends BaseReferences<_$AppDatabase, $HearingsTable, Hearing> {
  $$HearingsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CasesTable _caseIdTable(_$AppDatabase db) => db.cases.createAlias(
    $_aliasNameGenerator(db.hearings.caseId, db.cases.id),
  );

  $$CasesTableProcessedTableManager get caseId {
    final $_column = $_itemColumn<int>('case_id')!;

    final manager = $$CasesTableTableManager(
      $_db,
      $_db.cases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$HearingsTableFilterComposer
    extends Composer<_$AppDatabase, $HearingsTable> {
  $$HearingsTableFilterComposer({
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

  ColumnFilters<String> get hearingDate => $composableBuilder(
    column: $table.hearingDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hearingTime => $composableBuilder(
    column: $table.hearingTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$CasesTableFilterComposer get caseId {
    final $$CasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableFilterComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HearingsTableOrderingComposer
    extends Composer<_$AppDatabase, $HearingsTable> {
  $$HearingsTableOrderingComposer({
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

  ColumnOrderings<String> get hearingDate => $composableBuilder(
    column: $table.hearingDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hearingTime => $composableBuilder(
    column: $table.hearingTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$CasesTableOrderingComposer get caseId {
    final $$CasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableOrderingComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HearingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HearingsTable> {
  $$HearingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get hearingDate => $composableBuilder(
    column: $table.hearingDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get hearingTime => $composableBuilder(
    column: $table.hearingTime,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$CasesTableAnnotationComposer get caseId {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$HearingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $HearingsTable,
          Hearing,
          $$HearingsTableFilterComposer,
          $$HearingsTableOrderingComposer,
          $$HearingsTableAnnotationComposer,
          $$HearingsTableCreateCompanionBuilder,
          $$HearingsTableUpdateCompanionBuilder,
          (Hearing, $$HearingsTableReferences),
          Hearing,
          PrefetchHooks Function({bool caseId})
        > {
  $$HearingsTableTableManager(_$AppDatabase db, $HearingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HearingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HearingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HearingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> caseId = const Value.absent(),
                Value<String> hearingDate = const Value.absent(),
                Value<String?> hearingTime = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => HearingsCompanion(
                id: id,
                caseId: caseId,
                hearingDate: hearingDate,
                hearingTime: hearingTime,
                purpose: purpose,
                outcome: outcome,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int caseId,
                required String hearingDate,
                Value<String?> hearingTime = const Value.absent(),
                Value<String?> purpose = const Value.absent(),
                Value<String?> outcome = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => HearingsCompanion.insert(
                id: id,
                caseId: caseId,
                hearingDate: hearingDate,
                hearingTime: hearingTime,
                purpose: purpose,
                outcome: outcome,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$HearingsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({caseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (caseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.caseId,
                                referencedTable: $$HearingsTableReferences
                                    ._caseIdTable(db),
                                referencedColumn: $$HearingsTableReferences
                                    ._caseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$HearingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $HearingsTable,
      Hearing,
      $$HearingsTableFilterComposer,
      $$HearingsTableOrderingComposer,
      $$HearingsTableAnnotationComposer,
      $$HearingsTableCreateCompanionBuilder,
      $$HearingsTableUpdateCompanionBuilder,
      (Hearing, $$HearingsTableReferences),
      Hearing,
      PrefetchHooks Function({bool caseId})
    >;
typedef $$DocumentFoldersTableCreateCompanionBuilder =
    DocumentFoldersCompanion Function({
      Value<int> id,
      required int caseId,
      required String name,
      required String createdAt,
    });
typedef $$DocumentFoldersTableUpdateCompanionBuilder =
    DocumentFoldersCompanion Function({
      Value<int> id,
      Value<int> caseId,
      Value<String> name,
      Value<String> createdAt,
    });

final class $$DocumentFoldersTableReferences
    extends
        BaseReferences<_$AppDatabase, $DocumentFoldersTable, DocumentFolder> {
  $$DocumentFoldersTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CasesTable _caseIdTable(_$AppDatabase db) => db.cases.createAlias(
    $_aliasNameGenerator(db.documentFolders.caseId, db.cases.id),
  );

  $$CasesTableProcessedTableManager get caseId {
    final $_column = $_itemColumn<int>('case_id')!;

    final manager = $$CasesTableTableManager(
      $_db,
      $_db.cases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$DocumentImagesTable, List<DocumentImage>>
  _documentImagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.documentImages,
    aliasName: $_aliasNameGenerator(
      db.documentFolders.id,
      db.documentImages.folderId,
    ),
  );

  $$DocumentImagesTableProcessedTableManager get documentImagesRefs {
    final manager = $$DocumentImagesTableTableManager(
      $_db,
      $_db.documentImages,
    ).filter((f) => f.folderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_documentImagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DocumentFoldersTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentFoldersTable> {
  $$DocumentFoldersTableFilterComposer({
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

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CasesTableFilterComposer get caseId {
    final $$CasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableFilterComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> documentImagesRefs(
    Expression<bool> Function($$DocumentImagesTableFilterComposer f) f,
  ) {
    final $$DocumentImagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentImages,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentImagesTableFilterComposer(
            $db: $db,
            $table: $db.documentImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentFoldersTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentFoldersTable> {
  $$DocumentFoldersTableOrderingComposer({
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

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CasesTableOrderingComposer get caseId {
    final $$CasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableOrderingComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentFoldersTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentFoldersTable> {
  $$DocumentFoldersTableAnnotationComposer({
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

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CasesTableAnnotationComposer get caseId {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> documentImagesRefs<T extends Object>(
    Expression<T> Function($$DocumentImagesTableAnnotationComposer a) f,
  ) {
    final $$DocumentImagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.documentImages,
      getReferencedColumn: (t) => t.folderId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentImagesTableAnnotationComposer(
            $db: $db,
            $table: $db.documentImages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DocumentFoldersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentFoldersTable,
          DocumentFolder,
          $$DocumentFoldersTableFilterComposer,
          $$DocumentFoldersTableOrderingComposer,
          $$DocumentFoldersTableAnnotationComposer,
          $$DocumentFoldersTableCreateCompanionBuilder,
          $$DocumentFoldersTableUpdateCompanionBuilder,
          (DocumentFolder, $$DocumentFoldersTableReferences),
          DocumentFolder,
          PrefetchHooks Function({bool caseId, bool documentImagesRefs})
        > {
  $$DocumentFoldersTableTableManager(
    _$AppDatabase db,
    $DocumentFoldersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentFoldersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentFoldersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentFoldersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> caseId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => DocumentFoldersCompanion(
                id: id,
                caseId: caseId,
                name: name,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int caseId,
                required String name,
                required String createdAt,
              }) => DocumentFoldersCompanion.insert(
                id: id,
                caseId: caseId,
                name: name,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DocumentFoldersTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({caseId = false, documentImagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (documentImagesRefs) db.documentImages,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (caseId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.caseId,
                                    referencedTable:
                                        $$DocumentFoldersTableReferences
                                            ._caseIdTable(db),
                                    referencedColumn:
                                        $$DocumentFoldersTableReferences
                                            ._caseIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (documentImagesRefs)
                        await $_getPrefetchedData<
                          DocumentFolder,
                          $DocumentFoldersTable,
                          DocumentImage
                        >(
                          currentTable: table,
                          referencedTable: $$DocumentFoldersTableReferences
                              ._documentImagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$DocumentFoldersTableReferences(
                                db,
                                table,
                                p0,
                              ).documentImagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.folderId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$DocumentFoldersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentFoldersTable,
      DocumentFolder,
      $$DocumentFoldersTableFilterComposer,
      $$DocumentFoldersTableOrderingComposer,
      $$DocumentFoldersTableAnnotationComposer,
      $$DocumentFoldersTableCreateCompanionBuilder,
      $$DocumentFoldersTableUpdateCompanionBuilder,
      (DocumentFolder, $$DocumentFoldersTableReferences),
      DocumentFolder,
      PrefetchHooks Function({bool caseId, bool documentImagesRefs})
    >;
typedef $$DocumentImagesTableCreateCompanionBuilder =
    DocumentImagesCompanion Function({
      Value<int> id,
      required int folderId,
      required String filePath,
      Value<int> sortOrder,
      required String addedAt,
    });
typedef $$DocumentImagesTableUpdateCompanionBuilder =
    DocumentImagesCompanion Function({
      Value<int> id,
      Value<int> folderId,
      Value<String> filePath,
      Value<int> sortOrder,
      Value<String> addedAt,
    });

final class $$DocumentImagesTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentImagesTable, DocumentImage> {
  $$DocumentImagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $DocumentFoldersTable _folderIdTable(_$AppDatabase db) =>
      db.documentFolders.createAlias(
        $_aliasNameGenerator(db.documentImages.folderId, db.documentFolders.id),
      );

  $$DocumentFoldersTableProcessedTableManager get folderId {
    final $_column = $_itemColumn<int>('folder_id')!;

    final manager = $$DocumentFoldersTableTableManager(
      $_db,
      $_db.documentFolders,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_folderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$DocumentImagesTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentImagesTable> {
  $$DocumentImagesTableFilterComposer({
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

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DocumentFoldersTableFilterComposer get folderId {
    final $$DocumentFoldersTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.documentFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFoldersTableFilterComposer(
            $db: $db,
            $table: $db.documentFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentImagesTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentImagesTable> {
  $$DocumentImagesTableOrderingComposer({
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

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DocumentFoldersTableOrderingComposer get folderId {
    final $$DocumentFoldersTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.documentFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFoldersTableOrderingComposer(
            $db: $db,
            $table: $db.documentFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentImagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentImagesTable> {
  $$DocumentImagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  $$DocumentFoldersTableAnnotationComposer get folderId {
    final $$DocumentFoldersTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.folderId,
      referencedTable: $db.documentFolders,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DocumentFoldersTableAnnotationComposer(
            $db: $db,
            $table: $db.documentFolders,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DocumentImagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentImagesTable,
          DocumentImage,
          $$DocumentImagesTableFilterComposer,
          $$DocumentImagesTableOrderingComposer,
          $$DocumentImagesTableAnnotationComposer,
          $$DocumentImagesTableCreateCompanionBuilder,
          $$DocumentImagesTableUpdateCompanionBuilder,
          (DocumentImage, $$DocumentImagesTableReferences),
          DocumentImage,
          PrefetchHooks Function({bool folderId})
        > {
  $$DocumentImagesTableTableManager(
    _$AppDatabase db,
    $DocumentImagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentImagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentImagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentImagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> folderId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> addedAt = const Value.absent(),
              }) => DocumentImagesCompanion(
                id: id,
                folderId: folderId,
                filePath: filePath,
                sortOrder: sortOrder,
                addedAt: addedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int folderId,
                required String filePath,
                Value<int> sortOrder = const Value.absent(),
                required String addedAt,
              }) => DocumentImagesCompanion.insert(
                id: id,
                folderId: folderId,
                filePath: filePath,
                sortOrder: sortOrder,
                addedAt: addedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DocumentImagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({folderId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (folderId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.folderId,
                                referencedTable: $$DocumentImagesTableReferences
                                    ._folderIdTable(db),
                                referencedColumn:
                                    $$DocumentImagesTableReferences
                                        ._folderIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$DocumentImagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentImagesTable,
      DocumentImage,
      $$DocumentImagesTableFilterComposer,
      $$DocumentImagesTableOrderingComposer,
      $$DocumentImagesTableAnnotationComposer,
      $$DocumentImagesTableCreateCompanionBuilder,
      $$DocumentImagesTableUpdateCompanionBuilder,
      (DocumentImage, $$DocumentImagesTableReferences),
      DocumentImage,
      PrefetchHooks Function({bool folderId})
    >;
typedef $$ActivityLogTableCreateCompanionBuilder =
    ActivityLogCompanion Function({
      Value<int> id,
      required String type,
      Value<int?> caseId,
      Value<int?> hearingId,
      required String title,
      required String createdAt,
    });
typedef $$ActivityLogTableUpdateCompanionBuilder =
    ActivityLogCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<int?> caseId,
      Value<int?> hearingId,
      Value<String> title,
      Value<String> createdAt,
    });

final class $$ActivityLogTableReferences
    extends BaseReferences<_$AppDatabase, $ActivityLogTable, ActivityLogData> {
  $$ActivityLogTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CasesTable _caseIdTable(_$AppDatabase db) => db.cases.createAlias(
    $_aliasNameGenerator(db.activityLog.caseId, db.cases.id),
  );

  $$CasesTableProcessedTableManager? get caseId {
    final $_column = $_itemColumn<int>('case_id');
    if ($_column == null) return null;
    final manager = $$CasesTableTableManager(
      $_db,
      $_db.cases,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_caseIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ActivityLogTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogTable> {
  $$ActivityLogTableFilterComposer({
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

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hearingId => $composableBuilder(
    column: $table.hearingId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CasesTableFilterComposer get caseId {
    final $$CasesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableFilterComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogTable> {
  $$ActivityLogTableOrderingComposer({
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

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hearingId => $composableBuilder(
    column: $table.hearingId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CasesTableOrderingComposer get caseId {
    final $$CasesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableOrderingComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogTable> {
  $$ActivityLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get hearingId =>
      $composableBuilder(column: $table.hearingId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CasesTableAnnotationComposer get caseId {
    final $$CasesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.caseId,
      referencedTable: $db.cases,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CasesTableAnnotationComposer(
            $db: $db,
            $table: $db.cases,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivityLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLogTable,
          ActivityLogData,
          $$ActivityLogTableFilterComposer,
          $$ActivityLogTableOrderingComposer,
          $$ActivityLogTableAnnotationComposer,
          $$ActivityLogTableCreateCompanionBuilder,
          $$ActivityLogTableUpdateCompanionBuilder,
          (ActivityLogData, $$ActivityLogTableReferences),
          ActivityLogData,
          PrefetchHooks Function({bool caseId})
        > {
  $$ActivityLogTableTableManager(_$AppDatabase db, $ActivityLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int?> caseId = const Value.absent(),
                Value<int?> hearingId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> createdAt = const Value.absent(),
              }) => ActivityLogCompanion(
                id: id,
                type: type,
                caseId: caseId,
                hearingId: hearingId,
                title: title,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                Value<int?> caseId = const Value.absent(),
                Value<int?> hearingId = const Value.absent(),
                required String title,
                required String createdAt,
              }) => ActivityLogCompanion.insert(
                id: id,
                type: type,
                caseId: caseId,
                hearingId: hearingId,
                title: title,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ActivityLogTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({caseId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (caseId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.caseId,
                                referencedTable: $$ActivityLogTableReferences
                                    ._caseIdTable(db),
                                referencedColumn: $$ActivityLogTableReferences
                                    ._caseIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ActivityLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLogTable,
      ActivityLogData,
      $$ActivityLogTableFilterComposer,
      $$ActivityLogTableOrderingComposer,
      $$ActivityLogTableAnnotationComposer,
      $$ActivityLogTableCreateCompanionBuilder,
      $$ActivityLogTableUpdateCompanionBuilder,
      (ActivityLogData, $$ActivityLogTableReferences),
      ActivityLogData,
      PrefetchHooks Function({bool caseId})
    >;
typedef $$NotificationHistoryTableCreateCompanionBuilder =
    NotificationHistoryCompanion Function({
      Value<int> id,
      required String triggeredAt,
      required String summary,
    });
typedef $$NotificationHistoryTableUpdateCompanionBuilder =
    NotificationHistoryCompanion Function({
      Value<int> id,
      Value<String> triggeredAt,
      Value<String> summary,
    });

class $$NotificationHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationHistoryTable> {
  $$NotificationHistoryTableFilterComposer({
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

  ColumnFilters<String> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationHistoryTable> {
  $$NotificationHistoryTableOrderingComposer({
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

  ColumnOrderings<String> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationHistoryTable> {
  $$NotificationHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get triggeredAt => $composableBuilder(
    column: $table.triggeredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);
}

class $$NotificationHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationHistoryTable,
          NotificationHistoryData,
          $$NotificationHistoryTableFilterComposer,
          $$NotificationHistoryTableOrderingComposer,
          $$NotificationHistoryTableAnnotationComposer,
          $$NotificationHistoryTableCreateCompanionBuilder,
          $$NotificationHistoryTableUpdateCompanionBuilder,
          (
            NotificationHistoryData,
            BaseReferences<
              _$AppDatabase,
              $NotificationHistoryTable,
              NotificationHistoryData
            >,
          ),
          NotificationHistoryData,
          PrefetchHooks Function()
        > {
  $$NotificationHistoryTableTableManager(
    _$AppDatabase db,
    $NotificationHistoryTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationHistoryTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationHistoryTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> triggeredAt = const Value.absent(),
                Value<String> summary = const Value.absent(),
              }) => NotificationHistoryCompanion(
                id: id,
                triggeredAt: triggeredAt,
                summary: summary,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String triggeredAt,
                required String summary,
              }) => NotificationHistoryCompanion.insert(
                id: id,
                triggeredAt: triggeredAt,
                summary: summary,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationHistoryTable,
      NotificationHistoryData,
      $$NotificationHistoryTableFilterComposer,
      $$NotificationHistoryTableOrderingComposer,
      $$NotificationHistoryTableAnnotationComposer,
      $$NotificationHistoryTableCreateCompanionBuilder,
      $$NotificationHistoryTableUpdateCompanionBuilder,
      (
        NotificationHistoryData,
        BaseReferences<
          _$AppDatabase,
          $NotificationHistoryTable,
          NotificationHistoryData
        >,
      ),
      NotificationHistoryData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CourtsTableTableManager get courts =>
      $$CourtsTableTableManager(_db, _db.courts);
  $$CasesTableTableManager get cases =>
      $$CasesTableTableManager(_db, _db.cases);
  $$HearingsTableTableManager get hearings =>
      $$HearingsTableTableManager(_db, _db.hearings);
  $$DocumentFoldersTableTableManager get documentFolders =>
      $$DocumentFoldersTableTableManager(_db, _db.documentFolders);
  $$DocumentImagesTableTableManager get documentImages =>
      $$DocumentImagesTableTableManager(_db, _db.documentImages);
  $$ActivityLogTableTableManager get activityLog =>
      $$ActivityLogTableTableManager(_db, _db.activityLog);
  $$NotificationHistoryTableTableManager get notificationHistory =>
      $$NotificationHistoryTableTableManager(_db, _db.notificationHistory);
}
