#if !os(watchOS)
    import Firebase
#endif
import Foundation

class AnalyticsHelper {
    class func openedCategory(categoryId: Int, region: String) {
        logEvent("category_open", parameters: ["id": categoryId, "region": region])
        logEvent("category_page_open_\(categoryId)", parameters: nil)
    }
    
    class func openedFeaturedPodcast() {
        logEvent("featured_podcast_clicked", parameters: nil)
    }
    
    class func subscribedToFeaturedPodcast() {
        logEvent("featured_podcast_subscribed", parameters: nil)
    }
    
    class func userGuideOpened() {
        logEvent("user_guide_opened", parameters: nil)
    }
    
    class func userGuideEmail(feedback: Bool) {
        if feedback {
            userGuideEmailFeedback()
        }
        else {
            userGuideEmailSupport()
        }
    }
    
    class func userGuideEmailSupport() {
        logEvent("user_guide_email", parameters: nil)
    }
    
    class func userGuideEmailFeedback() {
        logEvent("user_guide_feedback", parameters: nil)
    }
    
    class func downloadFromNotification() {
        logEvent("notification_download", parameters: nil)
    }
    
    class func archiveFromNotification() {
        logEvent("notification_archive", parameters: nil)
    }
    
    class func addToUpNextFromNotification(playFirst: Bool) {
        if playFirst {
            logEvent("notification_add_to_up_next_top", parameters: nil)
        }
        else {
            logEvent("notification_add_to_up_next_bottom", parameters: nil)
        }
    }
    
    class func playNowFromNotification() {
        logEvent("notification_play_now", parameters: nil)
    }
    
    class func sharedPodcast() {
        logEvent("shared_podcast", parameters: nil)
    }
    
    class func sharedPodcastList() {
        logEvent("shared_podcast_list", parameters: nil)
    }
    
    class func sharedEpisode() {
        logEvent("shared_episode", parameters: nil)
    }
    
    class func sharedEpisodeWithTimestamp() {
        logEvent("shared_episode_time", parameters: nil)
    }
    
    class func navigatedToDiscover() {
        logEvent("discover_open", parameters: nil)
    }
    
    class func playedEpisode() {
        logEvent("played_episode", parameters: nil)
    }
    
    class func subscribedToPodcast() {
        logEvent("subscribed_to_podcast", parameters: nil)
    }
    
    // MARK: - List Analytics
    
    class func podcastEpisodePlayedFromList(listId: String, podcastUuid: String) {
        logEvent("discover_list_episode_play", parameters: ["list_id": listId, "podcast_uuid": podcastUuid])
    }
    
    class func podcastSubscribedFromList(listId: String, podcastUuid: String) {
        logEvent("discover_list_podcast_subscribe", parameters: ["list_id": listId, "podcast_uuid": podcastUuid])
    }
    
    class func podcastTappedFromList(listId: String, podcastUuid: String) {
        logEvent("discover_list_podcast_tap", parameters: ["list_id": listId, "podcast_uuid": podcastUuid])
    }

    class func podcastEpisodeTapped(fromList listId: String, podcastUuid: String, episodeUuid: String) {
        logEvent("discover_list_podcast_episode_tap", parameters: ["list_id": listId, "podcast_uuid": podcastUuid, "episode_uuid": episodeUuid])
    }

    class func listShowAllTapped(listId: String) {
        logEvent("discover_list_show_all", parameters: ["list_id": listId])
    }
    
    class func listImpression(listId: String) {
        logEvent("discover_list_impression", parameters: ["list_id": listId])
    }
    
    class func forceTouchPlay() {
        logEvent("play_force_touch", parameters: nil)
    }
    
    class func forceTouchPause() {
        logEvent("pause_force_touch", parameters: nil)
    }
    
    class func forceTouchMarkPlayed() {
        logEvent("mark_as_played_force_touch", parameters: nil)
    }
    
    class func forceTouchTopFilter() {
        logEvent("top_filter_force_touch", parameters: nil)
    }
    
    class func forceTouchPodcast() {
        logEvent("podcast_force_touch", parameters: nil)
    }
    
    class func forceTouchDiscover() {
        logEvent("discover_force_touch", parameters: nil)
    }
    
    class func didConnectToChromecast() {
        logEvent("connected_to_chromecast", parameters: nil)
    }
    
    class func didChooseIcon(iconName: String?) {
        if let name = iconName {
            // Firebase doesn't like dashes (Event name must contain only letters, numbers, or underscores)
            logEvent("icon_\(name.replacingOccurrences(of: "-", with: "_"))", parameters: nil)
        }
        else {
            logEvent("icon_default", parameters: nil)
        }
    }
    
    class func siriSleeptimer() {
        logEvent("siri_sleep_timer", parameters: nil)
    }
    
    class func siriChapterChanged() {
        logEvent("siri_chapter_change", parameters: nil)
    }
    
    class func siriSurpriseMe() {
        logEvent("siri_surprise_me", parameters: nil)
    }
    
    class func siriUpNext() {
        logEvent("siri_up_next", parameters: nil)
    }
    
    class func siriPause() {
        logEvent("siri_pause", parameters: nil)
    }
    
    class func siriResume() {
        logEvent("siri_resume", parameters: nil)
    }
    
    class func siriPlayPodcast() {
        logEvent("siri_play_podcast", parameters: nil)
    }
    
    class func siriPlayAllFilter() {
        logEvent("siri_play_all_filter", parameters: nil)
    }
    
    class func siriPlayTopFilter() {
        logEvent("siri_play_top_filter", parameters: nil)
    }
    
    class func siriOpenFilter() {
        logEvent("siri_open_filter", parameters: nil)
    }
    
    class func tourStarted(tourName: String) {
        logEvent("\(tourName)_tour_started", parameters: nil)
    }
    
    class func tourCompleted(tourName: String) {
        logEvent("\(tourName)_tour_completed", parameters: nil)
    }
    
    class func tourCancelled(tourName: String, at step: Int) {
        logEvent("\(tourName)_tour_cancelled_\(step)", parameters: nil)
    }
    
    #if !os(watchOS)
        class func tabSelected(tab: MainTabBarController.Tab) {
            switch tab {
            case .podcasts:
                logEvent("podcast_tab_open", parameters: nil)
            case .filter:
                logEvent("filter_tab_open", parameters: nil)
            case .profile:
                logEvent("profile_tab_open", parameters: nil)
        
            case .discover: break // we don't log this case, since it's handled in did load
            }
        }
    #endif
    
    class func nowPlayingOpened() {
        logEvent("now_playing_open", parameters: nil)
    }
    
    class func upNextOpened() {
        logEvent("up_next_open", parameters: nil)
    }
    
    class func filterOpened() {
        logEvent("filter_opened", parameters: nil)
    }
    
    class func podcastOpened(uuid: String) {
        logEvent("podcast_open", parameters: ["podcastUuid": uuid])
    }
    
    class func episodeOpened(podcastUuid: String, episodeUuid: String) {
        logEvent("episode_open", parameters: ["podcastUuid": podcastUuid, "episodeUuid": episodeUuid])
    }
    
    class func playerShowNotesOpened() {
        logEvent("now_playing_notes_open", parameters: nil)
    }
    
    class func chaptersOpened() {
        logEvent("now_playing_chapters_open", parameters: nil)
    }
    
    class func accountDeleted() {
        logEvent("account_deleted", parameters: nil)
    }
    
    private class func logEvent(_ name: String, parameters: [String: Any]?) {
        #if os(watchOS)
        // assuming for now we don't want analytics on a watch
        #else
            Analytics.logEvent(name, parameters: parameters)
        #endif
    }
}