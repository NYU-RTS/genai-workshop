library(ellmer)

if (Sys.getenv("API_KEY") == "") {
  stop(paste("Error: Environment variable", API_KEY, "is not set!"))
} else {
  API_KEY <- Sys.getenv("API_KEY")
}

if (Sys.getenv("LLM_MODEL") == "") {
  stop(paste("Error: Environment variable", API_KEY, "is not set!"))
} else {
  LLM_MODEL <- Sys.getenv("LLM_MODEL")
}

chat  <- chat_openai(
  base_url="https://ai-gateway.apps.cloud.rt.nyu.edu/v1/",
  api_key=API_KEY,
  model=LLM_MODEL)

chat$chat("
  What is the difference between a tibble and a data frame?
  Answer with a bulleted list
")
