library(ellmer)

if (Sys.getenv("API_KEY") == "") {
  stop(paste("Error: Environment variable", API_KEY, "is not set!"))
} else {
  API_KEY <- Sys.getenv("API_KEY")
}

if (Sys.getenv("VIRTUAL_KEY") == "") {
  stop(paste("Error: Environment variable", VIRTUAL_KEY, "is not set!"))
} else {
  VIRTUAL_KEY <- Sys.getenv("VIRTUAL_KEY")
}

if (Sys.getenv("LLM_MODEL") == "") {
  stop(paste("Error: Environment variable", API_KEY, "is not set!"))
} else {
  LLM_MODEL <- Sys.getenv("LLM_MODEL")
}

chat <- chat_portkey(
  base_url = "https://ai-gateway.apps.cloud.rt.nyu.edu/v1/",
  api_key = API_KEY,
  virtual_key = VIRTUAL_KEY,
  model = LLM_MODEL
)


PWD <- getwd()

chat$chat(
  "What do you see in these images?",
  content_image_file(file.path(
    PWD,
    "images",
    "Gfp-wisconsin-madison-the-nature-boardwalk.jpg"
  ))
)
