import 'package:finamp/screens/settings_screen.dart';
import 'package:finamp/screens/tabs_settings_screen.dart';
import 'package:finamp/screens/transcoding_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../components/AlbumScreen/download_button.dart';
import '../components/InteractionSettingsScreen/FastScrollSelector.dart';
import '../components/LayoutSettingsScreen/content_view_type_dropdown_list_tile.dart';
import '../components/LayoutSettingsScreen/theme_selector.dart';
import '../components/NetworkSettingsScreen/auto_offline_selector.dart';
import '../components/TranscodingSettingsScreen/transcode_switch.dart';
import '../components/finamp_app_bar_back_button.dart';
import '../l10n/app_localizations.dart';
import '../models/finamp_models.dart';
import '../services/finamp_settings_helper.dart';
import '../services/finamp_user_helper.dart';
import 'layout_settings_screen.dart';

class QuickSettingsScreen extends ConsumerWidget {
  const QuickSettingsScreen({super.key});

  static const routeName = "/quick-settings";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text("Quick Settings"), leading: FinampAppBarBackButton()),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 200.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              style: TextTheme.of(context).bodyLarge,
              "These are some of the most commonly tweaked settings, collected here for easy access.  Check out the"
              "full settings screen for more advanced options.  This menu can always be accessed from the settings screen.",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: Text("All Settings"),
            onTap: () => Navigator.of(context).pushNamed(SettingsScreen.routeName),
          ),
          Divider(),
          // grid mode toggle plus size
          const ContentViewTypeDropdownListTile(),
          if (ref.watch(finampSettingsProvider.contentViewType) == ContentViewType.grid) const GridImageSizeSelector(),
          ListTile(
            leading: const Icon(Icons.widgets),
            title: Text("Additional layout settings"),
            onTap: () => Navigator.of(context).pushNamed(LayoutSettingsScreen.routeName),
            contentPadding: EdgeInsets.only(left: 50),
          ),
          // dark mode
          const ThemeSelector(verbose: true),
          // show fast scroller
          FastScrollSelector(),
          Divider(),
          // auto-offline mode?
          AutoOfflineSelector(),
          // transcode + deeper link
          const TranscodeSwitch(),
          ListTile(
            leading: const Icon(Icons.compress),
            title: Text("Additional transcoding settings"),
            onTap: () => Navigator.of(context).pushNamed(TranscodingSettingsScreen.routeName),
            contentPadding: EdgeInsets.only(left: 50),
          ),
          // music screen tabs
          ListTile(
            leading: const Icon(Icons.tab),
            title: Text("Remove or rearrange music tabs (e.g. Albums, tracks)"),
            onTap: () => Navigator.of(context).pushNamed(TabsSettingsScreen.routeName),
          ),
          // album image cache?
          ListTile(
            title: Text(AppLocalizations.of(context)!.cacheLibraryImagesSettings),
            subtitle: Text(AppLocalizations.of(context)!.cacheLibraryImagesSettingsSubtitle),
            trailing: DownloadButton(
              item: DownloadStub.fromFinampCollection(
                FinampCollection(
                  type: FinampCollectionType.libraryImages,
                  library: GetIt.instance<FinampUserHelper>().currentUser!.currentView!,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
