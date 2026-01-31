import 'package:app/src/widgets/button/action_button.dart';
import 'package:core/modules/opportunities/models/sip_opportunity_model.dart';
import 'package:core/modules/opportunities/serviecs/pdf_generation_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Bottom sheet for Revival Proposal - Stopped SIPs
class SipRevivalBottomSheet extends StatefulWidget {
  final StoppedSipOpportunity opportunity;

  const SipRevivalBottomSheet({
    Key? key,
    required this.opportunity,
  }) : super(key: key);

  static void show(BuildContext context, StoppedSipOpportunity opportunity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SipRevivalBottomSheet(opportunity: opportunity),
    );
  }

  @override
  State<SipRevivalBottomSheet> createState() => _SipRevivalBottomSheetState();
}

class _SipRevivalBottomSheetState extends State<SipRevivalBottomSheet> {
  bool _isGenerating = false;
  final _currencyFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  String _formatDate(String date) {
    try {
      final dt = DateTime.parse(date);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEA580C).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.restore,
                          color: Color(0xFFEA580C),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'SIP Revival Proposal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Client Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7ED),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFED7AA),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.person_outline,
                          size: 16,
                          color: Color(0xFFC2410C),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Client: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFC2410C),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            widget.opportunity.userName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Color(0xFFC2410C),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Last Paid: ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFC2410C),
                          ),
                        ),
                        Text(
                          _formatDate(widget.opportunity.lastSuccessDate),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(
                          Icons.warning_amber_outlined,
                          size: 16,
                          color: Color(0xFFDC2626),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Silent for ${widget.opportunity.daysSinceAnySuccess} days',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Warning message
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFFFCA5A5),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Color(0xFFDC2626),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'The Revival PDF shows the "Cost of Stopping" - the wealth this client loses by staying inactive.',
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF991B1B),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                          side: const BorderSide(
                            color: Color(0xFFE5E7EB),
                            width: 1,
                          ),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ActionButton(
                      margin: EdgeInsets.zero,
                      bgColor: const Color(0xFFEA580C),
                      showProgressIndicator: _isGenerating,
                      onPressed: () async {
                        setState(() {
                          _isGenerating = true;
                        });
                        
                        await PdfGeneratorService.generateSipProposal(
                          clientName: widget.opportunity.userName,
                          currentSip: widget.opportunity.lastSipAmount ?? 10000,
                          stepUpPercent: 0,
                          isRevival: true,
                        );
                        
                        if (mounted) {
                          setState(() {
                            _isGenerating = false;
                          });
                          Navigator.pop(context);
                        }
                      },
                      text: 'Generate Revival PDF',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
