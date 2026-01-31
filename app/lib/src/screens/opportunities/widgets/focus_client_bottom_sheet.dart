import 'package:core/modules/opportunities/models/opportunities_overview_model.dart';
import 'package:flutter/material.dart';

class FocusClientBottomSheet extends StatelessWidget {
  final TopFocusClient client;

  const FocusClientBottomSheet({Key? key, required this.client})
      : super(key: key);

  static void show(BuildContext context, TopFocusClient client) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FocusClientBottomSheet(client: client),
    );
  }

  @override
  Widget build(BuildContext context) {
    final drillDown = client.drillDownDetails;
    // Ensure 0.6 to 0.95 height constraint
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              // Drag Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              Expanded(
                child: ListView(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  children: [
                    // --- HEADER ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                client.clientName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                maxLines: 1,
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E8FF),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  client.formattedImpactValue,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF7C3AED),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(Icons.close,
                                size: 20, color: Color(0xFF6B7280)),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // AI Insight Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDFA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: const Color(0xFFCCFBF1), width: 1),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.lightbulb_outline,
                              color: Color(0xFF0D9488), size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('AI Insight',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF115E59))),
                                const SizedBox(height: 4),
                                Text(
                                  client.pitchHook,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color(0xFF134E4A),
                                      height: 1.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // --- SECTION 1: Portfolio Review ---
                    if (drillDown.portfolioReview.hasIssue) ...[
                      _buildSectionHeader(
                          '📉 Portfolio Underperformance', const Color(0xFFDC2626)),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFFECACA), width: 1),
                        ),
                        child: Column(
                          children: drillDown.portfolioReview.schemes.map((s) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                      child: Text(s.name,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1F2937)))),
                                  Text('${s.xirrLag}% Lag',
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFDC2626))),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // --- SECTION 2: Insurance ---
                    if (drillDown.insurance.hasGap) ...[
                      _buildSectionHeader(
                          '🛡️ Coverage Gap', const Color(0xFF0D9488)),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: const Color(0xFFA7F3D0), width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Protection Gap',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF065F46))),
                                Text(
                                  'Rs. ${_formatCurrency(drillDown.insurance.gapAmount)}',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF047857)),
                                ),
                              ],
                            ),
                            OutlinedButton(
                              onPressed: () {
                                // TODO: Generte Insurance PDF
                              },
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(
                                    color: Color(0xFF0D9488)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: const Text('Pitch Term Plan',
                                  style: TextStyle(color: Color(0xFF0D9488))),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],

                    // --- SECTION 3: SIP Issues ---
                    if (drillDown.sipHealth.stoppedSips.isNotEmpty ||
                        drillDown.sipHealth.stagnantSips.isNotEmpty) ...[
                      _buildSectionHeader(
                          '⚠️ SIP Issues', const Color(0xFFEA580C)),
                      const SizedBox(height: 12),
                      
                      // Stopped SIPs
                      ...drillDown.sipHealth.stoppedSips.map((sip) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF7ED),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFFED7AA), width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.restore,
                                  color: Color(0xFFEA580C), size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(sip.scheme,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1F2937))),
                                    Text(
                                        'Stopped ${sip.daysStopped} days ago • Rs. ${_formatCurrency(sip.amount)}',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF9A3412))),
                                  ],
                                ),
                              ),
                              // Revival Button
                              GestureDetector(
                                onTap: () {
                                  // Map to StoppedSipOpportunity and open sheet
                                  // Note: This requires full data mapping which might be better handled in the controller
                                  // For now, simpler implementation
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEA580C),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Revive',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),

                      // Stagnant SIPs
                       ...drillDown.sipHealth.stagnantSips.map((sip) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFAF5FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: const Color(0xFFE9D5FF), width: 1),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.trending_up,
                                  color: Color(0xFF7C3AED), size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(sip.scheme,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1F2937))),
                                    Text(
                                        'No step-up for ${sip.yearsRunning} years',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF6B21A8))),
                                  ],
                                ),
                              ),
                               // Step-up Button
                              GestureDetector(
                                onTap: () {
                                  // Trigger logic
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF7C3AED),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('Step-up',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Divider(color: color.withOpacity(0.2), thickness: 1),
        ),
      ],
    );
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(2)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(2)} L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)} K';
    }
    return amount.toStringAsFixed(0);
  }
}
