import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:morsequest/features/profile_page/screens/profile_screen.dart';
import 'package:morsequest/features/shop_page/shop_screen.dart';
import '../widgets/library_page_widgets.dart';
import '../../main_page/widgets/main_widgets.dart';
import '../../../../shared/widgets/custom_bottom_nav.dart';
import '../../../../shared/utils/navigation_helper.dart';
import '../../../../shared/providers/sound_provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _isAlphabetView = true;
  int _currentNavIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final soundProvider = Provider.of<SoundProvider>(context, listen: false);
      soundProvider.pauseBackgroundMusic();
    });
  }

  @override
  void dispose() {
    final soundProvider = Provider.of<SoundProvider>(context, listen: false);
    soundProvider.resumeBackgroundMusic();
    soundProvider.stopMorse();
    super.dispose();
  }

  void _handleMorseTap(SoundProvider soundProvider, String morseCode) {
    soundProvider.playMorseSequence(morseCode);
  }

  @override
  Widget build(BuildContext context) {
    final soundProvider = Provider.of<SoundProvider>(context);

    final List<MorseData> currentData = _isAlphabetView
        ? alphabetMorse
        : numberMorse;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            const MainHeader(),
            const SizedBox(height: 20),
            const LibraryTitle(),
            const SizedBox(height: 30),
            CustomToggle(
              isAlphabet: _isAlphabetView,
              onChanged: (value) {
                soundProvider.stopMorse();
                setState(() {
                  _isAlphabetView = value;
                });
              },
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: _isAlphabetView ? 3 : 2,
                    childAspectRatio: _isAlphabetView ? 1.5 : 2.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: currentData.length,
                  itemBuilder: (context, index) {
                    final data = currentData[index];
                    return MorseCard(
                      data: data,
                      onTap: () {
                        _handleMorseTap(soundProvider, data.code);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          soundProvider.stopMorse();
          soundProvider.resumeBackgroundMusic();
          NavigationHelper.onNavTapped(context, index, _currentNavIndex);
        },
      ),
    );
  }
}
