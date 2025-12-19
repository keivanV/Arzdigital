import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';

class CryptoDetailScreen extends StatefulWidget {
  final dynamic crypto;
  const CryptoDetailScreen({super.key, required this.crypto});

  @override
  State<CryptoDetailScreen> createState() => _CryptoDetailScreenState();
}

class _CryptoDetailScreenState extends State<CryptoDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  List<FlSpot> chartData = [];
  bool chartLoading = true;
  String chartError = '';
  Map<String, dynamic> extraInfo = {};
  final String apiKey = 'a5afbfda-db7e-440b-8a03-4a6134595a5a';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchChartData();
    fetchExtraInfo();
  }

  Future<void> fetchExtraInfo() async {
    final id = widget.crypto['id'];
    final url = Uri.parse(
      'https://pro-api.coinmarketcap.com/v1/cryptocurrency/info?id=$id',
    );
    final response = await http.get(
      url,
      headers: {'X-CMC_PRO_API_KEY': apiKey},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'][id.toString()];
      setState(() => extraInfo = data);
    }
  }

  Future<void> fetchChartData() async {
    setState(() {
      chartLoading = true;
      chartError = '';
      chartData = [];
    });

    try {
      String slug =
          widget.crypto['slug'] ?? widget.crypto['symbol'].toLowerCase();
      final resp = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/coins/$slug/market_chart?vs_currency=usd&days=30',
        ),
      );
      if (resp.statusCode == 200) {
        final prices = json.decode(resp.body)['prices'] as List;
        if (prices.isNotEmpty) {
          final spots = <FlSpot>[];
          final total = prices.length;
          for (int i = 0; i < 30; i++) {
            final idx = (i * (total - 1) / 29).round();
            spots.add(FlSpot(i.toDouble(), prices[idx][1].toDouble()));
          }
          setState(() {
            chartData = spots;
            chartLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        chartError = 'چارت موقتاً در دسترس نیست 😔';
        chartLoading = false;
      });
    }
  }

  final fakeComments = [
    {
      'user': 'Ali Reza',
      'date': '2025-12-18',
      'text': 'عالیه، قیمتش داره میره بالا! 🚀',
    },
    {
      'user': 'Sara',
      'date': '2025-12-15',
      'text': 'به نظرم بهترین ارز دیجیتال هست.',
    },
    {
      'user': 'Mohammad',
      'date': '2025-12-10',
      'text': 'کمی ریسکیه ولی پتانسیل خوبی داره.',
    },
    {
      'user': 'Neda',
      'date': '2025-12-05',
      'text': 'من سرمایه گذاری کردم، سود خوبی داد 😍',
    },
    {'user': 'Hossein', 'date': '2025-12-03', 'text': 'آینده روشنه! 🌟'},
  ];

  @override
  Widget build(BuildContext context) {
    final crypto = widget.crypto;
    final q = crypto['quote']['USD'];
    final price = q['price'];
    final change24 = q['percent_change_24h'];
    final change7d = q['percent_change_7d'];
    final change30d = q['percent_change_30d'];
    final volume24 = q['volume_24h'];
    final marketCap = q['market_cap'];

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchChartData,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 320,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.indigo, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        'https://s2.coinmarketcap.com/static/img/coins/128x128/${crypto['id']}.png',
                    width: 110,
                    height: 110,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    crypto['name'],
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    crypto['symbol'],
                    style: const TextStyle(fontSize: 20, color: Colors.white70),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(price)}',
                    style: const TextStyle(
                      fontSize: 42,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${change24.toStringAsFixed(2)}% (24h)',
                    style: TextStyle(
                      fontSize: 22,
                      color: change24 > 0 ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            labelColor: Colors.purple,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.purple,
            tabs: const [
              Tab(text: 'اطلاعات'),
              Tab(text: 'چارت'),
              Tab(text: 'نظرات'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoCard('رتبه', '#${crypto['cmc_rank']}'),
                      _buildInfoCard(
                        'مارکت کپ',
                        '\$${NumberFormat.compact().format(marketCap)}',
                      ),
                      _buildInfoCard(
                        'حجم ۲۴ ساعته',
                        '\$${NumberFormat.compact().format(volume24)}',
                      ),
                      _buildInfoCard(
                        'تغییر ۷ روزه',
                        '${change7d?.toStringAsFixed(2) ?? '-'}%',
                        isChange: true,
                        changeValue: change7d ?? 0,
                      ),
                      _buildInfoCard(
                        'تغییر ۳۰ روزه',
                        '${change30d?.toStringAsFixed(2) ?? '-'}%',
                        isChange: true,
                        changeValue: change30d ?? 0,
                      ),
                      _buildInfoCard(
                        'در گردش',
                        NumberFormat.compact().format(
                          crypto['circulating_supply'] ?? 0,
                        ),
                      ),
                      if (extraInfo['urls'] != null) ...[
                        const SizedBox(height: 20),
                        if (extraInfo['urls']['website']?.isNotEmpty == true)
                          _buildLinkButton(
                            'وبسایت رسمی',
                            extraInfo['urls']['website'][0],
                          ),
                        if (extraInfo['urls']['explorer']?.isNotEmpty == true)
                          _buildLinkButton(
                            'اکسپلورر',
                            extraInfo['urls']['explorer'][0],
                          ),
                      ],
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                  child: chartLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.purple,
                          ),
                        )
                      : chartData.isEmpty
                      ? Center(
                          child: Text(
                            chartError,
                            style: const TextStyle(
                              color: Colors.orange,
                              fontSize: 18,
                            ),
                          ),
                        )
                      : LineChart(
                          LineChartData(
                            gridData: const FlGridData(show: true),
                            borderData: FlBorderData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 45,
                                  getTitlesWidget: (value, meta) {
                                    final day = value.toInt();
                                    if (day == 0)
                                      return const Text(
                                        '۳۰ روز قبل',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      );
                                    if (day == 14)
                                      return const Text(
                                        '۱۶ روز قبل',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      );
                                    if (day == 29)
                                      return const Text(
                                        'امروز',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 11,
                                        ),
                                      );
                                    return const Text('');
                                  },
                                ),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                            ),
                            minX: 0,
                            maxX: 29,
                            minY:
                                chartData
                                    .map((e) => e.y)
                                    .reduce((a, b) => a < b ? a : b) *
                                0.95,
                            maxY:
                                chartData
                                    .map((e) => e.y)
                                    .reduce((a, b) => a > b ? a : b) *
                                1.05,
                            lineBarsData: [
                              LineChartBarData(
                                spots: chartData,
                                isCurved: true,
                                color: Colors.purpleAccent,
                                barWidth: 5,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.purple.withOpacity(0.3),
                                ),
                              ),
                            ],
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                getTooltipItems: (spots) => spots.map((spot) {
                                  final daysAgo = 29 - spot.x.toInt();
                                  final dayText = daysAgo == 0
                                      ? 'امروز'
                                      : '$daysAgo روز قبل';
                                  return LineTooltipItem(
                                    '\$${spot.y.toStringAsFixed(2)}\n$dayText',
                                    const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                ),
                ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: fakeComments.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: Text(
                          'نظرات کاربران ✨',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    final c = fakeComments[i - 1];
                    return Card(
                      color: Colors.purple.withOpacity(0.15),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 20,
                                  child: Icon(Icons.person, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  c['user']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  c['date']!,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              c['text']!,
                              style: const TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    String label,
    String value, {
    bool isChange = false,
    double changeValue = 0,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 17, color: Colors.white70),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isChange
                  ? (changeValue > 0 ? Colors.green : Colors.red)
                  : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkButton(String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri))
            launchUrl(uri, mode: LaunchMode.externalApplication);
        },
        icon: const Icon(Icons.link),
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
