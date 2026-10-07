import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../domain/models/cafe_detail.dart';

class CafeFacilityItem extends StatelessWidget {
  const CafeFacilityItem({super.key, required this.facility});

  final CafeFacility facility;

  @override
  Widget build(BuildContext context) {
    final data = _facilityData(facility);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 38,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceSoft,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(data.icon, size: 18, color: AppColors.icon),
        ),
        const SizedBox(width: 9),
        Flexible(
          child: Text(
            data.label,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  _FacilityData _facilityData(CafeFacility facility) {
    switch (facility) {
      case CafeFacility.wifi:
        return const _FacilityData(label: 'Wi-Fi', icon: Icons.wifi_rounded);

      case CafeFacility.powerOutlet:
        return const _FacilityData(
          label: 'Power outlet',
          icon: Icons.power_rounded,
        );

      case CafeFacility.parking:
        return const _FacilityData(
          label: 'Parking',
          icon: Icons.local_parking_rounded,
        );

      case CafeFacility.airConditioner:
        return const _FacilityData(
          label: 'Air conditioner',
          icon: Icons.ac_unit_rounded,
        );

      case CafeFacility.outdoor:
        return const _FacilityData(label: 'Outdoor', icon: Icons.deck_outlined);

      case CafeFacility.smokingArea:
        return const _FacilityData(
          label: 'Smoking area',
          icon: Icons.smoking_rooms_outlined,
        );

      case CafeFacility.prayerRoom:
        return const _FacilityData(
          label: 'Prayer room',
          icon: Icons.mosque_outlined,
        );

      case CafeFacility.meetingRoom:
        return const _FacilityData(
          label: 'Meeting room',
          icon: Icons.meeting_room_outlined,
        );

      case CafeFacility.petFriendly:
        return const _FacilityData(
          label: 'Pet friendly',
          icon: Icons.pets_outlined,
        );

      case CafeFacility.toilet:
        return const _FacilityData(label: 'Toilet', icon: Icons.wc_outlined);

      case CafeFacility.wheelchairAccessible:
        return const _FacilityData(
          label: 'Accessible',
          icon: Icons.accessible_rounded,
        );
    }
  }
}

class _FacilityData {
  const _FacilityData({required this.label, required this.icon});

  final String label;
  final IconData icon;
}
