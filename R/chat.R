library(ellmer)

if (Sys.getenv("LLM_MODEL") == "") {
  stop(paste("Error: Environment variable", API_KEY, "is not set!"))
} else {
  LLM_MODEL <- Sys.getenv("LLM_MODEL")
}

chat <- chat_portkey(
  base_url = "https://ai-gateway.apps.cloud.rt.nyu.edu/v1/",
  model = LLM_MODEL
)

chat$chat(
  "
  What is the difference between a tibble and a data frame?
  Answer with a bulleted list
"
)
