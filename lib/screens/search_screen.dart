import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'crypto_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // فیلترها
  String _changeFilter = 'all'; // all, positive, negative
  String _marketCapFilter = 'all'; // all, high, mid, low
  double _minVolume = 0; // میلیون دلار
  Set<String> _selectedCategories = {};

  // دسته‌بندی‌های نمونه
  final List<String> categories = [
    'DeFi',
    'Meme',
    'Layer 1',
    'Layer 2',
    'AI',
    'Gaming',
    'NFT',
    'Stablecoin',
    'Oracle',
  ];

  // داده‌های نمونه (در آینده از لیست اصلی cryptos بگیر)
  List<Map<String, dynamic>> sampleCryptos = [
    {
      'name': 'Bitcoin',
      'symbol': 'BTC',
      'price': 95000,
      'change24': 2.5,
      'marketCap': 1.8e12,
      'volume24': 35e9,
      'id': 1,
    },
    {
      'name': 'Ethereum',
      'symbol': 'ETH',
      'price': 3500,
      'change24': -1.2,
      'marketCap': 420e9,
      'volume24': 15e9,
      'id': 1027,
    },
    {
      'name': 'Solana',
      'symbol': 'SOL',
      'price': 180,
      'change24': 5.8,
      'marketCap': 80e9,
      'volume24': 4e9,
      'id': 5426,
    },
    {
      'name': 'Dogecoin',
      'symbol': 'DOGE',
      'price': 0.25,
      'change24': -3.4,
      'marketCap': 35e9,
      'volume24': 2e9,
      'id': 74,
    },
    {
      'name': 'Pepe',
      'symbol': 'PEPE',
      'price': 0.000012,
      'change24': 12.3,
      'marketCap': 5e9,
      'volume24': 1.5e9,
      'id': 12345,
    },
  ];

  List<Map<String, dynamic>> get filteredCryptos {
    return sampleCryptos.where((crypto) {
      final matchesSearch =
          crypto['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          crypto['symbol'].toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesChange =
          _changeFilter == 'all' ||
          (_changeFilter == 'positive' && crypto['change24'] > 0) ||
          (_changeFilter == 'negative' && crypto['change24'] < 0);

      final matchesMarketCap =
          _marketCapFilter == 'all' ||
          (_marketCapFilter == 'high' && crypto['marketCap'] >= 1e12) ||
          (_marketCapFilter == 'mid' &&
              crypto['marketCap'] >= 1e11 &&
              crypto['marketCap'] < 1e12) ||
          (_marketCapFilter == 'low' && crypto['marketCap'] < 1e11);

      final matchesVolume = crypto['volume24'] >= _minVolume * 1e6;

      return matchesSearch &&
          matchesChange &&
          matchesMarketCap &&
          matchesVolume;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        title: const Text('جستجوی پیشرفته'),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: textColor,
        elevation: 4,
      ),
      body: Column(
        children: [
          // فیلد جستجو
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'جستجو بر اساس نام یا نماد...',
                hintStyle: TextStyle(color: subColor),
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // فیلتر تغییرات ۲۴ ساعته
                _buildFilterSection(
                  title: 'تغییرات ۲۴ ساعته',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildChip(
                        'همه',
                        _changeFilter == 'all',
                        () => setState(() => _changeFilter = 'all'),
                      ),
                      _buildChip(
                        'مثبت ↑',
                        _changeFilter == 'positive',
                        () => setState(() => _changeFilter = 'positive'),
                        color: Colors.green,
                      ),
                      _buildChip(
                        'منفی ↓',
                        _changeFilter == 'negative',
                        () => setState(() => _changeFilter = 'negative'),
                        color: Colors.red,
                      ),
                    ],
                  ),
                ),

                // فیلتر مارکت کپ
                _buildFilterSection(
                  title: 'مارکت کپ',
                  child: Wrap(
                    spacing: 10,
                    children: [
                      _buildChip(
                        'همه',
                        _marketCapFilter == 'all',
                        () => setState(() => _marketCapFilter = 'all'),
                      ),
                      _buildChip(
                        'بالای ۱T',
                        _marketCapFilter == 'high',
                        () => setState(() => _marketCapFilter = 'high'),
                      ),
                      _buildChip(
                        '۱۰۰B - ۱T',
                        _marketCapFilter == 'mid',
                        () => setState(() => _marketCapFilter = 'mid'),
                      ),
                      _buildChip(
                        'زیر ۱۰۰B',
                        _marketCapFilter == 'low',
                        () => setState(() => _marketCapFilter = 'low'),
                      ),
                    ],
                  ),
                ),

                // فیلتر حجم
                _buildFilterSection(
                  title: 'حداقل حجم ۲۴ ساعته (میلیون دلار)',
                  child: Slider(
                    value: _minVolume,
                    min: 0,
                    max: 10000,
                    divisions: 100,
                    label: _minVolume.round().toString(),
                    onChanged: (value) => setState(() => _minVolume = value),
                  ),
                ),

                // دسته‌بندی‌ها
                _buildFilterSection(
                  title: 'دسته‌بندی',
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: categories.map((cat) {
                      final selected = _selectedCategories.contains(cat);
                      return FilterChip(
                        label: Text(cat),
                        selected: selected,
                        onSelected: (bool sel) {
                          setState(() {
                            if (sel) {
                              _selectedCategories.add(cat);
                            } else {
                              _selectedCategories.remove(cat);
                            }
                          });
                        },
                        selectedColor: Colors.purple.withOpacity(0.3),
                        checkmarkColor: Colors.purple,
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _changeFilter = 'all';
                          _marketCapFilter = 'all';
                          _minVolume = 0;
                          _selectedCategories.clear();
                        });
                      },
                      child: const Text('پاک کردن فیلترها'),
                    ),
                    ElevatedButton(
                      onPressed: () => setState(() {}),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                      ),
                      child: const Text(
                        'اعمال فیلترها',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Text(
                  'نتایج (${filteredCryptos.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 12),

                // لیست نتایج
                if (filteredCryptos.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Text(
                        'هیچ ارزی با این فیلترها یافت نشد 😔',
                        style: TextStyle(fontSize: 18, color: subColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                else
                  ...filteredCryptos.map(
                    (crypto) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      color: isDark ? Colors.grey[850] : Colors.white,
                      child: ListTile(
                        onTap: () {
                          // در آینده crypto واقعی رو پاس بده
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => CryptoDetailScreen(crypto: crypto)));
                        },
                        leading: CachedNetworkImage(
                          imageUrl:
                              'https://s2.coinmarketcap.com/static/img/coins/64x64/${crypto['id']}.png',
                          width: 48,
                          height: 48,
                          placeholder: (_, __) =>
                              const CircularProgressIndicator(),
                        ),
                        title: Text(
                          '${crypto['name']} (${crypto['symbol']})',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        subtitle: Text(
                          '\$${NumberFormat.compact().format(crypto['price'])} • ${crypto['change24'] > 0 ? '+' : ''}${crypto['change24'].toStringAsFixed(2)}%',
                          style: TextStyle(
                            color: crypto['change24'] > 0
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                        trailing: Text(
                          'MCap: \$${NumberFormat.compact().format(crypto['marketCap'])}',
                          style: TextStyle(fontSize: 12, color: subColor),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        child,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildChip(
    String label,
    bool selected,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: (color ?? Colors.purple).withOpacity(0.3),
      backgroundColor: Colors.grey.withOpacity(0.2),
      labelStyle: TextStyle(color: selected ? (color ?? Colors.purple) : null),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
