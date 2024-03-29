import SwiftUI
import PocketCastsServer
import PocketCastsDataModel

struct TopFivePodcastsStory: ShareableStory {
    let podcasts: [Podcast]

    let identifier: String = "top_five_podcast"

    let duration: TimeInterval = 5.seconds

    var body: some View {
        GeometryReader { geometry in
            PodcastCoverContainer(geometry: geometry) {
                let headerSpacing = geometry.size.height * 0.054
                let size = round(max(geometry.size.height * 0.099, 60))

                VStack(spacing: headerSpacing) {
                    StoryLabel(L10n.eoyStoryTopPodcasts, for: .title2)
                        .opacity(0.8)
                    VStack(spacing: geometry.size.height * 0.03) {
                        ForEach(0...4, id: \.self) {
                            topPodcastRow($0, size: size)
                        }
                    }.padding([.leading, .trailing], 35)
                }
            }.background(DynamicBackgroundView(podcast: podcasts[0]))
        }
    }

    @ViewBuilder
    func topPodcastRow(_ index: Int, size: Double) -> some View {
        HStack(spacing: 16) {
            Text("\(index + 1).")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white)

                if let podcast = podcasts[safe: index] {
                    PodcastCover(podcastUuid: podcast.uuid)
                        .frame(width: size, height: size)
                } else {
                    Rectangle()
                        .frame(width: size, height: size)
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(podcasts[safe: index]?.title ?? "")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                Text(podcasts[safe: index]?.author ?? "")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .opacity(0.8)
            }
            // Allow the the title label to expand based on the size of the row
            // Show more text for larger devices, and a bit less for smaller ones
            .frame(maxHeight: size)
            Spacer()
        }
        .opacity(podcasts[safe: index] != nil ? 1 : 0)
    }

    func onAppear() {
        Analytics.track(.endOfYearStoryShown, story: identifier)
    }

    func willShare() {
        Analytics.track(.endOfYearStoryShare, story: identifier)
    }

    func sharingAssets() -> [Any] {
        [
            StoryShareableProvider.new(AnyView(self)),
            StoryShareableText(L10n.eoyStoryTopPodcastsShareText("%1$@"), podcasts: podcasts)
        ]
    }
}

struct DummyStory_Previews: PreviewProvider {
    static var previews: some View {
        TopFivePodcastsStory(podcasts: [Podcast.previewPodcast(), Podcast.previewPodcast(), Podcast.previewPodcast(), Podcast.previewPodcast(), Podcast.previewPodcast()])
    }
}
