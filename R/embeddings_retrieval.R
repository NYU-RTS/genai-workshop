library(text2vec)
library(tm)
library(proxy)
library(stringr)

set.seed(123) # For reproducibility

# 1. Create a corpus of documents
documents <- c(
  "Machine learning is a field of study that gives computers the ability to learn without being explicitly programmed.",
  "Natural language processing is a subfield of linguistics, computer science, and artificial intelligence.",
  "Deep learning is part of a broader family of machine learning methods based on artificial neural networks.",
  "Retrieval-augmented generation combines retrieval of documents with text generation for better responses.",
  "Text embeddings are vector representations of text that capture semantic meaning.",
  "R is a programming language and environment for statistical computing and graphics.",
  "Vector databases store and retrieve high-dimensional vectors for similarity search operations.",
  "Python is a programming language that lets you work quickly and integrate systems more effectively.",
  "Data science is an interdisciplinary field that uses scientific methods to extract knowledge from data.",
  "Artificial intelligence is intelligence demonstrated by machines, as opposed to natural intelligence."
)

# Assign IDs to documents
doc_ids <- paste0("doc_", 1:length(documents))
names(documents) <- doc_ids

# 2. Preprocess the text
preprocess_text <- function(text) {
  # Convert to lowercase
  text <- tolower(text)
  # Remove punctuation
  text <- str_replace_all(text, "[[:punct:]]", " ")
  # Remove numbers
  text <- str_replace_all(text, "[[:digit:]]", " ")
  # Remove extra whitespace
  text <- str_replace_all(text, "\\s+", " ")
  text <- trimws(text)
  return(text)
}

# Apply preprocessing
processed_docs <- sapply(documents, preprocess_text)

# 3. Create a vocabulary and document-term matrix
# Create iterator over tokens
tokens <- space_tokenizer(processed_docs)

# Create vocabulary
it <- itoken(tokens, ids = names(processed_docs))
vocab <- create_vocabulary(it)

# Prune vocabulary
vocab <- prune_vocabulary(vocab, term_count_min = 1)

# Create document-term matrix
vectorizer <- vocab_vectorizer(vocab)
dtm <- create_dtm(it, vectorizer)

# 4. Create TF-IDF model and get embeddings
tfidf <- TfIdf$new()
tfidf_matrix <- fit_transform(dtm, tfidf)

# 5. Store embeddings (in memory for this example)
embeddings <- as.matrix(tfidf_matrix)
rownames(embeddings) <- names(processed_docs)

# Display the structure of our embedding database
cat("Embedding Database Structure:\n")
print(dim(embeddings))
cat(
  "Each document is represented by a",
  ncol(embeddings),
  "dimensional vector\n\n"
)

# 6. RAG function to retrieve and generate using cosine distance
retrieve_documents <- function(query, embeddings, documents, top_n = 3) {
  # Preprocess the query
  processed_query <- preprocess_text(query)

  # Tokenize
  query_tokens <- space_tokenizer(processed_query)

  # Create iterator and convert to DTM
  query_it <- itoken(query_tokens, ids = c("query"))
  query_dtm <- create_dtm(query_it, vectorizer)

  # Transform to TF-IDF
  query_tfidf <- transform(query_dtm, tfidf)

  # Convert to matrix
  query_vector <- as.matrix(query_tfidf)

  # Calculate cosine distance
  distances <- proxy::dist(query_vector, embeddings, method = "cosine")

  # Convert to a more manageable format
  dist_df <- data.frame(
    doc_id = colnames(distances),
    distance = as.numeric(distances),
    stringsAsFactors = FALSE
  )

  # Sort by distance (ascending - lower distance means more similar)
  dist_df <- dist_df[order(dist_df$distance), ]

  # Get top N results
  top_results <- head(dist_df, top_n)

  # Add the actual document text
  top_results$text <- documents[top_results$doc_id]

  return(top_results)
}

# 7. Demo: Try a few example queries
example_queries <- c(
  "Tell me about machine learning",
  "What is natural language processing?",
  "How do vector databases work?"
)

for (query in example_queries) {
  cat("\n\nQuery:", query, "\n")
  cat("Finding most similar documents...\n")

  results <- retrieve_documents(query, embeddings, documents)

  cat("\nTop", nrow(results), "most relevant documents:\n")
  for (i in 1:nrow(results)) {
    cat("\n", i, ". Document:", results$doc_id[i], "\n")
    cat("   Cosine Distance:", round(results$distance, 4), "\n")
    cat("   Text:", results$text[i], "\n")
  }

  # Simulate a RAG response (in a real application, this would use an LLM)
  cat("\nSimulated RAG Response:\n")
  cat("Based on the retrieved documents, here's a response to your query:\n")

  # For this example, we'll just concatenate the top documents
  retrieved_text <- paste(results$text, collapse = " ")
  cat("\"", substr(retrieved_text, 1, 200), "...\"\n")
}
