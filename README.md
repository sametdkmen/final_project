# Lezzet Durağı — Yemek Sipariş Uygulaması

Flutter bootcamp bitirme projesi olarak geliştirilmiş bir **yemek sipariş
uygulamasıdır**. Menü ve sepet verileri uzak bir REST API'den gelir; durum
yönetimi **BLoC (Cubit)** deseniyle yapılır.

## Akış

1. **Açılış ekranı** — logo ve uygulama adı, 2 saniye sonra girişe geçer.
2. **Giriş ekranı** — ad, soyad ve adres alınır. Gerçek bir kimlik doğrulama
   yoktur; ad-soyad birleşimi API'de sepeti ayırt eden kullanıcı adı olur.
3. **Ana ekran** — menüdeki yemekler 2 sütunlu ızgarada listelenir. Uygulama
   çubuğundaki sepet simgesi, sepetteki ürün sayısını rozet olarak gösterir.
4. **Yemek detayı** — 1–10 arası adet seçilir, genel toplam anlık hesaplanır,
   "Sepete Ekle" ile ürün sepete yazılır. Aynı yemek sepette zaten varsa eski
   satır silinir, yeni adet onun yerini alır.
5. **Sepet** — ürünler satır satır listelenir ve tek tek silinebilir. Alt
   panelde ödeme tipi (Kredi Kartı / Nakit / Online Ödeme), adres ve KDV dahil
   toplam gösterilir.
6. **Sipariş onayı** — tutar, ödeme tipi ve adres özeti; sepet temizlenir ve
   7 saniye sonra ana ekrana dönülür.

## Mimari

```
lib/
├── main.dart                        # MultiBlocProvider + MaterialApp
├── core/
│   ├── api_constants.dart           # API uç noktaları ve görsel URL'si
│   └── app_colors.dart              # Renk paleti
├── data/
│   ├── entity/
│   │   ├── food.dart                # Menü öğesi
│   │   ├── food_response.dart       # "tüm yemekler" yanıt zarfı
│   │   ├── cart_item.dart           # Sepet satırı (satır toplamı dahil)
│   │   └── cart_response.dart       # "sepet" yanıt zarfı
│   └── repository/
│       └── food_repository.dart     # Dio ile API çağrıları
└── ui/
    ├── cubit/
    │   ├── session_cubit.dart       # Kullanıcı adı + adres
    │   ├── home_cubit.dart          # Menü listesi
    │   ├── cart_cubit.dart          # Sepet durumu (yüklendi mi + satırlar + toplam)
    │   └── food_detail_cubit.dart   # Sepete ekleme
    └── screens/
        ├── splash_screen.dart
        ├── login_screen.dart
        ├── home_screen.dart
        ├── food_detail_screen.dart
        ├── cart_screen.dart
        └── order_confirmation_screen.dart
assets/
├── fonts/Poppins-Regular.ttf
└── images/                          # food.svg, empty_cart.svg, motorcycle.svg
```

Entity sınıflarındaki JSON anahtarları (`yemek_adi`, `sepet_yemek_id` …) API
sözleşmesine ait olduğu için olduğu gibi bırakılmıştır; Dart tarafındaki alan
adları İngilizcedir.

## API

| Uç nokta | İşlev |
| --- | --- |
| `tumYemekleriGetir.php` | Menüyü listeler |
| `sepeteYemekEkle.php` | Sepete ürün ekler |
| `sepettekiYemekleriGetir.php` | Kullanıcının sepetini döner (boşsa gövde boştur) |
| `sepettenYemekSil.php` | Sepetten satır siler |

## Kullanılan paketler

- `flutter_bloc` — Cubit tabanlı durum yönetimi
- `dio` — HTTP istekleri
- `flutter_svg` — SVG görseller

## Çalıştırma

```bash
flutter pub get
flutter run
```

Uygulama yalnızca dikey yönde çalışır ve internet bağlantısı gerektirir.
