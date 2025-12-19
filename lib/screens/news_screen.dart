import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart' as intl;

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  final List<Map<String, String>> news = const [
    {
      'title': 'بیت‌کوین به سقف تاریخی جدید نزدیک شد!',
      'date': '۱۴۰۴/۰۹/۲۸',
      'image': 'https://cryptologos.cc/logos/bitcoin-btc-logo.png?v=032',
      'fullText': '''
بیت‌کوین در ۲۴ ساعت گذشته بیش از ۵٪ رشد داشته و اکنون در آستانه شکستن سقف تاریخی ۱۰۰,۰۰۰ دلار قرار گرفته است. 
تحلیلگران معتقدند با ورود سرمایه‌های نهادی و تأیید ETFهای جدید، این روند صعودی ادامه خواهد داشت. 
در حال حاضر دامیننس بیت‌کوین نیز به ۵۸٪ رسیده که نشان‌دهنده قدرت بالای آن در بازار است.
    ''',
    },
    {
      'title': 'اتریوم آماده آپدیت بزرگ Dencun',
      'date': '۱۴۰۴/۰۹/۲۷',
      'image': 'https://cryptologos.cc/logos/ethereum-eth-logo.png?v=032',
      'fullText': '''
آپدیت Dencun که قرار است در سه‌ماهه اول ۲۰۲۶ فعال شود، هزینه‌های لایه ۲ اتریوم را به شدت کاهش خواهد داد.
این آپدیت شامل proto-danksharding است که ظرفیت بلاکچین را به طور چشمگیری افزایش می‌دهد.
جامعه اتریوم بسیار هیجان‌زده است و قیمت ETH در واکنش به این خبر بیش از ۸٪ رشد کرده است.
    ''',
    },
    {
      'title': 'کاردانو به رتبه ۸ بازار بازگشت',
      'date': '۱۴۰۴/۰۹/۲۶',
      'image': 'https://cryptologos.cc/logos/cardano-ada-logo.png?v=032',
      'fullText': '''
پس از ماه‌ها اصلاح قیمت، کاردانو با رشد ۱۲٪ در هفته گذشته به رتبه ۸ مارکت‌کپ بازگشت.
توسعه‌دهندگان کاردانو اعلام کردند که هاردفورک جدید Chang به زودی فعال خواهد شد که حاکمیت غیرمتمرکز کامل را به ارمغان می‌آورد.
این خبر باعث جذب سرمایه‌گذاران نهادی جدید شده و چشم‌انداز روشنی برای آینده ADA ایجاد کرده است.
    ''',
    },
    {
      'title': 'ریپل در دادگاه SEC پیروز شد!',
      'date': '۱۴۰۴/۰۹/۲۵',
      'image': 'https://cryptologos.cc/logos/xrp-xrp-logo.png?v=032',
      'fullText': '''
دادگاه فدرال آمریکا حکم نهایی خود را صادر کرد: XRP یک اوراق بهادار نیست!
این پیروزی بزرگ برای ریپل باعث رشد ۲۵٪ قیمت XRP در کمتر از ۲۴ ساعت شد.
حالا صرافی‌های آمریکایی می‌توانند دوباره XRP را لیست کنند و انتظار می‌رود حجم معاملات به شدت افزایش یابد.
    ''',
    },
    {
      'title': 'تتر بیشترین حجم معاملات روزانه را ثبت کرد',
      'date': '۱۴۰۴/۰۹/۲۴',
      'image': 'https://cryptologos.cc/logos/tether-usdt-logo.png?v=032',
      'fullText': '''
استیبل‌کوین تتر (USDT) در ۲۴ ساعت گذشته بیش از ۱۲۰ میلیارد دلار حجم معاملات داشته که بالاترین رقم در تاریخ است.
این نشان‌دهنده افزایش فعالیت تریدرها در بازار کریپتو است.
تتر همچنان با اختلاف زیاد بزرگ‌ترین استیبل‌کوین جهان باقی مانده و بیش از ۷۰٪ بازار استیبل‌کوین‌ها را در اختیار دارد.
    ''',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('اخبار کریپتو'),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.amber : Colors.black,
        elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: news.length,
        itemBuilder: (context, index) {
          final item = news[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            color: isDark ? Colors.grey[850] : Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: isDark ? Colors.grey[900] : Colors.white,
                    title: Text(
                      item['title']!,
                      style: TextStyle(
                        color: isDark ? Colors.amber : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    content: SingleChildScrollView(
                      child: Text(
                        item['fullText']!.trim(),
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          'بستن',
                          style: TextStyle(color: Colors.amber),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    // سمت راست: عکس خبر
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: CachedNetworkImage(
                        imageUrl: item['image']!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          color: Colors.grey[800],
                          child: const Icon(
                            Icons.image,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // سمت چپ: عنوان و تاریخ
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item['title']!,
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item['date']!,
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 14, color: Colors.amber),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
