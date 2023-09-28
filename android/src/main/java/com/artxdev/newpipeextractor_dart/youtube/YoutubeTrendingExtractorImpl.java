package com.artxdev.newpipeextractor_dart.youtube;

import com.artxdev.newpipeextractor_dart.FetchData;
import org.schabi.newpipe.extractor.ListExtractor;
import org.schabi.newpipe.extractor.localization.Localization;
import org.schabi.newpipe.extractor.services.youtube.extractors.YoutubeTrendingExtractor;
import org.schabi.newpipe.extractor.stream.StreamInfoItem;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import static org.schabi.newpipe.extractor.ServiceList.YouTube;

public class YoutubeTrendingExtractorImpl {

    private static YoutubeTrendingExtractor extractor;
    private static ListExtractor.InfoItemsPage<StreamInfoItem> itemsPage;

    public static Map<Integer, Map<String, String>> getTrendingPage() throws Exception {
        extractor = (YoutubeTrendingExtractor) YouTube.getKioskList().getDefaultKioskExtractor();
        extractor.forceLocalization(Localization.fromLocale(Locale.getDefault()));
        extractor.fetchPage();
        itemsPage = extractor.getInitialPage();
        final List<StreamInfoItem> items = itemsPage.getItems();
        final Map<Integer, Map<String, String>> itemsMap = new HashMap<>();
        for (int i = 0; i < items.size(); i++) {
            final StreamInfoItem item = items.get(i);
            final Map<String, String> itemMap = FetchData.fetchStreamInfoItem(item);
            itemsMap.put(i, itemMap);
        }

        return itemsMap;
    }
}
