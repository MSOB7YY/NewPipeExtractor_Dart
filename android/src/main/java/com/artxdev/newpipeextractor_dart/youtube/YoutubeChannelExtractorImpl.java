package com.artxdev.newpipeextractor_dart.youtube;

import com.artxdev.newpipeextractor_dart.FetchData;
import org.schabi.newpipe.extractor.ListExtractor;
import org.schabi.newpipe.extractor.services.youtube.extractors.YoutubeChannelExtractor;
import org.schabi.newpipe.extractor.stream.StreamInfoItem;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.schabi.newpipe.extractor.ServiceList.YouTube;

public class YoutubeChannelExtractorImpl {

    private YoutubeChannelExtractor extractor;

    private ListExtractor.InfoItemsPage<StreamInfoItem> currentPage;

    public Map<String, String> getChannel(final String url) throws Exception {
        extractor = (YoutubeChannelExtractor) YouTube.getChannelExtractor(url);
        extractor.fetchPage();
        final Map<String, String> channelMap = new HashMap<String, String>();
        // channelMap.put("url", extractor.getUrl());
        channelMap.put("avatarUrl", extractor.getAvatarUrl());
        channelMap.put("bannerUrl", extractor.getBannerUrl());
        channelMap.put("description", extractor.getDescription());
        // channelMap.put("feedUrl", extractor.getFeedUrl());
        // channelMap.put("id", extractor.getId());
        channelMap.put("name", extractor.getName());
        channelMap.put("subscriberCount", String.valueOf(extractor.getSubscriberCount()));
        channelMap.put("isVerified", String.valueOf(extractor.isVerified()));
        return channelMap;
    }

    public Map<Integer, Map<String, String>> getChannelUploads(final String url) throws Exception {
        extractor = (YoutubeChannelExtractor) YouTube.getChannelExtractor(url);
        extractor.fetchPage();
        currentPage = extractor.getInitialPage();
        final List<StreamInfoItem> items = currentPage.getItems();
        return parseData(items);
    }

    public Map<Integer, Map<String, String>> getChannelNextPage() throws Exception {
        if (currentPage.hasNextPage()) {
            currentPage = extractor.getPage(currentPage.getNextPage());
            final List<StreamInfoItem> items = currentPage.getItems();
            return parseData(items);
        } else {
            return new HashMap<>();
        }
    }

    public Map<Integer, Map<String, String>> parseData(final List<StreamInfoItem> items) {
        final Map<Integer, Map<String, String>> itemsMap = new HashMap<>();
        for (int i = 0; i < items.size(); i++) {

            final StreamInfoItem item = items.get(i);
            final Map<String, String> itemMap = FetchData.fetchStreamInfoItem(item);

            itemsMap.put(i, itemMap);
        }
        return itemsMap;
    }
}
