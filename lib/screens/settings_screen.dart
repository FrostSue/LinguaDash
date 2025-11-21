import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/constants.dart';
import '../core/enums.dart';
import '../providers/settings_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/legal_dialog.dart';
import '../widgets/banner_ad_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _launchEmail(BuildContext context, SettingsProvider s) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ellstmc1@gmail.com',
      query: 'subject=${s.getText('mail_subject')}',
    );

    try {
      if (!await launchUrl(emailLaunchUri)) {
        throw Exception('Could not launch email');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(s.getText('mail_error')),
            backgroundColor: AppColors.wrongRed,
          )
        );
      }
    }
  }

  Future<void> _launchGitHub(BuildContext context) async {
    final Uri url = Uri.parse('https://github.com/FrostSue/LinguaDash');
    
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw Exception('Could not launch GitHub');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("GitHub linki açılamadı."),
            backgroundColor: AppColors.wrongRed,
          )
        );
      }
    }
  }

  void _showLegal(BuildContext context, String title, String content, SettingsProvider s) {
    showDialog(
      context: context,
      builder: (ctx) => LegalDialog(
        title: title, 
        content: content, 
        settings: s
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = context.watch<SettingsProvider>();
    
    final privacyText = s.language == AppLanguage.turkish 
        ? AppTexts.privacyPolicyTr 
        : AppTexts.privacyPolicyEn;
    final termsText = s.language == AppLanguage.turkish 
        ? AppTexts.termsOfUseTr 
        : AppTexts.termsOfUseEn;

    return Scaffold(
      backgroundColor: AppColors.background,
      
      bottomNavigationBar: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: BannerAdWidget(),
        ),
      ),
      
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primaryPurple, width: 3),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]
          ),
          child: Column(
            children: [
              Text(
                s.getText('settings'),
                style: TextStyle(
                  fontSize: 36,
                  fontFamily: s.fontFamily,
                  color: AppColors.primaryPurple,
                  fontWeight: FontWeight.bold
                )
              ),
              
              const SizedBox(height: 20),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildIconBtn(
                            icon: s.isMuted ? 'assets/icons/mute.png' : 'assets/icons/unmute.png',
                            label: s.getText('sound'),
                            onTap: () => s.toggleMute(),
                            active: true
                          ),
                          _buildIconBtn(
                            icon: 'assets/icons/device_vibrate.png',
                            label: s.getText('vibration'),
                            onTap: () => s.toggleVibration(),
                            active: s.isVibrationEnabled
                          )
                        ]
                      ),
                      
                      const Divider(height: 30),

                      _buildDropdown<AppLanguage>(
                        label: s.getText('language'),
                        value: s.language,
                        items: AppLanguage.values,
                        textBuilder: (e) => e == AppLanguage.turkish ? 'Türkçe' : 'English',
                        onChanged: (v) => s.setLanguage(v!)
                      ),
                      
                      const SizedBox(height: 15),

                      _buildDropdown<AppFont>(
                        label: s.getText('font'),
                        value: s.font,
                        items: AppFont.values,
                        textBuilder: (e) => e == AppFont.custom ? 'LinguaFont' : 'System',
                        onChanged: (v) => s.setFont(v!)
                      ),
                      
                      const Divider(height: 30),
                      
                      ListTile(
                        leading: const Icon(Icons.mail, color: AppColors.secondaryTeal, size: 28),
                        title: Text(s.getText('contact_us'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () => _launchEmail(context, s),
                      ),

                      ListTile(
                        leading: const Icon(Icons.code, color: Colors.black87, size: 28),
                        title: Text(s.getText('github_repo'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () => _launchGitHub(context),
                      ),

                      ListTile(
                        leading: const Icon(Icons.privacy_tip, color: AppColors.primaryPurple, size: 28),
                        title: Text(s.getText('privacy_policy'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () => _showLegal(context, s.getText('privacy_policy'), privacyText, s),
                      ),

                      ListTile(
                        leading: const Icon(Icons.description, color: AppColors.primaryPurple, size: 28),
                        title: Text(s.getText('terms_of_use'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        onTap: () => _showLegal(context, s.getText('terms_of_use'), termsText, s),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 10),

              CustomButton(
                text: s.getText('save_back'),
                onPressed: () => Navigator.pop(context),
                height: 55,
              ),
              
              const SizedBox(height: 15),

              Column(
                children: [
                  Text(
                    "${s.getText('developer')}: @FrostSue",
                    style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold, fontSize: 14)
                  ),
                  Text(
                    s.getText('version'),
                    style: TextStyle(color: Colors.grey[400], fontSize: 12)
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconBtn({required String icon, required String label, required VoidCallback onTap, required bool active}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: active ? AppColors.primaryPurple.withOpacity(0.1) : Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: active ? AppColors.primaryPurple : Colors.grey)
            ),
            child: Opacity(
              opacity: active ? 1.0 : 0.5,
              child: Image.asset(icon, width: 35)
            )
          ),
          const SizedBox(height: 5),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))
        ]
      )
    );
  }

  Widget _buildDropdown<T>({required String label, required T value, required List<T> items, required String Function(T) textBuilder, required ValueChanged<T?> onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        DropdownButton<T>(
          value: value,
          onChanged: onChanged,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(textBuilder(e)))).toList()
        )
      ]
    );
  }
}