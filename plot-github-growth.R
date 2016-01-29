library(data.table)
library(ggplot2)
library(plyr)

results <- fread('event-types-aggregated.csv',
                 colClasses=c('integer', 'POSIXlt','factor', 'integer'))

results$V1 <- NULL

results$event.type <- as.factor(results$event.type)
results$date <- as.POSIXct(results$date, format = "%Y-%m-%d")

results <- subset(results, !(event.type %in% c('CreateEvent', 'DeleteEvent',
                                               'DownloadEvent', 'ForkApplyEvent',
                                               'GistEvent', 'GollumEvent',
                                               'ReleaseEvent', 'StatusEvent',
                                               'PublicEvent')))
results <- subset(results, date <= as.POSIXct('2015-12-31'))

results <- rename(results, c("event.type" = "Event Type"))
options(scipen=10000)

p <- ggplot(results) +
  aes(x = date, y = count, color = `Event Type`, linetype = `Event Type`) +
  ylab("Number of events") +
  xlab("Date") +
  theme_bw() +
  theme(legend.position="bottom", legend.text = element_text(size = 8),
        legend.key = element_rect(colour = "white")) +
  geom_smooth(se = FALSE, size=1.5) +
  guides(col = guide_legend(nrow = 3, title.position = "bottom",
                            title.hjust = 0.5)) +
  scale_y_log10() +
  scale_colour_brewer(palette = "Paired")

pdf('github-growth.pdf')
print(p)
dev.off()
