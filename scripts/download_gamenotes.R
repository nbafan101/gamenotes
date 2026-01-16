# scripts/download_gamenotes.R

pdf_links <- c(
  "http://www.nba.com/gamenotes/celtics.pdf",
  "http://www.nba.com/gamenotes/nets.pdf",
  "http://www.nba.com/gamenotes/knicks.pdf",
  "http://www.nba.com/gamenotes/sixers.pdf",
  "http://www.nba.com/gamenotes/raptors.pdf",
  "http://www.nba.com/gamenotes/bulls.pdf",
  "http://www.nba.com/gamenotes/cavaliers.pdf",
  "http://www.nba.com/gamenotes/pistons.pdf",
  "http://www.nba.com/gamenotes/pacers.pdf",
  "http://www.nba.com/gamenotes/bucks.pdf",
  "http://www.nba.com/gamenotes/hawks.pdf",
  "http://www.nba.com/gamenotes/hornets.pdf",
  "http://www.nba.com/gamenotes/heat.pdf",
  "http://www.nba.com/gamenotes/magic.pdf",
  "http://www.nba.com/gamenotes/wizards.pdf",
  "http://www.nba.com/gamenotes/mavericks.pdf",
  "http://www.nba.com/gamenotes/rockets.pdf",
  "http://www.nba.com/gamenotes/grizzlies.pdf",
  "http://www.nba.com/gamenotes/pelicans.pdf",
  "http://www.nba.com/gamenotes/spurs.pdf",
  "http://www.nba.com/gamenotes/nuggets.pdf",
  "http://www.nba.com/gamenotes/timberwolves.pdf",
  "http://www.nba.com/gamenotes/thunder.pdf",
  "http://www.nba.com/gamenotes/blazers.pdf",
  "http://www.nba.com/gamenotes/jazz.pdf",
  "http://www.nba.com/gamenotes/warriors.pdf",
  "http://www.nba.com/gamenotes/clippers.pdf",
  "http://www.nba.com/gamenotes/lakers.pdf",
  "http://www.nba.com/gamenotes/suns.pdf",
  "http://www.nba.com/gamenotes/kings.pdf"
)

save_dir <- "nba_game_notes"
if (!dir.exists(save_dir)) dir.create(save_dir, recursive = TRUE)

for (link in pdf_links) {
  file_name <- basename(link)
  file_path <- file.path(save_dir, file_name)

  tryCatch({
    download.file(link, file_path, mode = "wb", quiet = TRUE)
    message("✅ Saved: ", file_path)
  }, error = function(e) {
    message("❌ Failed: ", link, " | ", e$message)
  })
}
