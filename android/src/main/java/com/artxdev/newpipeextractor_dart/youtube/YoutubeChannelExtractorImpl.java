package com.artxdev.newpipeextractor_dart.youtube;

import com.artxdev.newpipeextractor_dart.FetchData;
import org.schabi.newpipe.extractor.InfoItem;
import org.schabi.newpipe.extractor.ListExtractor;
import org.schabi.newpipe.extractor.services.youtube.extractors.YoutubeChannelExtractor;
import org.schabi.newpipe.extractor.services.youtube.extractors.YoutubeChannelTabExtractor;
import org.schabi.newpipe.extractor.stream.StreamInfoItem;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.schabi.newpipe.extractor.ServiceList.YouTube;

public class YoutubeChannelExtractorImpl {

    private YoutubeChannelExtractor extractor;
    private YoutubeChannelTabExtractor tabextractor;

    private ListExtractor.InfoItemsPage<InfoItem> currentPage;

    public Map<String, String> getChannel(final String url) throws Exception {
        extractor = (YoutubeChannelExtractor) YouTube.getChannelExtractor(url);
        extractor.fetchPage();
        tabextractor = (YoutubeChannelTabExtractor) YouTube.getChannelTabExtractor(extractor.getTabs().get(0));
        tabextractor.fetchPage();
        final Map<String, String> channelMap = new HashMap<String, String>();
        channelMap.put("avatarUrl", FetchData.getBestImage(extractor.getAvatars()).getUrl());
        channelMap.put("bannerUrl", FetchData.getBestImage(extractor.getBanners()).getUrl());
        channelMap.put("description", extractor.getDescription());

//        try {
//            channelMap.put("url", extractor.getUrl());
//        } catch (Exception ignore) {
//        }
//        try {
//            channelMap.put("id", extractor.getId());
//        } catch (Exception ignore) {
//        }
//        try {
//            channelMap.put("feedUrl", extractor.getFeedUrl());
//        } catch (Exception ignore) {
//        }
        channelMap.put("name", extractor.getName());
        channelMap.put("subscriberCount", String.valueOf(extractor.getSubscriberCount()));
        channelMap.put("isVerified", String.valueOf(extractor.isVerified()));
        return channelMap;
    }

    public Map<Integer, Map<String, String>> getChannelUploads(final String url) throws Exception {
        extractor = (YoutubeChannelExtractor) YouTube.getChannelExtractor(url);
        extractor.fetchPage();
        tabextractor = (YoutubeChannelTabExtractor) YouTube.getChannelTabExtractor(extractor.getTabs().get(0));
        tabextractor.fetchPage();
        currentPage = tabextractor.getInitialPage();
        final List<InfoItem> items = currentPage.getItems();
        return parseData(items);
    }

    public Map<Integer, Map<String, String>> getChannelNextPage() throws Exception {
        if (currentPage.hasNextPage()) {
            currentPage = tabextractor.getPage(currentPage.getNextPage());
            final List<InfoItem> items = currentPage.getItems();
            return parseData(items);
        } else {
            return new HashMap<>();
        }
    }

    public Map<Integer, Map<String, String>> parseData(final List<InfoItem> items) {
        final Map<Integer, Map<String, String>> itemsMap = new HashMap<>();
        for (int i = 0; i < items.size(); i++) {

            final StreamInfoItem item = (StreamInfoItem) items.get(i);
            final Map<String, String> itemMap = FetchData.fetchStreamInfoItem(item);

            itemsMap.put(i, itemMap);
        }
        return itemsMap;
    }
}
