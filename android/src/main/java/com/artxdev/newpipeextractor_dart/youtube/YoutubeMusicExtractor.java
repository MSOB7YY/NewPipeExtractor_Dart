package com.artxdev.newpipeextractor_dart.youtube;

import com.artxdev.newpipeextractor_dart.FetchData;
import org.schabi.newpipe.extractor.InfoItem;
import org.schabi.newpipe.extractor.ListExtractor;
import org.schabi.newpipe.extractor.channel.ChannelInfoItem;
import org.schabi.newpipe.extractor.localization.DateWrapper;
import org.schabi.newpipe.extractor.playlist.PlaylistInfoItem;
import org.schabi.newpipe.extractor.search.SearchExtractor;
import org.schabi.newpipe.extractor.services.youtube.linkHandler.YoutubeSearchQueryHandlerFactory;
import org.schabi.newpipe.extractor.stream.StreamInfoItem;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static java.util.Collections.singletonList;
import static org.schabi.newpipe.extractor.ServiceList.YouTube;

public class YoutubeMusicExtractor {

    private SearchExtractor extractor;
    private ListExtractor.InfoItemsPage<InfoItem> itemsPage;

    public Map<String, Map<Integer, Map<String, String>>> searchYoutube(final String query,
            final List<String> filters) throws Exception {
        final List<String> contentFilter = singletonList(YoutubeSearchQueryHandlerFactory.MUSIC_SONGS);
        if (filters != null) {
            contentFilter.addAll(filters);
        }
        extractor = YouTube.getSearchExtractor(query, contentFilter, "");
        extractor.fetchPage();
        itemsPage = extractor.getInitialPage();
        final List<InfoItem> items = itemsPage.getItems();
        return _fetchResultsFromItems(items);
    }

    public Map<String, Map<Integer, Map<String, String>>> getNextPage() throws Exception {
        if (itemsPage.hasNextPage()) {
            itemsPage = extractor.getPage(itemsPage.getNextPage());
            final List<InfoItem> items = itemsPage.getItems();
            return _fetchResultsFromItems(items);
        } else {
            return new HashMap<>();
        }
    }

    private Map<String, Map<Integer, Map<String, String>>> _fetchResultsFromItems(
            final List<InfoItem> items) {
        final List<StreamInfoItem> streamsList = new ArrayList<>();
        final List<PlaylistInfoItem> playlistsList = new ArrayList<>();
        final List<ChannelInfoItem> channelsList = new ArrayList<>();
        final Map<String, Map<Integer, Map<String, String>>> resultsList = new HashMap<>();
        for (int i = 0; i < items.size(); i++) {
            switch (items.get(i).getInfoType()) {
                case STREAM:
                    final StreamInfoItem streamInfo = (StreamInfoItem) items.get(i);
                    streamsList.add(streamInfo);
                    break;
                case CHANNEL:
                    final ChannelInfoItem channelInfo = (ChannelInfoItem) items.get(i);
                    channelsList.add(channelInfo);
                    break;
                case PLAYLIST:
                    final PlaylistInfoItem playlistInfo = (PlaylistInfoItem) items.get(i);
                    playlistsList.add(playlistInfo);
                    break;
                default:
                    break;
            }
        }

        // Extract into a map Stream Results
        final Map<Integer, Map<String, String>> streamResultsMap = new HashMap<>();
        if (!streamsList.isEmpty()) {
            for (int i = 0; i < streamsList.size(); i++) {
                final Map<String, String> itemMap = new HashMap<>();
                final StreamInfoItem item = streamsList.get(i);
                itemMap.put("name", item.getName());
                itemMap.put("uploaderName", item.getUploaderName());
                itemMap.put("uploaderUrl", item.getUploaderUrl());
                itemMap.put("uploadDate", item.getTextualUploadDate());

                final DateWrapper date = item.getUploadDate();
                if (date != null) {
                    itemMap.put("date", FetchData.getDateString(date.offsetDateTime()));
                    itemMap.put("isDateApproximation", String.valueOf(date.isApproximation()));
                }

                itemMap.put("thumbnailUrl", item.getThumbnailUrl());
                itemMap.put("duration", String.valueOf(item.getDuration()));
                itemMap.put("viewCount", String.valueOf(item.getViewCount()));
                itemMap.put("url", item.getUrl());
                itemMap.put("id", YoutubeLinkHandler.getIdFromStreamUrl(item.getUrl()));
                streamResultsMap.put(i, itemMap);
            }
        }
        resultsList.put("streams", streamResultsMap);

        // Extract into a map Channel Results
        final Map<Integer, Map<String, String>> channelResultsMap = new HashMap<>();
        if (!channelsList.isEmpty()) {
            for (int i = 0; i < channelsList.size(); i++) {
                final Map<String, String> itemMap = new HashMap<>();
                final ChannelInfoItem item = channelsList.get(i);
                itemMap.put("name", item.getName());
                itemMap.put("thumbnailUrl", item.getThumbnailUrl());
                itemMap.put("url", item.getUrl());
                itemMap.put("id", YoutubeLinkHandler.getIdFromChannelUrl(item.getUrl()));
                itemMap.put("description", item.getDescription());
                itemMap.put("streamCount", String.valueOf(item.getStreamCount()));
                itemMap.put("subscriberCount", String.valueOf(item.getSubscriberCount()));
                channelResultsMap.put(i, itemMap);
            }
        }
        resultsList.put("channels", channelResultsMap);

        // Extract into a map Playlist Results
        final Map<Integer, Map<String, String>> playlistResultsMap = new HashMap<>();
        if (!playlistsList.isEmpty()) {
            for (int i = 0; i < playlistsList.size(); i++) {
                final Map<String, String> itemMap = new HashMap<>();
                final PlaylistInfoItem item = playlistsList.get(i);
                itemMap.put("name", item.getName());
                itemMap.put("uploaderName", item.getUploaderName());
                itemMap.put("url", item.getUrl());
                itemMap.put("id", YoutubeLinkHandler.getIdFromPlaylistUrl(item.getUrl()));
                itemMap.put("thumbnailUrl", item.getThumbnailUrl());
                itemMap.put("streamCount", String.valueOf(item.getStreamCount()));
                playlistResultsMap.put(i, itemMap);
            }
        }
        resultsList.put("playlists", playlistResultsMap);
        return resultsList;
    }

}
