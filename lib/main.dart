import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String appName = 'DUPOUY SIBE NATHALIE';
const String developerName = 'DUPOUY SIBE NATHALIE';
const String supportEmail = 'support@dupouysibenathalie.fr';
const bool screenshotMode = bool.fromEnvironment('SCREENSHOT_MODE');

const Color brandPrimary = Color(0xFF0157D3);
const Color brandSecondary = Color(0xFF168F9D);
const Color brandAccent = Color(0xFF54DCE7);
const Color brandInk = Color(0xFF224062);
const Color brandSurface = Color(0xFFF6FAFC);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(OperationsApp(store: OperationsStore(screenshotMode: screenshotMode)));
}

class OperationsApp extends StatelessWidget {
  const OperationsApp({required this.store, super.key});

  final OperationsStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: buildTheme(Brightness.light),
      darkTheme: buildTheme(Brightness.dark),
      home: OperationsHome(store: store),
    );
  }
}

ThemeData buildTheme(Brightness brightness) {
  final scheme = ColorScheme.fromSeed(
    seedColor: brandPrimary,
    brightness: brightness,
    primary: brandPrimary,
    secondary: brandSecondary,
    tertiary: const Color(0xFF3D7D55),
    surface: brightness == Brightness.light
        ? brandSurface
        : const Color(0xFF111A24),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: brightness == Brightness.light
        ? brandSurface
        : scheme.surface,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: brightness == Brightness.light
          ? brandSurface
          : scheme.surface,
      foregroundColor: brightness == Brightness.light
          ? brandInk
          : scheme.onSurface,
      elevation: 0,
      titleTextStyle: TextStyle(
        color: brightness == Brightness.light ? brandInk : scheme.onSurface,
        fontWeight: FontWeight.w800,
        fontSize: 18,
        letterSpacing: 0,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: brightness == Brightness.light
          ? Colors.white
          : scheme.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.55)),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.light
          ? Colors.white
          : scheme.surfaceContainerHighest,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      height: 72,
      indicatorColor: brandAccent.withValues(alpha: 0.25),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w800
              : FontWeight.w600,
          letterSpacing: 0,
        ),
      ),
    ),
  );
}

enum OpsArea { payroll, procurement, inventory, workOrders }

extension OpsAreaCopy on OpsArea {
  String get label => switch (this) {
    OpsArea.payroll => 'Payroll',
    OpsArea.procurement => 'Requests',
    OpsArea.inventory => 'Inventory',
    OpsArea.workOrders => 'Orders',
  };

  String get fullLabel => switch (this) {
    OpsArea.payroll => 'Payroll reports',
    OpsArea.procurement => 'Procurement requests',
    OpsArea.inventory => 'Inventory tracking',
    OpsArea.workOrders => 'Work orders',
  };

  String get objectLabel => switch (this) {
    OpsArea.payroll => 'Report',
    OpsArea.procurement => 'Request',
    OpsArea.inventory => 'Item',
    OpsArea.workOrders => 'Work order',
  };

  String get titleLabel => switch (this) {
    OpsArea.payroll => 'Report title',
    OpsArea.procurement => 'Request title',
    OpsArea.inventory => 'Item name',
    OpsArea.workOrders => 'Work order title',
  };

  String get amountLabel => switch (this) {
    OpsArea.payroll => 'Payroll value',
    OpsArea.procurement => 'Budget',
    OpsArea.inventory => 'Units on hand',
    OpsArea.workOrders => 'Estimated hours',
  };

  String get amountPrefix => switch (this) {
    OpsArea.payroll => 'EUR ',
    OpsArea.procurement => 'EUR ',
    OpsArea.inventory => '',
    OpsArea.workOrders => '',
  };

  String get amountSuffix => switch (this) {
    OpsArea.payroll => '',
    OpsArea.procurement => '',
    OpsArea.inventory => ' units',
    OpsArea.workOrders => ' hrs',
  };

  String get ownerLabel => switch (this) {
    OpsArea.payroll => 'Prepared by',
    OpsArea.procurement => 'Requester',
    OpsArea.inventory => 'Stock owner',
    OpsArea.workOrders => 'Assigned team',
  };

  String get newAction => switch (this) {
    OpsArea.payroll => 'New payroll report',
    OpsArea.procurement => 'New procurement request',
    OpsArea.inventory => 'New inventory item',
    OpsArea.workOrders => 'New work order',
  };

  String get emptyMessage => switch (this) {
    OpsArea.payroll => 'Add payroll reports as each period closes.',
    OpsArea.procurement => 'Track purchases from request through receipt.',
    OpsArea.inventory =>
      'Add stock items that need cycle counts or reorder checks.',
    OpsArea.workOrders => 'Plan assignments, repairs, and operational tasks.',
  };

  IconData get icon => switch (this) {
    OpsArea.payroll => Icons.payments_outlined,
    OpsArea.procurement => Icons.assignment_add,
    OpsArea.inventory => Icons.inventory_2_outlined,
    OpsArea.workOrders => Icons.engineering_outlined,
  };

  List<String> get statuses => switch (this) {
    OpsArea.payroll => ['Draft', 'Reviewed', 'Paid'],
    OpsArea.procurement => ['Requested', 'Ordered', 'Received'],
    OpsArea.inventory => ['In stock', 'Reorder', 'Cycle count'],
    OpsArea.workOrders => ['Queued', 'In progress', 'Closed'],
  };

  Color statusColor(String status) {
    final colors = switch (this) {
      OpsArea.payroll => const [
        Color(0xFF8B5E00),
        Color(0xFF1565C0),
        Color(0xFF2E7D32),
      ],
      OpsArea.procurement => const [
        Color(0xFF7B3F00),
        Color(0xFF0B6E79),
        Color(0xFF2E7D32),
      ],
      OpsArea.inventory => const [
        Color(0xFF2E7D32),
        Color(0xFFC62828),
        Color(0xFF6A4C93),
      ],
      OpsArea.workOrders => const [
        Color(0xFF7B3F00),
        Color(0xFF1565C0),
        Color(0xFF2E7D32),
      ],
    };
    final index = statuses.indexOf(status);
    return colors[index < 0 ? 0 : index.clamp(0, colors.length - 1)];
  }
}

class OpsRecord {
  OpsRecord({
    required this.id,
    required this.area,
    required this.title,
    required this.owner,
    required this.status,
    required this.amount,
    required this.dueDate,
    required this.notes,
  });

  final String id;
  final OpsArea area;
  final String title;
  final String owner;
  final String status;
  final double amount;
  final DateTime dueDate;
  final String notes;

  OpsRecord copyWith({
    String? id,
    OpsArea? area,
    String? title,
    String? owner,
    String? status,
    double? amount,
    DateTime? dueDate,
    String? notes,
  }) {
    return OpsRecord(
      id: id ?? this.id,
      area: area ?? this.area,
      title: title ?? this.title,
      owner: owner ?? this.owner,
      status: status ?? this.status,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'area': area.name,
      'title': title,
      'owner': owner,
      'status': status,
      'amount': amount,
      'dueDate': dueDate.toIso8601String(),
      'notes': notes,
    };
  }

  factory OpsRecord.fromJson(Map<String, Object?> json) {
    final areaName = json['area']?.toString();
    final area = OpsArea.values.firstWhere(
      (candidate) => candidate.name == areaName,
      orElse: () => OpsArea.workOrders,
    );
    final dueDate = DateTime.tryParse(json['dueDate']?.toString() ?? '');

    return OpsRecord(
      id: json['id']?.toString() ?? UniqueKey().toString(),
      area: area,
      title: json['title']?.toString() ?? area.objectLabel,
      owner: json['owner']?.toString() ?? 'Operations',
      status: json['status']?.toString() ?? area.statuses.first,
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      dueDate: dueDate ?? DateTime.now().add(const Duration(days: 7)),
      notes: json['notes']?.toString() ?? '',
    );
  }
}

class LocalSettings {
  const LocalSettings({
    required this.workspace,
    required this.manager,
    required this.reviewCadence,
  });

  final String workspace;
  final String manager;
  final String reviewCadence;

  static const fallback = LocalSettings(
    workspace: 'Main operations desk',
    manager: 'Local operations lead',
    reviewCadence: 'Daily close review',
  );

  LocalSettings copyWith({
    String? workspace,
    String? manager,
    String? reviewCadence,
  }) {
    return LocalSettings(
      workspace: workspace ?? this.workspace,
      manager: manager ?? this.manager,
      reviewCadence: reviewCadence ?? this.reviewCadence,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'workspace': workspace,
      'manager': manager,
      'reviewCadence': reviewCadence,
    };
  }

  factory LocalSettings.fromJson(Map<String, Object?> json) {
    return LocalSettings(
      workspace: json['workspace']?.toString() ?? fallback.workspace,
      manager: json['manager']?.toString() ?? fallback.manager,
      reviewCadence:
          json['reviewCadence']?.toString() ?? fallback.reviewCadence,
    );
  }
}

class OperationsStore {
  OperationsStore({required this.screenshotMode});

  static const String _recordsKey = 'ops_records_v1';
  static const String _settingsKey = 'ops_settings_v1';

  final bool screenshotMode;

  Future<List<OpsRecord>> loadRecords() async {
    if (screenshotMode) {
      return sampleRecords();
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_recordsKey);
    if (raw == null || raw.isEmpty) {
      return <OpsRecord>[];
    }

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded
          .whereType<Map<String, Object?>>()
          .map(OpsRecord.fromJson)
          .toList()
        ..sort(sortRecords);
    } on FormatException {
      return <OpsRecord>[];
    } on TypeError {
      return <OpsRecord>[];
    }
  }

  Future<void> saveRecords(List<OpsRecord> records) async {
    if (screenshotMode) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _recordsKey,
      jsonEncode(records.map((record) => record.toJson()).toList()),
    );
  }

  Future<LocalSettings> loadSettings() async {
    if (screenshotMode) {
      return const LocalSettings(
        workspace: 'Rennes operations room',
        manager: 'Nathalie Sibe',
        reviewCadence: '09:00 and 16:30 checks',
      );
    }

    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_settingsKey);
    if (raw == null || raw.isEmpty) {
      return LocalSettings.fallback;
    }

    try {
      return LocalSettings.fromJson(jsonDecode(raw) as Map<String, Object?>);
    } on FormatException {
      return LocalSettings.fallback;
    } on TypeError {
      return LocalSettings.fallback;
    }
  }

  Future<void> saveSettings(LocalSettings settings) async {
    if (screenshotMode) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}

int sortRecords(OpsRecord a, OpsRecord b) {
  final areaCompare = a.area.index.compareTo(b.area.index);
  if (areaCompare != 0) {
    return areaCompare;
  }
  return a.dueDate.compareTo(b.dueDate);
}

List<OpsRecord> sampleRecords() {
  return [
    OpsRecord(
      id: 'payroll-may',
      area: OpsArea.payroll,
      title: 'DUPOUY SIBE NATHALIE',
      owner: 'Finance desk',
      status: 'Reviewed',
      amount: 48200,
      dueDate: DateTime(2026, 5, 13),
      notes: 'Overtime checks are complete; director approval is pending.',
    ),
    OpsRecord(
      id: 'payroll-vacation',
      area: OpsArea.payroll,
      title: 'Leave balance report',
      owner: 'People operations',
      status: 'Draft',
      amount: 18,
      dueDate: DateTime(2026, 5, 18),
      notes: 'Compare balance changes against signed May requests.',
    ),
    OpsRecord(
      id: 'proc-supplies',
      area: OpsArea.procurement,
      title: 'Packing supplies refill',
      owner: 'Warehouse lead',
      status: 'Ordered',
      amount: 1260,
      dueDate: DateTime(2026, 5, 12),
      notes: 'Supplier confirmed partial delivery for the morning route.',
    ),
    OpsRecord(
      id: 'proc-maintenance',
      area: OpsArea.procurement,
      title: 'Maintenance tooling',
      owner: 'Workshop',
      status: 'Requested',
      amount: 890,
      dueDate: DateTime(2026, 5, 17),
      notes: 'Compare two supplier quotes before ordering.',
    ),
    OpsRecord(
      id: 'stock-labels',
      area: OpsArea.inventory,
      title: 'Label rolls A42',
      owner: 'Stock room',
      status: 'Reorder',
      amount: 24,
      dueDate: DateTime(2026, 5, 12),
      notes: 'Minimum level is 30 units. Add to the next supplier order.',
    ),
    OpsRecord(
      id: 'stock-chemicals',
      area: OpsArea.inventory,
      title: 'Cleaning concentrate',
      owner: 'Facilities',
      status: 'Cycle count',
      amount: 64,
      dueDate: DateTime(2026, 5, 15),
      notes: 'Count sealed units only and separate damaged containers.',
    ),
    OpsRecord(
      id: 'order-dock',
      area: OpsArea.workOrders,
      title: 'Dock door sensor check',
      owner: 'Maintenance',
      status: 'In progress',
      amount: 3,
      dueDate: DateTime(2026, 5, 11),
      notes: 'Test open and close states after replacing the sensor bracket.',
    ),
    OpsRecord(
      id: 'order-audit',
      area: OpsArea.workOrders,
      title: 'Friday safety walk',
      owner: 'Operations team',
      status: 'Queued',
      amount: 2,
      dueDate: DateTime(2026, 5, 16),
      notes: 'Use the east aisle checklist and record blocking issues.',
    ),
  ]..sort(sortRecords);
}

class OperationsHome extends StatefulWidget {
  const OperationsHome({required this.store, super.key});

  final OperationsStore store;

  @override
  State<OperationsHome> createState() => _OperationsHomeState();
}

class _OperationsHomeState extends State<OperationsHome> {
  int _index = 0;
  bool _loading = true;
  List<OpsRecord> _records = <OpsRecord>[];
  LocalSettings _settings = LocalSettings.fallback;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final records = await widget.store.loadRecords();
    final settings = await widget.store.loadSettings();
    if (!mounted) {
      return;
    }
    setState(() {
      _records = records;
      _settings = settings;
      _loading = false;
    });
  }

  Future<void> _upsertRecord(OpsRecord record) async {
    final updated = List<OpsRecord>.of(_records)
      ..removeWhere((candidate) => candidate.id == record.id)
      ..add(record)
      ..sort(sortRecords);
    setState(() => _records = updated);
    await widget.store.saveRecords(updated);
  }

  Future<void> _saveSettings(LocalSettings settings) async {
    setState(() => _settings = settings);
    await widget.store.saveSettings(settings);
  }

  Future<void> _openEditor(OpsArea area, {OpsRecord? existing}) async {
    final result = await showModalBottomSheet<OpsRecord>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (context) => RecordEditor(area: area, existing: existing),
    );
    if (result != null) {
      await _upsertRecord(result);
    }
  }

  Future<void> _openDetail(OpsRecord record) async {
    final updated = await Navigator.of(context).push<OpsRecord>(
      MaterialPageRoute(
        builder: (context) => RecordDetailScreen(
          record: record,
          onEdit: () => _openEditor(record.area, existing: record),
        ),
      ),
    );
    if (updated != null) {
      await _upsertRecord(updated);
    }
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsScreen(
          settings: _settings,
          onSettingsChanged: _saveSettings,
          recordsCount: _records.length,
          screenshotMode: widget.store.screenshotMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedArea = _areaForIndex(_index);

    return Scaffold(
      appBar: AppBar(
        title: const Text(appName),
        actions: [
          IconButton(
            key: const Key('settingsButton'),
            tooltip: 'Settings',
            onPressed: _openSettings,
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: _index,
              children: [
                DashboardScreen(
                  records: _records,
                  settings: _settings,
                  onAreaSelected: (area) =>
                      setState(() => _index = _indexForArea(area)),
                  onCreate: _openEditor,
                  onRecordSelected: _openDetail,
                ),
                for (final area in OpsArea.values)
                  AreaScreen(
                    key: PageStorageKey(area.name),
                    area: area,
                    records: _records
                        .where((record) => record.area == area)
                        .toList(),
                    onCreate: () => _openEditor(area),
                    onRecordSelected: _openDetail,
                  ),
              ],
            ),
      floatingActionButton: selectedArea == null || _loading
          ? null
          : FloatingActionButton.extended(
              key: const Key('addRecordButton'),
              tooltip: selectedArea.newAction,
              onPressed: () => _openEditor(selectedArea),
              icon: const Icon(Icons.add),
              label: const Text('New'),
            ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (index) => setState(() => _index = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: 'Payroll',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment),
            label: 'Requests',
          ),
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
          NavigationDestination(
            icon: Icon(Icons.engineering_outlined),
            selectedIcon: Icon(Icons.engineering),
            label: 'Orders',
          ),
        ],
      ),
    );
  }

  OpsArea? _areaForIndex(int index) {
    if (index <= 0 || index > OpsArea.values.length) {
      return null;
    }
    return OpsArea.values[index - 1];
  }

  int _indexForArea(OpsArea area) => area.index + 1;
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    required this.records,
    required this.settings,
    required this.onAreaSelected,
    required this.onCreate,
    required this.onRecordSelected,
    super.key,
  });

  final List<OpsRecord> records;
  final LocalSettings settings;
  final ValueChanged<OpsArea> onAreaSelected;
  final void Function(OpsArea area, {OpsRecord? existing}) onCreate;
  final ValueChanged<OpsRecord> onRecordSelected;

  @override
  Widget build(BuildContext context) {
    final urgent = records
        .where((record) => record.status != record.area.statuses.last)
        .take(4)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        HeaderPanel(settings: settings, records: records),
        const SizedBox(height: 16),
        Text(
          'Operational lanes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: OpsArea.values.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.18,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final area = OpsArea.values[index];
            final areaRecords = records
                .where((record) => record.area == area)
                .toList();
            return AreaSummaryCard(
              area: area,
              records: areaRecords,
              onTap: () => onAreaSelected(area),
            );
          },
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: Text(
                'Attention queue',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            TextButton.icon(
              onPressed: () => onCreate(OpsArea.procurement),
              icon: const Icon(Icons.add),
              label: const Text('Request'),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (urgent.isEmpty)
          const EmptyState(
            icon: Icons.task_alt,
            title: 'No active records',
            message: 'Add work as it arrives to keep the daily review current.',
          )
        else
          for (final record in urgent)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RecordCard(
                record: record,
                onTap: () => onRecordSelected(record),
              ),
            ),
      ],
    );
  }
}

class HeaderPanel extends StatelessWidget {
  const HeaderPanel({required this.settings, required this.records, super.key});

  final LocalSettings settings;
  final List<OpsRecord> records;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final closed = records
        .where((record) => record.status == record.area.statuses.last)
        .length;
    final dueSoon = records.where((record) {
      final days = record.dueDate.difference(DateTime.now()).inDays;
      return days <= 3 && record.status != record.area.statuses.last;
    }).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: brandInk,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: brandAccent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: brandAccent.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.apartment, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      settings.workspace,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      settings.reviewCadence,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.78),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: MetricPill(
                  label: 'Open',
                  value: '${records.length - closed}',
                  color: brandAccent,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricPill(
                  label: 'Due soon',
                  value: '$dueSoon',
                  color: const Color(0xFFFFC857),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: MetricPill(
                  label: 'Closed',
                  value: '$closed',
                  color: scheme.tertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class MetricPill extends StatelessWidget {
  const MetricPill({
    required this.label,
    required this.value,
    required this.color,
    super.key,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.78),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class AreaSummaryCard extends StatelessWidget {
  const AreaSummaryCard({
    required this.area,
    required this.records,
    required this.onTap,
    super.key,
  });

  final OpsArea area;
  final List<OpsRecord> records;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final open = records
        .where((record) => record.status != record.area.statuses.last)
        .length;
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(area.icon, color: area.statusColor(area.statuses.first)),
                  const Spacer(),
                  Text(
                    '$open open',
                    style: TextStyle(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                area.fullLabel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Text(
                '${records.length} saved',
                style: TextStyle(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AreaScreen extends StatelessWidget {
  const AreaScreen({
    required this.area,
    required this.records,
    required this.onCreate,
    required this.onRecordSelected,
    super.key,
  });

  final OpsArea area;
  final List<OpsRecord> records;
  final VoidCallback onCreate;
  final ValueChanged<OpsRecord> onRecordSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        SectionIntro(area: area, records: records, onCreate: onCreate),
        const SizedBox(height: 12),
        if (records.isEmpty)
          EmptyState(
            icon: area.icon,
            title: 'No ${area.objectLabel.toLowerCase()} records',
            message: area.emptyMessage,
          )
        else
          for (final record in records)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: RecordCard(
                record: record,
                onTap: () => onRecordSelected(record),
              ),
            ),
      ],
    );
  }
}

class SectionIntro extends StatelessWidget {
  const SectionIntro({
    required this.area,
    required this.records,
    required this.onCreate,
    super.key,
  });

  final OpsArea area;
  final List<OpsRecord> records;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final active = records
        .where((record) => record.status != record.area.statuses.last)
        .length;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: area
                .statusColor(area.statuses.first)
                .withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(area.icon, color: area.statusColor(area.statuses.first)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                area.fullLabel,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$active active of ${records.length} saved records',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton.filledTonal(
          tooltip: area.newAction,
          onPressed: onCreate,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

class RecordCard extends StatelessWidget {
  const RecordCard({required this.record, required this.onTap, super.key});

  final OpsRecord record;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      record.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  StatusChip(record: record),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  InfoPill(icon: Icons.person_outline, label: record.owner),
                  InfoPill(
                    icon: Icons.calendar_today_outlined,
                    label: formatDate(record.dueDate),
                  ),
                  InfoPill(
                    icon: Icons.stacked_bar_chart,
                    label: formatAmount(record),
                  ),
                ],
              ),
              if (record.notes.trim().isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  record.notes,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({required this.record, super.key});

  final OpsRecord record;

  @override
  Widget build(BuildContext context) {
    final color = record.area.statusColor(record.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        record.status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class InfoPill extends StatelessWidget {
  const InfoPill({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.62),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: scheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: scheme.onSurfaceVariant,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Icon(icon, size: 34, color: brandSecondary),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordDetailScreen extends StatefulWidget {
  const RecordDetailScreen({
    required this.record,
    required this.onEdit,
    super.key,
  });

  final OpsRecord record;
  final VoidCallback onEdit;

  @override
  State<RecordDetailScreen> createState() => _RecordDetailScreenState();
}

class _RecordDetailScreenState extends State<RecordDetailScreen> {
  late OpsRecord _record;

  @override
  void initState() {
    super.initState();
    _record = widget.record;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.of(context).pop(_record);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_record.area.objectLabel),
          actions: [
            IconButton(
              tooltip: 'Edit',
              onPressed: widget.onEdit,
              icon: const Icon(Icons.edit_outlined),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_record.area.icon, color: brandPrimary),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _record.area.fullLabel,
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        StatusChip(record: _record),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _record.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        InfoPill(
                          icon: Icons.person_outline,
                          label: _record.owner,
                        ),
                        InfoPill(
                          icon: Icons.calendar_month_outlined,
                          label: 'Due ${formatDate(_record.dueDate)}',
                        ),
                        InfoPill(
                          icon: Icons.stacked_line_chart,
                          label: formatAmount(_record),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _record.notes.isEmpty ? 'No notes saved.' : _record.notes,
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Status', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            for (final status in _record.area.statuses)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: OutlinedButton.icon(
                  onPressed: () => setState(() {
                    _record = _record.copyWith(status: status);
                  }),
                  icon: Icon(
                    _record.status == status
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                  ),
                  label: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(status),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => Navigator.of(context).pop(_record),
              icon: const Icon(Icons.check),
              label: const Text('Save status'),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordEditor extends StatefulWidget {
  const RecordEditor({required this.area, this.existing, super.key});

  final OpsArea area;
  final OpsRecord? existing;

  @override
  State<RecordEditor> createState() => _RecordEditorState();
}

class _RecordEditorState extends State<RecordEditor> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _ownerController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late String _status;
  late DateTime _dueDate;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _ownerController = TextEditingController(text: existing?.owner ?? '');
    _amountController = TextEditingController(
      text: existing == null ? '' : trimDouble(existing.amount),
    );
    _notesController = TextEditingController(text: existing?.notes ?? '');
    _status = existing?.status ?? widget.area.statuses.first;
    _dueDate = existing?.dueDate ?? DateTime.now().add(const Duration(days: 7));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ownerController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 14, 16, bottomInset + 16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(widget.area.icon, color: brandPrimary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.existing == null
                          ? widget.area.newAction
                          : 'Edit ${widget.area.objectLabel.toLowerCase()}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: widget.area.titleLabel),
                validator: requiredText,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _ownerController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: widget.area.ownerLabel),
                validator: requiredText,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(labelText: widget.area.amountLabel),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Add a value';
                  }
                  if (double.tryParse(value.trim().replaceAll(',', '.')) ==
                      null) {
                    return 'Use a number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _status,
                items: widget.area.statuses
                    .map(
                      (status) =>
                          DropdownMenuItem(value: status, child: Text(status)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _status = value);
                  }
                },
                decoration: const InputDecoration(labelText: 'Status'),
              ),
              const SizedBox(height: 12),
              Text(
                'Due ${formatDate(_dueDate)}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ActionChip(
                    avatar: const Icon(Icons.today, size: 18),
                    label: const Text('Tomorrow'),
                    onPressed: () => _setDueDate(1),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.calendar_view_week, size: 18),
                    label: const Text('One week'),
                    onPressed: () => _setDueDate(7),
                  ),
                  ActionChip(
                    avatar: const Icon(Icons.event_available, size: 18),
                    label: const Text('One month'),
                    onPressed: () => _setDueDate(30),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                minLines: 3,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  key: const Key('saveRecordButton'),
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save record'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setDueDate(int days) {
    setState(() => _dueDate = DateTime.now().add(Duration(days: days)));
  }

  void _save() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final existing = widget.existing;
    final amount = double.parse(
      _amountController.text.trim().replaceAll(',', '.'),
    );
    final record = OpsRecord(
      id: existing?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      area: widget.area,
      title: _titleController.text.trim(),
      owner: _ownerController.text.trim(),
      status: _status,
      amount: amount,
      dueDate: _dueDate,
      notes: _notesController.text.trim(),
    );
    Navigator.of(context).pop(record);
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.settings,
    required this.onSettingsChanged,
    required this.recordsCount,
    required this.screenshotMode,
    super.key,
  });

  final LocalSettings settings;
  final ValueChanged<LocalSettings> onSettingsChanged;
  final int recordsCount;
  final bool screenshotMode;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late LocalSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
        children: [
          SettingsCard(
            icon: Icons.business_center_outlined,
            title: 'Workspace',
            lines: [
              _settings.workspace,
              _settings.manager,
              _settings.reviewCadence,
            ],
            action: OutlinedButton.icon(
              onPressed: _editWorkspace,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            ),
          ),
          SettingsCard(
            icon: Icons.storage_outlined,
            title: 'Local records',
            lines: [
              '${widget.recordsCount} saved records on this device',
              'Records stay in local app storage',
            ],
          ),
          const SettingsCard(
            icon: Icons.lock_outline,
            title: 'Privacy',
            lines: [
              'No account registration',
              'No analytics, ads, location, contacts, photos, or cloud sync',
              'Uninstalling the app removes locally stored app data according to Android behavior',
            ],
          ),
          const SettingsCard(
            icon: Icons.support_agent_outlined,
            title: 'Support',
            lines: [developerName, supportEmail],
          ),
        ],
      ),
    );
  }

  Future<void> _editWorkspace() async {
    final workspace = TextEditingController(text: _settings.workspace);
    final manager = TextEditingController(text: _settings.manager);
    final cadence = TextEditingController(text: _settings.reviewCadence);

    final result = await showDialog<LocalSettings>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Workspace'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: workspace,
                decoration: const InputDecoration(labelText: 'Workspace name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: manager,
                decoration: const InputDecoration(labelText: 'Manager'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: cadence,
                decoration: const InputDecoration(labelText: 'Review cadence'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(
                LocalSettings(
                  workspace: workspace.text.trim().isEmpty
                      ? LocalSettings.fallback.workspace
                      : workspace.text.trim(),
                  manager: manager.text.trim().isEmpty
                      ? LocalSettings.fallback.manager
                      : manager.text.trim(),
                  reviewCadence: cadence.text.trim().isEmpty
                      ? LocalSettings.fallback.reviewCadence
                      : cadence.text.trim(),
                ),
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    workspace.dispose();
    manager.dispose();
    cadence.dispose();

    if (result != null) {
      setState(() => _settings = result);
      widget.onSettingsChanged(result);
    }
  }
}

class SettingsCard extends StatelessWidget {
  const SettingsCard({
    required this.icon,
    required this.title,
    required this.lines,
    this.action,
    super.key,
  });

  final IconData icon;
  final String title;
  final List<String> lines;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: brandPrimary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ?action,
              ],
            ),
            const SizedBox(height: 10),
            for (final line in lines)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  line,
                  style: TextStyle(color: scheme.onSurfaceVariant),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

String? requiredText(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Required';
  }
  return null;
}

String formatDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}';
}

String formatAmount(OpsRecord record) {
  return '${record.area.amountPrefix}${trimDouble(record.amount)}${record.area.amountSuffix}';
}

String trimDouble(double value) {
  if (value == value.roundToDouble()) {
    return value.toStringAsFixed(0);
  }
  return value.toStringAsFixed(1);
}
