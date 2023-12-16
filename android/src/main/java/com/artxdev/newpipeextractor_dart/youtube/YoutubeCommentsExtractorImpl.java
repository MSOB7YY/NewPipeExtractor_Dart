package com.artxdev.newpipeextractor_dart.youtube;

import com.artxdev.newpipeextractor_dart.FetchData;
import org.schabi.newpipe.extractor.ListExtractor;
import org.schabi.newpipe.extractor.comments.CommentsInfoItem;
import org.schabi.newpipe.extractor.localization.DateWrapper;
import org.schabi.newpipe.extractor.services.youtube.extractors.YoutubeCommentsExtractor;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.schabi.newpipe.extractor.ServiceList.YouTube;

public class YoutubeCommentsExtractorImpl {
    private ListExtractor.InfoItemsPage<CommentsInfoItem> currentPage;
    private YoutubeCommentsExtractor extractor;
    private Integer totalCommentsCount = -1;

    public Map<Integer, Map<String, String>> getComments(final String url) throws Exception {
        totalCommentsCount = -1; // resetting total comments count.

        extractor = (YoutubeCommentsExtractor) YouTube.getCommentsExtractor(url);
        extractor.fetchPage();
        currentPage = extractor.getInitialPage();
        final List<CommentsInfoItem> comments = currentPage.getItems();

        return parseData(comments);
    }

    public Map<Integer, Map<String, String>> getCommentsNextPage() throws Exception {
        if (currentPage.hasNextPage()) {
            currentPage = extractor.getPage(currentPage.getNextPage());
            final List<CommentsInfoItem> items = currentPage.getItems();
            return parseData(items);
        } else {
            return new HashMap<>();
        }
    }

    private Map<Integer, Map<String, String>> parseData(final List<CommentsInfoItem> items) throws Exception {
        if (totalCommentsCount == -1) {
            try {
                totalCommentsCount = extractor.getCommentsCount();
            } catch (Exception ignore) {
                totalCommentsCount = -1;
            }
        }
        final Map<Integer, Map<String, String>> itemsMap = new HashMap<>();
        for (int i = 0; i < items.size(); i++) {
            final CommentsInfoItem item = items.get(i);
            final Map<String, String> itemMap = new HashMap<>();

            itemMap.put("commentId", item.getCommentId());
            itemMap.put("author", item.getUploaderName());
            itemMap.put("commentText", item.getCommentText().getContent());
            itemMap.put("uploaderAvatarUrl", FetchData.getBestImage(item.getUploaderAvatars()).getUrl());
            itemMap.put("uploadDate", item.getTextualUploadDate());
            itemMap.put("uploaderUrl", item.getUploaderUrl());
            itemMap.put("likeCount", String.valueOf(item.getLikeCount()));
            itemMap.put("pinned", String.valueOf(item.isPinned()));
            itemMap.put("hearted", String.valueOf(item.isHeartedByUploader()));
            itemMap.put("replyCount", String.valueOf(item.getReplyCount()));
            itemMap.put("totalCommentsCount", String.valueOf(totalCommentsCount));

            itemMap.put("name", item.getName());

            final DateWrapper date = item.getUploadDate();
            if (date != null) {
                itemMap.put("date", FetchData.getDateString(date.offsetDateTime()));
                itemMap.put("isDateApproximation", String.valueOf(date.isApproximation()));
            }

            itemMap.put("thumbnailUrl", FetchData.getBestImage(item.getThumbnails()).getUrl());
            itemMap.put("url", item.getUrl());
            itemsMap.put(i, itemMap);
        }
        return itemsMap;
    }

}
