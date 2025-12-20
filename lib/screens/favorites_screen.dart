import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  final List<Map<String, dynamic>> exchanges = const [
    {
      'name': 'Binance',
      'icon': Icons.account_balance_wallet,
      'color': Colors.amber,
      'website': 'https://www.binance.com',
      'description':
          'بایننس بزرگ‌ترین صرافی ارز دیجیتال جهان از نظر حجم معاملات روزانه است. این صرافی از بیش از ۶۰۰ ارز دیجیتال پشتیبانی می‌کند و کارمزد بسیار پایینی دارد که با استفاده از توکن BNB حتی کمتر هم می‌شود. امکانات پیشرفته‌ای مانند معاملات فیوچرز، استیکینگ، لانچ‌پد و اپلیکیشن موبایل عالی ارائه می‌دهد. هم برای کاربران مبتدی و هم حرفه‌ای مناسب است. توجه: برای کاربران ایرانی احراز هویت لازم نیست، اما به دلیل تحریم‌ها توصیه می‌شود با VPN استفاده شود.',
    },
    {
      'name': 'Bybit',
      'icon': Icons.trending_up,
      'color': Colors.cyan,
      'website': 'https://www.bybit.com',
      'description':
          'بای‌بیت یکی از بهترین صرافی‌ها برای معاملات فیوچرز و مشتقه محسوب می‌شود. کارمزد بسیار پایین، رابط کاربری سریع و حرفه‌ای، پشتیبانی ۲۴ ساعته و بونوس‌های جذاب برای کاربران جدید دارد. بدون نیاز به احراز هویت (KYC) می‌توانید تا سقف بالایی برداشت روزانه داشته باشید. در حال حاضر یکی از بهترین و امن‌ترین گزینه‌ها برای کاربران ایرانی است.',
    },
    {
      'name': 'KuCoin',
      'icon': Icons.star,
      'color': Colors.deepPurple,
      'website': 'https://www.kucoin.com',
      'description':
          'کوکوین با پشتیبانی از بیش از ۷۰۰ ارز دیجیتال، یکی از متنوع‌ترین صرافی‌هاست. بدون نیاز به احراز هویت برای معاملات و برداشت محدود فعالیت می‌کند. امکانات استیکینگ، لانچ‌پول برای پروژه‌های جدید و اپلیکیشن کاربرپسند دارد. گزینه‌ای عالی برای کسانی که به دنبال آلت‌کوین‌های جدید و ناشناخته هستند.',
    },
    {
      'name': 'OKX',
      'icon': Icons.flash_on,
      'color': Colors.orange,
      'website': 'https://www.okx.com',
      'description':
          'اوکی‌ایکس یکی از قدرتمندترین صرافی‌ها با امکانات پیشرفته مانند معاملات اسپات، فیوچرز، آپشن و ربات معاملاتی داخلی است. کارمزد رقابتی دارد و احراز هویت اجباری نیست (تا سقف مشخص). پشتیبانی از وب۳ و والت داخلی نیز ارائه می‌دهد. انتخابی عالی برای تریدرهای حرفه‌ای.',
    },
    {
      'name': 'Coinbase',
      'icon': Icons.verified,
      'color': Colors.blue,
      'website': 'https://www.coinbase.com',
      'description':
          'کوین‌بیس معتبرترین صرافی آمریکایی با مجوزهای رسمی و امنیت بسیار بالاست. رابط کاربری بسیار ساده‌ای دارد و برای مبتدیان عالی است. امکان خرید مستقیم با کارت اعتباری و آموزش‌های رایگان با پاداش ارز دیجیتال ارائه می‌دهد. با این حال نیاز به احراز هویت کامل دارد و برای کاربران ایرانی محدودیت‌هایی وجود دارد.',
    },
    {
      'name': 'Kraken',
      'icon': Icons.security,
      'color': Colors.teal,
      'website': 'https://www.kraken.com',
      'description':
          'کراکن یکی از قدیمی‌ترین صرافی‌های جهان (تأسیس ۲۰۱۱) با سابقه امنیتی بی‌نقص است. امنیت بسیار بالا، پشتیبانی عالی از مشتریان و کارمزد منطقی دارد. گزینه‌ای مناسب برای نگهداری بلندمدت دارایی‌هاست. البته نیاز به احراز هویت دارد و رابط کاربری کمی پیچیده‌تر است.',
    },
    {
      'name': 'Gate.io',
      'icon': Icons.door_sliding,
      'color': Colors.redAccent,
      'website': 'https://www.gate.io',
      'description':
          'گیت‌ایو با تنوع بسیار بالای ارزها و تمرکز روی پروژه‌های جدید شناخته می‌شود. لانچ‌پول، ایردراپ و معاملات فیوچرز ارائه می‌دهد. بدون نیاز به احراز هویت برای برداشت محدود فعالیت می‌کند و کارمزد مناسبی دارد. گزینه‌ای عالی برای شکار پروژه‌های نوظهور و پرسود.',
    },
    {
      'name': 'Bitget',
      'icon': Icons.change_circle,
      'color': Colors.indigo,
      'website': 'https://www.bitget.com',
      'description':
          'بیت‌گت صرافی رو به رشدی است که روی کپی‌تریدینگ تمرکز دارد. امکان کپی کردن معاملات تریدرهای حرفه‌ای، کارمزد پایین، بونوس‌های جذاب و معاملات فیوچرز با لوریج بالا ارائه می‌دهد. احراز هویت اجباری نیست و برای کسانی که می‌خواهند از تجربه دیگران استفاده کنند، گزینه‌ای عالی است.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('صرافی‌ها'),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black87,
        elevation: 4,
        shadowColor: Colors.purple.withOpacity(0.2),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: exchanges.length,
        itemBuilder: (context, index) {
          final exchange = exchanges[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: isDark ? Colors.grey[850] : Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: (exchange['color'] as Color).withOpacity(0.2),
                child: Icon(
                  exchange['icon'] as IconData,
                  color: exchange['color'] as Color,
                  size: 30,
                ),
              ),
              title: Text(
                exchange['name'] as String,
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    72,
                    0,
                    20,
                    24,
                  ), 
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.end, 
                    children: [
                      Text(
                        exchange['description'] as String,
                        textAlign: TextAlign.right, 
                        textDirection: TextDirection.rtl, 
                        style: TextStyle(
                          fontSize: 15.5,
                          height: 1.7,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment
                            .centerLeft, 
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final uri = Uri.parse(
                              exchange['website'] as String,
                            );
                            if (await canLaunchUrl(uri)) {
                              launchUrl(
                                uri,
                                mode: LaunchMode.externalApplication,
                              );
                            }
                          },
                          icon: const Icon(Icons.open_in_new, size: 20),
                          label: const Text(
                            'بازدید از وبسایت',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: exchange['color'] as Color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
