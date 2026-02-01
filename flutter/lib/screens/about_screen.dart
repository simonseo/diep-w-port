import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('About DIEP-W'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Info Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.medical_services,
                        size: 64,
                        color: Color(0xFF4A90E2),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'DIEP-W',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Estimate the Weight of the DIEP Flap\nin Breast Reconstruction',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Version 2.0.0',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSecondaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // About Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'DIEP-W is a clinical tool for preoperatively estimating the weight of Deep Inferior Epigastric Artery Perforator (DIEP) flaps used in breast reconstruction surgery.',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'The application provides two calculation methods:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Pinch Method: Using manual pinch measurements\n• CT Method: Using CT angiography measurements',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Both methods measure flap thickness at three paraumbilical sites (5 cm right, left, and inferior from the umbilicus) along with BMI and planned flap dimensions.',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Medical Team, Publication & Contact Card (MERGED)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Medical Team & Publication',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Credits
                      Text(
                        'Developed by:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '• Kyongje Woo, MD\n• Goohyun Mun, MD',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.8),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Department of Plastic Surgery\nSamsung Medical Center\nSungkyunkwan University School of Medicine\nSeoul, South Korea',
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.6),
                      ),
                      const SizedBox(height: 12),
                      // Samsung Hospital Logo
                      Center(
                        child: Image.asset(
                          'assets/images/samsung_hospital_logo.png',
                          height: 60,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Publication
                      Text(
                        'Scientific Publication:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Woo KJ, Kim EJ, Lee KT, Mun GH.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '"A Novel Method to Estimate the Weight of the DIEP Flap in Breast Reconstruction: DIEP-W, a Simple Calculation Formula Using Paraumbilical Flap Thickness"',
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'J Reconstr Microsurg. 2016 Sep;32(7):520-7.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'doi: 10.1055/s-0036-1581078',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final Uri url = Uri.parse('https://pubmed.ncbi.nlm.nih.gov/27050336/');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Could not open PubMed link'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        icon: const Icon(Icons.open_in_new, size: 16),
                        label: const Text('View on PubMed'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      
                      // Medical Contact
                      Text(
                        'Medical Questions:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 20, color: Color(0xFF4A90E2)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final Uri emailUri = Uri(
                                  scheme: 'mailto',
                                  path: 'economywoo@gmail.com',
                                  queryParameters: {
                                    'subject': 'DIEP-W Medical Question',
                                  },
                                );
                                if (await canLaunchUrl(emailUri)) {
                                  await launchUrl(emailUri);
                                }
                              },
                              child: Text(
                                'economywoo@gmail.com',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF4A90E2),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // App Development & Technical Support Card (MERGED)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Development',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Flutter Mobile App Version 2.0.0',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Modernized version with enhanced UI/UX, dark mode support, inline BMI calculator, calculation history, and improved keyboard navigation.',
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        'App Technical Support:',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 20, color: Color(0xFF4A90E2)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                final Uri emailUri = Uri(
                                  scheme: 'mailto',
                                  path: 'simon.myunggun.seo@gmail.com',
                                  queryParameters: {
                                    'subject': 'DIEP-W App Technical Question',
                                  },
                                );
                                if (await canLaunchUrl(emailUri)) {
                                  await launchUrl(emailUri);
                                }
                              },
                              child: Text(
                                'simon.myunggun.seo@gmail.com',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF4A90E2),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Installation Guide Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.install_mobile,
                            color: theme.colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Install as Mobile App',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This web app can be installed on your mobile device and used like a native app!',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Text(
                        'Android (Chrome):',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInstallStep(theme, '1', 'Open this website in Chrome browser'),
                      const SizedBox(height: 6),
                      _buildInstallStep(theme, '2', 'Tap the menu icon (⋮) in the top right'),
                      const SizedBox(height: 6),
                      _buildInstallStep(theme, '3', 'Select "Add to Home screen" or "Install app"'),
                      const SizedBox(height: 6),
                      _buildInstallStep(theme, '4', 'Tap "Add" or "Install"'),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'iOS (Safari):',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildInstallStep(theme, '1', 'Open this website in Safari browser'),
                      const SizedBox(height: 6),
                      _buildInstallStep(theme, '2', 'Tap the Share button (square with arrow)'),
                      const SizedBox(height: 6),
                      _buildInstallStep(theme, '3', 'Scroll down and tap "Add to Home Screen"'),
                      const SizedBox(height: 6),
                      _buildInstallStep(theme, '4', 'Tap "Add"'),
                      
                      const SizedBox(height: 16),
                      
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.offline_bolt,
                              color: theme.colorScheme.primary,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Once installed, the app works offline and saves your calculation history!',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Image Credits Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Image Credits',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'App icon illustration by Bella Geraci / Getty Images',
                        style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 4),
                      InkWell(
                        onTap: () async {
                          final Uri url = Uri.parse('https://www.allure.com/story/sadia-zapp-diep-flap-reconstruction-surgery');
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          }
                        },
                        child: Text(
                          'Source: Allure Magazine',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Disclaimer Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disclaimer',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'This application is intended for use by qualified medical professionals only. The calculations provided are estimates based on the published formula and should be used in conjunction with clinical judgment and other diagnostic methods.',
                        style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Always verify measurements and consult with experienced colleagues when planning surgical procedures.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Footer
              Center(
                child: Text(
                  '© 2024 DIEP-W Flutter\nModernized Medical Calculator',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstallStep(ThemeData theme, String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              text,
              style: theme.textTheme.bodySmall?.copyWith(
                height: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
