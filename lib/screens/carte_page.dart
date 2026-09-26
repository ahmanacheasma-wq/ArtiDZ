import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import '../main.dart' show AppC;
import 'resultat_recherche.dart' show ArtisanListing, kListings;
import 'reservation_page.dart';

class CartePage extends StatefulWidget {
  final String metier;
  final String wilaya;
  final List<ArtisanListing> artisans;

  const CartePage({
    super.key,
    required this.metier,
    required this.wilaya,
    required this.artisans,
  });

  @override
  State<CartePage> createState() => _CartePageState();
}

class _CartePageState extends State<CartePage> {
  GoogleMapController? _mapController;
  ArtisanListing? _selectedArtisan;

  static const LatLng _centreAlgerie = LatLng(28.0339, 1.6596);

  static const Map<String, LatLng> _wilayas = {
    'Adrar':               LatLng(27.8742, -0.2939),
    'Chlef':               LatLng(36.1650,  1.3317),
    'Laghouat':            LatLng(33.8000,  2.8833),
    'Oum El Bouaghi':      LatLng(35.8833,  7.1167),
    'Batna':               LatLng(35.5550,  6.1740),
    'Béjaïa':              LatLng(36.7515,  5.0560),
    'Biskra':              LatLng(34.8500,  5.7333),
    'Béchar':              LatLng(31.6167, -2.2167),
    'Blida':               LatLng(36.4700,  2.8300),
    'Bouira':              LatLng(36.3833,  3.9000),
    'Tamanrasset':         LatLng(22.7850,  5.5228),
    'Tébessa':             LatLng(35.4000,  8.1167),
    'Tlemcen':             LatLng(34.8800, -1.3150),
    'Tiaret':              LatLng(35.3711,  1.3167),
    'Tizi Ouzou':          LatLng(36.7169,  4.0497),
    'Alger':               LatLng(36.7372,  3.0869),
    'Djelfa':              LatLng(34.6667,  3.2500),
    'Jijel':               LatLng(36.8200,  5.7667),
    'Sétif':               LatLng(36.1898,  5.4108),
    'Saïda':               LatLng(34.8300,  0.1500),
    'Skikda':              LatLng(36.8667,  6.9000),
    'Sidi Bel Abbès':      LatLng(35.1833, -0.6333),
    'Annaba':              LatLng(36.9000,  7.7667),
    'Guelma':              LatLng(36.4667,  7.4333),
    'Constantine':         LatLng(36.3650,  6.6147),
    'Médéa':               LatLng(36.2667,  2.7500),
    'Mostaganem':          LatLng(35.9333,  0.0833),
    'M\'Sila':             LatLng(35.7000,  4.5333),
    'Mascara':             LatLng(35.3967,  0.1400),
    'Ouargla':             LatLng(31.9500,  5.3167),
    'Oran':                LatLng(35.6969, -0.6331),
    'El Bayadh':           LatLng(33.6833,  1.0167),
    'Illizi':              LatLng(26.5000,  8.4833),
    'Bordj Bou Arréridj':  LatLng(36.0667,  4.7667),
    'Boumerdès':           LatLng(36.7667,  3.4667),
    'El Tarf':             LatLng(36.7667,  8.3167),
    'Tindouf':             LatLng(27.6742, -8.1478),
    'Tissemsilt':          LatLng(35.6000,  1.8167),
    'El Oued':             LatLng(33.3667,  6.8500),
    'Khenchela':           LatLng(35.4333,  7.1333),
    'Souk Ahras':          LatLng(36.2833,  7.9500),
    'Tipaza':              LatLng(36.5833,  2.4500),
    'Mila':                LatLng(36.4500,  6.2667),
    'Aïn Defla':           LatLng(36.2667,  1.9667),
    'Naâma':               LatLng(33.2667, -0.3167),
    'Aïn Témouchent':      LatLng(35.2983, -1.1400),
    'Ghardaïa':            LatLng(32.4900,  3.6700),
    'Relizane':            LatLng(35.7333,  0.5500),
    'Timimoun':            LatLng(29.2639,  0.2306),
    'Bordj Badji Mokhtar': LatLng(21.3297,  0.9456),
    'Ouled Djellal':       LatLng(34.4167,  5.0667),
    'Béni Abbès':          LatLng(30.1283, -2.1658),
    'In Salah':            LatLng(27.1958,  2.4739),
    'In Guezzam':          LatLng(19.5667,  5.7667),
    'Touggourt':           LatLng(33.1000,  6.0667),
    'Djanet':              LatLng(24.5547,  9.4853),
    'El M\'Ghair':         LatLng(33.9500,  5.9167),
    'El Menia':            LatLng(30.5833,  2.8833),
  };

  @override
  void initState() {
    super.initState();
    final platform = GoogleMapsFlutterPlatform.instance;
    if (platform is GoogleMapsFlutterAndroid) {
      platform.useAndroidViewSurface = false;
    }
  }

  @override
  void didUpdateWidget(CartePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wilaya != widget.wilaya) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_initialPosition, 13),
      );
    }
  }

  String get _wilayaName {
    final w = widget.wilaya;
    if (w.contains(' - ')) return w.split(' - ').last.trim();
    return w.trim();
  }

  LatLng get _initialPosition {
    return _wilayas[_wilayaName] ?? _centreAlgerie;
  }

  Set<Marker> get _markers {
    return widget.artisans.asMap().entries.map((entry) {
      final i = entry.key;
      final artisan = entry.value;
      final basePos = _initialPosition;
      final pos = LatLng(
        basePos.latitude + (i * 0.008),
        basePos.longitude + (i * 0.008),
      );
      return Marker(
        markerId: MarkerId('artisan_$i'),
        position: pos,
        infoWindow: InfoWindow(
          title: artisan.name,
          snippet: '${artisan.metier} • ⭐ ${artisan.rating}',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          artisan.disponible
              ? BitmapDescriptor.hueOrange
              : BitmapDescriptor.hueRed,
        ),
        onTap: () => setState(() => _selectedArtisan = artisan),
      );
    }).toSet();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      body: Stack(children: [

        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: _initialPosition,
            zoom: 13,
          ),
          markers: _markers,
          onMapCreated: (controller) {
            _mapController = controller;
            Future.delayed(const Duration(milliseconds: 500), () {
              controller.animateCamera(
                CameraUpdate.newLatLngZoom(_initialPosition, 13),
              );
            });
          },
          onTap: (_) => setState(() => _selectedArtisan = null),
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          mapToolbarEnabled: false,
          liteModeEnabled: false,
        ),

        Positioned(
          top: 0, left: 0, right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(16, top + 12, 16, 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF3D2B1F).withOpacity(0.95),
                  const Color(0xFF3D2B1F).withOpacity(0.0),
                ],
              ),
            ),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 14, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.metier,
                    style: const TextStyle(fontFamily: 'Georgia',
                        fontSize: 16, color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(_wilayaName,
                    style: TextStyle(fontSize: 12,
                        color: Colors.white.withOpacity(0.7)),
                  ),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppC.ocre,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('${widget.artisans.length} artisans',
                  style: const TextStyle(fontSize: 11,
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),
        ),

        Positioned(
          top: top + 80, right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(
                  color: Colors.black.withOpacity(0.1), blurRadius: 10)],
            ),
            child: Column(children: [
              _legendItem(AppC.ocre, 'Disponible'),
              const SizedBox(height: 6),
              _legendItem(const Color(0xFFB71C1C), 'Indisponible'),
            ]),
          ),
        ),

        if (_selectedArtisan != null)
          Positioned(
            bottom: 24, left: 16, right: 16,
            child: _buildArtisanCard(_selectedArtisan!),
          ),
      ]),
    );
  }

  Widget _legendItem(Color color, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(width: 10, height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 6),
      Text(label, style: const TextStyle(fontSize: 10, color: AppC.brunFonce)),
    ],
  );

  Widget _buildArtisanCard(ArtisanListing artisan) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(
            color: AppC.brun.withOpacity(0.2),
            blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: AppC.creme,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppC.sable),
          ),
          child: Center(child: Text(artisan.emoji,
              style: const TextStyle(fontSize: 28))),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(artisan.name, style: const TextStyle(fontSize: 15,
                color: AppC.brunFonce, fontWeight: FontWeight.w600)),
            Text(artisan.metier, style: const TextStyle(fontSize: 12,
                color: AppC.ocre, fontWeight: FontWeight.w500)),
            Row(children: [
              const Icon(Icons.star_rounded, size: 12, color: AppC.ocre),
              const SizedBox(width: 3),
              Text('${artisan.rating} (${artisan.reviews})',
                  style: const TextStyle(fontSize: 11, color: AppC.argile)),
              const SizedBox(width: 8),
              Container(width: 6, height: 6,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: artisan.disponible ? AppC.success : AppC.argile),
              ),
              const SizedBox(width: 4),
              Text(artisan.disponible ? 'Disponible' : 'Indisponible',
                  style: TextStyle(fontSize: 10,
                      color: artisan.disponible ? AppC.success : AppC.argile)),
            ]),
          ],
        )),
        GestureDetector(
          onTap: () {
            if (artisan.disponible) {
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => ReservationPage(artisan: artisan),
              ));
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: artisan.disponible ? AppC.brunFonce : AppC.argentClair,
              borderRadius: BorderRadius.circular(12),
              boxShadow: artisan.disponible ? [BoxShadow(
                  color: AppC.brun.withOpacity(0.35),
                  blurRadius: 8, offset: const Offset(0, 3))] : [],
            ),
            child: Text(artisan.disponible ? 'Réserver' : 'Notifier',
                style: TextStyle(fontSize: 13,
                    color: artisan.disponible ? Colors.white : AppC.argile,
                    fontWeight: FontWeight.w600)),
          ),
        ),
      ]),
    );
  }
}