import 'package:flutter/material.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../services/prayer_time_service.dart';

class PrayerTimesScreen extends StatefulWidget {
  const PrayerTimesScreen({super.key});

  @override
  State<PrayerTimesScreen> createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  final PrayerTimeService _prayerTimeService = PrayerTimeService();
  PrayerTimes? _prayerTimes;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('da_DK', null).then((_) {
      _loadPrayerTimes();
    });
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final prayerTimes = await _prayerTimeService.getPrayerTimes();
      if (mounted) {
        setState(() {
          _prayerTimes = prayerTimes;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bønnetider'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: _prayerTimes == null && _errorMessage == null
            ? const CircularProgressIndicator()
            : _errorMessage != null
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 16),
                ),
              )
            : _buildPrayerTimesList(),
      ),
    );
  }

  Widget _buildPrayerTimesList() {
    String currentPrayer = _prayerTimes!
        .currentPrayer()
        .toString()
        .split('.')
        .last;
    String nextPrayer = _prayerTimes!.nextPrayer().toString().split('.').last;

    Map<String, String> prayerNames = {
      'fajr': 'Fajr',
      'sunrise': 'Solopgang',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
      'none': '',
    };

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('EEEE, d. MMMM yyyy', 'da_DK').format(DateTime.now()),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
          const SizedBox(height: 24),
          _buildPrayerTimeRow(
            'Fajr',
            _prayerTimes!.fajr,
            Icons.brightness_4_outlined,
            currentPrayer == 'fajr',
          ),
          _buildPrayerTimeRow(
            'Solopgang',
            _prayerTimes!.sunrise,
            Icons.wb_sunny_outlined,
            false,
          ),
          _buildPrayerTimeRow(
            'Dhuhr',
            _prayerTimes!.dhuhr,
            Icons.wb_sunny,
            currentPrayer == 'dhuhr',
          ),
          _buildPrayerTimeRow(
            'Asr',
            _prayerTimes!.asr,
            Icons.brightness_6_outlined,
            currentPrayer == 'asr',
          ),
          _buildPrayerTimeRow(
            'Maghrib',
            _prayerTimes!.maghrib,
            Icons.brightness_5_outlined,
            currentPrayer == 'maghrib',
          ),
          _buildPrayerTimeRow(
            'Isha',
            _prayerTimes!.isha,
            Icons.nights_stay_outlined,
            currentPrayer == 'isha',
          ),
          const SizedBox(height: 24),
          Text(
            'Næste bøn er ${prayerNames[nextPrayer]}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeRow(
    String name,
    DateTime time,
    IconData icon,
    bool isCurrent,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: isCurrent ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
          color: isCurrent
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 16),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Text(
              DateFormat.jm('da_DK').format(time),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
