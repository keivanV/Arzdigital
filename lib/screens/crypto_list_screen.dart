import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'crypto_detail_screen.dart';
import '../widgets/heartbeat_badge.dart';

class CryptoListScreen extends StatefulWidget {
  const CryptoListScreen({super.key});

  @override
  State<CryptoListScreen> createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  List<dynamic> cryptos = [];
  List<dynamic> filteredCryptos = [];
  bool loading = true;

  int totalCoins = 0;
  double usdtPrice = 1.0;
  double totalVolume = 0;
  double totalMarketCap = 0;
  double btcDominance = 0;

  final String cmcApiKey = 'a5afbfda-db7e-440b-8a03-4a6134595a5a';
  final String baseUrl = 'https://pro-api.coinmarketcap.com';
  final double usdToIrr = 620000; // نرخ تقریبی دلار به تومان

  @override
  void initState() {
    super.initState();
    fetchCryptos();
    fetchGlobalData();
  }

  Future<void> fetchCryptos() async {
    setState(() => loading = true);
    final url = Uri.parse(
      '$baseUrl/v1/cryptocurrency/listings/latest?limit=100',
    );
    final response = await http.get(
      url,
      headers: {'X-CMC_PRO_API_KEY': cmcApiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        cryptos = data['data'];
        filteredCryptos = cryptos;
        loading = false;
      });
    } else {
      setState(() => loading = false);
    }
  }

  Future<void> fetchGlobalData() async {
    try {
      final globalResp = await http.get(
        Uri.parse('https://api.coingecko.com/api/v3/global'),
      );
      if (globalResp.statusCode == 200) {
        final globalData = json.decode(globalResp.body)['data'];
        setState(() {
          totalCoins = globalData['active_cryptocurrencies'] ?? 0;
          totalMarketCap = (globalData['total_market_cap']?['usd'] ?? 0)
              .toDouble();
          totalVolume = (globalData['total_volume']?['usd'] ?? 0).toDouble();
          btcDominance = (globalData['market_cap_percentage']?['btc'] ?? 0)
              .toDouble();
        });
      }

      final usdtResp = await http.get(
        Uri.parse(
          'https://api.coingecko.com/api/v3/simple/price?ids=tether&vs_currencies=usd',
        ),
      );
      if (usdtResp.statusCode == 200) {
        final usdtData = json.decode(usdtResp.body);
        setState(() {
          usdtPrice = (usdtData['tether']?['usd'] ?? 1.0).toDouble();
        });
      }
    } catch (e) {
      // خطاها نادیده گرفته می‌شوند
    }
  }

  String formatPriceInIrr(double usdPrice) {
    final irrPrice = usdPrice * usdToIrr;
    return NumberFormat.compact(locale: 'fa_IR').format(irrPrice) + ' تومان';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? Colors.grey[850] : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 4,
        shadowColor: Colors.purple.withOpacity(0.3),
        title: Center(
          child: Text(
            'arzdigital',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 1.2,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: textColor),
            onPressed: () => showSearch(
              context: context,
              delegate: CryptoSearchDelegate(cryptos),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: isDark ? Colors.grey[900] : Colors.grey[100],
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 60,
                right: 16,
                left: 16,
                bottom: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.close, color: textColor, size: 32),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    'منو',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    context,
                    'رمز ارز ها',
                    Icons.currency_bitcoin,
                  ),
                  _buildDrawerItem(context, 'دیده بان', Icons.remove_red_eye),
                  _buildDrawerItem(context, 'ابزار ها', Icons.build),
                  _buildDrawerItem(context, 'محصولات', Icons.shopping_bag),
                  _buildDrawerItem(context, 'نمای بازار', Icons.bar_chart),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // آمار بالا
          Container(
            width: double.infinity,
            color: isDark ? Colors.grey[900] : Colors.grey[200],
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatItem(
                    'تعداد ارزها:',
                    NumberFormat.compact().format(totalCoins),
                  ),
                  _buildStatItem(
                    'قیمت تتر:',
                    '\$${usdtPrice.toStringAsFixed(4)}',
                  ),

                  _buildStatItem(
                    'ارزش بازار:',
                    '\$${NumberFormat.compact().format(totalMarketCap)}',
                  ),
                  _buildStatItem(
                    'دامیننس BTC:',
                    '${btcDominance.toStringAsFixed(1)}%',
                  ),
                ],
              ),
            ),
          ),
          // هدر جدول
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            color: isDark ? Colors.grey[850] : Colors.grey[300],
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'تغییرات',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'قیمت',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    'ارز دیجیتال',
                    textAlign: TextAlign.end,
                    style: TextStyle(color: subTextColor, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          // لیست ارزها
          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.purple),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await fetchCryptos();
                      await fetchGlobalData();
                    },
                    child: ListView.builder(
                      itemCount: filteredCryptos.length,
                      itemBuilder: (context, index) {
                        final crypto = filteredCryptos[index];
                        final price = crypto['quote']['USD']['price'];
                        final change24 =
                            crypto['quote']['USD']['percent_change_24h'];
                        final marketCap = crypto['quote']['USD']['market_cap'];

                        return InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CryptoDetailScreen(crypto: crypto),
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: cardBg?.withOpacity(0.95),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.purple.withOpacity(isDark ? 0.2 : 0.1),
                                  Colors.blue.withOpacity(isDark ? 0.2 : 0.1),
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.purple.withOpacity(
                                    isDark ? 0.3 : 0.15,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // سمت چپ: تغییرات + مارکت کپ (چپ‌چین)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    HeartbeatBadge(change24: change24),
                                    const SizedBox(height: 8),
                                    Text(
                                      'MCap: \$${NumberFormat.compact().format(marketCap)}',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: subTextColor,
                                      ),
                                    ),
                                  ],
                                ),

                                // وسط: قیمت دلار (بالا) و تومان (پایین) — کاملاً وسط و منظم
                                const Spacer(),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      '\$${NumberFormat.compact().format(price)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatPriceInIrr(price),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: subTextColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                // سمت راست: نام + رتبه + لوگو (راست‌چین)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          crypto['name'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: textColor,
                                          ),
                                        ),
                                        Text(
                                          '#${crypto['cmc_rank']} • ${crypto['symbol']}',
                                          style: TextStyle(
                                            color: subTextColor,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    CachedNetworkImage(
                                      imageUrl:
                                          'https://s2.coinmarketcap.com/static/img/coins/64x64/${crypto['id']}.png',
                                      width: 48,
                                      height: 48,
                                      placeholder: (_, __) => Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isDark
                                              ? Colors.grey[800]
                                              : Colors.grey[300],
                                        ),
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.purple,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, String title, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      trailing: Icon(icon, color: Colors.purple),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('رفتن به: $title')));
      },
    );
  }
}

// کلاس جستجو (بدون تغییر)
class CryptoSearchDelegate extends SearchDelegate<String> {
  final List<dynamic> cryptos;
  CryptoSearchDelegate(this.cryptos);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, ''),
  );

  @override
  Widget buildResults(BuildContext context) {
    final results = cryptos
        .where(
          (c) =>
              c['name'].toLowerCase().contains(query.toLowerCase()) ||
              c['symbol'].toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    if (results.isEmpty) {
      return const Center(
        child: Text(
          'هیچ نتیجه‌ای یافت نشد 😔',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final c = results[i];
        final price = c['quote']['USD']['price'];
        final change24 = c['quote']['USD']['percent_change_24h'];
        return ListTile(
          leading: CachedNetworkImage(
            imageUrl:
                'https://s2.coinmarketcap.com/static/img/coins/64x64/${c['id']}.png',
            width: 40,
            height: 40,
          ),
          title: Text('${c['name']} (${c['symbol']})'),
          subtitle: Text(
            '\$${NumberFormat('#,##0.00').format(price)} • ${change24.toStringAsFixed(2)}%',
          ),
          trailing: Icon(
            change24 > 0 ? Icons.trending_up : Icons.trending_down,
            color: change24 > 0 ? Colors.green : Colors.red,
          ),
          onTap: () {
            close(context, c['name']);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CryptoDetailScreen(crypto: c)),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? cryptos.take(10).toList()
        : cryptos
              .where(
                (c) =>
                    c['name'].toLowerCase().contains(query.toLowerCase()) ||
                    c['symbol'].toLowerCase().contains(query.toLowerCase()),
              )
              .take(8)
              .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, i) {
        final c = suggestions[i];
        return ListTile(
          leading: CachedNetworkImage(
            imageUrl:
                'https://s2.coinmarketcap.com/static/img/coins/64x64/${c['id']}.png',
            width: 40,
            height: 40,
          ),
          title: Text(c['name']),
          subtitle: Text(c['symbol']),
          onTap: () {
            query = c['name'];
            showResults(context);
          },
        );
      },
    );
  }
}
