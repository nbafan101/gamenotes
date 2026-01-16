# scripts/download_gamenotes.R

# Robust downloads for CI
if (!requireNamespace("curl", quietly = TRUE)) {
  stop("Package 'curl' is required. Install it with install.packages('curl').")
}

pdf_links <- c(
  "https://www.nba.com/gamenotes/celtics.pdf",
  "https://www.nba.com/gamenotes/nets.pdf",
  "https://www.nba.com/gamenotes/knicks.pdf",
  "https://www.nba.com/gamenotes/sixers.pdf",
  "https://www.nba.com/gamenotes/raptors.pdf",
  "https://www.nba.com/gamenotes/bulls.pdf",
  "https://www.nba.com/gamenotes/cavaliers.pdf",
  "https://www.nba.com/gamenotes/pistons.pdf",
  "https://www.nba.com/gamenotes/pacers.pdf",
  "https://www.nba.com/gamenotes/bucks.pdf",
  "https://www.nba.com/gamenotes/hawks.pdf",
  "https://www.nba.com/gamenotes/hornets.pdf",
  "https://www.nba.com/gamenotes/heat.pdf",
  "https://www.nba.com/gamenotes/magic.pdf",
  "https://www.nba.com/gamenotes/wizards.pdf",
  "https://www.nba.com/gamenotes/mavericks.pdf",
  "https://www.nba.com/gamenotes/rockets.pdf",
  "https://www.nba.com/gamenotes/grizzlies.pdf",
  "https://www.nba.com/gamenotes/pelicans.pdf",
  "https://www.nba.com/gamenotes/spurs.pdf",
  "https://www.nba.com/gamenotes/nuggets.pdf",
  "https://www.nba.com/gamenotes/timberwolves.pdf",
  "https://www.nba.com/gamenotes/thunder.pdf",
  "https://www.nba.com/gamenotes/blazers.pdf",
  "https://www.nba.com/gamenotes/jazz.pdf",
  "https://www.nba.com/gamenotes/warriors.pdf",
  "https://www.nba.com/gamenotes/clippers.pdf",
  "https://www.nba.com/gamenotes/lakers.pdf",
  "https://www.nba.com/gamenotes/suns.pdf",
  "https://www.nba.com/gamenotes/kings.pdf"
)

save_dir <- "nba_game_notes"
if (!dir.exists(save_dir)) dir.create(save_dir, recursive = TRUE)

ua <- "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0 Safari/537.36"

h <- curl::new_handle()
curl::handle_setheaders(h,
  "User-Agent" = ua,
  "Accept" = "application/pdf,*/*;q=0.8"
)
curl::handle_setopt(h, followlocation = 1L)

download_one <- function(url, dest, tries = 3) {
  for (i in seq_len(tries)) {
    ok <- tryCatch({
      tmp <- paste0(dest, ".tmp")
      curl::curl_download(url, tmp, handle = h, quiet = TRUE)
      # basic sanity: ensure we got a non-trivial file
      if (file.info(tmp)$size < 1024) stop("Downloaded file too small (likely blocked/HTML).")
      file.rename(tmp, dest)
      TRUE
    }, error = function(e) {
      message(sprintf("Attempt %d/%d failed: %s | %s", i, tries, url, e$message))
      FALSE
    })
    if (ok) return(TRUE)
    Sys.sleep(2 * i) # backoff
  }
  return(FALSE)
}

for (link in pdf_links) {
  file_name <- basename(link)
  file_path <- file.path(save_dir, file_name)

  if (download_one(link, file_path, tries = 3)) {
    message("✅ Saved: ", file_path)
  } else {
    message("❌ Failed: ", link)
  }
}
