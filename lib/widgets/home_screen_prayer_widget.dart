import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:adhan/adhan.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../services/prayer_time_service.dart';
import '../screens/prayer_times_screen.dart';

class HomeScreenPrayerWidget extends StatefulWidget {
  const HomeScreenPrayerWidget({super.key});

  @override
  State<HomeScreenPrayerWidget> createState() => _HomeScreenPrayerWidgetState();
}

class _HomeScreenPrayerWidgetState extends State<HomeScreenPrayerWidget> {
  final PrayerTimeService _prayerTimeService = PrayerTimeService();
  PrayerTimes? _prayerTimes;
  String? _errorMessage;
  Timer? _timer;
  Duration? _timeUntilNextPrayer;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('da_DK', null).then((_) {
      _loadPrayerTimes();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    try {
      final prayerTimes = await _prayerTimeService.getPrayerTimes();
      if (mounted) {
        setState(() {
          _prayerTimes = prayerTimes;
        });
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Kunne ikke hente bønnetider";
        });
      }
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_prayerTimes == null) return;

      final now = DateTime.now();
      Prayer nextPrayerEnum = _prayerTimes!.nextPrayer();
      DateTime? nextPrayerTime;

      if (nextPrayerEnum == Prayer.none) {
        final tomorrow = now.add(const Duration(days: 1));
        final tomorrowPrayerTimes = PrayerTimes(
          _prayerTimes!.coordinates,
          DateComponents.from(tomorrow),
          _prayerTimes!.calculationParameters,
        );
        nextPrayerTime = tomorrowPrayerTimes.fajr;
      } else {
        nextPrayerTime = _prayerTimes!.timeForPrayer(nextPrayerEnum);
      }

      if (nextPrayerTime != null) {
        setState(() {
          _timeUntilNextPrayer = nextPrayerTime!.difference(now);
        });
      }
    });
  }

  String _formatDuration(Duration duration) {
    if (duration.isNegative) return "0s";
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return "${hours}t ${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PrayerTimesScreen()),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_errorMessage != null) {
      return Text(_errorMessage!, style: const TextStyle(color: Colors.red));
    }

    if (_prayerTimes == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Prayer nextPrayerEnum = _prayerTimes!.nextPrayer();

    if (nextPrayerEnum == Prayer.none) {
      nextPrayerEnum = Prayer.fajr;
    }

    final nextPrayerName = nextPrayerEnum.toString().split('.').last;

    final prayerNames = {
      'fajr': 'Fajr',
      'sunrise': 'Solopgang',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Næste bøn er',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Text(
          prayerNames[nextPrayerName] ?? '',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 4),
        if (_timeUntilNextPrayer != null)
          Text(
            'om ${_formatDuration(_timeUntilNextPrayer!)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Tryk for at se alle tider',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[500]),
          ],
        ),
      ],
    );
  }
}
