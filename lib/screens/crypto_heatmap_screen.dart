import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:syncfusion_flutter_treemap/treemap.dart';

class CryptoHeatmapScreen extends StatefulWidget {
  const CryptoHeatmapScreen({super.key});

  @override
  State<CryptoHeatmapScreen> createState() => _CryptoHeatmapScreenState();
}

class _CryptoHeatmapScreenState extends State<CryptoHeatmapScreen> {
  List<Map<String, dynamic>> cryptoData = [];
  bool isLoading = true;
  String? errorMessage;

  final String apiKey = 'a5afbfda-db7e-440b-8a03-4a6134595a5a';

  @override
  void initState() {
    super.initState();
    fetchCryptoData();
  }

  Future<void> fetchCryptoData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest?start=1&limit=100&convert=USD',
        ),
        headers: {'X-CMC_PRO_API_KEY': apiKey, 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];

        setState(() {
          cryptoData = data.map((coin) {
            final double? marketCap = coin['quote']['USD']['market_cap'];
            final double change =
                coin['quote']['USD']['percent_change_24h'] ?? 0.0;
            return {
              'symbol': coin['symbol'],
              'change': change,
              'marketCap': marketCap ?? 0.0,
            };
          }).toList();

          cryptoData.sort(
            (a, b) =>
                (b['marketCap'] as double).compareTo(a['marketCap'] as double),
          );

          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'خطا در دریافت داده: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'خطای شبکه: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('نمای  بازار'),
          foregroundColor: Colors.amber,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('نمای حرارتی کریپتو')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: fetchCryptoData,
                child: const Text('تلاش مجدد'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('نمای بازار'),
        foregroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => isLoading = true);
              fetchCryptoData();
            },
          ),
        ],
      ),
      body: SfTreemap(
        dataCount: cryptoData.length,
        weightValueMapper: (int index) =>
            cryptoData[index]['marketCap'] as double,
        tooltipSettings: const TreemapTooltipSettings(color: Colors.black87),
        colorMappers: <TreemapColorMapper>[
          TreemapColorMapper.range(
            from: -100,
            to: -15,
            color: Colors.red[900]!,
          ),
          TreemapColorMapper.range(from: -15, to: -10, color: Colors.red[800]!),
          TreemapColorMapper.range(from: -10, to: -5, color: Colors.red[700]!),
          TreemapColorMapper.range(from: -5, to: -2, color: Colors.red[500]!),
          TreemapColorMapper.range(from: -2, to: 0, color: Colors.red[400]!),
          TreemapColorMapper.range(from: 0, to: 2, color: Colors.green[400]!),
          TreemapColorMapper.range(from: 2, to: 5, color: Colors.green[500]!),
          TreemapColorMapper.range(from: 5, to: 10, color: Colors.green[700]!),
          TreemapColorMapper.range(from: 10, to: 15, color: Colors.green[800]!),
          TreemapColorMapper.range(
            from: 15,
            to: 100,
            color: Colors.green[900]!,
          ),
        ],
        levels: <TreemapLevel>[
          TreemapLevel(
            padding: const EdgeInsets.all(2.0),
            groupMapper: (int index) => cryptoData[index]['symbol'],
            colorValueMapper: (TreemapTile tile) {
              final int index = tile.indices[0];
              return cryptoData[index]['change'] as double;
            },
            labelBuilder: (BuildContext context, TreemapTile tile) {
              final int index = tile.indices[0];
              final String symbol = cryptoData[index]['symbol'];
              final double change = cryptoData[index]['change'];
              final double weight = tile.weight; // marketCap

              // فقط برای کوین‌های بزرگ (بالای ۵۰ میلیارد دلار) متن کامل (symbol + درصد)
              if (weight > 50e9) {
                return Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            symbol,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 32,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${change > 0 ? '+' : ''}${change.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // برای کوین‌های متوسط (بالای ۱۰ میلیارد) فقط symbol
              if (weight > 10e9) {
                return Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text(
                        symbol,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              }

              // کوچیک‌تر از ۱۰ میلیارد → هیچ متنی (جلوگیری کامل از overflow)
              return const SizedBox.shrink();
            },
            tooltipBuilder: (BuildContext context, TreemapTile tile) {
              final int index = tile.indices[0];
              final String symbol = cryptoData[index]['symbol'];
              final double change = cryptoData[index]['change'];

              return Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      symbol,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${change > 0 ? '+' : ''}${change.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: change >= 0
                            ? Colors.green[300]
                            : Colors.red[300],
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
